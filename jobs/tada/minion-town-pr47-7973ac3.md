Implemented the revised weblet ocap design in commit `0fc92f4` and opened draft PR kriscendobot/minion.town#51 from a fresh branch because PR #47 was already merged and deleted.

Changed publishing to use guest-held `@sites`, introduced front/back directories, guest-side evaluation, directory-keyed identity, watch-based upgrades, direct `back` bootstraps, owner-scoped tools, and fail-closed legacy records. Removed the gateway powers resolver and added `weblet_upgrade`.

Verified: typecheck, build, 211 tests passed with 3 daemon integration tests skipped, both convention probes passed, and GitHub CI passed. The automated gardening wrapper still incorrectly invokes Yarn for this npm repository; PR #51 remains draft for the review/undraft stage.

Self-improvement: the PR gardening wrapper needs package-manager detection instead of assuming Yarn.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-pr47-7973ac3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 1102s

<!-- garden-usage-end -->
