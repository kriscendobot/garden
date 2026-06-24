---
ts: 2026-06-22T14:03:13Z
kind: result
role: librarian
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
---

Cycle 443 designs-lane ingest complete. Ingested `packages/whylip/README.md` (121 lines, commit e1a5cda5, 2026-03-10, kumavis).

Affected paths:
- `library/sources/endo-but-for-bots--packages-whylip-README-md.md` (new)
- `library/sections/endo-but-for-bots--packages-whylip-README-md--dual-backend-conversation-tree-as-mailbox-derived-reconstruction.md` (new)
- `library/sections/README.md` (updated: cycle 443 entry + total line)

Single most structurally interesting move: §the-named-dual-backend-conversation-tree-as-mailbox-derived-reconstruction. The @endo/conversation-tree package is used by both Fae and the Whylip UI with different backends: Fae's EndoPetstoreBackend persists nodes in the daemon's petname store (survives restart); Whylip UI's MemoryBackend reconstructs the tree from the CapTP mailbox on each page load. The daemon side is authoritative; the UI holds a transient derived cache. §the-named-daemon-side-as-authoritative-conversation-state as tier-3 meta-pattern.

Additional patterns named: §the-named-whylip-as-branching-primer-not-linear-chat, §the-named-scene-plus-narrative-json-schema, §the-named-structured-llm-response-as-ui-driver, §the-named-whylip-host-as-endo-guest-routing-layer, §the-named-per-book-host-profile-as-cap-isolation, §the-named-voice-input-as-whylip-affordance, §the-named-petname-store-as-general-persistent-object-store.

Citation arc delta: +6 (883 → 889). Sections: 954 → 955. Sources: 480 → 481. Post-refactor conformant docs: 90 → 91. Consecutive non-garden sources: 132 → 133.

Scholar inbox: up to date; no drain needed.

Self-improvement: nothing this time.
