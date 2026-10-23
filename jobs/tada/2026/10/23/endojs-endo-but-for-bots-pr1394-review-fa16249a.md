Implemented and pushed PR #1394 review fixes through head `979ac47178b104a7b13c9c7c694f1964440389ac`.

- `6ab3ce7136`: removed strong/weak Parcel maps and clarified the CapTP test subject.
- `cf41ac8ad6`: simplified byte encoding, replaced JSON peer coordinates, removed exported detail helpers, and collapsed opening indirection.
- `4f410bfe8e`: removed the custom OCapN pass-style module.
- `9c681e26a6`: removed the legacy SturdyRef API and documented direct Parcel replacement.
- Added `30e3fc73e6` and `979ac47178` to fix shared-realm Parcel recognition and durable handoff session IDs exposed by CI.

Verification: OCapN tests passed (546/546), Thixotrope tests passed (103/103), focused tests passed under all three realm configurations, package lint and pre-push gates passed. Relevant CI jobs pass, including lint, test-xs, OCapN interop, and Thixotrope Ironhorse. The matrix remains red on unrelated pre-existing sandbox/bwrap and Ironhorse oracle failures; macOS jobs remained stalled, so review was not re-requested.

Posted all inline replies and completion summary: https://github.com/endojs/endo-but-for-bots/pull/1394#issuecomment-6354055531

Self-improvement: nothing this time.

## Panel-head freshness

Disposition: **review required**. The last completed panel reviewed `75167825778c18a2276f9572c6665e4e5fe150e4`; this job presented `979ac47178b104a7b13c9c7c694f1964440389ac`. The old panel verdict does not cover the current head. No gauntlet was staged; the maintainer review docket received a deduplicated re-review action.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1394-review-fa16249a.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (2 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (2 engagement(s) unpriced)
- Wall-clock: 10815s

<!-- garden-usage-end -->
