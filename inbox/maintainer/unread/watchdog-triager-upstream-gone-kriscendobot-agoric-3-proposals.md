from_host: endolin-garden2-5bcdff64
from: watchdog:triager/kriscendobot-agoric-3-proposals
sent_at: 2026-08-13T14:39:03Z
watchdog_key: triager-upstream-gone-kriscendobot-agoric-3-proposals
notice_count: 2
first_seen: 2026-08-13T14:33:04Z
last_seen: 2026-08-13T14:39:03Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-08-13T14:33:04Z, latest 2026-08-13T14:39:03Z).
The SAME condition (`triager-upstream-gone-kriscendobot-agoric-3-proposals`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

triager: fetch for kriscendobot-agoric-3-proposals at /home/kris/garden2/worktrees/kriscendobot-agoric-3-proposals.git failed (rc=128) — the UPSTREAM APPEARS GONE (deleted/renamed fork, or this host's credentials lost access). git said: git@github.com: Permission denied (publickey). fatal: Could not read from remote repository.  Please make sure you have the correct access rights and the repository exists.
This does NOT self-heal by retrying: kriscendobot-agoric-3-proposals is not being triaged at all until it is resolved. Remedy — confirm with 'gh api repos/kriscendobot/agoric-3-proposals', then either restore access, or disarm the watch durably by adding journal watch-optout/kriscendobot-agoric-3-proposals AND removing repos/kriscendobot-agoric-3-proposals (see designs/auto-provision-fork-watchers.md).
