---
gate: go-ahead
priority: normal
posted_by: producer
posted_at: 2026-07-08T06:29:45Z
---

---
role: builder
---

# Build: reference deployment + operations for the daemon AWS storage platform (phase 4 of designs/endo-daemon-aws-storage.md)

**Repo:** endojs/endo-but-for-bots. Design: `designs/endo-daemon-aws-storage.md` (draft PR #637). Depends on the phase-2/3 job `build-endo-daemon-aws-storage-wiring` having landed; do not start before it.

Provisioning script for one DynamoDB table (pk HASH / sk RANGE strings, on-demand) and one S3 bucket, a least-privilege IAM policy scoped to exactly the operation set in the design's client-powers section, deployment docs on the gateway-aws-deployment stack (PR #356), backup/restore posture (point-in-time recovery, bucket versioning), cost notes, and the lease item enforcing the one-daemon-per-(table, keyPrefix) exclusivity rule. The garden's AWS account (us-west-1, IAM `garden-fleet`, skill `skills/aws-administration/SKILL.md`) may host the reference deployment; the package stays account-agnostic.
