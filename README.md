# ipsec_over_fastconnect

This repository reproduces the upstream `terraform-provider-oci` private IPSec-over-FastConnect example from `examples/networking/ipsec_connections`.

It is intentionally structured in your root-module style:

- explicit `provider.tf` and `versions.tf`
- typed `variables.tf`
- a small `locals.tf` for environment resolution
- `*.auto.tfvars` files for environment and domain inputs

## Scope

The topology reproduced here is:

- one private CPE
- one DRG
- one DRG route table
- one cross-connect
- one private virtual circuit
- one private IPSec connection with two `tunnel_configuration` blocks
- the same follow-on IPSec tunnel data sources and two tunnel-management resources shown in the upstream example

## Files

- `identity.auto.tfvars`
- `core.cpe.auto.tfvars`
- `core.drg.auto.tfvars`
- `core.fastconnect.auto.tfvars`
- `core.ipsec.auto.tfvars`
- `provider.tf`
- `versions.tf`
- `variables.tf`
- `locals.tf`
- `main.tf`
- `outputs.tf`

## Usage

```bash
make init
make plan
make apply
make destroy
```

## Notes

- The provider floor is `>= 6.12.0`, which is the first local provider tag that contains private IPSec-over-FastConnect `tunnel_configuration` support.
- Applying this stack requires a tenancy and region where the FastConnect cross-connect workflow is actually available.
