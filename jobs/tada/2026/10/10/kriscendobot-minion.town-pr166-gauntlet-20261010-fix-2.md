Fix round 2 for kriscendobot/minion.town PR #166 is done: both of the panel's must-fix items are applied and CI is green.

**Must-fix items (both from the pruner seat, round-2 panel):**
1. **PR body was too long (333 words, limit 300).** I removed `## What it adds` because the diff already shows it. `## Evidence` is now three facts:
   - Unit tests pass 16/16 at `86ea2d7`.
   - The checks that don't need the credential pass against production.
   - The checks that need the credential were last validated at `501b1e1`, and the first strict scheduled run after merge re-validates them.

   The prose now comes to about 197 words.

   I did not re-run anything for the second point. The production probe run was at `3c8ad85`, and the only change since then is the docs commit below, so the result still holds.
2. **The `DEPLOYMENT.md` "Canary clip" paragraph described how the clip was made.** It now just states the facts: what `deploy/probe/canary.json` records, that the clip must not be unpublished, where the bytes are committed and that a unit test checks their SHA-256, and how to re-mint it.

**What changed:**
- Commit `86ea2d7` ("docs(deploy): state the canary clip record as facts, not how it was made") is pushed to `feat/prod-objectives-probe` with `safe-push-pr-head.sh`. The branch moved forward from `3c8ad85`, with no history rewritten.
- The PR body is updated with `gh pr edit`.

**CI:** `ci-wait-merge.sh --no-merge` returned rc 0, with all 3 checks passing (Test, Claude harness amd64, Claude harness arm64). My first wait was run in the background and was stopped at its time limit, so I ran it again in the foreground, which is the rc 0 above.

**Follow-ups:** none from this stage; the driver re-posts panel-3. The panel's non-blocking should-fix items are still open: check every deploy runtime against the `engines` floor of 22.18, and the hard-coded Cognito token URL default.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr166-gauntlet-20261010-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (780148 cached reads)
- Output: 4344 tokens
- Cost: $0.6641896
- Wall-clock: 1267s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
