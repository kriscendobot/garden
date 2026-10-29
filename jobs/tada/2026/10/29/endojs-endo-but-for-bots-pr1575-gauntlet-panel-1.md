Panel round 1 on PR #1575 returned **must-fix**. `panel.sh` exited 0 and posted its own review.

- **Pinned pair:** base `71b9ab575bd3f5899832d8373cb7dcbf2b0f237d`, head `096598354304dbde311e34fa6d4e76800e2cbc96`. The head is `feature/api-key-provider-adapters` on `endojs/endo-but-for-bots`, checked out detached in an isolated worktree. `git rev-parse HEAD` matched the retained head ID.
- **Pre-pass:** the read-only probes exited 0. The only output was a non-blocking advisory that the pruner should look at the 3-line prose comment at `packages/hosted-agent/src/anthropic-api-key-issuer.js:27`.
- **Panel:** the PR-body concision probe fired, so the pruner was forced over the description. The result is must-fix, and I did not fix or un-draft anything. The must-fix findings are in the posted review, not in my output. The stage-result marker is below.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1575-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (235665 cached reads)
- Output: 1397 tokens
- Cost: $0.2228525
- Wall-clock: 453s

<!-- garden-usage-end -->
