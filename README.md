# Garden

A library of agent **roles** and **skills** for working across many forks of
GitHub repositories, plus a **journal** that records what the garden has done and
coordinates a fleet of worker agents.

You drive the garden by **talking to it**, not by operating it. Describe the work
you want and the garden does it: drafts designs, builds implementations, fixes and
rebases pull requests, ferries finished work upstream. There are two equivalent
surfaces for asking:

- **Talk to the liaison**: open a `claude` session with the garden root as the
  working directory and say what you want in a sentence or two.
- **Act on the pull request**: review it, approve it, or leave a comment with an
  instruction. A watcher turns that into the same work.

Either way your request becomes a job that a worker claims and carries out; you
review the result and approve when it is right. You never manage the machinery in
between.

This README covers the two things a maintainer does:

1. [**Get the garden running**](#1-getting-the-garden-running): bring up the
   worker fleet and your inbox (one-time, per host).
2. [**Talk to the garden**](#2-talking-to-the-garden): the catalog of what to say
   to get each kind of work done.

The machinery behind all this (the roles, the skills, the dispatch contract, the
job board, the journal) is documented in [`CLAUDE.md`](./CLAUDE.md), the
[`designs/`](./designs/) directory, and the [`roles/`](./roles/) and
[`skills/`](./skills/) trees. You rarely need to read any of it to use the garden;
[Going deeper](#going-deeper) points the curious at it.

---

## 1. Getting the garden running

The fleet runs as `systemd --user` services. Bring-up is five steps. (Full
rationale in [`CLAUDE.md`](./CLAUDE.md) § Job system and the
[job-board](./designs/job-board.md) design.)

### Step 0: Verify a unique hostname (do this first)

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

### Step 1: Bootstrap the user manager (one-time)

Headless `systemctl --user` needs lingering enabled so the user manager runs
without an active login session:

```sh
loginctl enable-linger "$USER"
```

### Step 2: Install and enable the units

```sh
scripts/jobs/install-units.sh install
scripts/jobs/install-units.sh enable-services
```

This installs the worker template and a handful of supervisory services (a
scheduler, a per-repo comment watcher, the fleet scaler, a stale-claim reaper, and
the dashboard regenerator). You do not interact with them directly; they keep the
fleet reconciled and the board flowing.

### Step 3: Set this host's worker count

The worker count is journal state that the fleet scaler reconciles toward. ~100 is
the default; tune per host. The pool is large because most workers sit cheaply
idle waiting for work or for a reply from you. The count is sized for concurrency,
not CPU.

```sh
scripts/jobs/set-gardeners.sh 100 "$(hostname -s)"
```

### Step 4: Watch your inbox

When a worker needs a decision from you, it messages your inbox. Surface those
messages by running `scripts/jobs/maintainer-watch.sh` through the Claude Code
**Monitor** tool (a short polling interval). A message appears in your session;
you reply or dismiss it:

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
units, and the supervisory timers `waiting` with recent last-fire times. The
per-host worker count and last update live in `journal/hosts/<host>`.

### Changing the recurring-job schedule

To add or change a recurring job (commonly a weekly task duplication), race a
schedule change onto the journal rather than using a host-local crontab, so the
schedule is shared across hosts:

```sh
scripts/jobs/set-schedule.sh <name> <cadence> [prefix] [body-file]
```

See the [schedule](./skills/schedule/SKILL.md) skill.

---

## 2. Talking to the garden

The garden organizes itself around **what you want**, not how it is built. What
follows is the catalog of intents: for each, an example phrasing and what it
effects. Lead with plain language. You do not need to know the verbs or the role
names; the deterministic [verb primer](#a-primer-on-verbs) at the end is a
convenience, not a requirement.

You can say any of these to the **liaison** in a `claude` session. For anything
tied to an existing pull request, you can instead express it **on the PR itself**
(a review, an approval, a comment). The two surfaces are equivalent: both become
jobs on the same board, worked by the same fleet. See
[Reviewing on the pull request](#reviewing-on-the-pull-request).

### Propose and design

> "Please design a way for the daemon to serve weblet content from CAS."
> "Spec out X."

The garden drafts a **design proposal** and opens it as a DRAFT pull request for
your review. A design records the agreed *approach*, separate from any code; it
merges to the project's roadmap branch. You review and approve it like any PR.

### Build an implementation

> "Build the next phase of the worker-pool design."
> "Finish #475 as designed."

The garden turns an approved design into an **implementation**: a code pull
request, opened DRAFT, that runs the review chain before it reaches your queue.

Design and implementation are deliberately two separate PRs: the design captures
the approach and merges to the roadmap branch; the implementation lands the code
and merges to the fork. You review and approve each independently.

### Fix or revise an open PR

> "Rebase #96 and shepherd it back to green."
> "Weave #440 past the conflicts."
> "Retcon #442."
> "Address the review on #379."

The garden does the corresponding work on an open pull request: rebase it, weave
it past conflicts, retcon its commit structure, refresh its derived artifacts,
drive CI back to green, or work through review feedback. The recognized one-word
verbs are in the [primer](#a-primer-on-verbs); plain language works just as well.

### Merge an approved PR

> "Merge #96."
> (or simply **approve** the PR)

Approving a pull request is the signal to merge it. The garden conducts the merge
onto the right branch: a design PR merges to the roadmap branch (and queues the
implementation); an implementation PR merges to the fork.

### Ferry work upstream

> "Ferry #96 upstream."

The garden carries finished, approved work onto the corresponding **upstream**
pull request under **your own (`kriskowal`) identity**, rather than the bot's.
This is the one action that uses your primary identity, so it requires explicit
authorization and must run from the credentialed host. *Ferry* is the preferred
verb.

### Adopt a repository

> "Fork repo Z and set it up as a garden project."
> "Ingest Z's design docs into the library."

The garden adopts a new repository as a project (a bot fork it can work in), or
has a **scholar** ingest an external repo's documents into the cross-cutting
reference library, so later work can look up that project's terms and conventions
instead of guessing.

### Garden-meta requests

The garden maintains itself the same way it does project work, by your asking:

> "Encode this lesson so it does not recur." → a worker writes the correction into
> the relevant role, skill, or doc, and the change is broadcast to the fleet.
> "Fix the monitors." / "Pause the services." / "Scale the fleet down." → the
> liaison handles these local operations directly.

When a misclassification or mistake recurs, asking the garden to *encode the
lesson* is how its future behavior improves.

### Reviewing on the pull request

Every design and implementation lands as a pull request, so you can drive the
whole loop from GitHub with no `claude` session open:

- **Approve**: the signal to merge (above).
- **Request changes / leave inline comments**: concrete asks ("please rename
  this", "I'd like X instead") with a CHANGES_REQUESTED review are picked up; a
  worker addresses each comment, replies on the threads citing the fixing commits,
  and re-requests review.
- **@-mention the bot with an instruction**: a comment that addresses the
  garden's bot identity and states what you want becomes a job.
- **Comment a recognized verb**: `rebase #96`, `shepherd #96`, and the rest of
  the [primer](#a-primer-on-verbs) map deterministically.

This surface is exactly as authoritative as talking to the liaison; both end as
jobs on the same board, worked by the same fleet.

### A primer on verbs

These one-word verbs are the garden's vocabulary for working an open PR. Each maps
to a specific job. You say them to the liaison in a `claude` session, or write
them on the PR as a comment. You never need them (plain language always works),
but they are precise. `#N` is the pull-request number.

| Verb | What the garden does |
| --- | --- |
| **run the gauntlet** #N | run the full PR-creation chain end to end (clean → panel review → fix-loop → un-draft for your review) |
| **rebase** #N | rebase the PR branch on its base |
| **weave** #N | rebase and resolve conflicts |
| **retcon** #N | reset and restage the branch per-package, with a separate `chore: Update yarn.lock` commit and implementation+tests combined; the net diff is unchanged |
| **refresh** #N | re-sync the branch and regenerate derived artifacts (lockfiles, generated docs) |
| **shepherd** #N | drive CI back to green: re-run known operational flakes, escalate deeper failures to a fix |
| **ferry** #N | carry finished, approved work upstream under your own (`kriskowal`) identity; requires authorization and the credentialed host |

The idiom is **gauntlet** (v1's "gamut" is retired). On a PR comment, the watcher
recognizes `rebase` / `retcon` / `refresh` / `shepherd` / `run the gauntlet`
directly; anything else (an @-mention, a review with asks) is read for intent. To
the liaison, just describe what you want. The table is the set of *deterministic*
mappings, not the limit of what you can ask.

### Two identities

The garden uses two GitHub identities. **`kriscendobot`** is the default: all
routine fork-side work (branches, draft PRs, comments, lint and coverage passes)
happens as the bot. **`kriskowal`** is your primary, used only for upstream pushes
that must land under your own name; every such use requires explicit authorization
and the credentialed host (this is what **ferry** does).

### When the garden does the wrong thing

- **Tell the liaison.** *"don't dispatch that"*, *"close #N"*, *"that
  classification is wrong, redo as Y"*. The in-the-loop surface applies your
  direction immediately. The liaison reads recent journal activity at the start of
  a session, so it already knows the state of in-flight work without being briefed.
- **Encode the lesson.** When a mistake recurs, ask the garden to write the rule
  into the relevant role, skill, or doc (above), so future work reads the
  corrected context.

---

## The maintainer dashboard

The journal's top-level `README.md` is your dashboard: a bulletin of items that
need your attention (PRs ready for review, decisions to make, authorizations to
grant) plus a summary of ongoing work. Workers post bulletin rows as conditions
arise and clear them as conditions resolve; you read the dashboard and act in the
upstream system.

**[Browse the journal on GitHub](https://github.com/kriskowal/garden/tree/journal2)**

---

## Going deeper

You do not need any of this to use the garden, but the curious can read on:

- [`CLAUDE.md`](./CLAUDE.md): the top-level orientation auto-loaded into the
  liaison, covering the layout, the dispatch contract, and the current role/skill
  inventory.
- [`designs/`](./designs/): the architecture, including the
  [job board](./designs/job-board.md) and the
  [gardening state machine](./designs/gardening-state-machine.md).
- [`roles/<role>/AGENT.md`](./roles/): the operating brief for each role, covering
  its posture, the skills it uses, what it may touch, and what counts as done.
- [`skills/<skill>/SKILL.md`](./skills/): self-contained playbooks for individual
  capabilities (purpose, inputs, procedure, output, state).
- [`scripts/jobs/`](./scripts/jobs/): the worker fleet, the job-board primitives,
  the inbox tools, and the systemd units.
- [`WORKTREES.md`](./WORKTREES.md): worktree lifecycle, covering the standing
  journal worktree, fork worktrees, and the per-dispatch worktree triple.

A note on naming: role and skill files are `AGENT.md` / `SKILL.md` / `COMMON.md`,
not `CLAUDE.md`, on purpose. Claude Code auto-loads only `CLAUDE.md`, so the root
`CLAUDE.md` orients the liaison while role and skill files stay out of the
auto-loaded set; each worker reads only the files its role brief names.

Both `main2` (development) and the orphan `journal2` branch are pushed directly to
`origin`; the garden uses no PR workflow for its own repository. PR workflows are
reserved for fork worktrees of *other* repos, where finished work is ferried
upstream.
