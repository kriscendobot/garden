I pushed the round-4 fixes to PR #171, but CI never ran: GitHub Actions refused to start any of the three jobs because of an account billing or spending limit. So the fix has no CI result yet. I did not rerun or push more, per the stage rules, and `ci-wait-merge.sh` says the maintainer has already been alerted.

**Fix pushed:** commit `d3bf7e8` on `feat/claude-arc-prod-validation` (up from `e49f49f`), pushed with `safe-push-pr-head.sh` as an added commit, not a rewrite.

**Must-fix items applied:**
1. **`DISABLE_UPDATES` check removed.** The probe was reading the flag from the `minion-mcp` parent process, but `cli-launch.ts` never passes it to the `claude` processes it starts. As the panel asked, I didn't patch that read again:
   - `deploy/probe/claude-harness.mjs`: the on-box program no longer reads the parent's environment (no `systemctl … MainPID`, no `/proc/<pid>/environ`). The `serviceRunning` and `disableUpdates` fields and their two checks are gone. The `claude --version` smoke run no longer sets `DISABLE_UPDATES=1`, so it starts the binary the same way production does.
   - `deploy/probe/prod-objectives.mjs`: `upgradePolicy` now reads "root-owned read-only artifact and parent directories".
   - `deploy/probe/prod-objectives.test.mjs`: removed the `DISABLE_UPDATES` assertions. The program-shape test now asserts that the program reads no service environment.
   - `DEPLOYMENT.md`: the `claude-harness-pinned-upgrade-policy` row drops the environment clause and says root ownership is what blocks self-update, and why `DISABLE_UPDATES` isn't checked. The least-privilege paragraph no longer says the program reads the running service's environment.
2. **Wording:** `DEPLOYMENT.md` now says "The checked production objectives of" instead of "primary-phase objectives".
3. **PR body cuts (504 → 462 words):**
   - "Not in this PR" is now one sentence: the confinement check is deferred pending #167 and tracked on kriscendobot/garden#89.
   - Dropped the trailing "and this PR does not harden the workflow further in its place".
   - Removed the `DISABLE_UPDATES` claim from the summary.
   - The old production-evidence line about `DISABLE_UPDATES` is now marked as what the check asserted at the time.
   - The regression-evidence line now names the ownership violation. I checked that claim: with the owner check disabled, 2 tests fail; the file was then restored.

**Tests:** `node --test deploy/probe/prod-objectives.test.mjs` passes, 25 of 25.

**Should-fix items not done:** reusing `validateRelease`, regrouping the commits, rerunning the probe at the new head, the `vm.Script` parse test, a single file for the harness layout, and keeping the `ssm wait` error line. These were at the fixer's discretion. Two of them need a production probe rerun or a history rewrite.

**Follow-ups:**
- Once Actions billing is fixed, the driver needs to re-watch CI for `d3bf7e8`.
- Making `DISABLE_UPDATES` actually reach the spawned `claude` would need a separate `cli-launch.ts` allowlist change, and the maintainer would have to confirm it.

<!-- gauntlet-stage-result: fix=ci-billing-blocked -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr171-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (1069093 cached reads)
- Output: 7291 tokens
- Cost: $0.8670706
- Wall-clock: 167s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
