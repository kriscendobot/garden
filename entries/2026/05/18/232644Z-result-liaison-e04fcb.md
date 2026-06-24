---
ts: 2026-05-18T23:26:44Z
kind: result
role: liaison
project: garden
to: "*"
subject_matter:
  - message-bus
  - job-board
  - concurrent-stewards
  - meta-evolution
refs:
  - entries/2026/05/17/204600Z-message-steward-58a3c1.md
  - entries/2026/05/18/200000Z-message-steward-c3a91d.md
  - entries/2026/05/18/195800Z-message-liaison-12198.md
---

# Job board landed: replace directive-via-inbox with claim-via-board for work items

The maintainer's framing on 2026-05-18: *"I would like the journal to include a new job board, where stewards (or other roles) race to take jobs off the board. They will need a monitor to see jobs getting posted when they are idle, and a routine for racing to take a job off the board with git transactions, including push and pull for agents distributed across environments. I would like the steward to clear context and return to its designated workspace between jobs, and to remember that it is the steward when idle."*

This entry records the meta-evolution that resolves that framing, plus the diagnosis of the message-bus failures the maintainer noted in the same engagement.

## Diagnosis (message-bus failures)

Three failure modes evidenced in the recent journal:

1. **Wrapped-skill-script Monitors silently fail when the working tree moves.** Both `entries/2026/05/17/204600Z-message-steward-58a3c1.md` and `entries/2026/05/18/200000Z-message-steward-c3a91d.md` document the same pattern: a stuck interactive rebase on `/home/kris/main` pinned the working tree at a stale commit; the inbox-drain Monitor's hardcoded path stopped existing; `while sleep 90; do bash <path> ...; done` retried silently. Path-fallback discipline (landed today, `db0e283`) closes the immediate hole; the deeper safety net is the workspace-check sub-step now wired into the steward's per-cycle survey.
2. **Per-cycle drain shares the same hardcoded skill-script path as the Monitor**, so when the Monitor breaks the per-cycle survey breaks the same way. There is no orthogonal channel.
3. **No durable "I am the steward, watching for work" presence**. The steward's identity lived only in its prompt; after `/clear`, nothing re-bootstrapped the role. The presence files for `understudy` and `general-contractor` already existed; the steward's was missing.

## What landed

### New foundation on `main`

- [`skills/job-board/SKILL.md`](../../../../<garden-root>/skills/job-board/SKILL.md): the procedural skill. Inputs (`post-job.sh`, `claim-job.sh`, `complete-job.sh`, `job-board-poll.sh`), state, four transitions (post / claim / complete-done / complete-abandoned), the workspace-check sub-procedure, the daemon shape.
- [`skills/job-board/post-job.sh`](../../../../<garden-root>/skills/job-board/post-job.sh): producer-side helper. Writes the frontmatter+body file to `jobs/open/`, commits and pushes via the standard journal-sync retry loop.
- [`skills/job-board/claim-job.sh`](../../../../<garden-root>/skills/job-board/claim-job.sh): consumer-side claim race. `git mv` from `open/` to `claimed/` then `git push origin HEAD:journal`; rejection means lost race (hard-reset, no retry).
- [`skills/job-board/complete-job.sh`](../../../../<garden-root>/skills/job-board/complete-job.sh): consumer-side completion. `git mv` to `done/` or `abandoned/` with completion-stamp lines appended.
- [`skills/job-board/job-board-poll.sh`](../../../../<garden-root>/skills/job-board/job-board-poll.sh): long-lived bash daemon. Polls `git fetch + ls jobs/open/` on a 30s default cadence; writes `NEW` / `GONE` lines to `/tmp/garden-jobs.log` for a parent-context Monitor to tail.

### Role-file changes on `main`

- [`roles/steward/AGENT.md`](../../../../<garden-root>/roles/steward/AGENT.md): added a top-level **Workspace, presence, and the job board** section. Designated workspace at `/home/kris`; presence file at `journal/presence/<host>/steward.md` with a `workspace_path:` field; the per-job lifecycle (claim → dispatch → result → complete → return to idle). Parent-context Monitor count bumped from three to four (added the job-board tail Monitor). Standing monitors table grew a `jobs` row. Per-cycle procedure grew a *Workspace check* sub-step at the top of *Survey*, a *Bump the presence heartbeat* sub-step, and a *Scan the job board* sub-step; *Dispatch* dispatches claimed jobs alongside the existing flows; *Schedule next* triggers active mode on any open job eligible for `steward`. Vocabulary intro names the new work-vs-comm channel split.
- [`roles/liaison/AGENT.md`](../../../../<garden-root>/roles/liaison/AGENT.md): added a top-level **Posting jobs to the board** section. Names the producer side (`skills/job-board/post-job.sh`), the residual cases where the inbox is still right (decisions, FYIs, replies, broadcasts, self-improvement reports), and the concurrent-steward shape ("kick these jobs off asynchronously"). Bulletin/journal vocabulary table updated: "let the [role] know" now routes to the board for work and to the inbox for FYIs; "kick off (asynchronously)" is a new compound phrase that explicitly names the board.
- [`roles/understudy/AGENT.md`](../../../../<garden-root>/roles/understudy/AGENT.md): added job-board skill; updated *When dispatched* handoff shape so job-board claim is the preferred route, `message: steward → understudy` is the legacy fallback.
- [`roles/general-contractor/AGENT.md`](../../../../<garden-root>/roles/general-contractor/AGENT.md): added job-board skill; the contractor's slot-refill step consults the board before walking the design-pipeline directly.

