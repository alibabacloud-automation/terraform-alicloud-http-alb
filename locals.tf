locals {
  address_allocated_mode = var.create_eip ? "Fixed" : "Dynamic"

  # Build vSwitch-to-zone mapping from data source
  vswitch_zone_map = {
    for vs in data.alicloud_vswitches.selected.vswitches : vs.id => vs.zone_id
  }
}
