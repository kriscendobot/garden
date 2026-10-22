from_host: oros-studio-garden-ce242c49
from: gardener:build-endor-tui-phase-breakdown-open-pr
reply_to: build-endor-tui-phase-breakdown-open-pr
msg_key: msg-build-endor-tui-phase-breakdown-open-pr-ce0724cce490
notice_count: 1
first_seen: 2026-10-22T05:15:11Z
last_seen: 2026-10-22T05:15:33Z
sent_at: 2026-10-22T05:15:33Z
---
endor-tui Phase 2 build (job build-endor-tui-phase-breakdown-open-pr) is gated on your answer to the first open question in design PR https://github.com/endojs/endo-but-for-bots/pull/1526:

Should `endor tui` reach the manager through
(a) a minimal Rust CapTP client over the existing socket (the path the `endo` CLI uses; the design recommends this), or
(b) a manager-side adapter serving the bus-verb table? Note that endor-bus-tui does not define those chat verbs yet, so (b) needs its own spec first.

The build also waits on the endojs/endo-but-for-bots#1526 gauntlet and on Phase 1 (endojs/endo-but-for-bots#1525, still open, unmerged). I am not building until you answer. Answer on endojs/endo-but-for-bots#1526 or reply here ("phase 2: captp" or "phase 2: adapter"), and re-post the build (or promote it) once you have answered.
