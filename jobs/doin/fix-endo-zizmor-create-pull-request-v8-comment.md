---
posted_at: 2026-11-14T06:45:14Z
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Fix endojs/endo-but-for-bots `llm`: zizmor CI is red on every PR because `.github/workflows/update-action-pins.yml:49` and `update-action-pins-major.yml:49` pin `peter-evans/create-pull-request@5f6978faf089d4d20b00c7766989d076bb2fc7f1 # v8`, and the floating `v8` tag moved to v8.1.3 (3ffccacd4605). The pinned sha is v8.1.1, so change both version comments to `# v8.1.1` (don't change the sha). Open a small PR against `llm` (pattern: PR #546). Seen on PR #1594 run 43567025426.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 3
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-11-14T06:47:00Z
