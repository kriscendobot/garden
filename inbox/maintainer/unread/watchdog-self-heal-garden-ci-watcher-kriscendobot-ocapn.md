from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-09-27T07:36:50Z
watchdog_key: self-heal-garden-ci-watcher-kriscendobot-ocapn
notice_count: 9
first_seen: 2026-09-27T00:00:04Z
last_seen: 2026-09-27T07:36:50Z
---
WATCHDOG notice — occurrence #9 (first seen 2026-09-27T00:00:04Z, latest 2026-09-27T07:36:50Z).
The SAME condition (`self-heal-garden-ci-watcher-kriscendobot-ocapn`) has now been observed 9 times; this is ONE
coalesced notice that updates in place, not 9 messages. Latest detail:

self-heal: garden-ci-watcher@kriscendobot-ocapn exited rc=1 with no scoped fix. Capture: fd1a1d44f75638b746a4da8edc9aa1bbd9d1aa14 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p fd1a1d44f75638b746a4da8edc9aa1bbd9d1aa14). Diagnosis: This is the known ci-watcher shared-VERIFY-clone-lock-contention bug (`FATAL: cannot acquire clone lock .../verify.lock`), already fixed on `main2` — `5620bdbe5f6` ("isolate CI watcher clones per slug") plus `e6ea1d33fc8` and a string of follow-on hardening commits (`ad55dea66f9`, `1570aa85a47`, `ab66fece68f`, `4948cdd9a75`, `9dbda9d5573`, `c38cb55b172`, `5b48813cd0b`) — but the root checkout's HEAD (`47b41af5a14`) is 26 commits behind `origin/main2` (`0350fdd5bda`), so this host simply hasn't deployed the fix yet. No new code defect here; posting another `self-heal-fix` job would just duplicate work already merged upstream. Emitting no JOB block per instructions — this is a deploy-lag/environmental condition, not something a fix job would address. Recommend the root-repo-guard/deplo
