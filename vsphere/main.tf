terraform {
  required_providers {
	vsphere = {
		source = "hashicorp/vsphere"
	}
  }
}


provider "vsphere" {
  /* user           = var.username
  password       = var.password
  vsphere_server = var.vcenter
  
  # If you have a self-signed cert*/
  allow_unverified_ssl = true
}

#data sources
data "vsphere_datacenter" "datacenter" {
	name = var.dc
}

data "vsphere_compute_cluster" "cluster" {
	name = var.compute
	datacenter_id = "${data.vsphere_datacenter.datacenter.id}"
}

#data "vsphere_datastore_cluster" "datastore_cluster" {
	#name = var.storage
	#datacenter_id = "${data.vsphere_datacenter.datacenter.id}"
#}

data "vsphere_datastore" "datastore" {
  name = var.storage
  datacenter_id = "${data.vsphere_datacenter.datacenter.id}"
}

data "vsphere_network" "network" {
	name = "VM Network 192"
	datacenter_id = "${data.vsphere_datacenter.datacenter.id}"
}

#data "vsphere_virtual_machine" "template" {
  #name          = "EAServer2022"
  #datacenter_id = "${data.vsphere_datacenter.datacenter.id}"
#}

data "vsphere_content_library" "library" {
  name = "VM-Templates"
}

data "vsphere_content_library_item" "item" {
  name = "TMPL_WIN_2022_STD"
  type = "vm-template"
  library_id = data.vsphere_content_library.library.id
}

#virtual machine
resource "vsphere_virtual_machine" "meyers00" {
    name = "TROSVMeyers00"
    resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
    #datastore_cluster_id = data.vsphere_datastore_cluster.datastore_cluster.id
    datastore_id = data.vsphere_datastore.datastore.id

    num_cpus = 2
    num_cores_per_socket = 1
    memory = 4096
    #guest_id = data.vsphere_virtual_machine.template.guest_id
    guest_id = data.vsphere_content_library_item.item.id
    scsi_type = "pvscsi"
    firmware = "efi"
    folder = "Schools"

    network_interface {
    network_id = data.vsphere_network.network.id
    adapter_type = "vmxnet3"
    }

    disk {
    label = "disk0"
    size = 100
    thin_provisioned = true
    }
  clone {
    #template_uuid = data.vsphere_virtual_machine.template.id
    template_uuid = data.vsphere_content_library_item.item.id
    customize {
      timeout = 0
      windows_options {
        computer_name = "TROSVMeyers00"
        admin_password = "Gr33kMyth!"
        join_domain = "corp.tylertechnologies.com"
        domain_admin_user = "tyler\\elmmeyers"
        domain_admin_password = "S@X0n68.P#uck!"
        time_zone = 35
        auto_logon = true
        auto_logon_count = 1
      }
      network_interface{}
    }
  }
}
