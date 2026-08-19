---
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
kriscendobot/minion.town#36 ("feat: remove toy minion tools and prune demo-only
minion scopes") is being superseded by kriscendobot/minion.town#20, which the
maintainer just approved and is being merged (job
kriscendobot-minion.town-pr20-merge-20260819) -- #20 does the same toy-tool/
mcp:minions:* removal, coupled with the B5 feature.

Before closing #36, verify one thing: #36 was described as also adding a
`whoami` baseline tool. Check whether #20 (once merged) already includes an
equivalent, by diffing #36 against #20's merged state. If #20 does NOT cover
that addition, do not silently drop it -- post a small follow-up job to port
just the `whoami` tool forward, then close #36. If #20 already covers it (or
#36 turns out to have no independent value beyond the removal #20 also does),
close #36 with a comment pointing at #20 as the superseding PR and explain why
in one or two sentences. Standard authorization: commenting on this repo is
covered by its standing authorization (check
journal/projects/minion-town/README.md if it's unclear).

<!-- garden-reaped: 0 -->

<!-- garden-reap-now -->
---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-08-19T04:53:23Z
