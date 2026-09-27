from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-09-27T03:10:57Z
watchdog_key: self-heal-garden-ci-watcher-kriscendobot-oros-ckm-data-readiness
notice_count: 1
first_seen: 2026-09-27T03:10:57Z
last_seen: 2026-09-27T03:10:57Z
---
self-heal: garden-ci-watcher@kriscendobot-oros-ckm-data-readiness exited rc=1 with no scoped fix. Capture: 28c8ced1404e717c71c4eeb02fdada05a57b5a77 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p 28c8ced1404e717c71c4eeb02fdada05a57b5a77). Diagnosis: This is the known, already-fixed clone-lock contention bug — matches memory `ci-watcher-shared-verify-clone-lock-contention-fixed.md` exactly (FATAL "cannot acquire clone lock .../verify.lock" for `garden-ci-watcher@kriscendobot-oros-ckm-data-readiness`). The deployed root checkout (`HEAD` = `47b41af5a14`, dated 2026-09-26 12:42) is a strict ancestor of the fix commits `5620bdbe5f6`/`e6ea1d33fc8` (landed 2026-09-27 00:01) and sits **17 commits behind** `origin/main2`, which contains not just those two but a further cascade of follow-on hardening for this exact contention path (`fix(ci-watcher): latch soft verify lock contention`, `fix(watchers): latch busy clone lock contention`, `fix(ci-watcher): take the VERIFY clone lock soft in verify_fetch`, `fix(jobs): hold clone_lock across ci-wat
