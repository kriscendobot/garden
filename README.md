# Garden

**The garden mostly grows by itself, but to get what you want, you have to pull
weeds.** (Corollary: you reap what you sow.)

The garden is a fleet of coding agents that works your GitHub repositories. It
drafts designs, builds implementations, reviews its own pull requests, fixes
what review finds, and ferries finished work upstream under your name. You
steer it in plain language from whichever surface is closest to hand: a
terminal, a GitHub issue, a PR comment, or a web page.

The load-bearing idea is that the **design→build workflow keeps the garden busy
until every measure has been taken to anticipate the maintainer's feedback**.
Each job runs a loop of automatic and agentic steps — observe (watchers, the
job board), orient (triage, research), decide (review panels, the proxy), act
(build, fix, push) — an OODA loop that terminates only when the machine has
nothing left to say about the work. Two roles tune the loop's edges:

- The **appellate** tunes the tail. After the review panel passes a PR, the
  appellate appeals the panel's own deferrals: anything small and in-context
  gets promoted back into the same change instead of being risked on a
  follow-up list. Whatever *can* be done now, gets done now
  ([roles/appellate/AGENT.md](roles/appellate/AGENT.md)).
- The **proxy** keeps agents busy while you are away. When a worker would
  block on a common judgment call — "keep going?", "which direction first?" —
  the proxy answers with heuristics that readily anticipate you: favor
  progress over efficiency, tolerate throw-away work, pick a direction and
  mark it provisional. Policy and authority questions still wait for you
  ([roles/proxy/AGENT.md](roles/proxy/AGENT.md)).

So: mostly self-growing. Your job is the weeding — review what surfaces,
answer the questions only you can answer, and say what you want next.

This README is a graduated tutorial in usage:

