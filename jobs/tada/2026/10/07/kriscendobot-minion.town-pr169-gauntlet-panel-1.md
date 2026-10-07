PR #169 (`fix(deploy): preflight guest recovery secret`) failed panel round 1. The panel ran cleanly and returned **must-fix**, and the review is posted on the PR.

**Run:** I reviewed head `c37488c` against the PR's pinned base `d750b09` (`main-d750b09`) in an isolated checkout, using the single-round code panel. `panel.sh` exited 0 and all 32 seats returned a verdict: 4 request-changes, 16 comment-only, 12 approve. The run is recorded in the journal at `panel-runs/kriscendobot-minion.town-169/2107411b57e8.md`.

**Review:** posted at 2026-10-07T23:18:51Z with the `garden-panel … round=1 disposition=must-fix` marker. GitHub would not let the bot request changes on its own PR, so it went up as a COMMENTED review. The full aggregate was 84 KB, over GitHub's review size limit. The posted 59 KB version has a must-fix summary, the request-changes and comment-only seats in full except one comment-only seat that didn't fit, and the 12 approving seats by name only. The complete text is in the panel-run record.

**Must-fix items for the fix stage:**
- **prover:**
  - The ordering test (`test/deploy-secret-preflight.test.ts:92-102`) still passes if the production change is reverted, because `indexOf` returns -1 for a missing string.
  - `deploy-guest-recovery-key.sh` has no test.
  - The copy of the preflight that is actually pasted into the `deploy-app.sh` heredoc is never run.
- **engine-realist:**
  - The preflight accepts any non-empty `GUEST_RECOVERY_KEY`, but the app refuses keys shorter than 32 characters at startup (`src/auth/stores/dynamodb.ts:54`). A short key would pass the preflight and the deploy would still crash.
  - `DEPLOYMENT.md` treats rotating the key as routine, but rotation makes existing stored guest-recovery records unreadable.
- **purist:**
  - The IAM grant is a wildcard (`minion/guest-recovery-key-*`), but the docs call it an "exact" ARN.
  - The preflight helper doesn't follow the existing `lib/` + `common.sh` pattern.
  - Two scripts write `account.env` in different ways.
  - The test builds paths two different ways.
- **transplanter:**
  - The script assumes `python3` is on PATH, and if it's missing the error blames the secret.
  - The remote script stages through fixed `/tmp` file names instead of `mktemp`.

Nothing else is needed from this stage; the gauntlet's fix loop picks up from here.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr169-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (944874 cached reads)
- Output: 5532 tokens
- Cost: $0.7677107999999999
- Wall-clock: 233s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
