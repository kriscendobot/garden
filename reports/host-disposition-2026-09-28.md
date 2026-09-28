# Per-host job disposition — 2026-09-28

How healthy and productive each garden host has been, from `journal2` commit
subjects (`claim(`, `tada(… done`, `terminal-failure: hint … by <host>`,
`reap-now: hint … by <host> (transient handler kill)`). Hosts are discovered
from claim authorship and `jobs/doin/` claim records, not a fixed list.
*Completion rate* = completions ÷ claims in the window (the headline number).
*Terminal failures* are non-transient (deterministic) failures, usually content
or environment defects; *transient kills* are external kills or blips, usually
host health. *In-flight* is the current `jobs/doin/` set, not a gap in the
counts. This is a report only: findings are surfaced, not diagnosed.

**Regenerate:** `scripts/jobs/host-disposition-report.py --windows 24h,7d`
(on `main2` from `3771b615390`; read-only against the producer journal clone;
`--windows 6h,24h,7d` adds a fresh-incident window).

_Generated 2026-09-28T06:43Z from `origin/journal2` @ `f61a5438b2b5` by `scripts/jobs/host-disposition-report.py`._

## Last 24h

| host | claims (by kind) | completions | terminal failures | transient kills | in-flight | completion rate |
| --- | --- | --- | --- | --- | --- | --- |
| endolin-garden-ece02cb4 | 134 (cleric 47, monk 87) | 125 | 0 | 5 | 1 | **93%** |
| endolin-garden2-5bcdff64 | 187 (cleric 23, monk 164) | 69 | 111 | 4 | 3 | **37%** |
| oros-studio-garden-ce242c49 | 81 (monk 81) | 21 | 2 | 58 | 0 | **26%** |
| **fleet** | 402 | 215 | 113 | 67 | 4 | **53%** |

Per-claim follow-through, last 24h (each claim's next disposition for the same base; *requeued* = re-claimed with no tada/failure/kill in between, *other* = gone from the board without one of those events):

| host / kind | claims | done | terminal | transient | requeued | other | in-flight | follow-through |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| endolin-garden-ece02cb4 / cleric | 47 | 39 | 0 | 5 | 3 | 0 | 0 | 83% |
| endolin-garden-ece02cb4 / monk | 87 | 86 | 0 | 0 | 0 | 0 | 1 | 99% |
| endolin-garden2-5bcdff64 / cleric | 23 | 20 | 0 | 2 | 1 | 0 | 0 | 87% |
| endolin-garden2-5bcdff64 / monk | 164 | 49 | 111 | 2 | 0 | 0 | 2 | 30% |
| oros-studio-garden-ce242c49 / monk | 81 | 21 | 2 | 58 | 0 | 0 | 0 | 26% |

## Last 7d

| host | claims (by kind) | completions | terminal failures | transient kills | in-flight | completion rate |
| --- | --- | --- | --- | --- | --- | --- |
| endolin-garden-ece02cb4 | 334 (cleric 83, monk 251) | 304 | 2 | 23 | 1 | **91%** |
| endolin-garden2-5bcdff64 | 402 (cleric 60, monk 342) | 267 | 113 | 17 | 3 | **66%** |
| oros-studio-garden-ce242c49 | 88 (monk 88) | 22 | 2 | 64 | 0 | **25%** |
| **fleet** | 824 | 593 | 117 | 104 | 4 | **72%** |

Per-claim follow-through, last 7d (each claim's next disposition for the same base; *requeued* = re-claimed with no tada/failure/kill in between, *other* = gone from the board without one of those events):

| host / kind | claims | done | terminal | transient | requeued | other | in-flight | follow-through |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| endolin-garden-ece02cb4 / cleric | 83 | 75 | 0 | 5 | 3 | 0 | 0 | 90% |
| endolin-garden-ece02cb4 / monk | 251 | 229 | 2 | 18 | 1 | 0 | 1 | 91% |
| endolin-garden2-5bcdff64 / cleric | 60 | 54 | 0 | 5 | 1 | 0 | 0 | 90% |
| endolin-garden2-5bcdff64 / monk | 342 | 213 | 113 | 12 | 2 | 0 | 2 | 62% |
| oros-studio-garden-ce242c49 / monk | 88 | 22 | 2 | 64 | 0 | 0 | 0 | 25% |

## Notable

Fleet average: **53%** over 24h, **72%** over 7d. Two of three hosts sit well
below it. Both are this weekend's known incidents, and each has its own
failure signature:

- **oros-studio-garden-ce242c49 — 26% (24h) / 25% (7d), transient-dominated.**
  81 claims, 21 completions, **58 transient kills**, only 2 terminal failures in
  24h. Nearly every claim ends in a `reap-now … (transient handler kill)`, and
  the kills track the claims hour by hour (2026-09-27 07:00–13:59Z: 67 claims,
  57 kills, 8 completions). A host whose handlers keep getting killed looks like
  this: an environment or host fault, not job content (the
  stale-Claude-Code-CLI incident). Completions come back at 15:00–18:00Z. The
  host has claimed **nothing since ~2026-09-27T17Z** and has no job in flight.
  Its 24h numbers are all history, and it is idle or offline now (`hosts/`
  still declares `monks: 4`, last updated 16:49Z).
- **endolin-garden2-5bcdff64 — 37% (24h) / 66% (7d), terminal-dominated,
  monk-only.** 187 claims, 69 completions, **111 terminal failures**, 4
  transient kills in 24h. The failures are confined to the **monk** pool: garden2
  monks follow through on 30% of claims (49 done / 111 terminal of 164), while
  garden2 **clerics sit at 87%**, level with endolin-garden's clerics. A failure
  scoped to one host and one worker kind points at that pool's own
  environment (the expired-Anthropic-credentials incident), not at job content.
  Terminal failures spiked 2026-09-27 12:00–20:00Z (~100 in 9h) and then fell
  to a trickle, but they have **not reached zero**: 6 in the last 6h
  (01:00–05:00Z 2026-09-28), with the garden2 monk follow-through still at 57%
  over that 6h. Its 7d rate (66%) hides a host that ran at ~90% until Saturday
  midday.
- **endolin-garden-ece02cb4 — 93% (24h) / 91% (7d), the healthy baseline.**
  Zero terminal failures in 24h. Its losses are transient kills (5 in 24h, all on
  clerics, 23 over 7d) and a few requeues. Cleric follow-through (83% over 24h)
  trails monks (99%), which is worth watching but is not an incident.

Reading the two incidents as a model for future reports: **lots of claims,
few completions, and failures mostly in the transient column** means a host
or environment problem that kills the handler (oros-studio). **Lots of claims,
few completions, and failures mostly in the terminal column, confined to one
worker kind on one host**, means that pool's credentials or runtime are broken
(garden2 monks). Either way, a high claim count with a low completion rate
also shows the host churning the board: it claims the fleet's work faster than
healthy hosts can.
