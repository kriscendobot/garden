---
gate: blocked
blocked_on: build-daemon-rename-to-manager-phase2
priority: normal
posted_by: gardener
posted_at: 2026-07-02T10:16:43Z
---

# Build: daemon→manager rename Phase 3 (consumer sweep + CHANGELOG + docs)

Blocked on Phase 2 merging. Repo: endojs/endo-but-for-bots, base `llm`, bot identity.
Design: designs/daemon-rename-to-manager.md (Phase 3 + Documentation section).

Small sweep: grep the design's authoritative recipe for remaining Daemon*/Mignonic*
identifiers across packages/ and update any remaining workspace consumers (most
import unchanged names like EndoHost/EndoGuest/EndoWorker, so this is small). Add
the @endo/daemon CHANGELOG entry (makeDaemon → makeManager; exports otherwise
unchanged; outright cut, no deprecated alias). Update daemon docs' file-path/
identifier mentions (packages/daemon/CLAUDE.md line ~96 src/daemon.js→src/manager.js,
DEBUGGING.md, MULTIPLAYER.md) — leave general "the daemon" OS-process prose alone.
Also update self-referential diagnostic strings still naming old files (e.g.
bus-manager-node.js error "bus-daemon-node.js requires arguments", manager-go.js
"daemon-go.js requires arguments") if not handled in Phase 2. Optional one-liner:
rust endor.rs "legacy Node.js daemon child" comment → "manager".
