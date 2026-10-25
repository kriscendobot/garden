Fix round 2 for kriscendobot/minion.town PR #220: the style pre-pass failure is fixed, the commit is pushed, and CI is green (7 of 7 checks, 0 failed).

**What changed**
- **`numRuns` failures (2 files):** `test/settings-menu.test.ts` and `test/deploy-guest-credential-gate.test.ts` failed the spell-out probe on `numRuns`. Renaming it isn't possible: it's fast-check's own option name. I added the line `// spell-out-exempt -- `numRuns` is the fast-check parameter name.` as the first line of both files. That is the same opt-out marker `test/accounts.test.ts`, `test/waitlist.test.ts` and `test/web/guest-settings-http.test.ts` already use.
- **Re-run:** the probe now passes against `origin/main`.
- **Advisory comment (non-blocking):** I kept the 6-line comment in `deploy/aws/scripts/deploy-accounts-store.sh` near line 176. It records reasons the code alone doesn't show: rows deleted or rebound after the scan, why the transaction is all-or-nothing, and why the last item is conditional. So it isn't just restating the code next to it.

**Push and CI**
- Pushed commit `cebd636a` ("test: mark fast-check's numRuns parameter as an exempt name (#220)") to `split/pr216-account-deletion` with `safe-push-pr-head.sh`. It was a fast-forward from `aee8ea91`.
- `ci-wait-merge.sh --no-merge` exited 0. I accidentally started a second copy of the CI wait; it was stopped at its time limit and had no effect.

**Follow-ups:** none. The driver posts panel round 3. Prettier isn't set up in this project (`npx` fetched a default copy that flags files this PR doesn't touch), so I ignored its warnings.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr220-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (889347 cached reads)
- Output: 3864 tokens
- Cost: $0.7095974
- Wall-clock: 1360s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
