Fix round 6 for kriscendobot/minion.town#254 is pushed and CI is green: `ci-wait-merge.sh --no-merge` returned rc 0 with 7 of 7 checks passing, including the browser gate on Chromium, Firefox and WebKit.

**Which reviews I applied.** No pre-pass block came with the job. Two panel reviews were posted after the last head commit (`314b1d6`) and neither had been answered: 5815955862 (01:32Z) and 5815993072 (01:46Z). I applied the must-fix items from both. Four commits now sit on `fix/recovery-outcome-screen` at `80927f0`, pushed with `safe-push-pr-head.sh` as a fast-forward.

**What changed:**
- **Transient recovery copy (breaker, integrator):** when the recovery check itself fails, the "temporarily unavailable" card now reads "Guest recovery is temporarily unavailable". Its copy mentions only the sign-in, not a guest key the browser doesn't have. A new `temporaryOutcomeCopy` function supplies the title and message.
- **typist:** `recoveryProvider` is declared `unknown`.
- **saboteur:** the landing's catch-all now logs unexpected errors with `console.error`.
- **archivist, breaker, integrator:** the visitor table and the unbonded-account section in `designs/closed-beta-waitlist.md` now list the outcome cards and the retry behavior. The Caddy landing comment is updated to match.
- **decomplector, coverage-auditor:** removed `dev/recovery-outcome-browser-demo.ts`.
- **corner-prober:** the browser gate now covers a failed first load followed by a successful in-place retry, for both `#recover=1` and `#v=1&guest=`, with no saved key. Added tests for the 64-character provider label and for a 500 wait-list response.
- **fast-checker:** added property tests for `invitationFailureMessage` across statuses 400–599, and for how recovery outcomes are stored and consumed once.
- **stylist:** renamed `t` to `testContext`.
- **releaser:** rewrote the changeset with one paragraph per audience. The Caddy reload instruction comes first and says what happens without it, and `identityProvider` is marked optional.
- **pruner:** cut the redundant clause from the `index.html` card comment, and cut the PR body to about 170 words. I kept the `home.js` retry comments: the earlier pruner wanted them gone, but the later pass judged them worth keeping.

I posted a per-finding summary comment on the PR (issuecomment-6715872296).

**Local checks:**
- `tsc` is clean.
- The affected Vitest suites pass (88 tests).
- The probe tests pass 36 of 36.
- The landing browser gate passes in Chromium. Firefox and WebKit can't launch here because system libraries are missing; both passed in CI.
- The full `npm test` run had one failure, in `test/git-remote/capability.test.ts`. This PR doesn't touch that code, and the failure is probably caused by the sandbox's git environment. The CI `test` job passed.

**Follow-ups:**
- `ensure-project-worktree.sh` failed with EROFS again (the known monk-sandbox issue). I worked in a fresh clone under `$TMPDIR` instead.
- My first `ci-wait-merge` run was in the background and was stopped at the 10-minute limit. I polled checks in the foreground, then reran `ci-wait-merge` in the foreground, which gave the rc 0 above.
- The panel-6 job still shows as in progress on the board.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr254-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 106 tokens (5316256 cached reads)
- Output: 21748 tokens
- Cost: $2.464987200000001
- Wall-clock: 2728s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
