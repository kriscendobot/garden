The review is fully handled. The merge is queued with the conductor, and the build is posted as a six-step chain of builder jobs. The production canary, legacy migration and retirement are parked until the maintainer answers the design's open questions.

**The review:** kriskowal approved #1543 and asked to "conduct the design and build the implementation". The review has no inline comments. The preflight check found no earlier resolution by a peer (exit 0). PR #1543 is open, not a draft, mergeable, and its checks are green.

1. **Conduct (merge):** `endojs-endo-but-for-bots-pr1543-conduct` was already waiting in `jobs/todo/`, posted by the approval reconciler at 01:06Z. I didn't post a duplicate. It will merge the PR, and the conductor chooses the merge method.
2. **Build:** I posted the serial orchestration `orchestrate-build-api-key-agents-20261104`, which stops if any step fails. Its six builder steps run in this order, all behind the disabled `apiKeyGuestAgents` flag so the current subscription path keeps working as the fallback:
   1. `build-api-key-agents-p0-freeze-onboarding`: the parent design's step 1, which adds the `legacyClaudeSubscription` flag, marks the old subscription signup as deprecated, and adds a check on the `--bare` credential list.
   2. `build-api-key-agents-p1-provider-registry`
   3. `build-api-key-agents-p2-provider-adapters`
   4. `build-api-key-agents-p3-provider-ui`
   5. `build-api-key-agents-p4-agent-factory`
   6. `build-api-key-agents-p5-pinned-responder`

   Each step points the builder at the design files on `llm`, or on branch `design/claude-api-key-agents` if the merge hasn't landed yet. Each step is told not to decide any of the parent design's open questions.
3. **Follow-up guard:** I parked `api-key-agents-canary-and-retirement` in `plan/` to wait for the maintainer, with the question asked at this review's URL. It covers companion phases 6–7 (the production canary with a real key, then legacy migration) and the parent design's steps 4–9 (credential revocation and deleting the old CLI path). It waits for two things:
   - the maintainer's go-ahead to run the production canary;
   - answers to the parent design's five open questions: whether to keep the Agent SDK backend as `@endo/claude`, how long legacy agents may stay parked, whether delegated agents need bulk provider attachment, how the garden gets inference afterwards, and how long the deprecation interval is.

I confirmed all eight board entries are on `origin/journal2`. I posted a reply on the PR naming the conductor job, the build orchestration and the parked item: https://github.com/endojs/endo-but-for-bots/pull/1543#issuecomment-6620327644

**Follow-ups:** none for this job. Once phases 1–5 land, the parked item needs the maintainer's answers.

## Panel-head freshness

Disposition: **review required**. The last completed panel reviewed `2866a26dbfe791e9a0ed771d52ad727e826d32da`; this job presented `b33bfd4f183bb1bfc6d5755744a943be969bcc61`. The old panel verdict does not cover the current head. No gauntlet was staged; the maintainer review docket received a deduplicated re-review action.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1543-review-ed16aaac.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (864365 cached reads)
- Output: 7733 tokens
- Cost: $0.8221009999999999
- Wall-clock: 109s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
