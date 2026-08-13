from_host: endolin-garden2-5bcdff64
from: watchdog:triager/kriscendobot-finbot
sent_at: 2026-08-13T14:43:20Z
watchdog_key: triager-upstream-gone-kriscendobot-finbot
notice_count: 1
first_seen: 2026-08-13T14:41:24Z
last_seen: 2026-08-13T14:43:20Z
---
triager: fetch for kriscendobot-finbot at /home/kris/garden2/worktrees/kriscendobot-finbot.git failed (rc=128) — the UPSTREAM APPEARS GONE (deleted/renamed fork, or this host's credentials lost access). git said: git@github.com: Permission denied (publickey). fatal: Could not read from remote repository.  Please make sure you have the correct access rights and the repository exists.
This does NOT self-heal by retrying: kriscendobot-finbot is not being triaged at all until it is resolved. Remedy — confirm with 'gh api repos/kriscendobot/finbot', then either restore access, or disarm the watch durably by adding journal watch-optout/kriscendobot-finbot AND removing repos/kriscendobot-finbot (see designs/auto-provision-fork-watchers.md).
