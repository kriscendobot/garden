## Viability report: endojs/endo-but-for-bots PR #1360

**PR facts:** The PR is open, unmerged and still a draft. It is a design doc, "capability URL locators — endo store --locator and the https fragment form". It adds one file, `designs/capability-url-locators.md` (517 lines). The base is the frozen `llm-47f6965` and the head is `fb5bc7ae31b`. It was opened 2026-09-28 and has no comments or reviews yet.

**Deciding question:** Is the maintainer's 2026-09-28 pivot still undecided, with no newer design or implementation on `llm`? The pivot folds `endo adopt-locator` (#1333) into `endo store --locator` and defines an https fragment form for locators.

**Evidence:**
- `designs/capability-url-locators.md` is not on `llm` (the contents API returns 404). The locator designs that are on `llm` (`daemon-locator-reference.md`, `daemon-locator-terminology.md`, `endo-content-locators-magnet-urn.md`) came before this pivot and do not cover the https fragment form or the `store --locator` fold-in.
- None of the commits on `llm` since 2026-09-28 touch locators, `store`, or capability URLs. The only URL-related commit is an unrelated npm-registry-server fix.
- The companion implementation, #1333 (`feat(daemon,cli,chat): endo store --locator …`), is still open and unmerged, and already carries the pivoted title. It has no comments or reviews reversing the direction. Its stage 2 (https share-link emission) is gated on this design being accepted, so the premise still holds.
- No newer PR has replaced this one. A title search for "locator" turns up only older or orthogonal work: #1013 (relative routing hints), #1124 and #1397 (OCapN nonce locator / SturdyRefs), #697, and #1332.

**Decision:** The PR has not been superseded, and the reason for it (a design the maintainer asked for, which gates stage 2 of #1333) is still current. The gauntlet may begin. I spent no clean, panel, fix, CI-wait or un-draft budget and changed nothing.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1360-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (166952 cached reads)
- Output: 1621 tokens
- Cost: $0.40749840000000004
- Wall-clock: 23s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
