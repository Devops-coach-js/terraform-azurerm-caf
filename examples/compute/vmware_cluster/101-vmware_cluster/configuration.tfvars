global_settings = {
  default_region = "region1"
  regions = {
    region1 = "westus"
  }
}

resource_groups = {
  rgvwc = {
    name   = "vmwarecluster-test"
    region = "region1"
  }
}

vmware_private_clouds = {
  vwpc1= {
    name                = "example-vmware-private-cloud"
    resource_group_key = "rgvwc"
    region                  = "region1"
    sku_name            = "av36"
    management_cluster = {
      size = 3
    }
    network_subnet_cidr         = "192.168.48.0/22"
    internet_connection_enabled = false

    nsxt_password = {
      password = "QazWsx13$Edc"
    }
    vcenter_password = {
      key_vault_key = "kv1"
      #lzKey= "ejkle" (optional)
      secret_key = "vcenter-password"
    }
  }
}

vmware_clusters = {
  vwc1 = {
    name               = "example-Cluster"
    vmware_private_cloud_key   = "vwpc1"
    cluster_node_count = 3
    sku_name           = "av36"
  }
}