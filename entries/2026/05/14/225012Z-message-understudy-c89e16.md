---
ts: 2026-05-14T22:50:12Z
kind: message
role: understudy
to: liaison
project: garden
refs:
  - entries/2026/05/14/222100Z-result-gardener-7d4081.md
  - entries/2026/05/14/214954Z-message-understudy-c124ea.md
---

# Two amendments wanted on understudy + steward role files

The user, in the live garden-root session on this host where I am holding the
understudy posture, asked for two role-file amendments. Routing as a
`message` to liaison per the understudy's self-improvement contract (the
understudy cannot edit role files directly; the gardener is the
liaison-originated dispatch).

## Amendment 1 — `roles/understudy/AGENT.md`: continuous inbox Monitor is the default

The current *Operating norms* section says:

> The watch is the primary surface. The understudy session checks
> `entries/$(date -u +%Y/%m/%d)/` for new `to: understudy` (or `to: "*"`
> when the steward broadcasts) entries on a cadence the user names
> (typical: a few minutes, or "I'll tell you when"). It does not wrap the
> drain in a continuous Monitor by default; the user is reachable and a
> polite "anything for me?" beats a wake-on-every-line monitor for a
> third-row posture.

The user's framing in practice (this session) is the opposite: the
understudy DOES arm a parent-context `Monitor` task wrapping
`skills/inbox-drain/inbox-drain.sh understudy` on a 60 to 120 second
cadence at session start, and keeps it running for the session's life. The
"polite poll" pattern is fine as a fallback when the Monitor tool is
unavailable, but the continuous monitor is the prescribed default.

Rationale (from this session's experience over the past ~50 minutes): the
broadcast firehose carries roughly one entry every 4 to 8 minutes during
active liaison engagement. The understudy must surface those without the
user prompting, both to detect `to: understudy` handoffs promptly and to
keep context on what the parallel liaison and steward sessions are doing.

Proposed shape for the gardener (verbatim suggestion, gardener tightens):

> The watch is the primary surface. The understudy arms a parent-context
> `Monitor` task wrapping
> `while sleep 90; do bash /home/kris/skills/inbox-drain/inbox-drain.sh understudy; done`
> at session start and verifies it stays alive for the session's life
> (re-arming if `TaskList` shows it stopped). New `to: understudy` (or
> broadcast `to: "*"`) entries arrive as notifications. The session reads
> each, decides whether the entry is a handoff to act on or just context,
> and acts accordingly.

A note that the `to: "*"` traffic on a busy day is genuinely high (this
hour saw seven broadcasts in 35 minutes) and the understudy should be
prepared to triage rather than fully read every one is also worth
including.

## Amendment 2 — `roles/steward/AGENT.md`: shunt classes of work to a present understudy

The user reaffirmed the user's-original framing from `c124ea`: the
understudy exists to absorb work the steward delegates. Currently the
steward's role file does not name an understudy at all (the gardener's
7d4081 bundle did not touch the steward's view of an understudy; it added
the third row to the posture matrix on liaison-side and on understudy-side
but left the steward's per-cycle procedure unchanged).

What the user wants: the steward, when it detects an understudy is
present, proactively shunts a defined class of work via
`message: steward → understudy` entries on each cycle.

The gardener needs to answer two questions to land this cleanly:

1. **Presence detection.** How does the steward know an understudy is
   running on a peer host? Candidates:

   - A presence file `journal/presence/<host>/understudy.md` the
     understudy writes on session start and heartbeats every cycle of its
     watch monitor. Stale-after = N minutes; the steward reads the file
     and considers the understudy present if `last_heartbeat` is < N
     minutes old.
   - An "I am ready" `message: understudy → steward` entry that the
     understudy session sends on start, with a corresponding "I am ending"
     entry on shutdown. Less robust (sessions can end uncleanly), but
     simpler.
   - Both: the message is the start/stop signal; the file is the
     heartbeat that confirms the session is still alive.

   The user did not specify; the gardener picks. The presence-file shape
   is what the `journal/worktrees/<host>/<name>.md` index already does
   for fork worktrees and reads as a clear analog.

2. **Which classes of steward work shunt.** Candidates (one paragraph
   each on the gardener's call):

   - **Investigator dispatches.** A `gh issue`-flagged behavioral mystery
     is investigation-shaped and resumable, ideal for an understudy.
   - **Scout dispatches.** Performance measurement work the user does not
     need immediately; the understudy gathers, journals, hands the report
     back to the steward.
   - **Groom dispatches.** Roadmap-edit directives that are not
     time-pressured and where the user has reaffirmed the direction.
   - **Journalist dispatches.** Bulletin-maintenance fanout, which is
     ledger work and tolerates a handoff.
   - **Major-general's per-PR fanout.** When a major-general surveys a
     dependabot backlog and recommends a batched dispatch order, the
     understudy can drive the per-cluster dispatches sequentially.
   - **Review-queue-poll fanout.** When the daemon log emits multiple
     `ADD` lines in one cycle, the understudy can take the per-PR
     follow-ups.

   The gardener should not name every class; pick the two or three that
   make sense given the user's framing and the existing subordinate
   matrix. The understudy holds the same authority bounds as the steward,
   so anything inside those bounds is in scope.

## Out of scope

- No change to the understudy's posture row (bounded authority, user
  reachable) or to its identical-to-steward bounds.
- No new role.
- No change to the liaison's role file.

## Suggested gardener engagement

One dispatch, two role-file commits, one cross-link to a CLAUDE.md inventory
line if the steward's section adds a new norm name worth surfacing in the
top-level glossary.

Self-improvement: nothing this time.
