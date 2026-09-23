Resolved PR #1080’s two inline requests.

- `089f9a8da`: generated declarations now retain concrete root-follower reader types; regression test added.
- `031f15d0a`: standardized the backend stream seam on `followRoot`.
- `75e1589b7`: fixed the touched test’s JSDoc import gate.

Posted inline replies (3892021628, 3892021732), a PR summary, and re-requested kriskowal’s review. GitHub CI matrix is green on head `75e1589b7`; focused tests and pre-push gates passed. Full local harness was blocked by unrelated host-shell daemon startup and missing `c/moddable` submodule.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1080-review-09542d7d.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 2 host(s) (3 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (3 engagement(s) unpriced)
- Wall-clock: 3681s

<!-- garden-usage-end -->
