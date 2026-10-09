I applied the round-4 must-fix items to kriscendobot/minion.town PR #166 and pushed them as a follow-up commit. CI is green on the new head (`ci-wait-merge` rc 0, 3/3 checks passed).

**Commit `9572abf`** (moves the PR head from `525596d`; pushed with `safe-push-pr-head.sh`)

The panel's only must-fix was the pruner's concision item. Changes:
- **`.github/workflows/prod-probe.yml`:** removed the two comments the panel flagged (formerly lines 32 and 48).
- **`deploy/probe/prod-objectives.mjs`:**
  - Cut the header paragraph that repeated what the workflow does.
  - Removed the SDK narration comment.
  - Removed both inline "summary is public" reminders (that and the SDK note were the three comments flagged at 363, 366 and 420).
- **`src/endo/gateway/cache-policy.ts`:** removed the first sentence. This also removes the dead `designs/clip-gateway.md § 5.1` citation the archivist seat flagged.
- **`DEPLOYMENT.md`:** each check-table row now gives just the objective and its source of truth, without listing headers and directives. I trimmed the scratch-output paragraph down to the artifact name plus the rule that a public summary never carries a response body.

I also fixed one should-fix item because it was small. The purist seat found that if `HARD_CACHE_MAX_AGE` can't be parsed it becomes `NaN`, and then every `max-age` passes. The probe now throws if `IMMUTABLE_CACHE` has no positive integer `max-age`, so it fails closed instead.

`node --test deploy/probe/*.test.mjs` passes 20/20 on Node 22.23.3.

**Should-fix items still open (not blocking):**
- `package.json` still says `engines` `>=22.15.0`, but the probe needs Node 22.18 or later.
- An operator note uses the secret name `MINION_PROBE_CC_CLIENT_*`, while the workflow and docs use `MINION_PROBE_CLIENT_CREDENTIALS_CLIENT_*`. If they aren't reconciled, the strict scheduled runs will fail with `skipped: no-credential`.
- No completion summary has been posted for the new head.
- Other seats' suggestions:
  - Check the token URL's origin before sending the credential.
  - Use a unique pet name per run so concurrent runs don't collide.
  - Add a test for a strong ETag with the wrong hash.
  - Make the canary test actually run the checks.
  - Add property and boundary tests for the pure parsers and encoders.

As instructed, I did not re-run the panel; the driver posts panel-5.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr166-gauntlet-20261008-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 26 tokens (743885 cached reads)
- Output: 5178 tokens
- Cost: $0.6860730000000002
- Wall-clock: 809s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
