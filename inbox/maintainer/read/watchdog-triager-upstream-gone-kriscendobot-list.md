from_host: endolin-garden2-5bcdff64
from: watchdog:triager/kriscendobot-list
sent_at: 2026-08-13T14:33:14Z
watchdog_key: triager-upstream-gone-kriscendobot-list
notice_count: 1
first_seen: 2026-08-13T14:33:00Z
last_seen: 2026-08-13T14:33:14Z
---
triager: fetch for kriscendobot-list at /home/kris/garden2/worktrees/kriscendobot-list.git failed (rc=128) — the UPSTREAM APPEARS GONE (deleted/renamed fork, or this host's credentials lost access). git said: git@github.com: Permission denied (publickey). fatal: Could not read from remote repository.  Please make sure you have the correct access rights and the repository exists.
This does NOT self-heal by retrying: kriscendobot-list is not being triaged at all until it is resolved. Remedy — confirm with 'gh api repos/kriscendobot/list', then either restore access, or disarm the watch durably by adding journal watch-optout/kriscendobot-list AND removing repos/kriscendobot-list (see designs/auto-provision-fork-watchers.md).
