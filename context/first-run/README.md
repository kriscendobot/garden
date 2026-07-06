# first-run/ — the guided first-run tutorial

The ordered, conversational track the liaison drives when a user says **help**
on a not-yet-armed instance. This README **is** the tutorial script: it lists
the stages in run order with a one-line abstract each, and it carries the
**interaction norms** that bind the liaison driving it. There is deliberately no
separate tutorial script to drift from — this ordered tree is the single source
of truth, and each stage page is read just-in-time as the liaison reaches it.
Read here to run the tour, to resume a half-finished one, or to answer a
first-run question. Day-2 operation of a running instance is a sibling tree,
`../operations/README.md`.

Bare **help** starts at stage 1 and walks through. **start the garden** jumps
straight to stage 4 (the user who wants motion, not a tour). On an
**already-armed** instance, bare `help` skips the walk and degenerates to a
status summary (units, board counts, leadership, drain state) plus the
`help <topic>` menu — the stage pages double as the topic answers, so nothing
is written twice.

## Interaction norms (binding on the liaison driving the track)

- **Ask before acting, act on approval.** Every mutating step is proposed in one
  sentence with the exact command shown, then run **by the liaison itself** on a
  yes — never printed for the human to copy. Read-only checks (probes, status
  reads) run freely without asking.
- **Verify after each stage** — a unit list, a `gh auth status`, a board read —
  and show the one-line result, so trust accumulates stage by stage.
- **Resumable and idempotent.** Every stage begins with its own probe and skips
  cleanly when already done, so `help` after a half-finished first run continues
  where it left off, and `help` on a healthy instance degenerates to the status
  summary.
- **Escalate, don't improvise, on policy.** Stages that touch permissioned
  surfaces (watch-set widening, the ferry, identity switches) are *described*
  but never *performed* in the tutorial; route to the maintainer-authorization
  paths that govern them rather than acting.

## The stages

1. **Welcome.** One paragraph on what the garden is and what the tutorial will
   do, ending with "shall we?". No page — it is this framing.

2. **Identity → [identity.md](identity.md).** Confirm we are in-container (the
   guard already ran), show the location-derived `GARDEN` identity, and ask the
   one question only the human can answer: do your hosts have distinct short
   hostnames (the cross-host tiebreaker — same-host uniqueness is automatic)? On
   a collision, offer the rename (move the checkout, or a distinct hostname) and
   run it on approval.

3. **Bot credentials → [auth.md](auth.md).** Probe `gh auth status` and `.ssh/`.
   For missing pieces: generate the bot ssh key, print the public half and wait
   while the human adds it to the **bot** account, run `gh auth login` and relay
   the device code. Verify by whoami-ing the `gh` wrapper.

4. **Starting the garden → [first-job.md](first-job.md) for the board, and the
   command-level substance in `../operations/starting.md`.** The conversational
   pivot: on **start the garden** the liaison performs the whole bring-up itself
   — linger, install and enable units, size the pool, designate the leader on a
   first host, arm its own Monitors, offer the optional armings — asking before
   each consequential step and verifying after. The commands live in
   `../operations/starting.md` (agent-facing detail the liaison executes on
   demand), deliberately **not** here: this stage stays a conversation.

5. **First job → [first-job.md](first-job.md).** Offer to post a small real job,
   watch it cross `todo/ → doin/ → tada/`, and read the report back — teaching
   the board's shape and the core verbs.

6. **Where to go next.** Point at `help <topic>` (the `../operations/` tree),
   the control surfaces, and the README's conceptual §§ 2–3 for the architecture
   tour. No page — it is this handoff.

## Children (stage pages)

- **[identity.md](identity.md)** — the `GARDEN` shard identity: derived from the
  checkout's location (unique by construction, no `.garden` file or env knob),
  the cross-host hostname requirement, and the rename / parallel-pool moves.
- **[auth.md](auth.md)** — the three credentials (claude login or API key, bot
  ssh key, bot gh token): probes, the liaison-run halves, the human-only browser
  clicks, and the conservative non-bypass launch variant.
- **[first-job.md](first-job.md)** — posting a first job, the board's states,
  and the core verbs with pointers to the vocabulary table.
