# Subscription reset credits

The durable inventory of **manual mid-week quota resets** the maintainer can apply to each subscription. The weekly `reset-credit-watch` job maintains this file. The maintainer is the only source of truth for what credits exist. Update this file from maintainer statements, never from guesses.

Standing policy (kriskowal 2026-09-30): spend a subscription to **90%**, never 100%, before a reset; the last 10% is maintainer discretion. Use credits **mid-week, before they expire**.

## Inventory (reconciled 2026-10-26 by reset-credit-watch; credits per kriskowal 2026-10-10/11)

| Subscription | Credits available | Expires | Notes |
| --- | --- | --- | --- |
| claude-endolin1 ("endolin-claude1") | **none** | n/a | Last credit used 2026-09-30T19:40Z. Window from 10-24T03:00Z, next natural reset 10-31T03:00Z; meter 18% (derived, 55M/271M) at 10-26T15:32Z. |
| claude-endolin2 ("endolin-claude2") | **none** | n/a | Only credit (exp 10-22) used 2026-10-06T18:39Z. Retired for now (kriskowal 2026-10-11). |
| codex-endolin ("endolin-codex1") | **0 or 1** (unconfirmed) | 2026-11-06 | Per kriskowal 2026-10-10: "resets expire Oct 29 and Nov 6, no hurry". 10-16T03:51Z manual reset recorded as the 10-29 credit. Maintainer-reported manual reset 2026-10-23T00:20:27Z came ~3.5h before the 10-23T03:51Z natural reset: if that spent a credit, the 11-06 one is gone (confirm). Window from 10-23T00:20Z, next natural reset 10-30T00:20Z; meter 9% at 10-26T15:32Z (~2.5%/day). |
| claude-oros | unknown (treat as none) | | Listed "offline and derotated since 2026-09-28", but its pool shows active use (meter 74% at 10-19T16:32Z, window from 10-13T10:00Z). Maintainer asked to confirm status and credits (accountant-weekly 2026-10-17). |

Natural weekly boundaries: the Claude endolin subscriptions reset **Friday 20:00 America/Los_Angeles** (Sat 03:00Z). codex-endolin resets on a rolling 7 days from its last reset. claude-oros ("claude-oros-studio1") resets **Tuesday 04:00 America/Denver** (corrected 2026-10-01 per the oros operator).

## Planned use

- claude-endolin2: spend its one credit (expires 2026-10-22) EARLY in the week of 2026-10-03. Burn to ~90% first (projected ~2026-10-04T22:00Z at the 10-04T04:26Z pace), then the maintainer resets Monday/Tuesday (kriskowal, 2026-10-04). The liaison alerts the maintainer when claude2 nears 90%.

- codex-endolin: maintainer also plans to spend one codex credit this week once it is spent (kriskowal 2026-10-05: "I plan to reset endolin-claude2 and endolin-codex1 this week, whenever they're spent"). Readings 2026-10-05T05:15Z: claude1 61%, claude2 70%, codex 44% (natural reset in 4d16h, ~2026-10-09T21:10Z).

## Use log

- 2026-10-26 (reset-credit-watch): codex-endolin manual reset 2026-10-23T00:20:27Z (reset-events, maintainer-reported "0% consumed, 7d to next reset"), ~3.5h before its natural 10-23T03:51Z reset. Possibly the 11-06 credit (nearly all wasted) or a natural rollover read early; NOT yet recorded as a use, pending maintainer confirmation. The 10-19 recommendation (reset Tue 10-20) was not acted on.

- 2026-10-19 (reset-credit-watch): codex-endolin manual reset at 2026-10-16T03:50:59Z (reset-events, maintainer-reported, 3 days after its ~10-13 natural reset) recorded as credit use; assumed earliest-expiring (10-29), leaving the 11-06 credit. Maintainer to confirm.

- 2026-10-12 (reset-credit-watch): reconciled to maintainer statements of 10-10/10-11. codex-endolin credits now expire 10-29 and 11-06 (maintainer-stated; supersedes the 10-22/10-29 pair). claude-endolin2 retired for now with no credits.

- 2026-10-06T18:39:51Z: claude-endolin2 AND codex-endolin windows both rolled early, at the same instant (inferred from budget/live window_start_epoch 1791311991; natural resets were 10-10 03:00Z and ~10-09 21:10Z). This matches the 10-05 reset-credit-watch recommendation to spend one credit on each. Recorded as credit use: claude-endolin2's only credit (exp 10-22) and codex-endolin's 10-22 credit (assumed earliest-expiring; the 10-29 one is presumed remaining). Dashboard 2026-10-07T21:13Z (kriskowal): claude-endolin1 89%, claude-endolin2 20%, codex-endolin 9%. claude-endolin1 has no credit and is held in token backoff (ramp 0.84) until its 10-10 03:00Z reset. (liaison muster)

- ~2026-10-02T21:43Z: codex-endolin window rolled early (inferred from the 10-03 dashboard: 0%, resets in 6d 18h). No credit used (kriskowal 2026-10-03).

- 2026-09-30T19:40Z: claude-endolin1 manual reset (after burning to about 93–95%).
- 2026-09-28T16:46Z: codex-endolin manual reset (it had hit 100%).
