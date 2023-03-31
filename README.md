# IBM Cloud Activity Tracker Deployment for Canada

[IBM Cloud Activity Tracker](https://cloud.ibm.com/docs/activity-tracker?topic=activity-tracker-getting-started) has two related offerings:

* Activity Tracker Event Routing
* Activity Tracker Hosted Event Search

In Canada, only Hosted Event Search is available, and only in the Toronto region (ca-tor).  Additionally, global events, such as IAM events, will go to the Frankfurt region (eu-de) by default, meaning you either need an instance of Activity Tracker in Frankfurt, or you need to route those events to your Hosted Event Search instance in Toronto.  Typically, services provisioned in a region send events to the Activity Tracker in that region, but some cloud services in Toronto are still sending audit events to us-east or us-south, so it's recommended to forward events from those regions as well.  You can also forward from any other [region that supports routing](https://cloud.ibm.com/docs/atracker?topic=atracker-regions).

If data residency is important to your solution, you can use this Terraform to route all events to your instance of Activity Tracker in Toronto.

Note that you can only have one instance of Activity Tracker per region, so you may need to tweak this terraform to provide your Activity Tracker crn if you already have one in Toronto.

## To Run

Copy `terraform.tfvars.template` to `terraform.tfvars` and fill in the variables.

Your API Key will need the following permissions

**Service:** Activity Tracker <br />
**Service Access:** Manager <br />
**Platform Access:** Administrator <br />

**Service:** Activity Tracker event routing <br />
**Platform Access:** Administrator <br />

It will also need permission Administrator permission for the Resource Group you are using.

### Inputs

| Name | Description | Type | Default/Example | Required |
| ---- | ----------- | ---- | ------- | -------- |
| ibmcloud_api_key | API Key used to provision resources.  Your key must be authorized to perform the actions in this script.  | string | N/A | yes |
| region | Region to deploy resources | string | ca-tor | only if overriding the default |
| resource_group_name | Name of existing resource group into which to deploy | string | N/A | yes |
| activity_tracker_plan | Activity Tracker Plan 7-day or 30-day | string | 7-day | only if overriding the default |
| activity_tracker_route_sources | A route will be created the sends events from the these regions to your target instance. | list(string) ["us-south","us-east","global"] | only if overriding the default.  The default routes local events from `us-south` and `us-east` and global events.  At time of writing, you can also route events from `au-syd`,`eu-de` and `eu-gb` |

### Run

* terraform init
* terraform apply

## Validate

Open your provisioned instance of Activity Tracker.  You should see both local events and global events, such as iam events in your Toronto instance of Activity Tracker.

You can also view your route and target using the [IBM Cloud CLI](https://cloud.ibm.com/docs/cli?topic=cli-install-ibmcloud-cli).  

Type the following to see commands related to Activity Tracker
```
ibmcloud at -h
```

To see all routes, type
```
ibmcloud at route ls
```

You should see a route called `canada-route`.

To see details of this route, type

```
ibmcloud at route get --route canada-route --output json
```

And you should see something like:
```json
{
  "id": "9be*****************79",
  "name": "canada-route",
  "crn": "crn:v1:bluemix:public:atracker:global:a/fa***************c::route:9be*****************79",
  "version": 0,
  "rules": [
    {
      "target_ids": [
        "a6a**************d"
      ],
      "locations": [
        "us-south",
        "us-east",
        "global"
      ]
    }
  ],
  "created_at": "2023-03-31T15:30:20.435Z",
  "updated_at": "2023-03-31T15:30:20.435Z",
  "api_version": 2
}
```

To see target details:
```
ibmcloud at target ls
```

You should see a target called 'tor-at-target'.  Note that the Region shows as `us-east`.  This is where the target metadata is stored.

To see the details of the target, type

```
ibmcloud at target get --target tor-at-target --output json
```

The output will look like:

```json
{
  "id": "a6a********************d",
  "name": "tor-at-target",
  "crn": "crn:v1:bluemix:public:atracker:us-east:a/fa8*******************48c::target:a6a********************d",
  "target_type": "logdna",
  "region": "us-east",
  "logdna_endpoint": {
    "target_crn": "crn:v1:bluemix:public:logdnaat:ca-tor:a/fa8*******************48c:e16********************2::"
  },
  "write_status": {
    "status": "success"
  },
  "created_at": "2023-03-31T15:30:19.459Z",
  "updated_at": "2023-03-31T15:30:19.459Z",
  "api_version": 2
}
```
