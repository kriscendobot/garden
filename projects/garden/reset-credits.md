# Subscription reset credits

The durable inventory of **manual mid-week quota resets** the maintainer can apply to each subscription. The weekly `reset-credit-watch` job maintains this file. The maintainer is the only source of truth for what credits exist. Update this file from maintainer statements, never from guesses.

Standing policy (kriskowal 2026-09-30): spend a subscription to **90%**, never 100%, before a reset; the last 10% is maintainer discretion. Use credits **mid-week, before they expire**.

## Inventory (as of 2026-10-03T03:43Z, per kriskowal)

| Subscription | Credits available | Expires | Notes |
| --- | --- | --- | --- |
| claude-endolin1 ("endolin-claude1") | **none** | n/a | Last credit used 2026-09-30T19:40Z. 3% at 2026-10-03T03:43Z (reset naturally 10-03T03:00Z). |
| claude-endolin2 ("endolin-claude2") | **1** | 2026-10-22 | 5% at 2026-10-03T03:43Z (reset naturally 10-03T03:00Z); true weekly cap about 121.6M meter-tokens. |
| codex-endolin ("endolin-codex1") | **2** | 2026-10-22 and 2026-10-29 | 0% at 2026-10-03T03:43Z, next reset 2026-10-09T21:43Z. The window rolled about 2026-10-02T21:43Z with no credit used (kriskowal confirmed 2026-10-03), so the earlier 10-05T16:46Z estimate was wrong. |
| claude-oros | unknown | | Host offline and derotated since 2026-09-28. |

Natural weekly boundaries: the Claude endolin subscriptions reset **Friday 20:00 America/Los_Angeles** (Sat 03:00Z). codex-endolin resets on a rolling 7 days from its last reset. claude-oros ("claude-oros-studio1") resets **Tuesday 04:00 America/Denver** (corrected 2026-10-01 per the oros operator).

## Planned use

- claude-endolin2: spend its one credit (expires 2026-10-22) EARLY in the week of 2026-10-03. Burn to ~90% first (projected ~2026-10-04T22:00Z at the 10-04T04:26Z pace), then the maintainer resets Monday/Tuesday (kriskowal, 2026-10-04). The liaison alerts the maintainer when claude2 nears 90%.

- codex-endolin: maintainer also plans to spend one codex credit this week once it is spent (kriskowal 2026-10-05: "I plan to reset endolin-claude2 and endolin-codex1 this week, whenever they're spent"). Readings 2026-10-05T05:15Z: claude1 61%, claude2 70%, codex 44% (natural reset in 4d16h, ~2026-10-09T21:10Z).

## Use log

- 2026-10-06T18:39:51Z: claude-endolin2 AND codex-endolin windows both rolled early, at the same instant (inferred from budget/live window_start_epoch 1791311991; natural resets were 10-10 03:00Z and ~10-09 21:10Z). This matches the 10-05 reset-credit-watch recommendation to spend one credit on each. Recorded as credit use: claude-endolin2's only credit (exp 10-22) and codex-endolin's 10-22 credit (assumed earliest-expiring; the 10-29 one is presumed remaining). Dashboard 2026-10-07T21:13Z (kriskowal): claude-endolin1 89%, claude-endolin2 20%, codex-endolin 9%. claude-endolin1 has no credit and is held in token backoff (ramp 0.84) until its 10-10 03:00Z reset. (liaison muster)

- ~2026-10-02T21:43Z: codex-endolin window rolled early (inferred from the 10-03 dashboard: 0%, resets in 6d 18h). No credit used (kriskowal 2026-10-03).

- 2026-09-30T19:40Z: claude-endolin1 manual reset (after burning to about 93–95%).
- 2026-09-28T16:46Z: codex-endolin manual reset (it had hit 100%).
