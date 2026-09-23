---
title: Security properties
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

**Rollback attack prevention**: The `snapshot.json` file records version numbers for all metadata files, ensuring clients see a consistent view. An attacker who compromises one piece of infrastructure cannot present clients with a mix of old and new metadata files from different points in time (`snapshot.json` pins the consistent set). The `timestamp.json`'s short expiry means clients quickly detect if they are being fed stale metadata (a "freeze" attack).

**Threshold signatures**: Root metadata requires a threshold of N-of-M key signatures before it is accepted, so compromise of fewer than N keys does not allow an attacker to replace the root trust anchor.

**Delegation**: The Targets role can delegate signing authority for subsets of the target namespace to additional roles, each with their own keys. This allows a large software distributor to give different teams signing authority over different packages without sharing a single root key.

Source: [The Update Framework - Roles and metadata](https://theupdateframework.io/docs/metadata/) and [TUF specification](https://theupdateframework.github.io/specification/latest/) retrieved 2026-06-11.
