---
source: designs/daemon-xs-worker-debugger.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_url: https://github.com/endojs/endo-but-for-bots/blob/llm/designs/daemon-xs-worker-debugger.md
section_kind: design
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - daemon
  - capability-security
  - hardened-javascript
status_at_ingest: In Progress
genre: §endo-but-for-bots-design §sibling-design-trio
cycle: 182
lane: designs
status: current
title: §Two-design-dependencies
parent: endo-but-for-bots--llm-designs-daemon-xs-worker-debugger--six-layer-XML-pass-through-with-dormant-by-default-and-break-on-uncaught-via-firstJump-walk
---

§The-design-cites-no-explicit-Dependencies-section, but the
prose names two §related-designs:

| Related | Relationship |
|---------|---------------|
| cycle 178 (daemon-xs-worker-snapshot) | §sibling-worker-capability — both extend xsnap engine exposure with non-obvious mechanism |
| cycle 176 (daemon-endor-architecture) | §the-Rust-supervisor-substrate this design lives within |

§Cycle-178-and-this-cycle form a §sibling-design-pair for the
xs-worker-* family: §snapshot extends with §suspend/resume;
§debugger extends with §inspect/control. §The-third-sibling
(`daemon-xs-worker-metering.md`, 828 lines, un-ingested) extends
with §observability.

§The-three-form-a §xs-worker-capability-trio: snapshot +
debugger + metering. §All-three-build-on-the-same-substrate
(cycle 176 endor-architecture) and extend the same engine layer.
