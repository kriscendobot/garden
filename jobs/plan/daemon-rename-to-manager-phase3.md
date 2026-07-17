---
gate: blocked
blocked_on: https://github.com/endojs/endo-but-for-bots/pull/780
priority: normal
posted_by: gardener
posted_at: 2026-07-17T06:15:36Z
---

# Build: daemon→manager rename Phase 3 (consumer sweep + CHANGELOG + docs)

Blocked on Phase 2 (PR endojs/endo-but-for-bots#780) merging. Repo:
endojs/endo-but-for-bots, base `llm`, bot identity.
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

NOTE (re-park by gardener, 2026-07-17): the original todo
`build-daemon-rename-to-manager-phase3` was promoted before Phase 2 landed. Phase 2
is still draft PR #780 (`makeManager` and the `Manager*` identifiers do not yet
exist on `llm`), so the CHANGELOG entry and consumer sweep cannot be written. This
plan is re-parked `blocked_on` PR #780 and the unblock watcher will re-promote it
once #780 merges/closes.