### Top-level doc

- [`CLAUDE.md`](../../../../<garden-root>/CLAUDE.md): Layout names the two-channel message bus; Dispatch contract names the job-board claim route alongside the existing direct-dispatch route; Skills inventory adds `job-board`.

### Journal-side changes

- [`journal/jobs/README.md`](../../../jobs/README.md): the contract. Layout (open / claimed / done / abandoned), frontmatter schema (job / posted-by / verb / target / authorizations / eligible_roles / claim-stamp / completion-stamp), eligibility table, transitions, claim race resolution, bash poll daemon shape, composition with the inbox.
- `journal/jobs/{open,claimed,done,abandoned}/` directories created with `.gitkeep` placeholders.
- [`journal/presence/README.md`](../../../presence/README.md): added the **steward** tenant row; named the `workspace_path:` field convention for roles whose AGENT.md names a designated workspace.

## Decisions (recorded for future reference)

The user's four decisions on 2026-05-18 that shaped the encoding:

1. **Job board replaces `message: <role> → steward` for work items.** The inbox is downgraded to broadcasts, retros, replies-from-subagents, decisions, and FYIs. Work directives route through the board.
2. **Eligible claimants**: stewards on different hosts, multiple stewards on one host, the understudy when present, the general-contractor when adopted. The `<sid>` in the claim path distinguishes same-role same-host racers.
3. **Per-job dispatch into a fresh subagent.** The idle consumer's parent context never holds per-job substance; every job dispatches into a per-dispatch worktree triple whose context is torn down with the dispatch root. The maintainer's framing ("clear context between jobs") is honored by ensuring the substance never enters the consumer's context to begin with.
4. **Per-cycle workspace check.** Every steward cycle starts by verifying pwd matches the host's `workspace_path:`, branch is `main`, and the garden checkout is synced to `origin/main`. Drift refuses to act and escalates via `message: steward → liaison`.

## What still needs to happen (operator side)

The encoding is on `main` and the journal carries the contract; the foundation is ready. The producer-and-consumer wiring happens at the next round of bootstraps:

- **Liaison restart.** When the user re-clears the liaison context, the fresh session reads the updated `roles/liaison/AGENT.md` and learns to post jobs via `skills/job-board/post-job.sh` for work items. The 2026-05-18 sqlite-fixers framing at `entries/2026/05/18/195800Z-message-liaison-12198.md` is the worked example the next liaison should re-issue as two jobs rather than as one inbox message.
- **Steward restart.** When the user re-clears the steward context, the fresh session reads the updated `roles/steward/AGENT.md` and follows the new bootstrap: write the presence file, arm the four parent-context Monitors (including the new job-board tail), run the per-cycle workspace check, scan the board, claim and dispatch.
- **Job-board poll daemon arming.** First steward cycle to run after the encoding lands will discover that `/tmp/garden-jobs.pid` is absent and spawn `skills/job-board/job-board-poll.sh 30`. The daemon writes the log; the Monitor tails it.

The maintainer's intent on the message-bus repairs (the path-fallback discipline that landed today, the workspace check now wired in, the presence file the next steward writes) and the job-board mechanism are all on `main` and on the journal. The mechanism is ready; the next consumer bootstrap will exercise it.

## Self-improvement

Two structural lessons from this engagement:

1. **The producer-consumer channel for work is the missing piece, not the inbox.** The recurring "messages get missed" pattern across May 14 to May 18 traced to *implicit single-consumer queueing*: a `message: liaison → steward` was the only way to ask a steward to act, so a single dropped-Monitor or stuck-rebase incident took out the channel. The board's claim-race shape lets the system tolerate single-host or single-session failures: any other eligible consumer can claim. The lesson is not "fix the inbox harder"; it is "the inbox is for communication, not for work distribution".
2. **A long-running idle session needs a durable identity breadcrumb, not just a prompt.** The presence file is the breadcrumb. `/clear` between jobs is safe because the role file plus the presence file fully re-bootstrap the session's identity, watch state, and designated workspace. The maintainer's framing "remember that it is the steward when idle" is honored by the presence file, not by chat-history.

Self-improvement: the meta-evolution shaped by a single user prompt that names the structural change works well; the alternative (waiting for two more silent-failure incidents to accumulate before encoding the fix) would have cost more in lost work than the encoding takes to author.
