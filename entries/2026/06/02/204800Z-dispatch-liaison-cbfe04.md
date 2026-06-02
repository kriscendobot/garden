---
ts: 2026-06-02T20:48:00Z
kind: dispatch
role: liaison
host: endolinbot
repo: kriskowal/garden
project: garden
to: designer
dispatch_root: /home/kris/dispatches/designer--cbfe04
prs:
  - repo: kriskowal/garden
    pr: 3
    role: target
refs:
  - https://github.com/kriskowal/garden/pull/3#pullrequestreview-4405854929 (04:08Z)
  - https://github.com/kriskowal/garden/pull/3#issuecomment-4598... (04:10Z)
  - https://github.com/kriskowal/garden/pull/3#pullrequestreview-4405876024 (04:19Z)
---

# dispatch: designer — revise designs/driver.md per kriskowal's architectural pivot on garden#3

User directive: "See feedback on https://github.com/kriskowal/garden/pull/3"

kriskowal left three pieces of substantive feedback today (2026-06-02) on
garden#3 (`design(driver): script-orchestrated PR-creation flow`,
head `5bb23453b`) that call for a substantial architectural pivot
in the design document:

## The three unaddressed asks

1. **04:08Z review (CHANGES_REQUESTED)** — "It is going to become
   difficult to manage the gardens daemons. Please take another pass to
   set these up with systemd and provide top-level scripts for starting
   up and stopping the daemons on Linux. I am expecting some configured
   quantity of persistent drivers taking jobs off the job inbox, and a
   single daemon for watching each activity feed and translating
   activity to message dispatches to one or [more inboxes]."

2. **04:10Z issue comment** — "Note: it is becoming clearer that the
   'driver' is not so much a role but a script that takes jobs off a
   generic inbox for all drivers and specializes its behavior on the
   kind of message that was left in its inbox. It should be clear that
   the script will need to delegate to an ephemeral subagent for many
   tasks, including building and fixing. The script just serves to
   drive the loop and reliably run [the state machine]."

3. **04:19Z review (CHANGES_REQUESTED)** — "It's not clear that we
   should have skills or roles for driver scripts. Perhaps we should
   reorganize this into a top level scripts/ directory with
   human-oriented readme docs for each script, reserving role and skill
   for agent context fragments."

## What the redesign should articulate

Revise `designs/driver.md` (442 lines, currently positions driver as a
role) to reflect:

- **Driver is a script, not a role.** The driver is a bash script that
  takes jobs off a generic inbox and dispatches behavior based on the
  job kind. It delegates to ephemeral subagents (via the `Agent` tool)
  for tasks that need judgment (build, fix, design, etc.). The script
  itself just drives the loop and reliably runs the state machine.

- **Top-level scripts/ directory.** Executable shell scripts (drivers,
  daemons, helpers) live under `scripts/<name>/` with a human-oriented
  README explaining what it does, how to invoke it, how it integrates
  with systemd. Reserve `roles/` and `skills/` for agent-only context
  fragments (operating briefs, playbooks).

- **systemd-managed daemons.** Two daemon shapes:
  1. **Persistent driver pool.** A maintainer-configured quantity of
     persistent driver processes, each invoked with a lane number
     (`scripts/driver/driver.sh 1`, `scripts/driver/driver.sh 2`,
     ...), each consuming jobs from the generic inbox. Lifetime
     ≥ multiple PRs (not 1-driver-per-PR as the current design says).
  2. **Per-activity-feed daemons.** One daemon per upstream activity
     feed (GitHub webhooks, repo polls, etc.) that translates events
     into message dispatches to the relevant inboxes. (Replaces the
     current per-repo poll daemons sitting behind the steward's
     daemon-log monitor.)

- **Top-level start/stop scripts.** systemd unit files plus
  human-invocable `scripts/daemons/start.sh` and `.../stop.sh` for
  Linux. Document where to put unit files; document what `systemctl
  --user enable ...` looks like.

- **Activity-watcher coalescence.** A single watcher process per
  activity feed (not one per role-context) that deterministically
  appends messages to the right inboxes. This appears in earlier
  feedback (22:20Z review) and the latest 04:08Z review reinforces it.

## Out of scope for this designer pass

- Do NOT physically move files between directories — that's
  implementation work for a later builder/fixer dispatch.
- Do NOT touch `roles/driver/`, `skills/driver-*/`, or `roles/driver/driver.sh`
  in this dispatch — articulate where they'd live in the new layout
  but leave the moves for an implementation follow-up.
- Do NOT alter `roles/cleaner/` (the earlier review at 04:00Z noted a
  conjugation point — "Cleaner is the name of a role. Cleaning is a
  skill." — that's a separate small fixer item).
- Do NOT add shellcheck-style cleanups; that's #401's lane.

## What to do

1. Edit `designs/driver.md` to articulate the four bullets above:
   driver-is-a-script, scripts/ top-level layout, systemd-managed
   daemons (driver pool + activity-feed daemons), top-level start/stop
   shell scripts. Land as a single new commit on `design/driver`:
   ```
   design(driver): pivot to script + systemd-managed daemons per #3 feedback
   ```
2. After pushing, post one top-level comment on PR #3 summarizing the
   pivot and threading replies to the three reviews (04:08Z, 04:10Z,
   04:19Z) confirming the design now reflects each ask. Use the GraphQL
   `resolveReviewThread` mutation to mark those threads as resolved if
   appropriate (CHANGES_REQUESTED stays until kriskowal re-reviews; just
   reply to acknowledge the design pivot).

## Per-action authorizations

- Edit `designs/driver.md`. Authorized.
- Regular append push to `kriskowal/garden:design/driver`. Authorized.
- Post one top-level PR comment + per-review replies. Authorized.
- `resolveReviewThread` GraphQL mutation. Authorized.

## Not authorized

- Editing files outside `designs/driver.md`.
- Force-push, retcon, un-draft/re-draft, merge.
- Moving files into a hypothetical new `scripts/` directory in this
  dispatch (design-only).
- Adding shellcheck CI / SC2166 fixups (covered elsewhere).

## Dispatch protocol

Read in order:
1. `garden/roles/COMMON.md`
2. `garden/roles/designer/AGENT.md`
3. Skills referenced just-in-time, especially
   `garden/skills/pr-review-thread-replies/SKILL.md` and
   `garden/skills/review-feedback-followup-commits/SKILL.md`.

Garden worktree is on `design/driver` at head `5bb23453b`.

## Report

A `result` journal entry. Include: new head SHA, file diff summary
(should be `designs/driver.md` only), the body of the top-level PR
comment, GraphQL outcomes for the per-review replies, and any
deviations from the four-bullet articulation.
