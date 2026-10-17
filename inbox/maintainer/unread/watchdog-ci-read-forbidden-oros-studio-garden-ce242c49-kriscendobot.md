from_host: oros-studio-garden-ce242c49
from: watchdog:ci-wait-merge
sent_at: 2026-10-17T08:37:01Z
watchdog_key: ci-read-forbidden-oros-studio-garden-ce242c49-kriscendobot
notice_count: 2
first_seen: 2026-10-16T18:44:42Z
last_seen: 2026-10-17T08:37:01Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-10-16T18:44:42Z, latest 2026-10-17T08:37:01Z).
The SAME condition (`ci-read-forbidden-oros-studio-garden-ce242c49-kriscendobot`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

ci-wait-merge on oros-studio-garden-ce242c49 cannot read CI for kriscendobot/minion.town#190: the GitHub token is forbidden (HTTP 403) from statusCheckRollup, and delegated merges do not accept the Actions-only fallback. This is a token permission gap, not pending CI. Grant the bot token checks:read and statuses:read (and actions:read) on 'kriscendobot', then rerun the stage.
