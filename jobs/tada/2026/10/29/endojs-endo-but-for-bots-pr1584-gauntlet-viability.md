**Viability report: endojs/endo-but-for-bots PR #1584** ("test(ses): smoke-test the host text codecs on XS")

The PR is open, unmerged and still a draft. Head is `f6a05cde2b`, a single commit pushed 2026-10-29T04:59Z. It is based on the frozen branch `master-6ee3fda`.

Deciding question: Does `master` still lack XS coverage for the host `TextEncoder`/`TextDecoder` (present-codecs and absent-codecs cases), with no other open or merged PR providing it?

Evidence:
- **Base is current.** Comparing `6ee3fda…master` on endojs/endo-but-for-bots gives ahead 0 and behind 0, so the frozen base equals today's `master` tip. There is no newer base history that could have displaced the PR.
- **No codec coverage on master.** `packages/ses/test/_xs.js` on `master`, in both endojs/endo-but-for-bots and upstream endojs/endo, never mentions `TextEncoder` or `TextDecoder`. Its last change was 2025-05-28.
- **The premise still holds.** endojs/endo#3322 permitted the codecs but tested them only on Node. The XS coverage existed only in #1349, which was closed at 2026-10-29T03:58Z after endojs/endo#3376 superseded its encapsulation, so that coverage never landed. #1584 was opened about an hour later to carry just the XS assertions.
- **No competing PR.** #1425 is related but separate: it fixes how SES-for-XS samples globals at import time. #1584 says it does not depend on #1425 and works around that sampling by deleting the codecs before SES loads. #1431 and #1576 change only design docs, and #1381 (merged) only marked the design implemented. None adds XS codec tests.
- **No discussion yet.** The PR has no comments or reviews, so nothing raises a supersession question.

Both claims are supported: the PR has not been superseded, and the gap that motivated it is still open on the current base. The gauntlet may begin. Nothing was changed: no commits, pushes or PR edits.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1584-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 6 tokens (122482 cached reads)
- Output: 1741 tokens
- Cost: $0.4241964
- Wall-clock: 29s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
