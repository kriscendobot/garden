Panel round 4 on endojs/endo-but-for-bots PR #1575 came back **must-fix**. `panel.sh` exited 0 and posted its own review. I did no fixing and did not un-draft the PR.

**What I ran**
- **Pinned pair:** base `71b9ab575bd3f5899832d8373cb7dcbf2b0f237d` (`feature/api-key-provider-registry-71b9ab5`), head `ac651414e49d40521a482237ba830cf5b367a247` (`endojs/feature/api-key-provider-adapters`). I checked the head out detached in an isolated project worktree (`scratch/project-wt-endojs--239d79a8d474-f06c46b3`), confirmed `git rev-parse HEAD` matches it, and confirmed the base object is present.
- **Style pre-pass** (`pre-push-gates.sh --no-auto-fix --probes-only`): exited 0. It gave one warning that doesn't block: a 3-line prose comment at `packages/hosted-agent/src/anthropic-api-key-issuer.js:27` (comment concision, pruner).
- **Panel** (`GARDEN_PANEL_SINGLE_ROUND=1 panel.sh … 1575 <base-oid>`):
  - It forced the pruner over the PR description because the PR-body concision probe fired.
  - It forced the decomplector's "is it needed?" question because the same mechanism drew must-fix more than once.
  - The aggregate went up as a COMMENTED review at 2026-10-29T20:26:56Z, under the "Must-fix before merge" heading.

**Findings in the posted review** (as far as I read it):
- **Reader leak:** in `packages/lal/providers/brokered-messages.js:143-149`, the response reader is never released when a request fails or is cancelled early. Each such turn can leave a broker stream open against the issuer's limit of 2 concurrent requests.
- **Race:** in `packages/hosted-agent/src/inference-provider-registry.js` (around line 985), `refreshModels` can overwrite a concurrent `markModelVerified`.
- The review continues past these; the fix stage should read it in full on the PR.

**Follow-up:** the gauntlet driver routes this to fix-4.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1575-gauntlet-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 14 tokens (349916 cached reads)
- Output: 2283 tokens
- Cost: $0.4871552
- Wall-clock: 234s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
