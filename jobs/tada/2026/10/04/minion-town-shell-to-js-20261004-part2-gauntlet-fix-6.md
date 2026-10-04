Fix round 6 for kriscendobot/minion.town PR #152 is done: I fixed all three must-fix items from panel round 6 (review 5408439681), and CI is green on the new head `d58c74c`.

**What I fixed:**
1. **breaker: symlinks dropped from Lambda packages.** `collectZipEntries` in `deploy/aws/scripts/lib/zip.js` silently skipped any symlinked file or directory. It now follows links the way `zip -r` does. A broken link, or a directory link that loops back to an ancestor, now throws an error instead of quietly producing a smaller package. I added two tests: one checks that linked files and directories get packaged, the other checks that a broken link and a link loop both throw. `test/deploy-provisioning-scripts.test.mjs` passes 32/32. The commit was pushed with `safe-push-pr-head.sh` (`1968736` → `d58c74c`).
2. **integrator: PR description overclaimed.** It said garden hosts no longer need `python3` or `zip`. It now says only that the scripts converted in this PR stopped using them, and that `deploy-siwe-thunk.sh`, `deploy-oauth2-proxy.sh` and `common.sh` still need `python3`.
3. **scribe: missing fix-loop summary.** I posted a summary comment on the PR (issuecomment-5985003488). It covers both the round-5 fix in `1968736` (scripts run through a symlink now run) and this round's fix, with test and CI status.

**CI:** `ci-wait-merge.sh --no-merge` returned rc 0, with 3 of 3 checks green.

**Follow-ups:**
- **Pool settings reset (comment-only, breaker #2).** The `preservedPoolFields` list in `deploy-pre-token-gen.js` leaves out `UserPoolAddOns` and the SMS/email message fields, so each run of the script resets them to defaults if a pool has them set. This was carried over unchanged from the old shell script, so it needs its own fix. `UserPoolAddOns` holds the advanced-security setting, so this one matters for security.
- **Late summaries (scribe).** This is the third round on this PR where the summary comment came late. The scribe proposes changing the fix-loop step in the garden's `skills/pr-creation-flow/SKILL.md` so the summary is posted when the fix commit lands. I did not make that change.
- **Next:** panel round 7, which the driver posts.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-shell-to-js-20261004-part2-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (915229 cached reads)
- Output: 7111 tokens
- Cost: $0.7845058
- Wall-clock: 342s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
