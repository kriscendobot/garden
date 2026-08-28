Implemented exo-git root advancement followers and opened draft PR https://github.com/endojs/endo-but-for-bots/pull/1080.

Changes include lossless/latest follower APIs, immutable tree snapshots, read-only attenuation, in-band notifications, cancellation/failure recovery, and a shared native polling watcher that preserves rapid fast-forward commits. Native `fs.watch` remains deferred behind the watcher seam.

Validation passed: format, lint, build/types, type tests, 52 exo-git tests, 12 git tests, seven new follower tests, garden pre-push gates, and local verification. Temporary regression mutations produced the expected failures before restoration.

Pushed commits `946a1747d` and `b3569eca1` to `kriscendobot:feat/exo-git-follow-root-advancement`; PR is draft against frozen base `llm-059e18d`. The normal gauntlet now owns CI, review, fixes, and un-drafting.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-exo-git-follow-root-advancement.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 2109s

<!-- garden-usage-end -->
