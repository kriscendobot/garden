from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-09-27T07:46:41Z
watchdog_key: self-heal-garden-ci-watcher-kriscendobot-proposal-compartments
notice_count: 8
first_seen: 2026-09-27T02:07:45Z
last_seen: 2026-09-27T07:46:41Z
---
WATCHDOG notice — occurrence #8 (first seen 2026-09-27T02:07:45Z, latest 2026-09-27T07:46:41Z).
The SAME condition (`self-heal-garden-ci-watcher-kriscendobot-proposal-compartments`) has now been observed 8 times; this is ONE
coalesced notice that updates in place, not 8 messages. Latest detail:

self-heal: garden-ci-watcher@kriscendobot-proposal-compartments exited rc=1 with no scoped fix. Capture: d1a8064423fcb5eba3be2ccc1e165f1071903cca (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p d1a8064423fcb5eba3be2ccc1e165f1071903cca). Diagnosis: This is the recurring deploy-lag false positive documented in memory, not a new defect — no JOB emitted. The root checkout (HEAD `47b41af5a14`) is 27 commits behind `origin/main2` (`f2860db2ad05`), and the actual fix (`5620bdbe5f6` isolating CI-watcher clones per repo slug, plus `e6ea1d33fc8` and follow-on hardening) already landed on `main2` earlier today but hasn't rolled out to this host yet via the rolling deploy. No stuck-canary marker is present, so the deploy isn't wedged; it just hasn't reached this host. Systemd's restart plus the pending rollout will clear this once the root advances.
