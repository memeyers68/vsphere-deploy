terraform {
  required_providers {
    vra = {
      source  = "vmware/vra"
    }
  }
  required_version = ">= 0.12"
}

provider "vra" {
  url           = "https://api.mgmt.cloud.vmware.com"
  refresh_token = "AKGdvexFqfFZBWSfxzBkJdu13pCunWv4n0_uPBFg1bBMcKDrKJyU_wDGTXFEAKtP"
  insecure      = false
}
