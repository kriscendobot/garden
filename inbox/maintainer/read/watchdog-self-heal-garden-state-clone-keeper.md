from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-09-03T23:23:58Z
watchdog_key: self-heal-garden-state-clone-keeper
notice_count: 1
first_seen: 2026-09-03T23:23:58Z
last_seen: 2026-09-03T23:23:58Z
---
self-heal: garden-state-clone-keeper exited rc=127 with no scoped fix. Capture: 0a32b360dd467b81b2e8634e26bb5dc955b62d17 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p 0a32b360dd467b81b2e8634e26bb5dc955b62d17). Diagnosis: ## Diagnosis

This is a **repeat occurrence of an already-diagnosed issue**, not a new bug. `garden-state-clone-keeper` exits 127 because its `ExecStart` (`/home/kris/garden/scripts/jobs/self-heal-run.sh garden-state-clone-keeper -- /home/kris/garden/scripts/jobs/state-clone-keeper.sh`) points at a script that doesn't exist in this host's deployed root checkout — HEAD is pinned at `252205765d`, which predates the commit (`830a4b299b`) that introduced `state-clone-keeper.sh` at all. The rendered systemd unit (`~/.config/systemd/user/garden-state-clone-keeper.service`) was installed from a *later* checkout state than what's currently detached at `$GARDEN_ROOT`, so the unit and the tree are skewed.

I confirmed the exact same signature was caught and fixed **52 minutes ago** by job `self-he
