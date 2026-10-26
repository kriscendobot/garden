PR #1567 is now out of draft and ready for review.

- **Advisory appellate pass** (does not block): I read the diff myself rather than running a separate `claude -p` review. It is a test-only change to `packages/floot/test/factory-system-prompt.test.js`. The "never infers a hosted backend from a colon in modelId" test now supplies a stub provider lookup and a `fetch` that throws if called. It also asserts that no request was made, which keeps the model routing check offline. I found nothing the panel missed.
- **Before the change:** the PR was open and still a draft, and its head was `e8294ede88ecfdde246386d42c8071e606da828a`, the commit the passing panel covered.
- **Action:** I ran `gh pr ready https://github.com/endojs/endo-but-for-bots/pull/1567`.
- **After the change:** the PR is no longer a draft, and the head is still `e8294ede88ecfdde246386d42c8071e606da828a`.

No garden files changed and there are no follow-ups.

<!-- gauntlet-stage-result: undraft=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1567-gauntlet-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (174118 cached reads)
- Output: 977 tokens
- Cost: $0.3961796
- Wall-clock: 18s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
