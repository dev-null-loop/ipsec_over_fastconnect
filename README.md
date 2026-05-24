# ipsec_over_fastconnect

This repository is a minimal Terraform reproducer for `oracle/terraform-provider-oci` issue `#1989`.

## Context

The issue was closed with a maintainer comment pointing users to:

- the updated `oci_core_ipsec` documentation
- the upstream `examples/networking/ipsec_connections/ipsec_connection_over_fc.tf` example

That upstream example shows the working path for a private IPSec-over-FastConnect connection by supplying two `tunnel_configuration` blocks.

This repository intentionally reproduces the failing path instead:

- `oci_core_cpe.is_private = true`
- `oci_core_ipsec.static_routes = []`
- no `tunnel_configuration` blocks

## Expected result

`make apply` is expected to fail on `oci_core_ipsec.this["issue_1989"]` with the same class of error reported in the issue:

```text
Error: 400-InvalidParameter, Request passed in to create private Ipsec tunnels must have 2 tunnel configuration details by default but 0 was provided
```

`oci_core_cpe` and `oci_core_drg` may already exist in state when the IPSec create fails. Run `make destroy` afterwards to clean up.

## Layout

- `provider.tf`: OCI provider
- `versions.tf`: provider pin used for the reproducer
- `variables.tf`: typed root inputs
- `main.tf`: minimal CPE, DRG, and IPSec resources
- `outputs.tf`: IDs and a few useful computed fields
- `identity.auto.tfvars`: tenancy, region, and compartment aliases
- `core.cpe.auto.tfvars`: private CPE input
- `core.drg.auto.tfvars`: DRG input
- `core.ipsec.auto.tfvars`: failing IPSec input

## Usage

```bash
make init
make plan
make apply
make destroy
```

## Why this is different from the upstream example

The upstream example is the fix path. This repository is the repro path.

If you want the working configuration instead, follow the upstream `ipsec_connection_over_fc.tf` example and provide exactly two `tunnel_configuration` blocks with:

- `oracle_tunnel_ip`
- `associated_virtual_circuits`
- `drg_route_table_id`
