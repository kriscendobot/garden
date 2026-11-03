Panel round 4 on PR #229 ended in **must-fix**, and the review is posted. I ran exactly one round and did not fix anything or un-draft the PR, which is still a draft.

- **Pinned pair:** base `443519ebee45143cccfe3a36c10635ce24d74ae0`, head `c0822505dbd1658e950e0168920e49abec602d9f` (`kriscendobot:feat/claude-api-provider-ui`). I checked out the head detached in an isolated project worktree, and `git rev-parse HEAD` matched it.
- **Style pre-pass:** `pre-push-gates.sh --no-auto-fix --probes-only` exited 0. Its only output was a non-blocking advisory that the pruner should check the 3-line prose comment at `deploy/aws/www/provider-ui.js:468`.
- **Panel:** `panel.sh` in single-round mode exited 0. The new-mechanism probe seated the decomplector, the PR-body concision probe forced the pruner over the description, and the repeated must-fix on one mechanism forced the decomplector's is-it-needed question.
- **Review:** [posted](https://github.com/kriscendobot/minion.town/pull/229#pullrequestreview-5759594744) at 2026-11-03T21:16:59Z against the pinned head. Its state is `COMMENTED` because the PR is self-authored, and it keeps the `Must-fix before merge` heading.

**Prover's must-fix finding:** no test covers the `src/http.ts` wiring or the `inferenceProvidersEnabled` rollout gate. Deleting that whole block would not be caught, because the endpoint tests build the endpoint directly. Three behaviors are unpinned:
- With the flag off, `/account/providers` returns 404.
- With the flag on and config missing, `createApp` throws.
- With the flag on and config complete, the endpoint is mounted with its dependencies correctly wired.

I only read the prover's section of the aggregate here, so other seats may have further findings. Fix-4 should work from the full review.

**Prover's other findings:**
- **Should-fix:** the browser acceptance test can skip silently.
- **Should-fix:** the Caddy deploy-script test checks strings rather than behavior.
- **Comment-only:** the provider menu links' hidden state when the feature is off has no test shown.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr229-gauntlet-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 16 tokens (399066 cached reads)
- Output: 3796 tokens
- Cost: $0.5427572
- Wall-clock: 1355s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
