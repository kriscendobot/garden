from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-09-22T02:05:07Z
watchdog_key: self-heal-garden-receipt-watcher-kriscendobot-finbot
notice_count: 1
first_seen: 2026-09-22T02:05:06Z
last_seen: 2026-09-22T02:05:07Z
---
self-heal: garden-receipt-watcher@kriscendobot-finbot exited rc=1 with no scoped fix. Capture: 9ce479faad12671e569133bb562a29d315c40303 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p 9ce479faad12671e569133bb562a29d315c40303). Diagnosis: The root checkout is 31 commits behind `origin/main2`, and this exact failure signature is already root-caused and fixed there — commit `06690f63fa` ("fix(receipt-watcher): guard empty prereq stderr + fix perm-silencing exec in clone_lock") isn't yet an ancestor of this host's deployed HEAD (`917115c9b7`). The single-line tail we captured (`FATAL: receipt journal prerequisite failed for kriscendobot/finbot (rc=1; see prerequisite stderr above)`, with no `prerequisite:` diagnostic line before it) is the exact symptom that commit fixes: `sed 's/^/  prerequisite: /' "$PREREQ_ERR"` silently prints nothing when `$PREREQ_ERR` is empty (the `clone_lock` timeout path was permanently silencing subshell stderr via a bare `exec {fd}>&- 2>/dev/null`), so `die` fires with no visible cause. This is th
