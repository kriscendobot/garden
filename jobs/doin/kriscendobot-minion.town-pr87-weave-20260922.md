---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# weave (rebase + resolve conflicts) kriscendobot/minion.town PR #87

PR: https://github.com/kriscendobot/minion.town/pull/87
Title: feat(claude): wire the Claude-agents capability behind ENDO_CLAUDE_ENABLED
Head branch: build/claude-agents-capability (kriscendobot/minion.town, bot-pushable)
Base branch: main

## Why this job exists

Handed off from the auto-shepherd `kriscendobot-minion.town-pr87-shepherd`.
The PR is APPROVED (trusted maintainer) but **not mergeable**: GitHub reports
`mergeable: false`, `mergeable_state: dirty` (CONFLICTING). Per the shepherd
brief (§ Conflicting PRs block CI dispatch) this is a weaver task, not a shepherd
fix — when the merge ref cannot be built, no new CI dispatches and pushing nudge
commits is pointless.

## Diagnosis at hand-off (2026-09-22)

- Head: `b6280ed36dbb8eca297d13593c047e4c3fad02e6` (single feature commit).
- Base `main`: `c2f0aac8e17a817ece09cda276dab7399ab40631`.
- `main...head`: **1 ahead, 36 behind**, status `diverged` — GitHub found real conflicts.
- CI is otherwise fine: the sole `test` check is green on the head SHA (run 2026-09-03),
  so once the rebase resolves conflicts and CI re-dispatches, green is expected.
- PR is still a DRAFT.

## Task

Rebase `build/claude-agents-capability` onto current `main` and resolve the
conflicts (see roles/weaver/AGENT.md, skills/conflict-resolution). Push with
`--force-with-lease` against the expected head. Once the PR reports
`mergeable_state: clean` and CI is green on the new head, the conductor will be
posted by the event watcher / a later reconcile tick (the PR is approved).
Never link to upstream agoric/agoric-sdk.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-22T01:13:10Z
