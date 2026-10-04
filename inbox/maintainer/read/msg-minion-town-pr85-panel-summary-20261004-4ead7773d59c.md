from_host: endolin-garden2-5bcdff64
from: gardener:minion-town-pr85-panel-summary-20261004
reply_to: minion-town-pr85-panel-summary-20261004
msg_key: msg-minion-town-pr85-panel-summary-20261004-4ead7773d59c
notice_count: 1
first_seen: 2026-10-04T04:55:43Z
last_seen: 2026-10-04T04:55:45Z
sent_at: 2026-10-04T04:55:45Z
---
kriscendobot/minion.town#85 (clip in-place upgrade, capability-authorized): merge-decision summary

Coverage: the last panel (round 6, 32 seats: 15 approve / 11 comment / 6 request-changes) reviewed 981ae8dc. Fix round 6 then landed 804dc9c/0993b8f/3f2671e, and those were squashed into the current head 53ff65ec (same tree as 3f2671e, 3 commits). So **the latest head has NOT been panel-reviewed**. Only the round-6 fixes are unreviewed, and they are small and test-backed. CI is green at 53ff65ec (test plus both Claude harness legs). No review threads are unresolved. Your three asks (capability instead of owner identity, attenuable/revocable, upgrade powers as well as content) are all addressed in the code and the PR body.

Round-6 objections still open after the fix round:
- purist: give PowerReference a nominal brand, and make opacity per authority (it is currently one module-wide WeakMap). **Follow-up-worthy.** It is a typing refinement with no behavior change, and the MCP surface is already marked transitional (kriscendobot/minion.town#142 controller exo).
- engine-realist: one unreadable grant file makes unpublish report failure for every clip, even though the unregister already succeeded. **Follow-up-worthy.** The failure is loud and recoverable, not a security or data-loss bug.
- engine-realist: no fsync on the temp-then-rename writes. **Follow-up-worthy.** The existing vhost-table already has the same durability gap, so this PR does not introduce it.
- integrator: commit grouping and a DEPLOYMENT.md:422 line wrap. **Taste/noise.**
- Fixed but unverified by a panel: the assessor must-fix (the rollback could delete a concurrent publisher's live record; the rollback is now nonce-keyed and runs in the clip queue, with a regression test). Also the integrator must-fix (stale "rewrites without the nonce" docs), the corner-prober tests (MAX_ATTENUATION_DEPTH, malformed nonce), and the scribe summary comment. **Not must-fix**, but the race fix is the only piece worth a quick human look.

Direction caveat: this lands the stable-id in-place interim you asked for on 10-02. Your 09-04 fresh-id-on-upgrade model lives on in draft design kriscendobot/minion.town#88, so merging kriscendobot/minion.town#85 means accepting a transitional surface.

Bottom line: **merge as is** (squash-ready, CI green), after optionally skimming the publish.ts rollback hunk (~L395-425). File one follow-up for the PowerReference brand plus the unpublish grant-read/fsync hardening. It does not need a redesign or another gauntlet.
