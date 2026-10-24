I applied the round-15 panel's fixes to PR #218 (kriscendobot/minion.town) and pushed them. CI is green: `ci-wait-merge.sh` returned rc 0 with 4/4 checks passing on head `f887332a`. The source was review 5637884676, the latest panel verdict; the job carried no pre-pass block.

**Commits** (pushed with `safe-push-pr-head.sh`, head moved from `65afe31e` to `f887332a`):
- **`8bb9965b` (corner-prober 1, must-fix):** The backfill's first scan page expanded the empty `start_key` array without a guard. Bash 3.2 through 4.3 abort on that under `set -u`, so the deploy would fail on old Bash. It now uses `${start_key[@]+"${start_key[@]}"}`. A new test fails on any unguarded `"${name[@]}"` in the script and checks that the guarded form expands to nothing under `set -u`.
- **`f887332a` (wording and trims):**
  - **Archivist 1 (must-fix):** design § 2 now says the ledger `PutItem` deny blocks only whole-row replacement, and points to § 8 for deletes and attribute edits.
  - **Archivist 2–5:**
    - The `accountKey` comment no longer lists `policy.ts`, which joins with NUL, not a space.
    - The portability amendment is described as already in DEPLOYMENT.md.
    - The approval-provenance sentence is gone from the design; the PR body's Decision section still records it.
    - The `→`, `≤` and `…` characters that had been rewritten are restored, and `identity.ts` is rewrapped to 80 columns.
  - **Pruner 2–6:** shortened the DEPLOYMENT.md rollout paragraph, removed the § 8 pointer and the repeated grant list in § 8, and deleted five comments that only narrated the code.
- **PR body (pruner 1):** trimmed to 281 words.

**Not fixed:**
- **Decomplector 1** asks again to move the ledger to #220. I declined it, as in rounds 12–14: the arc supervisor decided on 2026-10-23 and 2026-10-24 to keep it in this PR. Decomplector 2–3 are should-fix and stay deferred as directed.
- **Corner-prober 2–4** were rated summary-fix and are deferred. Adding a `row_kind` check to the bond's account update would widen the IAM attribute grant, so that belongs with #220. `recoverGuest` already returns nothing for ledger rows.

The follow-up comment answering each finding is https://github.com/kriscendobot/minion.town/pull/218#issuecomment-6383035860.

**Local checks:** typecheck is clean, and the accounts and backfill suites pass (210 tests). The full suite has one failure, in `test/git-remote/capability.test.ts` ("propagates a git failure…"). I believe it is the known local git-wrapper false failure; this PR doesn't touch that file, and CI's test job passed. Shellcheck shows the same findings as before the change.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr218-gauntlet-fix-15.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 56 tokens (2196704 cached reads)
- Output: 12526 tokens
- Cost: $1.3753247999999998
- Wall-clock: 1112s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
