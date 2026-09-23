---
ts: 2026-05-14T22:52:17Z
kind: dispatch
role: liaison
project: garden
to: "*"
refs:
  - entries/2026/05/14/225012Z-message-understudy-c89e16.md
  - entries/2026/05/14/222100Z-result-gardener-7d4081.md
  - entries/2026/05/14/214954Z-message-understudy-c124ea.md
---

# Dispatch: gardener lands two understudy/steward amendments (continuous Monitor default + steward-to-understudy shunting)

Dispatch root: `dispatches/gardener--12fdbf/`. Garden-meta only.

## Maintainer directives (forwarded by the understudy)

[`entries/2026/05/14/225012Z-message-understudy-c89e16.md`](225012Z-message-understudy-c89e16.md) carries two amendments the user requested in the understudy's live session.

### Amendment 1 — `roles/understudy/AGENT.md`: continuous Monitor is the default

The current *Operating norms* says the understudy "does not wrap the drain in a continuous Monitor by default; the user is reachable and a polite 'anything for me?' beats a wake-on-every-line monitor for a third-row posture." The user's actual framing in practice is the opposite — the understudy arms a parent-context `Monitor` task wrapping `skills/inbox-drain/inbox-drain.sh understudy` on a 60-120s cadence at session start and keeps it alive for the session.

Rationale: the broadcast firehose carries ~1 entry every 4-8 minutes during active engagement; the understudy must surface those without the user prompting. The "polite poll" pattern is a fallback when the Monitor tool is unavailable.

Encode the understudy's verbatim proposal:

> The watch is the primary surface. The understudy arms a parent-context `Monitor` task wrapping `while sleep 90; do bash /home/kris/skills/inbox-drain/inbox-drain.sh understudy; done` at session start and verifies it stays alive for the session's life (re-arming if `TaskList` shows it stopped). New `to: understudy` (or broadcast `to: "*"`) entries arrive as notifications. The session reads each, decides whether the entry is a handoff to act on or just context, and acts accordingly.

Plus a note that the `to: "*"` traffic on a busy day is genuinely high (this hour saw seven broadcasts in 35 minutes); the understudy triages rather than fully reads every one.

### Amendment 2 — `roles/steward/AGENT.md`: shunt classes of work to a present understudy

The steward's role file does not currently name the understudy. The user wants the steward, when it detects an understudy is present, to proactively shunt a defined class of work via `message: steward → understudy` entries on each cycle.

Two gardener decisions:

1. **Presence detection.** Pick a mechanism. The understudy suggests:
   - **Both**: a `message: understudy → steward` "I am ready" entry on session start + an "I am ending" entry on shutdown; plus a presence file `journal/presence/<host>/understudy.md` the understudy writes on start and heartbeats every Monitor cycle. The file has a `last_heartbeat` field; the steward considers the understudy present if heartbeat is < N minutes old (N = 5 is a reasonable starting value).
   - This is the gardener's call; the both-shape is the understudy's suggestion. Pick what reads cleanest.

2. **Which classes of work shunt.** Pick 2-3 from this candidate list:
   - Investigator dispatches (investigation-shaped, resumable).
   - Scout dispatches (perf measurement; report-back).
   - Groom dispatches (roadmap edits; not time-pressured).
   - Journalist dispatches (ledger work; tolerates handoff).
   - Major-general's per-PR fanout (after a survey, drive per-cluster dispatches sequentially).
   - Review-queue-poll fanout (multiple `ADD` lines in one cycle).

   Pick the 2-3 that fit the user's framing best. The understudy holds the same authority bounds as the steward, so anything inside those bounds is in scope.

## Per-action authorization

Standing on the garden repo. No project-side actions.

## Task

1. **Update `roles/understudy/AGENT.md`** § Operating norms: replace the "polite poll" default with the continuous-Monitor default per the verbatim proposal above. Add the high-traffic-triage note.

2. **Update `roles/steward/AGENT.md`** with two new sections:
   - **Understudy presence detection.** The mechanism (both-shape recommended): the understudy's start/end messages + a presence-file heartbeat at `journal/presence/<host>/understudy.md`. The steward reads the file at the top of each per-cycle survey to decide whether an understudy is available. Stale-after window picked by gardener (N=5 minutes is the suggested default).
   - **Work shunting to a present understudy.** Name the 2-3 work classes the steward shunts via `message: steward → understudy`. State the discipline: the steward continues to dispatch the actual subagent itself unless the understudy explicitly picks up the message; the shunt is an offer, not a transfer.

3. **Author or update `journal/presence/README.md`** documenting the presence-file shape (frontmatter fields, lifecycle, how the steward consumes it). If the directory doesn't exist, create it.

4. **Cross-reference**: liaison's role file (just got a *Vocabulary* + several other sections today) gets one line acknowledging the understudy can pick up work the user delegates while the liaison's session continues. The liaison and the understudy are siblings now (both bounded authority + user reachable, with the understudy specifically positioned as a steward-shunt destination).

5. **Cite both maintainer-directive precipitating messages** in notes-from-the-field rows: `225012Z` (the amendments) and `214954Z` (the understudy's first heads-up).

## Out of scope

- No change to the understudy's posture row (bounded authority, user reachable).
- No new role.
- No change to the liaison's posture or skills list.
- No change to the steward's existing per-cycle disciplines (PR-creation-flow scan, parent-context Monitors, issue surveillance, design-to-PR pipeline). The new shunting discipline is *added*, not substituted.

## Commits

- One commit per substantively-revised file (`roles/understudy/AGENT.md`, `roles/steward/AGENT.md`, `journal/presence/README.md`, optional `roles/liaison/AGENT.md`).

Push at end. Journal result entry.

## Report

≤ 300 words: presence-detection mechanism chosen, work-shunt classes named (2-3 with one-line rationale each), files revised, one-line `Self-improvement: ...`.
