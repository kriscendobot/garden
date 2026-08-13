---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: gardener
handler-timeout: 7200
repo: endojs/endo-but-for-bots

Run the gauntlet on https://github.com/endojs/endo-but-for-bots/pull/977 so it
can come out of draft. Third attempt; the first two failed for an environmental
reason that has since cleared.

## State (verified 2026-08-13 ~16:10Z)

- Head `cc282686478acc2daeda4f9b2b009a48780b259e`, DRAFT, OPEN, CI fully green.
- Two prior gauntlets (`ebfb-guest-unconfined-from-tree-gauntlet`,
  `ebfb-pr977-gauntlet-rerun`, plus a stray `ebfb-pr977-lint-unstick-gauntlet`)
  all HALTED. The last two halted at their panel stage for the SAME reason:
  juror sessions returned empty verdicts after three attempts against a provider
  usage limit around 04:36Z, producing `orchestration-failed: true` with zero
  billable tokens. That was a rolling session-window limit, not the account's
  weekly ceiling, and it reset hours ago. The maintainer has confirmed there is
  ample quota. **Proceed at full speed.**

## What to do

Run the full chain (clean, panel review, fix-loop, un-draft) per
`skills/pr-creation-flow/SKILL.md`, through the gardening state machine so each
stage is claim-sized. Do NOT attempt the chain inside one handler; a predecessor
overran 2400s doing exactly that.

## Constraints

- **Do not weaken the tests.** This PR is the daemon-side security regression
  coverage from the 2026-08-12 minion.town incident: the full guest method
  surface, the host-only method delta, `@host` rejection, and rejections pinned
  to the `no method "<name>"` message shape so a name that prefixes another
  (`makeUnconfined` vs `makeUnconfinedFromTree`) cannot pass on a sibling's
  error. If a panel seat proposes simplifying any of that, push back and report
  rather than complying.
- If jurors return empty verdicts or zero-token completions again, that is the
  provider condition, not a defect in the PR. Report it and stop rather than
  looping.
- Keep exploit specifics out of the PR description and commit messages.
- Environment note: a long worktree path overflows the unix `sun_path` limit when
  running the daemon tests locally; a peer worked around it with an
  `ENDO_TEST_DIRNAME` shim it did not commit. A failure of that shape is an
  environment artifact, not a broken test.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 4
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-13T16:11:02Z
