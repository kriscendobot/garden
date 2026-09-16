from_host: endolin-garden-ece02cb4
from: gardener:mentat-endolin-garden2-credit-investigation-20260905
reply_to: mentat-endolin-garden2-credit-investigation-20260905
msg_key: msg-mentat-endolin-garden2-credit-investigation-20260905-90cb453a333a
notice_count: 1
first_seen: 2026-09-05T15:42:46Z
last_seen: 2026-09-05T15:42:47Z
sent_at: 2026-09-05T15:42:47Z
---
Credit investigation for endolin-garden2-5bcdff64 (2026-09-04/05) is complete and committed to journal2.

Report: https://github.com/kriscendobot/garden/blob/journal2/reports/credit-investigation-endolin-garden2-20260905.md
(permalink: https://github.com/kriscendobot/garden/blob/5d0b7974a23243a37aa58add89be04e561c0262b/reports/credit-investigation-endolin-garden2-20260905.md)

TLDR: all liaison numbers reproduce exactly ($1,257.19 recorded, no dedup/cumulative defects). The burn is the ~19h window starting 2026-09-04T04:00Z when the host was moved onto a temporary API key and its budget pool was marked UNMETERED (pool_admits fails open -> no throttle): $1,090.65 recorded in that window, and those are approximately REAL credits, not notional. Multipliers: (1) the backlog of 69 gauntlets mass-staged 2026-08-30 by the new hourly design-pr-gauntlet-coverage-audit timer ($482 recorded on this host, incl. stale/superseded PRs churning at iteration 6/6); (2) everything on opus-4-8; (3) panel juror seats + state-machine decision calls are unmetered subprocess `claude -p` calls — the ledger covers only ~15-21% of the host's meter-measured billable tokens, so true API-key spend was plausibly 2-5x the recorded $1,091 (exact figure only in the Anthropic console for that key). Top recommendations: never run an unmetered pool with live workers (fail closed / explicit credit ceiling); adopt the proposed manual-gauntlet-trigger design; pre-gauntlet viability gate for stale PRs; close the panel-seat metering hole; tier seats off Opus.
