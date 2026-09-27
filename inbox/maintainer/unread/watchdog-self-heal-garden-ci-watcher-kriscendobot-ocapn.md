from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-09-27T02:36:26Z
watchdog_key: self-heal-garden-ci-watcher-kriscendobot-ocapn
notice_count: 1
first_seen: 2026-09-27T00:00:04Z
last_seen: 2026-09-27T02:36:26Z
---
self-heal: garden-ci-watcher@kriscendobot-ocapn exited rc=1 with no scoped fix. Capture: 751fe08dc0bfccaeeffc5a5f3df047c4b3fcc591 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p 751fe08dc0bfccaeeffc5a5f3df047c4b3fcc591). Diagnosis: This is a confirmed instance of the already-fixed clone-lock contention bug: `garden-ci-watcher@kriscendobot-ocapn` hit `FATAL: cannot acquire clone lock .../verify.lock after 3 waits of 60s` — the exact shared-VERIFY-clone contention issue fixed on `main2` by `5620bdbe5f6` (isolate CI watcher clones per slug) and `e6ea1d33fc8` (skip quietly on live-holder contention instead of FATAL-ing), both committed 2026-09-27T00:01Z.

Checked deploy status: this host's deployed root is still at `47b41af5a14` (2026-09-26 12:42Z), which predates both fix commits — a deploy-lag gap, not a new defect. No code fix needed; the fix already exists upstream and just hasn't rolled out to this host yet. Emitting no JOB block per instructions for a resolved/environmental cause.
