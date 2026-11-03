# FIX round 2 report: kriscendobot/minion.town PR #234

I applied the panel's findings from review 5751071420, except the commit-history finding (below), and CI is green at the new head. The head moved from `ec58aa32` to `a909f9be` through four follow-up commits, pushed with `safe-push-pr-head.sh` in advance mode.

## What changed

**`f89d91a8` fix(web): forget and dismiss (saboteur, breaker, purist, engine-realist)**
- `forgetContact` and `dismissAllMail` now make the `assertNotOvertaken` check that their sibling acts make.
- The comment listing the acts now includes both.
- `forgetContact` reuses a widened `removeName` instead of `has` then `remove`.
- `dismissAllMail` tolerates an overlapping rejection when no mail remains.
- The fault-test daemon's `remove` now throws on an absent name, as the real one does.
- New tests cover the overtaken cases, overlapping forgets, a forget that really fails, and a dismissal that rejects.

**`10a59872` fix(web): router answers (saboteur, wire-watcher)**
- A malformed percent escape now answers 400 instead of 503, with or without a bearer.
- The router records the accepted name, so replaying an accepted invitation after a forget answers 404 `invitation-unavailable`. Before, the browser said "Invitation accepted." with no contact made.
- Both have HTTP tests, and the router comment is tightened.

**`b27f18ab` fix(probe): round trip**
- **Disclosure scan:** it now covers the accept, re-accept and every mail-poll answer, using one helper shared with `guestStateViolations`.
- **Cleanup:** it is awaited in full before the retry starts, and is no longer listed as a step in the summary.
- **Names:** `prod-probe-self` joins the fixed names and the reset.
- **Failure reporting:** a body read failure keeps its step name, and `StepFailure` becomes a function.
- **Comments:** the restating comments the pruner flagged are gone.
- **Daemon test:** it now asserts that real message envelopes hold neither bearer.

**`a909f9be` docs(probe)**
- Added the check-table row and both bearers to the local-run recipe.
- Added the two routes to the route admission ledger and the Caddyfile comment.
- Trimmed the runbook paragraph, stated the merge-to-deploy window, and cited the coupon path from `designs/guest-coupons.md`.
- Updated the CI comment in `test.yml`.

**PR body (edited through `gh`, not a commit):** cut from 632 words to about 425. I removed the step list and test tallies, and added the merge-to-deploy window and the fact that forgetting revokes nothing.

## Verification
- **Local tests:** probe tests 34/34, `vitest run test/web` plus the Caddy floor test 140 passed with 4 skipped (the daemon suite), and typecheck clean.
- **Pre-push checks:** all 8 pre-push probes pass, and the cliché and orthography greps found nothing. The comment-concision advisory fired on the `INVITATION_PROBE_NAMES` rationale comment; I kept that comment because it explains why the names are fixed.
- **Mutation checks:** putting back the old cleanup made the new retry test fail. Putting back the old `forgetContact` made the overlap and overtaken tests fail.
- **CI:** `ci-wait-merge` returned rc 0, with both Actions runs successful. The bot token can't read the status rollup, so commit statuses and non-Actions checks weren't visible. In the log, the live-daemon suite ran with `ENDO_CHECKOUT` set and passed 4/4, including the new envelope assertion.

## Not applied
- **Integrator #4, redistributing commits into `feat(web)` and `feat(probe)`:** this finding needs a history rewrite, but this stage is required to push follow-up commits. It needs a separate retcon if wanted, and panel-3 may raise it again.
- **Comment-only notes left as they are:**
    - renaming `forgetContact` to `removeContact`
    - message-number reuse in the memory backend after a dismissal
    - growth of the invitation map (already disclosed in the PR body)
    - the probe's worst-case time budget against the job timeout (awaited cleanup adds up to about 100s per pass in the worst case)
    - a daemon test showing whether a forgotten remote invitation stays redeemable, which is still unverified; the docs now say forgetting revokes nothing

## Other notes
- The new mail scan has not run against live prod. The real-daemon CI test is the evidence it won't cause a false red.
- The merge-to-deploy window is documented rather than removed: a probe run between merge and deploy will go red and open the tracking issue until the deploy lands.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr234-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (2157020 cached reads)
- Output: 36902 tokens
- Cost: $2.27986
- Wall-clock: 943s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
