Addressed the full approved review on kriscendobot/minion.town PR #62; it had no inline comments.

- Pushed `1aafcbefe6a98b0ed925838f85859da2ff0d6f34`, centralizing `@main`, updating the guest-provisioning seam, preferring `@main` when endowed, and retaining `MAIN` compatibility for the current Endo pin.
- Linked upstream provisioning work at https://github.com/endojs/endo-but-for-bots/issues/982.
- Updated the PR title/body and posted summary https://github.com/kriscendobot/minion.town/pull/62#issuecomment-5486102816.
- Checks: six pre-push probes passed; `npm run typecheck`, `npm run build`, and local verification succeeded; `npm test` reported 289 passed and 5 existing real-daemon skips. Current-head CI is green, and the PR is approved, CLEAN, and MERGEABLE.
- Dispatched conductor job `kriscendobot-minion-town-pr62-conduct-20260831` to finalize the merge.
- Follow-up: Endo issue #982 owns exposing the retained guest worker as an indelible `@main`; Minion Town will switch automatically after its Endo pin advances.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr62-review-353e723b.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 516s

<!-- garden-usage-end -->
