---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr1226-review-179ff5ab
verdict: miss
category: process
pr: 1226
cluster: design-bespoke-mechanism-over-existing-path
cluster_pattern: A design invents a bespoke per-entity channel or mechanism where the repository's existing client/connection path already provides the access, and successive design-panel rounds patch that mechanism's recurring must-fix findings instead of asking whether it is needed at all.
review_at: 2026-09-24T03:27:35Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/1226#pullrequestreview-5299330782
identity: endojs/endo-but-for-bots#1226:review:5299330782:retro
producing_role: designer
producing_job: design-endo-guest-stdio-mcp
missed_by: decomplector (category f, minimum viable abstraction) and critic, across six design-panel rounds on 2026-09-08
severity: minor
grounds: |
  Split verdict. The review (CHANGES_REQUESTED at head e5c63291) makes two
  requests. (1) The review body asks the design to account for the garden's
  recent move to a structured stream output for `claude -p` and the metadata
  it now parses (availability, quota and usage signals). That is garden-internal
  knowledge first supplied in this review, outside the endo repository and every
  seat brief: new direction, not a miss. (2) An inline comment on the design
  file prefers the packages/lal approach, where the tool surface is a static
  declaration matching the guest agent interface, over inferring the catalog
  shape dynamically from the guest facet. That part is a miss. The draft the
  panel reviewed (4e1696a4) already cited "the static Lal tool set" as the
  projection source, yet its "Tool catalog derivation" section built a
  derive-prune-pin mechanism on top of it. Six panel rounds raised must-fix
  findings on catalog pinning, live-growth drift and the dispatch check without
  asking whether a static declaration, already present in the repository and
  named in the draft, would remove the mechanism. The decomplector's standing
  category (f) covers that question and did not bind. This is the same pattern
  as the earlier #1226 member (the bespoke per-guest socket). Minor severity:
  design-stage, and the primary adopted the fix. Deliverable verified in the
  world: commit 63f44248 replaced the dynamic inference with one static
  Lal-style declaration that drives both tools/list and --allowedTools, a reply
  on the inline thread links that commit, and the maintainer then approved
  that head (review 5299606833) and merged the PR.
---

The maintainer asked the design to reuse Lal's static guest-agent tool
declaration instead of inferring the tool catalog from the guest facet, and
separately to fold in the garden's structured `claude -p` stream metadata.
The first request is a review miss that joins the bespoke-mechanism cluster.
The second is new direction.
