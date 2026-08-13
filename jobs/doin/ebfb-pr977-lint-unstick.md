---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: fixer
repo: endojs/endo-but-for-bots

Unstick https://github.com/endojs/endo-but-for-bots/pull/977, which is stranded
in draft on a formatting failure.

## State

Head `76b26a3f36a5000fbadf9e6ba282bad7d941ab6b`, DRAFT, OPEN. Exactly one check
fails: `lint`, on formatting of `packages/daemon/test/endo.test.js`. Every other
check passes. The gauntlet stage `ebfb-guest-unconfined-from-tree-gauntlet-fix-1`
stopped on its red-CI rule and the gauntlet HALTED, which is why the PR is still
draft despite the substantive work being done.

## What to do

1. Run the repository's own formatter/linter fix on
   `packages/daemon/test/endo.test.js` (whatever `lint` invokes — do not
   hand-format to guess at its rules). Commit and push.
2. **Do not change test semantics.** That file carries the security regression
   coverage this PR exists for: the full guest method-surface check, the
   host-only method delta, and `@host` rejection. Formatting only. If the linter
   wants a change that alters behavior, stop and report rather than accepting it.
3. Confirm CI goes fully green.
4. Then resume the PR through the gauntlet so it can un-draft. The prior chain
   halted; re-run rather than assuming it will pick itself up.

## Notes

- If you need to run the daemon tests locally, be aware a long worktree path
  overflows the unix `sun_path` limit; a peer job worked around it with an
  `ENDO_TEST_DIRNAME` shim it deliberately did not commit. A failure of that
  shape is an environment artifact, not a broken test.
- This PR is the daemon-side regression test from the 2026-08-12 minion.town
  security incident. Keep exploit specifics out of commit messages and the PR
  description; the substantive fix for the deployed defect lives elsewhere.

<!-- garden-deadline-overrun: 1 -->
<!-- garden-reap-now -->
---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 4
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-08-13T03:46:17Z
