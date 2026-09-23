---
title: Threat model
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

TUF defends against:
- Arbitrary software installation (attacker serves malicious update)
- Rollback attacks (attacker serves old known-vulnerable version)
- Indefinite freeze attacks (attacker prevents clients from seeing any update)
- Extraneous dependencies (attacker serves signed-but-wrong artifact)
- Mix-and-match attacks (combining metadata from different points in time)
- Wrong software mirrors (substituting packages from a different product line)
- Signing-key compromise for individual roles (isolated by key separation; root key compromise is the only total compromise)

Source: [The Update Framework - Roles and metadata](https://theupdateframework.io/docs/metadata/) and [TUF specification](https://theupdateframework.github.io/specification/latest/) retrieved 2026-06-11.
