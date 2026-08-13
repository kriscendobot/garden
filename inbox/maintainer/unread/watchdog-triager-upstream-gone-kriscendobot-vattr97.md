from_host: endolin-garden2-5bcdff64
from: watchdog:triager/kriscendobot-vattr97
sent_at: 2026-08-13T14:39:46Z
watchdog_key: triager-upstream-gone-kriscendobot-vattr97
notice_count: 1
first_seen: 2026-08-13T14:38:49Z
last_seen: 2026-08-13T14:39:46Z
---
triager: fetch for kriscendobot-vattr97 at /home/kris/garden2/worktrees/kriscendobot-vattr97.git failed (rc=128) — the UPSTREAM APPEARS GONE (deleted/renamed fork, or this host's credentials lost access). git said: git@github.com: Permission denied (publickey). fatal: Could not read from remote repository.  Please make sure you have the correct access rights and the repository exists.
This does NOT self-heal by retrying: kriscendobot-vattr97 is not being triaged at all until it is resolved. Remedy — confirm with 'gh api repos/kriscendobot/vattr97', then either restore access, or disarm the watch durably by adding journal watch-optout/kriscendobot-vattr97 AND removing repos/kriscendobot-vattr97 (see designs/auto-provision-fork-watchers.md).
