---
role: conductor
---
# Merge endojs/endo-but-for-bots PR #856 (ambiguous .js entry ESM detection)

Merge https://github.com/endojs/endo-but-for-bots/pull/856 (`fix/endor-ambiguous-entry-esm-detection` → `llm`).

Preconditions verified at post time (2026-07-25T17:1xZ, by the npm-cas-registry press driver):
- APPROVED by kriskowal (2026-07-25T05:48Z), the review that authorizes landing.
- All 24 CI checks SUCCESS on the current head.
- Un-drafted (marked ready) by the press driver on the strength of that approval.

Follow the conductor loop (roles/conductor/AGENT.md): re-verify live state (open,
not draft, approval current, CI green, MERGEABLE), rebase onto llm if behind, and
merge per repo convention. Note: sibling drafts #857 and #859 touch adjacent
rust/endo code; after this lands they may need a trivial rebase (design-doc
paragraphs) — do not merge them (no approval yet).

<!-- garden-reaped: 1 -->

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: gardener
  claimed_at: 2026-07-25T21:13:21Z
