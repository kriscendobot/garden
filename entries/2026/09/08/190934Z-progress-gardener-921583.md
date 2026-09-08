---
kind: progress
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-09-08T19:09:36Z
---
# Claude-on-minion.town completion press — tick 1 (first dispatch)

Inward-facing counterpart to `claude-on-minion-town-press` (arc issue
kriscendobot/garden#89). Observe-and-report only; board untouched. Window: since
the schedule's own creation/rescope (~2026-09-08T19:03Z) — this is the FIRST
dispatch, so the effective window is the arc's start (orchestration created
18:53:31Z). Read against a fresh origin/journal2 clone at 0c2dbde298 (19:03Z).

## Roster resolved this tick

Active arc jobs = the 7 design children of orch `claude-on-minion-town-designs`
(order=parallel, on-child-failure=continue, state=running). All 7 are in `doin/`,
each claimed once, no requeue, no doom, none absent:

| child (design) | host | worker | claimed_at |
|---|---|---|---|
| design-minion-town-claude-harness-provisioning | ece02cb4 | cleric | 18:55:12Z |
| design-minion-town-claude-agents-root-endowment | 5bcdff64 | monk | 18:55:22Z |
| design-claude-agent-credential-reauth | 5bcdff64 | monk | 18:55:27Z |
| design-endo-claude-bare-caplet | 5bcdff64 | cleric | 18:55:47Z |
| design-endo-daemon-guest-bot-incarnation | ece02cb4 | cleric | 18:56:16Z |
| design-endo-guest-stdio-mcp | ece02cb4 | monk | 18:56:21Z |
| design-claude-on-minion-town-evaluation | 5bcdff64 | cleric | 18:56:39Z |

All are `role: designer, tier: mentor` — legitimately long jobs; ~7 min elapsed at
snapshot, far inside budget. No arc-press (`claude-on-minion-town-press-`) dispatch
jobs exist yet.

## Counts

- Location: 7/7 in `doin`, 0 `todo`, 0 `tada`, 0 absent.
- Claim vs completion: 7 claimed in window, 0 reached `tada` (expected — arc is
  ~10 min old). No repeated-claim-without-completion.
- Dooms in window: 0.
- policy-refusal in window: 0.
- Stalled claims (past handler-timeout, 2nd+ requeue): 0.
- Completed-but-failed: n/a (nothing in tada yet).
- Orchestration progress: `running`, 0/7 children complete — nominal for tick 1.
- Deliverable spot-check: n/a until a design lands.

## Arc-adjacent, NOT active-arc findings (recorded for auditability, no action)

These reference arc-tracked artifacts (criterion 3) but are pre-existing, parked,
and pre-date the arc window — none doomed in-window, none re-postable by me:
- `build-minion-town-claude-agents-capability` — plan, doomed 2026-09-03T22:35Z
  (deadline-overrun); the maintainer-narrowed root-only capability build. Doom is
  5 days old, outside the window; noted so the series can track it if the arc
  revisits root endowment (cf. design-minion-town-claude-agents-root-endowment).
- `endo-claude-agent-sdk-{design,backend,probe}` — plan, parked (not doomed).
- `endojs-endo-but-for-bots-pr1015-{2b55429b,review-348a2017,review-6a83ee90}-retro`
  — plan, parked (not doomed).

## Verdict

arc nominal: 7 roster jobs, 0 completed, 7 outstanding (all freshly claimed,
in-flight), 0 doomed in window. No maintainer message (anti-fatigue discipline).
