I applied both of the round-2 panel's must-fix items to kriscendobot/minion.town#169 and pushed them as commit `cfa7685` on `fix/deploy-secret-preflight`. CI is green: all 3 checks passed (`ci-wait-merge` exited 0).

**Must-fix items**
- **stylist (names):**
  - The helper file is now `lib/guest-recovery-helpers.sh`, and `$GUEST_RECOVERY_ENVIRONMENT` is now `$GUEST_RECOVERY_HELPERS`. The panel noted it holds helper code, not an environment.
  - The two functions are now `guest_recovery_key_valid` and `guest_recovery_key_merge`.
  - `out` is spelled out as `output`. The vague `new`/`newBody` names became `fetched`/`fetchedBody`.
  - `KEY` (the S3 object key) is now `ARTIFACT_OBJECT_KEY`, and `STAGE` is now `STAGE_DIRECTORY`. Every reference and the tests are updated.
- **integrator (stale PR description):**
  - I retitled the PR "fix(deploy): render and preflight the guest-recovery key in CD" and rewrote the body. It now says the checks validate the value, not just its presence.
  - It describes the IAM grant as a prefix pattern, not an exact ARN.
  - It says this is not a rotation path and states the IAM re-apply as a step to do before merge.
  - It lists what the current tests check.

**Should-fix items, also done**
- **Last line wins:** the render check and the preflight now judge only the last `GUEST_RECOVERY_KEY=` line, because that is the one systemd uses.
- **Merge input and newline:** the merge accepts the fetched key only as exactly one valid line. If the existing `account.env` has no final newline, it adds one so the key isn't glued onto the previous line.
- **Extractor:** the script that reads the key from Secrets Manager outputs it only when the whole value is a valid key. A value with a newline can no longer add extra lines to `account.env`.
- **Second writer:** `deploy-account-endpoint-secret.sh` now checks its key against the same pattern, so its comment is accurate.
- **DEPLOYMENT.md:** updated to say which line the check judges and which characters are allowed.
- **New tests:** a valid key line followed by a short or empty one, quoted keys, keys containing a space, a file with no final newline, a fetched file with more than one line, and the extractor. The test file passes 29/29 locally and the typecheck is clean.

**Follow-ups**
- I did not squash or regroup the commits, which the integrator listed as a should-fix. The PR now has three commits.
- The CD role's IAM policy (`deploy-cd-iam.mjs`) must be re-applied before merge so the new CD step can read the secret.
- Per the job spec, I did not re-run the panel; the gauntlet driver posts panel round 3.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr169-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 50 tokens (1994298 cached reads)
- Output: 16626 tokens
- Cost: $1.4341476000000004
- Wall-clock: 466s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
