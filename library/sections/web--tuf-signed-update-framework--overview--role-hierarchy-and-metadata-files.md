---
title: Role hierarchy and metadata files
source_kind: web
source_url: https://theupdateframework.io/docs/metadata/
source_date: 2026-01-01
ingested: 2026-06-11
ingested_by: scholar
topics: [signed-updates, node-packaging]
status: current
notes: "TUF specification last updated January 2026 per search results. CNCF Graduated project since December 2019."
parent: web--tuf-signed-update-framework--overview
---

TUF defines four required top-level roles, each with a dedicated metadata file:

| Role | File | Key type | Signs | Typical expiry |
|---|---|---|---|---|
| Root | `root.json` | Offline | Specifies all other top-level role keys and threshold requirements | Long (1 year+) |
| Targets | `targets.json` | Offline | Hashes and sizes of software update artifacts; can delegate to sub-roles | Medium |
| Snapshot | `snapshot.json` | Offline (recommended) | Version numbers and hashes of all targets metadata files | Medium |
| Timestamp | `timestamp.json` | Online | Hash and size of snapshot.json; re-signed frequently | Short (days) |

**Online vs. offline keys**: The Timestamp role uses an online key because it must be re-signed automatically at regular intervals (to prevent clients from treating old metadata as current). The Snapshot role should use an offline key to limit damage if the timestamp key is compromised; separate keys prevent a compromised timestamp key from also signing fake snapshot metadata.

Source: [The Update Framework - Roles and metadata](https://theupdateframework.io/docs/metadata/) and [TUF specification](https://theupdateframework.github.io/specification/latest/) retrieved 2026-06-11.
