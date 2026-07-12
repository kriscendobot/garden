---
ts: 2026-07-12T15:26:29Z
kind: result
role: designer
repo: endojs/endo-but-for-bots
project: endo
prs:
  - https://github.com/endojs/endo-but-for-bots/pull/711
  - https://github.com/endojs/endo-but-for-bots/pull/124#discussion_r3566577111
---

Job ebfb-124-daemon-cbor-frame: authored designs/daemon-cbor-frame-migration.md
(migrate daemon connection framing from @endo/netstring to @endo/cbor-frame,
follow-up to kriskowal's inline review comment on PR #124 at
serve-private-path.js). Covers the five-surface call-site inventory, the
first-byte-disjointness sniffing accept as the wire-compatibility mechanism,
framing/session orthogonality with the slot-machine fork, tag-24 policy
(slots tagged, CapTP untagged), a sibling tcp+cborframe+json+captp0 network
identifier, and a five-phase rollout ending in daemon-side netstring
retirement. Synced designs/README.md (summary table, M4 bucket, dependency
graph Framing subgraph, estimate, milestone totals). Draft PR #711 opened
against llm on branch design/daemon-cbor-frame-migration (commit 554a2427ac);
reply posted on the originating review thread under the repo's standing
comment authorization. Mermaid fences parse-validated.
