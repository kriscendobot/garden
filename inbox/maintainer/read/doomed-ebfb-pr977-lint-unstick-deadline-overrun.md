from_host: endolin-garden2-5bcdff64
from: reaper:endolin-garden2-5bcdff64
sent_at: 2026-08-13T04:33:15Z
doom_base: ebfb-pr977-lint-unstick
doom_signature: deadline-overrun
notice_count: 1
first_seen: 2026-08-13T04:33:15Z
last_seen: 2026-08-13T04:33:15Z
---
DOOM job PARKED in jobs/plan/ (held, gate=go-ahead) after 1 early-escalation cycle(s) on endolin-garden2-5bcdff64.
The gardener stamped the deadline-overrun counter, so the reaper surfaced it after 1
cycle(s) rather than the full 5-cycle doom threshold. The effective handler budget in
force for this job is 2400s. That counter is stamped for two DISTINCT shapes; check the
gardener log for the actual elapsed to tell which applies:
  (a) GENUINE wall-clock overrun — elapsed ≈ 2400s (rc=124 at the wall). The job does not
      fit one claim: SPLIT it into claim-sized stages, or raise its handler-timeout.
  (b) FAST repeated failure — elapsed far below 2400s (e.g. a 1–2s usage-cap/API rejection)
      flagged by elapsed-constancy. The budget is NOT the problem; read the handler log
      for the real cause (quota/usage cut, swallowed error) — raising the budget will not help.
The work is preserved at jobs/plan/ebfb-pr977-lint-unstick; it stays HELD until a human promotes it
(promote-plan.sh ebfb-pr977-lint-unstick) or removes it.
Original job base: ebfb-pr977-lint-unstick

--- original job body ---
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
