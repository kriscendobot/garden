# Garden

A library of agent **roles** and **skills** for working across many forks of
GitHub repositories, plus a **journal** that records what the garden has done and
acts as a git-backed **job board** and **message bus** that a fleet of worker
agents share.

The garden contains no application code — only the artifacts that let agents
dispatch focused subagents into worktrees of *other* repositories, and the
scripts that run the worker fleet.

This README covers the two things a maintainer does:

1. [**Get the garden running**](#1-getting-the-garden-running) — bring up the
   local worker fleet and the maintainer inbox.
2. [**Drive a change**](#2-driving-a-change) — take a feature from design,
   through design review, through implementation review, to merge — either by
   talking to the liaison in a `claude` prompt or by reviewing pull requests on
   GitHub.

A deeper tour of the architecture (roles, skills, the dispatch contract, the
journal) lives in [`CLAUDE.md`](./CLAUDE.md) and the [`designs/`](./designs/)
directory.

---

## How the garden is wired

There are two surfaces you interact with, and one fleet that does the work.

- **The liaison** is the agent you talk to. Open a `claude` session with the
  garden root as the working directory and you are talking to the liaison. It is
  a **relay and orchestrator, not a doer**: when you ask for work, it **posts a
  job** to the board for a worker to claim, rather than doing the work itself in
  your session. (Local operations — bringing up services, scaling the fleet,
  answering inbox messages, small library edits — it handles directly.)
- **Pull-request comments** are the other surface. A per-repo **triager** watches
  each project's PRs and turns a recognized comment ("rebase #N", an @-mention of
  the bot) into a job, deterministically. So you can drive the garden without a
  `claude` session at all — just by reviewing on GitHub.
- **The gardener fleet** does the substance. A host runs a large pool (~100) of
  **gardener** workers as systemd services. Each idle worker watches the board;
  when a job appears, the workers race to **claim** it (the accepted `git push`
  to the journal is the compare-and-swap), and the winner does the work and
  reports back. The pool is large because most workers are cheaply idle-blocked
  waiting for work or for a maintainer reply — the count is sized for
  concurrency, not CPU.

Everything coordinates through the **journal** (the orphan `journal2` branch,
checked out in `journal/`): producers post jobs, consumers claim them, and agents
message each other and you through per-role inboxes. Because the bus *is* a git
branch, the fleet can span multiple hosts.

---

## 1. Getting the garden running

The fleet runs as `systemd --user` services. Bring-up is five steps. (Full
rationale in [`CLAUDE.md`](./CLAUDE.md) § Job system and the
[job-board](./designs/job-board.md) design.)

### Step 0 — Verify a unique hostname (do this first)

Every host's logical name (`hostname -s`, overridable with `GARDEN_HOST`) **must
be unique across all your garden instances**. It keys claim metadata, the
per-host worker count, and journal index entries; two instances sharing a name
corrupt that state.

```sh
hostname -s          # is this unique among your running garden containers?
```

The kernel hostname can't be changed from inside a container (zero capabilities),
so it is fixed at creation via `--hostname`/`--name` (both `GARDEN_CONTAINER`).
The [`garden`](./garden) script creates and enters the container; to rename an
instance:

```sh
./garden reset && GARDEN_CONTAINER=<unique-name> ./garden
```

### Step 1 — Bootstrap the user manager (one-time)

Headless `systemctl --user` needs lingering enabled so the user manager runs
without an active login session:

```sh
loginctl enable-linger "$USER"
```

### Step 2 — Install and enable the units

```sh
scripts/jobs/install-units.sh install
scripts/jobs/install-units.sh enable-services
```

This installs the worker template and the supervisory services: the
**scheduler** (dispatches recurring jobs), the **repo-watcher** (reconciles a
triager unit per watched repo), the **watchman** (broadcasts role/skill
evolution), the **gardener-scaler** (reconciles the local pool to the
journal-declared count), the **reaper** (requeues stale claims), and the
**bulletin** regenerator.

### Step 3 — Set this host's worker count

The worker count is journal state that the gardener-scaler reconciles toward.
~100 is the default; tune per host.

```sh
scripts/jobs/set-gardeners.sh 100 "$(hostname -s)"
```

### Step 4 — Watch the maintainer inbox

The liaison surfaces messages workers address to you by running
`scripts/jobs/maintainer-watch.sh` through the Claude Code **Monitor** tool (a
short polling interval). When a worker needs a decision, the message appears in
your session; you reply or dismiss it:

```sh
scripts/jobs/maintainer-reply.sh   <msgid>   # routes your reply back to the worker, archives
scripts/jobs/maintainer-archive.sh <msgid>   # dismiss without replying
```

### Verifying health

The services are `--user` units. From a non-login shell, point the tools at the
user manager:

```sh
export XDG_RUNTIME_DIR=/run/user/$(id -u)
systemctl --user list-units 'garden-*' --all          # workers + supervisors
systemctl --user list-units 'garden-*' --state=failed  # should be empty
systemctl --user list-timers 'garden-*'                # supervisory cadences
```

A healthy fleet shows `garden-gardener@1..N` all `active (running)`, no failed
units, and the seven supervisory timers `waiting` with recent last-fire times.
The per-host worker count and last update live in `journal/hosts/<host>`.

### Changing the recurring-job schedule

To add or change a recurring job (commonly a weekly task duplication), race a
schedule change onto the journal rather than using a host-local crontab, so the
schedule is shared across hosts:

```sh
scripts/jobs/set-schedule.sh <name> <cadence> [prefix] [body-file]
```

The sole `garden-scheduler` service dispatches it on cadence. See the
[schedule](./skills/schedule/SKILL.md) skill.

---

## 2. Driving a change

A change moves through a lifecycle of **maintainer touch points** with automated
work between them. You describe an idea, review what the garden produces, and
approve when it's right; the garden runs the chains in between.

```
   you describe          garden drafts          you review on GitHub
   the idea      ─────►   the design     ─────►  (approve / request changes)
                          (a DRAFT PR)                    │
                                                          ▼  on approve
   you review the        garden builds          design merges to the
   implementation  ◄───  the implementation ◄── project's roadmap branch
   (approve / request)   (a DRAFT PR)
        │
        ▼  on approve
   implementation merges  ───►  (optional) ferry the work upstream
   to the bot fork              under your own identity
```

The design PR and the implementation PR are deliberately separate: the design
records the agreed approach (it merges to the project's roadmap branch); the
implementation lands the code (it merges to the fork's implementation branch).
They are reviewed and approved independently.

You drive each touch point through **either** of two surfaces. Use whichever is
in front of you.

### Surface A — talk to the liaison

In a `claude` session at the garden root, say what you want in a sentence or two.
The liaison composes a job and posts it to the board; a gardener claims it and
does the work. You do not need to babysit — close the session and pick up later;
the work continues on the fleet.

```
Please design a way for the daemon to serve weblet content from CAS.
```
```
Please build the next phase of the worker-pool design.
```
```
Please rebase #96 and shepherd it back to green.
```

The liaison reads recent journal activity at the start of a session, so it knows
the state of in-flight PRs without being briefed. If it does the wrong thing,
just tell it — *"don't dispatch that"*, *"close #N"*, *"that classification is
wrong, redo as Y"* — it is the user-in-the-loop surface and applies your
direction immediately.

### Surface B — review on the pull request

Every design and implementation lands as a pull request. You can drive the whole
loop from GitHub, with no `claude` session open:

- **Request changes / leave review comments.** Inline comments with concrete asks
  ("please rename this", "I'd like X instead") and a CHANGES_REQUESTED review are
  both picked up: the project's triager turns your review into a job, and a
  gardener addresses each comment, replies on the threads citing the fixing
  commits, and re-requests review.
- **@-mention the bot with an instruction.** A PR comment that @-mentions the
  garden's bot identity and states what you want is mapped to a job.
- **Use a recognized verb** (the primer below). A comment like `rebase #96` or
  `shepherd #96` maps deterministically to the corresponding job.
- **Approve.** Approving the PR is the signal to merge. On a design PR that merges
  the design to the roadmap branch (and queues implementation); on an
  implementation PR it merges the code to the fork.

Surface B is exactly as authoritative as Surface A — both end as jobs on the same
board, worked by the same fleet.

### A primer on verbs and commands

These are the recognized ways to motivate progress. Each maps to a job. In a
`claude` session you say them to the liaison; on a PR you write them as a comment
(or @-mention the bot with them). `#N` is the pull-request number.

| Verb | What the garden does |
| --- | --- |
| **run the gauntlet** #N | run the full PR-creation chain end to end (clean → panel review → fix-loop → un-draft for your review) |
| **rebase** #N | rebase the PR branch on its base |
| **retcon** #N | reset and restage the branch per-package, with a separate `chore: Update yarn.lock` commit and implementation+tests combined; the net diff is unchanged |
| **refresh** #N | re-sync the branch and regenerate derived artifacts (lockfiles, generated docs) |
| **shepherd** #N | drive CI back to green — re-run known operational flakes, escalate deeper failures to a fix |
| **ferry** #N | carry finished, approved work upstream under your own (`kriskowal`) identity onto the corresponding upstream PR. Requires explicit authorization and the credentialed host; *ferry* is the preferred verb |

The idiom is **gauntlet** (v1's "gamut" is retired). When you need something not
in this table, just describe it to the liaison in plain language — the table is
the set of *deterministic* mappings, not the limit of what you can ask.

### Two identities

The garden uses two GitHub identities. **`kriscendobot`** is the default — all
routine fork-side work (branches, draft PRs, comments, lint and coverage passes)
happens as the bot. **`kriskowal`** is your primary, used only for upstream pushes
that must land under your own name; every such use requires explicit
authorization in the job and the credentialed host (this is what **ferry** does).

### When the automation is wrong

- **Tell the liaison.** *"don't dispatch X"*, *"close #N"*, *"redo as Y"* — the
  in-the-loop surface applies it immediately.
- **Encode the lesson.** When a misclassification recurs, ask the liaison (or post
  a job) to have a **gardener** write the rule into the relevant role, skill, or
  doc, so future work reads the corrected context. The
  [self-improvement](./skills/self-improvement/SKILL.md) skill is the procedure;
  the **watchman** broadcasts role/skill changes to the fleet.

---

## The journal

The journal lives on the orphan `journal2` branch (checked out in `journal/`). It
is the garden's transcript, its job board (`jobs/{todo,doin,tada}/`), and its
message bus (per-role and per-job inboxes) — append-only and git-backed, so it
coordinates workers across hosts without a separate lock service.

**[Browse the journal on GitHub](https://github.com/kriskowal/garden/tree/journal)**

The journal's `README.md` is the maintainer dashboard: a bulletin of items that
need a human's attention plus a summary of ongoing work. Agents post and clear
bulletin rows as conditions arise and resolve; you read the dashboard and act in
the upstream system.

---

## Layout

- [`roles/<role>/AGENT.md`](./roles/) — operating brief for one role: its posture,
  the skills it uses, what it may touch, what counts as done.
- [`skills/<skill>/SKILL.md`](./skills/) — self-contained playbooks for individual
  capabilities (purpose, inputs, procedure, output, state).
- [`scripts/jobs/`](./scripts/jobs/) — the worker fleet, the job-board primitives,
  the maintainer-inbox tools, and the systemd units.
- [`designs/`](./designs/) — the architecture: the [job board](./designs/job-board.md),
  the [gardening state machine](./designs/gardening-state-machine.md), and more.
- [`CLAUDE.md`](./CLAUDE.md) — the top-level orientation auto-loaded into the
  liaison: layout, the dispatch contract, the current role/skill inventory.
- [`WORKTREES.md`](./WORKTREES.md) — worktree lifecycle: the standing journal
  worktree, fork worktrees, and the per-dispatch worktree triple.

Role and skill files are named `AGENT.md` / `SKILL.md` / `COMMON.md` on purpose:
Claude Code only auto-loads `CLAUDE.md`, so the root `CLAUDE.md` orients the
liaison while role and skill files stay out of the auto-loaded set — each worker
reads only the files its role brief names.

## How the work gets done

A **role** is an actor's brief; a **skill** is a reusable procedure a role cites.
A gardener that claims a PR job supervises the **gardening state machine** (a
shell script that runs the deterministic steps — rebase, evals, push — and shells
out to a `claude -p` decision only for genuine judgment calls), keeping routine
progress out of the worker's context. The judicial workflow (panel review →
fix-loop) that gates a PR before it reaches your queue runs the juror **seats**
carried over from the prior generation. See the [`designs/`](./designs/) directory
for the full picture.

Both `main2` (development) and `journal2` are pushed directly to `origin`; the
garden uses no PR workflow for its own repository. PR workflows are reserved for
fork worktrees of *other* repos, where finished work is ferried upstream.
