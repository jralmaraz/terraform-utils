locals {
    bq_permissions = ["bigquery.datasets.get", "bigquery.jobs.create", "bigquery.tables.list", "bigquery.tables.get"] 

}

resource "google_access_context_manager_service_perimeter" "test-access" {
  count = length(local.bq_permissions)
  parent         = "accessPolicies/123456"
  name           = "accessPolicies/123456/servicePerimeters/test_jose"
  title          = "BigQuery policy via terraform"
  status {

    resources = ["projects/B"]
    
    restricted_services = ["bigquery.googleapis.com"]

    egress_policies {
        egress_from {
              identities = [
                  "serviceAccount:test@test.iam.gserviceaccount.com"
              ]  
            }

        egress_to {
                resources = ["projects/A"]
                operations {
                    service_name = "bigquery.googleapis.com"
                    method_selectors {
                         permission = element(local.bq_permissions, count.index)
                    }
                }
            }
        }    
  }

}
