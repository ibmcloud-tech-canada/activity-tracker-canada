# IBM Cloud Activity Tracker Deployment for Canada

[IBM Cloud Activity Tracker](https://cloud.ibm.com/docs/activity-tracker?topic=activity-tracker-getting-started) has two related offerings:

* Activity Tracker Event Routing
* Activity Tracker Hosted Event Search

In Canada, only Hosted Event Search is available, and only in the Toronto region (ca-tor).  Additionally, global events, such as IAM events, will go to the Frankfurt region (eu-de) by default, meaning you either need an instance of Activity Tracker in Frankfurt, or you need to route those events to your Hosted Event Search instance in Toronto.  Typically, services provisioned in a region send events to the Activity Tracker in that region, but some cloud services in Toronto are still sending audit events to us-east or us-south.

If data residency is important to your solution, you can use this Terraform to route all events to your instance of Activity Tracker in Toronto.

Note that you can only have one instance of Activity Tracker per region, so you may need to tweak this terraform to provide your Activity Tracker crn if you already have one in Toronto.

*IMPORTANT:* There is current a bug, where if the provider region is set to `ca-tor` the activity_tracker_target resource will fail because it constructs a service url based on the region, and the toronto region doesn't have a service url.  To work around this, don't set the provider region, or set it to `us-east`.  If you are using this terraform as part of a larger template, you will need to compensate by setting the region explicitly on each resource - or run this template separately.

## To Run

Either set the environment variable `ibmcloud_api_key` to your API key that is authorized to managed the services in this terrform, or use the `ibmcloud_api_key` variable - uncomment in `variables.tf` the provider entry in `versions.tf`

Run

* terraform init
* terraform apply

## Validate

Open your provisioned instance of Activity Tracker.  You should see both local events and global events, such as iam events.