1. [**Getting started**](#1-getting-started) — get it running once, per host.
2. [**Control surfaces**](#2-control-surfaces) — the five places you talk to it.
3. [**How it works**](#3-how-it-works) — the machinery and its design
   principles, last, because you don't need it to garden.

---

## 1. Getting started

### What you need

- **Docker.** The garden lives in a container that runs systemd as PID 1.
- **A bot GitHub account** (like `kriscendobot`). All routine work — branches,
  draft PRs, comments — happens as the bot, never as you. Your own identity is
  reserved for [ferrying](#the-ferry-a-permissioned-cli-on-one-host).
- **Claude Code auth**, most practiced as a Claude subscription login from
  inside the container.

### Build and enter the container

```sh
./garden build     # build the image (once)
./garden           # create/start the container and drop into a shell
./garden reset     # remove the container; next entry starts fresh
```

The [`garden`](./garden) launcher bind-mounts this directory as the
container's home, so everything the bot accumulates — keys, tokens, claude
credentials, worktrees — lives here on the host and survives a `reset`.

**Pick a unique identity first.** Each instance has a logical name (its
*shard* identity) that keys job claims, per-host worker counts, and the
leader marker. Two instances sharing a name corrupt each other's state. At
container creation the launcher seeds this identity from `GARDEN`
(defaulting to the container hostname `GARDEN_HOSTNAME`) into a gitignored
`.garden` file, with `GARDEN_CONTAINER` naming the container:

```sh
GARDEN_CONTAINER=petunia GARDEN_HOSTNAME=petunia ./garden
```

Every fleet script then reads that file as its runtime `GARDEN` identity
(`common.sh` resolves `GARDEN` env → `.garden` file → `hostname -s`); an
exported `GARDEN` does **not** reach the systemd `--user` units, which is why
the durable file exists. Set `GARDEN` at creation time only when a pool's
identity must differ from its hostname (a second follower pool on the same
machine); `GARDEN_SHARD` remains accepted as a deprecated alias for one
release.

### Give the bot its keys

The launcher deliberately does **not** forward your SSH agent — an
agent-forwarded human identity must not leak into bot actions. The bot uses
its own keys under `.ssh/` in this directory (which is `~/.ssh/` inside the
container, and gitignored):

1. Generate a key and add it to the **bot** GitHub account (an
   `id_ed25519` under `<garden-root>/.ssh/`).
2. Inside the container, authenticate `gh` as the bot: `gh auth login`. The
   token lands in `.config/gh/`, also bind-mounted, also gitignored.

### Authenticate claude

Run `claude` inside the container and log in. A Claude subscription login is
the most practiced path — the whole fleet runs on one subscription — and the
credential persists in the bind-mounted home like everything else. The
launcher also forwards `ANTHROPIC_API_KEY` into the container if you export it
before `./garden`, but the subscription flow is the beaten path.

### Bring up the fleet

Inside the container:

```sh
loginctl enable-linger "$USER"                 # 1. user manager without a login session (once)
scripts/jobs/install-units.sh install          # 2. render + install the systemd units
scripts/jobs/install-units.sh enable-services
scripts/jobs/set-gardeners.sh 100 "$(hostname -s)"   # 3. this host's worker count
scripts/jobs/set-main-host.sh "$(hostname -s)"       # 4. designate the leader (single host: itself)
```

~100 workers is normal. Most are idle-blocked waiting on messages at any
moment — sleeping is the cheapest thing an agent can do — so the count is
sized for concurrency, not CPU. The leader marker gates the singleton services
(scheduler, watchers, bulletin); followers run only worker pools. See
[`designs/multibot-leader-follower.md`](designs/multibot-leader-follower.md)
when you add a second host.

Two optional armings:

```sh
scripts/jobs/set-garden-repo.sh <owner/name>   # drive the garden from its own GitHub issues…
scripts/jobs/add-maintainer.sh  <your-login>   # …allowlist who may drive it
```

Then watch your inbox. Workers message you when they need a decision; surface
those messages by running `scripts/jobs/maintainer-watch.sh` under a Claude
Code **Monitor** in your liaison session, and answer with:

```sh
scripts/jobs/maintainer-reply.sh   <msgid>   # reply routes back to the asking worker
scripts/jobs/maintainer-archive.sh <msgid>   # dismiss without replying
```

### Mint the bulletin token

The [GitHub Pages bulletin](#the-bulletin-github-pages) reads the garden's
status without auth, but replying from the page needs a fine-grained Personal
Access Token (Contents: Read and write, scoped to this repo only). The
click-by-click workflow is [`docs/bulletin/SETUP.md`](docs/bulletin/SETUP.md).

### Health, pausing

```sh
systemctl --user list-units 'garden-*' --state=failed   # should be empty
scripts/jobs/drain-fleet.sh on [reason]   # workers finish current jobs, take no new ones
scripts/jobs/drain-fleet.sh off
```

### Key vocabulary for the liaison

You never *need* the vocabulary — plain language always works — but these
verbs are precise, and the PR-comment watchers recognize the starred ones
deterministically. `#N` is a pull-request number.

| Verb | What the garden does |
| --- | --- |
| **design X** / propose X / spec X | draft a design document and open it as a DRAFT PR on the roadmap branch |
| **build #N** / build X | implement an approved design; a DRAFT code PR runs the review chain |
| **run the gauntlet #N** ★ | the full PR chain end to end: clean → panel review → fix-loop → un-draft for your review |
| **rebase #N** ★ | rebase the PR branch on its base |
| **weave #N** | rebase and resolve conflicts |
| **retcon #N** ★ | reset and restage the branch per-package, separate `chore: Update yarn.lock` commit; net diff unchanged |
| **refresh #N** ★ | re-sync the branch, regenerate derived artifacts |
| **shepherd #N** ★ | drive CI back to green |
| **fix #N** | address review feedback with commits and thread replies |
| **merge #N** ★ | conduct the merge onto the right branch (or just approve the PR) |
| **ferry #N** | carry approved work upstream under your own identity — authorization required |
| **defer X** / park X | park a job on the plan queue; the foreman promotes it when the board idles |
| **promote X** / go ahead on X | move a parked job onto the board now |
| **stand up / stand down / drain** | fleet operations, handled by the liaison directly |

---

## 2. Control surfaces

Five planes, one job board. Everything below becomes a job that a worker
claims; the surfaces differ only in where you're standing.

### The claude CLI: the liaison

Open a `claude` session with the garden root as the working directory. That
session *is* the **liaison** — the in-the-loop orchestrator with excess
authority that asks before acting. Say what you want:

> "Design a way for the daemon to serve weblet content from CAS."
> "Build the next phase of the worker-pool design."
> "Rebase #96 and shepherd it back to green."
> "What's blocked and why?"
> "Encode this lesson so it doesn't recur."

Common interactions, mined from practice:

- **Start work**: a sentence of intent becomes a `design` or `build` job.
- **Unstick a PR**: the fix/weave/retcon/shepherd verbs above.
- **Answer workers**: the maintainer-inbox Monitor surfaces questions;
  `maintainer-reply.sh` routes your answer back into the asking worker's
  inbox mid-job.
- **Steer the plan**: "defer X", "promote X", "go ahead on the retcon".
- **Operate the fleet**: "drain the fleet", "hand off leadership to petunia",
  "scale down to 50".
- **Teach it**: "encode this" writes the correction into the role or skill
  that got it wrong, and the change broadcasts to the running fleet.

### GitHub issues on the garden's own repo

File an issue — or comment on one — and the garden treats it as direction.
A deterministic watcher polls the repo named in `config/garden-repo`; an
author on `maintainers/allowlist` gets dispatched, anyone else is logged and
dropped **before any text reaches a model** (that gate, not trust in the
crowd, is the prompt-injection defense —
[`designs/issue-inbox.md`](designs/issue-inbox.md)).

- A new issue becomes a job; the worker replies *on the issue thread* and
  never closes it — you close it when satisfied.
- A comment on an in-flight issue is folded into the working agent's inbox; if
  that agent already finished, dead-letter rescue promotes your comment to a
  fresh job, so a late thought is never lost.
- 👀 on your comment means "received and processing."

### Other repositories: forks, PR comments, @-mentions

The garden works other repos through **bot forks** — it never pushes to
upstream directly. Adopt one by asking the liaison ("fork repo Z and set it
up as a garden project"); work happens in fork worktrees, PRs open as drafts
against frozen base branches, and the review chain runs before anything asks
for your attention.

On watched repos and anywhere `@<bot>` is mentioned:

- **Comment a verb**: `rebase`, `retcon`, `refresh`, `shepherd`, `run the
  gauntlet` map deterministically to jobs — imperative position only; using a
  verb as a noun doesn't fire it.
- **Review the PR**: APPROVED merges; CHANGES_REQUESTED with inline comments
  gets each thread addressed, replied to with the fixing commit, and review
  re-requested.
- **@-mention the bot with anything else**: a worker reads it and routes it —
  and per standing directive you get at least a substantive reply, not just a
  reactji.

Mentions are guarded by a sender-trust gate (allowlist or trusted-org
membership, checked in plain code before any model sees the text). Bot-side
etiquette is strict: no comments, reactjis, or cross-links on repos you don't
own without an authorization carried in the job
([roles/COMMON.md](roles/COMMON.md) § External-repo etiquette).

### The ferry: a permissioned CLI on one host

Everything above runs as the bot. **Ferrying** — carrying an approved PR from
the fork to the actual upstream repo — lands commits under *your* name, so it
is deliberately a separate, permissioned surface:

- It runs only on the host that holds your (`kriskowal`) credentials; a ferry
  claimed anywhere else blocks on its precondition check (`gh auth status`
  must show your account, upstream permissions must show `push: true`) and
  reports the gap rather than pushing as the bot.
- The job must carry `identity_switch_authorized: true`; no agent may
  originate that flag — only you.
- The fleet's `gh` wrapper pins every call to the bot identity; your identity
  is reachable only by explicit per-call override
  (`GARDEN_GH_IDENTITY=kriskowal gh …`), which makes each human-identity act
  auditable ([`designs/fleet-gh-identity.md`](designs/fleet-gh-identity.md)).
- Transferred commits are re-attributed to you alone: no bot author, no
  co-author trailers ([roles/boatman/AGENT.md](roles/boatman/AGENT.md)).

Usage is one line, from the credentialed host: **"ferry #96."**

### The bulletin: GitHub Pages

**<https://kriskowal.github.io/garden/bulletin/>** — the garden's face, for
when you're away from any terminal. It shows the live dashboard from the
journal (PRs parked for your review ranked by roadmap position, board counts,
per-host workers, your unread inbox) with a `## Latest` narrative lead
written by the journalist role when something changed.

Reading needs no auth. To **reply to workers from the page**, paste the
fine-grained PAT from [`docs/bulletin/SETUP.md`](docs/bulletin/SETUP.md) once
(stored in `localStorage`, sent only to `api.github.com`). Each unread
message gets a reply box; "Reply & acknowledge" commits your answer straight
onto the journal branch — same bus semantics as `maintainer-reply.sh`, one
compare-and-swap commit that delivers to the worker and archives the
original. A composer at the top opens a fresh thread to the liaison. No
token? The page falls back to "open a GitHub issue," which is surface #2.

---

## 3. How it works

You can garden for weeks without reading this section. It's here for the
weeds you'll eventually want to pull by the root.

### The life of a pull request

Design and implementation are **two separate pull requests**, on purpose: the
design records the agreed approach and merges to the project's roadmap
branch; the implementation is based on the mainline and merges to the fork.
You approve each independently, and a stale design can be re-litigated
without archaeology on the code.

1. **Design PR.** A designer drafts `designs/<slug>.md`, opens it DRAFT
   against the roadmap branch. A 7-seat design panel reviews. You approve;
   the conductor merges it to the roadmap.
2. **Build PR.** A builder implements the design from mainline, opens DRAFT
   against a frozen base branch on the fork. Then the **gauntlet** — one
   shell state machine that a worker supervises, invoking a model only at
   decision points:
   - **assayer** authors tests; **cleaner** drives coverage and dead-code
     passes and watches CI go green;
   - the **panel** fans out a 26-seat code jury; `must-fix` findings loop
     through a **fixer** and the panel re-runs until it terminates;
   - the **appellate** pass appeals small in-context deferrals back into the
     change;
   - the panel — and only the panel — un-drafts (`gh pr ready`). A
     non-draft PR is the machine saying "I anticipate no further feedback."
3. **Your review.** Approve to merge (the conductor linearizes: one merge in
   flight across the estate). Request changes and a fixer addresses each
   thread, citing the fixing commit.
4. **Ferry**, on your say-so, carries it upstream under your name.

The spine is [`skills/pr-creation-flow/SKILL.md`](skills/pr-creation-flow/SKILL.md);
the judiciary is [`designs/judicial-workflow.md`](designs/judicial-workflow.md).

### The life of an issue

An issue enters as direction (your issue on the garden's repo, a triaged
change on a watched repo, or a job you post directly) and becomes a board
entry: `todo/` → claimed to `doin/` → report in `tada/`. From there the
follow-up service reads each completed report's `## Follow-ups` section and
turns actionable ones into new jobs, schedules, or messages to you — the
board feeds itself. If the issue implies design work, the design→build
pipeline above takes over: a poller notices approved designs with no tracking
PR and posts the build. When the board drains entirely, the **foreman** looks
at the current milestone and posts its next most important unblocked step, so
an idle garden reaches for the roadmap instead of napping.

The board's serialization point is a `git push` to the journal branch —
first pusher wins, the rejected claim backs off to another job. No lock
service, no scheduler-of-schedulers
([`designs/job-board.md`](designs/job-board.md)).

### Self-healing, self-improvement, reflection

The posture: **automation is silent until an error, and every error feeds a
loop that makes the automation better.**

- `self-heal-run.sh` wraps fleet commands; on unexpected failure it captures
  the evidence and hands a content-hash to a diagnosing responder that posts
  a fix job. The wrapper diagnoses; systemd restarts. Throttled, so a crash
  loop can't burn tokens.
- The **reaper** requeues jobs whose claimant died; the same job base resumes
  the same session, so work survives its worker.
- **Deadmail** promotes messages sent to departed agents into fresh jobs;
  intent is never dropped on the floor.
- The **mentor** reads the journal and the fleet's warning logs on a cadence
  and emits improvement jobs — biased toward moving judgment *out* of agents
  and *into* scripts. The garden's self-healing is this loop.
- The **watchman** broadcasts changes on the dev branch to running agents, so
  a lesson you encode reaches the fleet mid-flight.

Reflection is also a habit you invoke: "encode this" turns today's mistake
into tomorrow's rule, and [`HISTORY.md`](HISTORY.md) records what survives
every rebuild — "the habit of turning a lesson into a rule and a rule into
infrastructure."

### The context library

The journal carries a **context library** (`journal/library/`) — hierarchical
documentation optimized for agents doing research on a token budget, not for
humans skimming a wiki. Its disciplines
([`skills/context-library/SKILL.md`](skills/context-library/SKILL.md)):

- every directory's README is a routing contract whose children partition the
  topic, so a reader descends only the right branch;
- every document leads with an abstract that is an **exit criterion** — match
  it and descend, or abandon the branch after one paragraph;
- many small files beat one long one; a query should load pages, not tomes;
- lookup starts by **grepping a keyword index** (meant to be grepped, never
  read) into one-paragraph concept pages that fan out to section files;
- the flat indexes (5,500+ section entries) are deterministic projections of
  the corpus, regenerated by script — no agent hand-edits an index;
- every lookup writes back: a keyword shortcut, a pruned confusion, a missing
  concept. Reading the library grows the library.

A **scholar** ingests external sources (idempotently, keyed by source commit)
and a **librarian** searches on demand and audits for oversize documents and
index gaps.

### Planning: schedules, the backlog, the milestone, delivery dates

The plan lives in the journal (`journal/plan/`): one record per design, the
milestone files that bin them, and `velocity.md`, which maps S/M/L/XL sizes
to observed days. A renderer projects the rollup — per milestone: designs,
complete, %, **estimated days remaining** — and a weekly recalibration job
re-fits velocity to what actually shipped, reprojects the roadmap, and grooms
the records. Delivery dates are a computed projection of measured velocity,
not vibes; when they're wrong you fix the velocity input, not the number.

The service verbs you actually use:

```sh
scripts/jobs/post-job.sh <basename> [body]            # a job, now
scripts/jobs/post-plan.sh --deferred <base> [body]    # parked; foreman promotes when idle
scripts/jobs/post-plan.sh --go-ahead <base> [body]    # parked until you say "go ahead"
scripts/jobs/promote-plan.sh <base>                   # …you said go ahead
scripts/jobs/set-schedule.sh <name> weekly [prefix]   # recurring, shared across hosts
scripts/jobs/set-schedule-once.sh <name> <ISO-time>   # fires exactly once, then deletes itself
```

Multi-part work gets an **orchestration**: park the children
(`post-plan.sh --orchestrated`), record the sequence
(`post-orchestration.sh --serial <orch> <child>…`), and a deterministic
watcher promotes each child as its predecessor completes, halting to you on
failure instead of stalling silently
([`skills/orchestration/SKILL.md`](skills/orchestration/SKILL.md)).

### The bidding market: the next metamorphosis

[`HISTORY.md`](HISTORY.md) traces four metamorphoses — shepherd, container,
supervision, and the current shape: deterministic scripts between two layers
of cognition. The fifth is designed and tracking
([#15](https://github.com/kriskowal/garden/issues/15)): replace the
first-to-claim race with a **bid/accept market**
([`designs/gardener-bid-accept-market.md`](designs/gardener-bid-accept-market.md)).

Workers become **differentiated** (by role, skill mix, and model tier) and
**reputation-bearing**: effectiveness is controlled by the acceptance gate,
so cost — normalized to dollars and duration — is the free variable a
reputation ledger scores. A broker awards jobs to bids; a Thompson-sampling
bandit explores new roles and models while exploiting known winners; a role
refiner mints new bidders and a consolidator caps the roster
([`designs/gardener-reputation-bootstrapping.md`](designs/gardener-reputation-bootstrapping.md)).
Job **indexing** deepens the same way: today jobs are deduplicated by
basename and directive-identity hash; the market indexes them by kind, role,
and cost history so bids have something to price. Today's race is,
deliberately, the market's degenerate case — the rollout is phased and the
old mode never breaks.

### Going deeper

- [`CLAUDE.md`](./CLAUDE.md) — the liaison's auto-loaded orientation: layout,
  dispatch contract, inventory.
- [`designs/`](./designs/) — the architecture, decision by decision.
- [`roles/`](./roles/) and [`skills/`](./skills/) — one brief per role, one
  playbook per capability. Named `AGENT.md`/`SKILL.md` (not `CLAUDE.md`) on
  purpose, so workers load only what their role names.
- [`WORKTREES.md`](./WORKTREES.md) — worktree shapes and lifecycles.
- **[The live board](https://github.com/kriskowal/garden/tree/journal2)** —
  the journal branch: jobs, inboxes, plan, library, and the bulletin's
  dashboard, all in one orphan branch that never merges with development.

Both `main2` (development) and `journal2` are pushed directly; the garden
runs no PR workflow on itself. The cobbler's children go barefoot so yours
don't have to.
