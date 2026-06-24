---
source_kind: web
source_url: https://theupdateframework.io/docs/metadata/
source_date: 2026-01-01
source_authors: [TUF / CNCF]
ingested: 2026-06-11
ingested_by: scholar
section_count: 1
status: current
notes: "TUF specification last updated January 2026. CNCF Graduated project since December 2019. One section covering the role hierarchy, key management, and threat model at the overview level sufficient to brief a designer."
---

The Update Framework (TUF) CNCF-graduated specification for securing software update systems against repository compromise, rollback attacks, and signing-key theft. Defines four role hierarchy (Root/Targets/Snapshot/Timestamp), online vs. offline key discipline, and threshold signatures. For the Endo gateway's upgrade channel design gap, TUF is the canonical reference for how signed update delivery works for always-online appliance-like nodes.

| Section | Topics | Status |
|---------|--------|--------|
| [overview](../sections/web--tuf-signed-update-framework--overview.md) | signed-updates, node-packaging | current |
