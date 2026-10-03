# Subscription reset credits

The durable inventory of **manual mid-week quota resets** the maintainer can apply to each subscription. The weekly `reset-credit-watch` job maintains this file. The maintainer is the only source of truth for what credits exist. Update this file from maintainer statements, never from guesses.

Standing policy (kriskowal 2026-09-30): spend a subscription to **90%**, never 100%, before a reset; the last 10% is maintainer discretion. Use credits **mid-week, before they expire**.

## Inventory (as of 2026-10-03T03:43Z, per kriskowal)

| Subscription | Credits available | Expires | Notes |
| --- | --- | --- | --- |
| claude-endolin1 ("endolin-claude1") | **none** | n/a | Last credit used 2026-09-30T19:40Z. 3% at 2026-10-03T03:43Z (reset naturally 10-03T03:00Z). |
| claude-endolin2 ("endolin-claude2") | **1** | 2026-10-22 | 5% at 2026-10-03T03:43Z (reset naturally 10-03T03:00Z); true weekly cap about 121.6M meter-tokens. |
| codex-endolin ("endolin-codex1") | **2?** (unconfirmed) | 2026-10-22 and 2026-10-29 | 0% at 2026-10-03T03:43Z, next reset 2026-10-09T21:43Z. The window rolled about 2026-10-02T21:43Z, earlier than the natural 10-05T16:46Z, so one credit (probably the 10-22 one) may have been used. Confirm with the maintainer. |
| claude-oros | unknown | | Host offline and derotated since 2026-09-28. |

Natural weekly boundaries: the Claude endolin subscriptions reset **Friday 20:00 America/Los_Angeles** (Sat 03:00Z). codex-endolin resets on a rolling 7 days from its last reset. claude-oros ("claude-oros-studio1") resets **Tuesday 04:00 America/Denver** (corrected 2026-10-01 per the oros operator).

## Use log

- ~2026-10-02T21:43Z: codex-endolin window rolled early (inferred from the 10-03 dashboard: 0%, resets in 6d 18h). Unconfirmed whether this used a credit.

- 2026-09-30T19:40Z: claude-endolin1 manual reset (after burning to about 93–95%).
- 2026-09-28T16:46Z: codex-endolin manual reset (it had hit 100%).
