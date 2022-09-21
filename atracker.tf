
## Adapted for Toronto

data "ibm_resource_group" "group" {
  name = var.resource_group_name
}

##############################################################################
# Activity Tracker and Route
##############################################################################
resource "ibm_resource_instance" "logdnaat_instance" {
  name = "activity-tracker-ca-tor"
  service = "logdnaat"
  plan = var.activity_tracker_plan
  location = "ca-tor"
  resource_group_id = data.ibm_resource_group.group.id
}

## Create the ingestion key for Activity Tracker
resource "ibm_resource_key" "ingestion_key" {
  name = "activity_tracker_tor_ingestion_key"
  role = "Administrator"
  resource_instance_id = ibm_resource_instance.logdnaat_instance.id
}

## Make your activity tracker instance in Toronto the target
resource "ibm_atracker_target" "atracker_logdna_target" {
  target_type = "logdna"
  logdna_endpoint {
    target_crn = ibm_resource_instance.logdnaat_instance.crn
    ingestion_key = ibm_resource_key.ingestion_key.credentials.ingestion_key
  }
  name = "my-logdna-target"
  region = "us-east"
}


## Route global events and events to us-south and us-east to your activity tracker instance in Toronto
resource "ibm_atracker_route" "atracker_route" {
  name = "canada-route"
  rules {
    target_ids = [ ibm_atracker_target.atracker_logdna_target.id ]
    locations = [ "us-south","us-east", "global" ]
  }
  lifecycle {
    # Recommended to ensure that if a target ID is removed here and destroyed in a plan, this is updated first
    create_before_destroy = true
  }
}


##############################################################################