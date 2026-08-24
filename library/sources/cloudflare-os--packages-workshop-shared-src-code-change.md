---
source_kind: comment-fragment
source_repo: cloudflare/cloudflare-os
source_path: packages/workshop-shared/src/code-change.ts
source_line_range: "1-634"
source_commit: 1ef6020a42fbabb6d27dd1063db3a075ba95c974
comment_subject: the operational-transform code-change module — base-free revisioned representation, concurrent transform under a server-order priority convention, and the ordered two-stage ingestion validation
source_authors: [Kenton Varda]
ingested: 2026-08-24
ingested_by: scholar
section_count: 3
status: current
---

`code-change.ts` is the single owner of Cloudflare OS's uncommitted-code-change invariants: the wire types, application, composition, transformation, diffing, and validation for the operational-transform stream a chat's edits flow through, layered over git-backed committed code. This digest captures three: the base-free revisioned representation (and why per-gadget files are lists, not `__proto__`-losing objects); concurrent transform under the fixed server-order priority convention and its per-path edit/set/remove rules; and the ordered two-stage ingestion validation (schema before transform, content after) with its running size budget and byte-identical-replica surrogate rules. The canonical home of the [[code-change-operational-transform]] concept; consumed by `submitCodeChange` in `api.ts` and folded by `agent-compaction.ts`.

| Section | Topics | Status |
|---------|--------|--------|
| [Operational-transform code-change representation](../sections/cloudflare-os--packages-workshop-shared-src-code-change--operational-transform-representation.md) | local-first-sync, change-propagation, content-addressed-storage | current |
| [Concurrent transform and the priority convention](../sections/cloudflare-os--packages-workshop-shared-src-code-change--concurrent-transform-priority-convention.md) | local-first-sync, change-propagation, data-structures | current |
| [Two-stage ingestion-validation trust boundary](../sections/cloudflare-os--packages-workshop-shared-src-code-change--two-stage-ingestion-validation.md) | local-first-sync, change-propagation, endpoint-security | current |
