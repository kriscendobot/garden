---
title: Security requirements
source_kind: web
source_url: https://docs.aws.amazon.com/marketplace/latest/userguide/container-product-policies.html
source_date: 2025-05-01
ingested: 2026-06-11
ingested_by: scholar
topics: [cloud-marketplace, node-packaging]
status: current
notes: "Metering details also from container-products-billing-integration.html. Updated May 1, 2025."
parent: web--aws-marketplace-container-requirements--technical-security
---

All container-based products must:

- Not contain any known vulnerabilities, malware, or end-of-life software packages or OS.
- Not request AWS credentials to access AWS services. Use IAM roles for service accounts (EKS) or IAM roles for tasks (ECS) instead.
- Only require least privileges to run.
- Be configured to run with non-root privileges by default.
- Not contain hardcoded secrets: no system/service passwords (even hashed), no private keys, no credentials.
- Not use password-based authentication for any services running inside the container, even if generated at launch.
- Not include image layers with unsupported architectures (for example, in-toto Attestation Framework metadata in an incompatible form).

Images are scanned for vulnerabilities when submitted. AWS credentials for the buyer are automatically obtained at runtime when the container runs inside ECS or EKS; never configure credentials in the image.

Source: [Container-based product requirements](https://docs.aws.amazon.com/marketplace/latest/userguide/container-product-policies.html) and [Container product billing, metering, and licensing integrations](https://docs.aws.amazon.com/marketplace/latest/userguide/container-products-billing-integration.html) retrieved 2026-06-11.
