# node-packaging

OS packaging and distribution of the Endo gateway node for marketplace deployment. The Endo strategy brief's Phase 11 promotes OS packaging from "pending tail" to load-bearing: for a marketplace listing, the packaged image (AMI or container) is the product. This topic aggregates the external constraints imposed by the target distribution channel (AWS Marketplace AMI and container requirements), the first-boot experience requirements (TLS certificate provisioning, operator identity bonding), and the ongoing operations requirements (signed update channels, operator observability) that a Phase 11 design must satisfy.

## Sections

| Section | One-line summary |
|---|---|
| [AWS Marketplace AMI requirements: technical security](../sections/web--aws-marketplace-ami-requirements--technical-security.md) | Security hardening and architecture rules every AMI must satisfy before and after listing. |
| [AWS Marketplace AMI requirements: pricing and listing process](../sections/web--aws-marketplace-ami-requirements--pricing-and-listing.md) | Pricing models and the 2–4 calendar week listing timeline. |
| [AWS Marketplace container requirements: technical security and metering](../sections/web--aws-marketplace-container-requirements--technical-security.md) | Container policies, ECR push, metering API options. |
| [ACME challenge types: HTTP-01, DNS-01, TLS-ALPN-01](../sections/web--acme-challenge-types--http01-dns01-tls-alpn01.md) | Challenge type constraints relevant to first-boot certificate provisioning. |
| [TLS provisioning patterns for first-boot self-custodial nodes](../sections/web--tls-first-boot-patterns--vendor-delegated-and-tofu.md) | Four first-boot TLS patterns with trade-offs for marketplace-deployed appliances. |
| [The Update Framework (TUF): overview](../sections/web--tuf-signed-update-framework--overview.md) | Signed update channel architecture for always-online nodes. |

## See also

- cloud-marketplace — the distribution channel that sets the packaging requirements.
- tls-provisioning — the first-boot TLS ceremony is a node-packaging dependency.
- signed-updates — the upgrade-channel design gap named in the Endo strategy brief.
- daemon — the Endo daemon process model that the packaged node hosts.
