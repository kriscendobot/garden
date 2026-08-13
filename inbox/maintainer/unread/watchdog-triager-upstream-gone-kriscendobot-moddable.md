from_host: endolin-garden2-5bcdff64
from: watchdog:triager/kriscendobot-moddable
sent_at: 2026-08-13T14:37:01Z
watchdog_key: triager-upstream-gone-kriscendobot-moddable
notice_count: 1
first_seen: 2026-08-13T14:36:47Z
last_seen: 2026-08-13T14:37:01Z
---
triager: fetch for kriscendobot-moddable at /home/kris/garden2/worktrees/kriscendobot-moddable.git failed (rc=128) — the UPSTREAM APPEARS GONE (deleted/renamed fork, or this host's credentials lost access). git said: git@github.com: Permission denied (publickey). fatal: Could not read from remote repository.  Please make sure you have the correct access rights and the repository exists.
This does NOT self-heal by retrying: kriscendobot-moddable is not being triaged at all until it is resolved. Remedy — confirm with 'gh api repos/kriscendobot/moddable', then either restore access, or disarm the watch durably by adding journal watch-optout/kriscendobot-moddable AND removing repos/kriscendobot-moddable (see designs/auto-provision-fork-watchers.md).
