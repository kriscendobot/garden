---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: gardener
handler-timeout: 7200
repo: endojs/endo-but-for-bots

Run the gauntlet on https://github.com/endojs/endo-but-for-bots/pull/977 so it
can come out of draft.

## State (verified 2026-08-13 ~04:30Z)

- Head `cc282686478acc2daeda4f9b2b009a48780b259e`, DRAFT, OPEN.
- **CI is fully green.** The formatting failure that stranded it is fixed
  (`fixup! test(daemon): exercise full host-only surface from guest and @host`).
- The earlier chain `ebfb-guest-unconfined-from-tree-gauntlet` HALTED at its
  `fix-1` stage on that red CI, which is why the PR is still draft even though
  the substantive work is done.

## What to do

Run the full chain (clean, panel review, fix-loop, un-draft) per
`skills/pr-creation-flow/SKILL.md`, driving it through the gardening state
machine so each stage is claim-sized. **Do not attempt the chain inside one
handler.** The predecessor job `ebfb-pr977-lint-unstick` overran its 2400s budget
at exactly that, which is why this is posted separately with a supervisor budget.

## Constraints

- **Do not weaken the tests.** This PR is the daemon-side security regression
  coverage from the 2026-08-12 minion.town incident: the full guest method
  surface, the host-only method delta, `@host` rejection, and rejections pinned
  to the `no method "<name>"` message shape so a name that prefixes another
  (`makeUnconfined` vs `makeUnconfinedFromTree`) cannot pass on a sibling's
  error. If a panel seat proposes simplifying any of that, push back and report
  rather than complying.
- Keep exploit specifics out of the PR description and commit messages. The
  deployed defect and its remediation live elsewhere and are the maintainer's to
  disclose.
- If CI goes red again, stop and report which check and why rather than looping.
- Environment note: a long worktree path overflows the unix `sun_path` limit when
  running the daemon tests locally; a peer worked around it with an
  `ENDO_TEST_DIRNAME` shim it did not commit. A failure of that shape is an
  environment artifact, not a broken test.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-08-13T04:28:46Z
