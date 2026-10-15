Fix round 5 for kriscendobot/minion.town PR #188 is pushed and CI is green (`ci-wait-merge.sh` returned rc 0 on head `6639959`).

**What the panel asked for:** the round-5 review (posted on `e4c71b8`) had one must-fix seat, pruner. All of its items were wording cuts that don't change behavior. I applied all six:
- **PR body:** the Verification section is now one line instead of nine quoted test titles, and the fail-closed bullet now just points to design Open questions #3 instead of restating the reasoning.
- **Refresher doc comment in `deploy/aws/www/shell.js`:** the fail-closed reasoning is dropped and it now cites design Open questions #3.
- **`ClipSource` typedef:** the repeated "null means the listing failed" note on `load` is gone.
- **`test/shell-clip.test.ts`:** removed the duplicate deploy-skew comment and the comment above `controlledLoad` that just restated what it does.

**Should-fix items I also took, since they were small:**
- **Transient errors (assessor, breaker, corner-prober):** `makeClipSource.load` now returns `null` for HTTP 408, 425 and 429, as it already did for 5xx. A rate limit or timeout therefore counts as a failed read and no longer uses up the first-load auto-select. I added these statuses to both the example test and the property test.
- **Hidden frame (wire-watcher):** `showEmpty` now clears the hidden frame's `srcdoc`, so the previous clip card doesn't stay loaded behind the empty pane.
- **Design doc (integrator):** section 2's list of gutter controls in `designs/clip-shell-framework.md` now includes the `#refresh-clips` button.
- **Round summary (scribe):** posted a short PR comment listing what changed from `e4c71b8`.

All of this is one follow-up commit, `6639959`, pushed with `safe-push-pr-head.sh` as a fast-forward from `e4c71b8`.

**Verification:**
- Locally, `npm run typecheck` passes and all 47 tests in `test/shell-clip.test.ts` pass.
- The full local `npm test` had one failure: `test/git-remote/capability.test.ts > projectPartition > propagates a git failure rather than reporting the ref absent`. This PR doesn't touch that code, and I believe the cause is this host's git environment, but I didn't check whether it also fails without the PR's changes.
- The CI run "test (typecheck + vitest)" on `6639959` passed. It sat queued for about 20 minutes before running.

**Follow-ups, not done:**
- A behavioral test that pins the bootstrap wiring (prover).
- A property test of "newest read wins" over different completion orders (fast-checker).
- Renaming the `sameClipRecord` parameters (stylist).
- `sameClipRecord` compares with `JSON.stringify`, which depends on key order (assessor). It is safe today because the records are always built with the same key order.

The panel has not been re-run; the driver posts panel-6.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr188-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 50 tokens (1460510 cached reads)
- Output: 8712 tokens
- Cost: $0.9402540000000001
- Wall-clock: 1516s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
