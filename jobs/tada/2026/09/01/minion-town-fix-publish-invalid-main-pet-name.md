---
handed-off: minion-town-pr71-land-deploy-publish-verify
deliverable-complete: false
---
Confirmed the root cause is the `guest.has("@main")` compatibility probe, not guest provisioning. The production daemon rejects that probe before falling back to legacy `MAIN`.

Reproduced the exact one-file `powers: "sites"` call: `Invalid pet name "@main"`.

Found existing draft PR https://github.com/kriscendobot/minion.town/pull/71 with the correct fallback and regression test. Independently verified its branch: 290 tests passed, 5 skipped; typecheck passed.

Posted and confirmed claimed successor `minion-town-pr71-land-deploy-publish-verify`, which owns review/merge, production deployment, successful publish/fetch verification, affected-guest confirmation, and the garden skill update.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-fix-publish-invalid-main-pet-name.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 225s

<!-- garden-usage-end -->
