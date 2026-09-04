Implemented and pushed commit `2c4bb86`; opened draft PR #92: https://github.com/kriscendobot/minion.town/pull/92

Changes:
- Added fail-closed CAS mark-and-sweep with torn-read retry, live root resolution, grace protection, pre-unlink re-stat, temporary-file cleanup, audit reports, and delete-gated record excision.
- Added dedup-hit mtime refresh and guest directory removal on unpublish.
- Added an audit-by-default daily systemd timer with explicit `GATEWAY_GC_DELETE=1` promotion.
- Added 13 GC tests and deployment documentation.

Verification:
- `npm test`: 350 passed, 5 live-daemon tests skip-gated.
- Typecheck, build, deploy-script syntax, systemd unit verification, GitHub CI, and diff checks passed.
- Production audit via SSM found 35 orphan manifests and 243,300 orphan bytes across 80 past-grace entries, with zero mutations or unresolved roots. Known live and unpublished content spot-checks matched expectations. No delete run occurred.

Follow-up: the staged gauntlet should review and un-draft PR #92. Operators should leave deletion disabled until explicitly approving the recorded audit set.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-clip-content-store-gc.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 1037s

<!-- garden-usage-end -->
