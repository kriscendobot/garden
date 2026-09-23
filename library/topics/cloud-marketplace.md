# cloud-marketplace

AWS Marketplace and equivalent cloud vendor distribution channels for software products. Covers seller registration requirements, AMI and container product technical constraints (security hardening, credential policies, vulnerability scanning, architecture requirements), pricing models (hourly, monthly, annual, contract, custom metering via MeterUsage/RegisterUsage APIs), and the listing lifecycle from submission through review to public publication. These requirements are the binding external constraints for the Endo gateway's Phase 11 OS packaging milestone and any future hosted-Gateway commercial listing.

## Sections

| Section | One-line summary |
|---|---|
| [AWS Marketplace AMI requirements: technical security](../sections/web--aws-marketplace-ami-requirements--technical-security.md) | Security hardening, architecture, access-control, and continuous-scanning rules every AMI listing must satisfy. |
| [AWS Marketplace AMI requirements: pricing and listing process](../sections/web--aws-marketplace-ami-requirements--pricing-and-listing.md) | Six pricing models (Hourly through Contract/Custom Metering) and the 7–10 business day / 2–4 calendar week listing review timeline. |
| [AWS Marketplace container requirements: technical security and metering](../sections/web--aws-marketplace-container-requirements--technical-security.md) | Container image policies, ECR push requirements, MeterUsage vs. RegisterUsage API billing integration for ECS/EKS/Fargate products. |

## See also

- node-packaging — the Endo gateway's Phase 11 OS packaging milestone that these marketplace requirements constrain.
- tls-provisioning — TLS certificate provisioning is required before a marketplace-deployed node is ready for operator use.
- signed-updates — signed update channels are a Phase 11 gap for an always-online marketplace listing.
