---
title: "AWS Marketplace AMI product requirements: security and architecture"
source_kind: web
source_url: https://docs.aws.amazon.com/marketplace/latest/userguide/product-and-ami-policies.html
source_date: 2025-05-01
ingested: 2026-06-11
ingested_by: scholar
topics: [cloud-marketplace, node-packaging]
status: current
notes: "AWS updated these requirements as of May 1, 2025. Continuously scanned post-listing."
---

## Abstract

The AWS Marketplace AMI product requirements define the security hardening, architecture, and access-control rules an AMI must satisfy to be listed and to remain listed. For an always-online self-custodial node targeting Phase 11 OS packaging, these rules are the binding technical constraints: no embedded credentials, HVM virtualization, EBS-backed, region-agnostic, no encrypted snapshots, no password-based auth, and automated AMI scanning before and after listing.

## Security policies

### General requirements

All AMIs must:

- Pass all security checks from the AWS Marketplace AMI scanning tool with no known vulnerabilities or malware.
- Use currently supported operating systems and software (end-of-life OS or software not allowed).
- Not be older than two years from their AMI creation date (older AMIs are not allowed).
- Prohibit password-based authentication for instance services, even if the password is generated or reset at launch. Null and blank passwords are not allowed. Exceptions: Windows EC2Config/EC2Launch administrator passwords; non-administrative services without other auth methods when strong random-per-instance passwords are used once and changed immediately.
- Not contain hardcoded secrets: no system/service passwords (including hashed), no private keys, no credentials.
- Not request AWS credentials to access AWS services. Products requiring AWS service access must use a minimally privileged IAM role assigned to the instance. Sellers must not have access to customer instances; customers may explicitly enable support access.

### SSH access (Linux AMIs)

- Must not allow password-based SSH authentication (`PasswordAuthentication no` in `sshd_config`).
- Must disable password-based remote logins for superuser accounts.
- Must not contain pre-seeded authorized public keys for SSH access.
- SSH service must listen on the TCP port specified for AMI scanning; must be accessible from subnets `10.0.0.0/16` and `10.2.0.0/16` on the EC2-assigned IP.

### Linux-specific

- Must allow users to gain fully privileged access (sudo).

## Architecture requirements

- Source AMIs must be provided in the US East (N. Virginia / us-east-1) Region.
- Must use HVM virtualization.
- Must use x86-64 or 64-bit ARM architecture.
- Must be EBS-backed. S3-backed AMIs are not supported.
- Must not use encrypted EBS snapshots.
- Must not use encrypted file systems.
- Must be built to run in all AWS Regions and must be region-agnostic. Per-region AMI variants are not allowed.

## Versioning and lifecycle

- Versions restricted by the seller for longer than two years are automatically archived. Archived versions remain launchable via existing launch templates but no longer discoverable by new subscribers.
- Archived versions unused for 13 months are deleted (unavailable to all).

## Continuous compliance

AWS Marketplace continuously scans listed products. Products falling out of compliance may be temporarily made unavailable to new subscribers until issues are resolved.

Source: [AMI-based product requirements for AWS Marketplace](https://docs.aws.amazon.com/marketplace/latest/userguide/product-and-ami-policies.html) retrieved 2026-06-11.
