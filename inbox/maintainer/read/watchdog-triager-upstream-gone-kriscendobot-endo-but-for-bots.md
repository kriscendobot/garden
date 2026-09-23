from_host: endolin-garden2-5bcdff64
from: watchdog:triager/kriscendobot-endo-but-for-bots
sent_at: 2026-08-13T14:37:01Z
watchdog_key: triager-upstream-gone-kriscendobot-endo-but-for-bots
notice_count: 1
first_seen: 2026-08-13T14:36:45Z
last_seen: 2026-08-13T14:37:01Z
---
triager: fetch for kriscendobot-endo-but-for-bots at /home/kris/garden2/worktrees/kriscendobot-endo-but-for-bots.git failed (rc=128) — the UPSTREAM APPEARS GONE (deleted/renamed fork, or this host's credentials lost access). git said: git@github.com: Permission denied (publickey). fatal: Could not read from remote repository.  Please make sure you have the correct access rights and the repository exists.
This does NOT self-heal by retrying: kriscendobot-endo-but-for-bots is not being triaged at all until it is resolved. Remedy — confirm with 'gh api repos/kriscendobot/endo-but-for-bots', then either restore access, or disarm the watch durably by adding journal watch-optout/kriscendobot-endo-but-for-bots AND removing repos/kriscendobot-endo-but-for-bots (see designs/auto-provision-fork-watchers.md).
