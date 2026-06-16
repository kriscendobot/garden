---
title: Deployment pattern for always-online appliance nodes
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

For an always-online node that receives automatic software updates:
1. The vendor maintains a TUF repository (typically a static file server or S3 bucket).
2. The Timestamp role's key is kept on the vendor's build infrastructure (online; re-signed on a schedule, for example daily or on every new release).
3. The Snapshot, Targets, and Root role keys are kept offline in hardware security modules (HSMs) or air-gapped signing ceremonies.
4. The node periodically fetches `timestamp.json`, verifies its expiry and signature, fetches `snapshot.json` if the hash changed, fetches `targets.json` if needed, and verifies the target artifact hash before applying the update.
5. On key rotation, the old root metadata delegates to the new root key; nodes performing a chain-of-trust walk from their shipped root certificate automatically pick up the rotation without manual intervention.

TUF is not designed for air-gapped nodes; it assumes connectivity to the update repository. For air-gapped scenarios, out-of-band metadata transfer is required.

Source: [The Update Framework - Roles and metadata](https://theupdateframework.io/docs/metadata/) and [TUF specification](https://theupdateframework.github.io/specification/latest/) retrieved 2026-06-11.
