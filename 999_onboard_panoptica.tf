module "onboarding" {  
  source = "https://panoptica-public-lightspin-prod-1.s3.us-east-2.amazonaws.com/terraform/terraform_onboarding_module.zip"
  external_id = "test"  
  account_display_name = "update-this" 
  cve_scan_enabled = true
  scanner_account_id = ""  
  region = "us-east-1"  
  tenant_id = "update this" 
  serverless_scan_enabled = true 
}