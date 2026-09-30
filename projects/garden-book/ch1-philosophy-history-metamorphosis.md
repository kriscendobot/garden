---
created: 2026-09-30
author: gardener (job book-ch1, orchestration garden-book-orch)
grounded-on: main2 7f0cb21902c
sources: README.md, CLAUDE.md, HISTORY.md, designs/gardener-bid-accept-market.md, designs/cleric-worker-bid-auction-reputation.md, skills/bid-auction/SKILL.md
---

# Chapter 1: Philosophy, history, and metamorphosis

This chapter covers what the garden is, why it exists, and how it came to have
its current shape. The later chapters explain how the machinery works and how
to run it. This one explains why the machinery looks the way it does, and the
answer is mostly historical. The garden has been rebuilt several times, and
each rebuild was a response to something that broke or stopped scaling in the
one before. If you are about to stand up your own instance, you will inherit
the current design all at once. Knowing what each part replaced makes the
design easier to follow.

The chapter draws on three documents in the garden's development branch
(`main2`): [`README.md`][readme], the tutorial written for the maintainer;
[`CLAUDE.md`][claude-md], the orientation file loaded automatically into the
garden's front-desk agent; and [`HISTORY.md`][history], the garden's own
account of its evolution. Quotations are taken verbatim. Where this chapter
and those files disagree, the files are authoritative.

## Contents

- [1.1 What the garden is](#11-what-the-garden-is)
- [1.2 Why it exists](#12-why-it-exists)
- [1.3 The metamorphoses](#13-the-metamorphoses)
  - [Stage one: genesis, the shepherd](#stage-one-genesis-the-shepherd)
  - [Stage two: containment, a container and a bot](#stage-two-containment-a-container-and-a-bot)
  - [Stage three: supervision, many sessions on an always-online host](#stage-three-supervision-many-sessions-on-an-always-online-host)
  - [Stage four: automation between two layers of cognition](#stage-four-automation-between-two-layers-of-cognition)
- [1.4 Where the garden stands now](#14-where-the-garden-stands-now)
- [1.5 The next metamorphosis: the bidding market](#15-the-next-metamorphosis-the-bidding-market)
- [1.6 What to carry forward](#16-what-to-carry-forward)

## 1.1 What the garden is

The README opens with a one-line summary:

> **The garden mostly grows by itself, but to get what you want, you have to
> pull weeds.** (Corollary: you reap what you sow.)

and then gives the plain description:

> The garden is a fleet of coding agents that works your GitHub repositories.
> It drafts designs, builds implementations, reviews its own pull requests,
> fixes what review finds, and ferries finished work upstream under your name.
> You steer it in plain language from whichever surface is closest to hand: a
> terminal, a GitHub issue, a PR comment, or a web page.

`CLAUDE.md` describes the same system from the inside, in terms of what the
repository actually contains:

> The garden is a library of agent **roles** and **skills** for working across
> many forks of GitHub repositories, plus a **journal** that records what the
> garden has done and coordinates the fleet. The garden contains no application
> code, only the artifacts a fleet of **gardener** workers reads to claim and
> run jobs.

Read the two together and the garden has three parts:

1. **A library of roles and skills.** A *role* is a short operating brief for
   one kind of agent (`roles/<role>/AGENT.md`): the builder, the fixer, the
   designer, the shepherd, and about three dozen others. A *skill* is a
   self-contained playbook for one capability (`skills/<skill>/SKILL.md`), for
   example how to rebase onto a frozen base branch or how to reply to a review
   thread. A role lists the skills it uses and never copies their text. The
   files are deliberately not named `CLAUDE.md`, because Claude Code would load
   a file with that name automatically. "They are loaded explicitly by the
   gardener whose role or job names them," so each worker's context holds only
   what its job requires.

2. **A journal-backed coordination substrate.** The *journal* is a git branch,
   `journal2`, which shares no history with the development branch and is
   checked out in the `journal/` directory. It serves as the garden's
   transcript, its **job board** (`jobs/`, where work is posted and claimed),
   and its **message bus** (`inbox/<doer>/`, where agents send each other
   directed messages). The garden runs no database and no lock server. A
   `git push` to `origin/journal2` is the only point where concurrent workers
   are serialized.

3. **A fleet of workers.** A *gardener* is the shared worker process that
   claims a job from the board, takes on the role that job names, and does the
   work in an isolated per-job git worktree. Many gardeners run on each host,
   and several hosts can share one journal. The name refers to the shared
   role and code path, not to any particular kind of worker process. Today the
   workers that run Anthropic models are called *monks*, and those that run
   OpenAI models are called *clerics*.

Between the human and the fleet sits the **liaison**, the agent you talk to
when you open a terminal in the garden root. The liaison does not do the
substantive work itself. When the maintainer asks for something (design X,
build pull request #N, fix, rebase, merge), the liaison posts a job to the
board with a short, deterministic name, and a gardener claims it. In
`CLAUDE.md`'s words: "The per-job substance never enters the liaison's
context, so a re-issued ask is idempotent and the board survives a `/clear`."

The garden manages its own code differently from the code it works on. Its
own repository has no pull-request workflow: `main2` and `journal2` are pushed
directly. Pull requests are reserved for forks of *other* repositories. The
README puts it this way: "The cobbler's children go barefoot so yours don't
have to."

## 1.2 Why it exists

The problem the garden addresses is how to get a large amount of real
software work done by AI agents without a human participating in every step,
while keeping the human in control of what matters.

Each part of that problem constrains the design:

- **Real software work** happens in pull requests on real repositories. That
  work includes continuous integration (CI) runs that fail, reviewers who
  request changes, base branches that move, and merge conflicts. A single
  agent session can handle one pull request, but not fifty over a month.
- **Many agents** must share work without doing it twice and without
  corrupting each other's working trees. That calls for a claiming protocol,
  isolation, and recovery when a worker dies partway through a job.
- **No human in every step** means work must continue while the maintainer is
  away. The garden also has to decide which questions are worth waking the
  maintainer for.
- **The human stays in control** of anything that acts under the
  maintainer's identity, anything that reads text an untrusted person could
  have written, and the work that gets accepted in the end.

The README's summary of the approach is:

> The load-bearing idea is that the **design→build workflow keeps the garden
> busy until every measure has been taken to anticipate the maintainer's
> feedback**. Each job runs a loop of automatic and agentic steps — observe
> (watchers, the job board), orient (triage, research), decide (review panels,
> the proxy), act (build, fix, push) — an OODA loop that terminates only when
> the machine has nothing left to say about the work.

(OODA stands for observe, orient, decide, act, a decision-cycle model borrowed
from military strategy.) The garden aims to finish everything it can before
the maintainer sees the work. Two roles handle the boundaries of that loop.
The **appellate** runs after the review panel passes a pull request. It
reconsiders the panel's deferred findings and brings small, in-context fixes
back into the same change. The **proxy** answers routine judgment questions,
such as "keep going?" or "which direction first?", on the maintainer's
behalf, using heuristics that "favor progress over efficiency, tolerate
throw-away work, pick a direction and mark it provisional." Questions of
policy and authority still wait for the human.

This leaves the maintainer with the job the README calls weeding: "review what
surfaces, answer the questions only you can answer, and say what you want
next."

The structure has three parts, each covered in detail in Chapter 2:

- **The job board** decides who does what. Producers post jobs to
  `jobs/todo/`. The producers are watchers on pull-request comments and CI,
  the scheduler, the liaison, and the *foreman*, which posts the next step
  when the board runs empty. Gardeners compete to claim a job by pushing it to
  `jobs/doin/`, and the first push to land wins.
- **The message bus** lets a job wait for an answer without keeping a process
  busy. A job can block on the maintainer or on a peer, and a message sent to
  an agent that has already finished becomes a new job, so its content is not
  lost.
- **The gardener fleet** does the work. Each gardener runs a job in its own
  worktree, calls a language model only where judgment is needed, and records
  a completion report to `jobs/tada/`.

`HISTORY.md` shows that this structure was not designed in one step. It is
the fourth rebuild.

## 1.3 The metamorphoses

`HISTORY.md` begins with its thesis:

> The garden has never held still. It is a system that keeps re-architecting
> itself: each time a way of working hits a ceiling, the maintainer and the
> agents tear out the coordinating layer and rebuild it, carrying the parts
> that still earn their place and leaving the rest behind. What survives every
> rebuild is not an architecture but a habit, the habit of turning a lesson
> into a rule and a rule into infrastructure.

It traces four such rebuilds, which it calls *metamorphoses*. It is also
careful about its evidence. The spine of the narrative comes from the
maintainer, and the dates and commit SHAs come from the repository. "Where the
evidence is thin, this document says so rather than inventing the detail."
This chapter does the same.

### Stage one: genesis, the shepherd

**What it was.** The garden's first capability was narrow: "drive a single
pull request's continuous-integration run back to green." The agent that did
this was the **shepherd**, and it predates the garden's repository. It first
appeared in an earlier garden built for the `endojs/endo-but-for-bots`
project, which already described the shepherd in one line as "keep CI healthy
across many in-flight PRs." The current repository's record of the shepherd
begins with the import of that earlier garden as a read-only reference shelf
on 2026-05-12 (`c68a23c8`, recorded against the predecessor's commit
`cc79140a6`). The shepherd and conductor roles were ported into the active
library a day later (`83b03907`, 2026-05-13). The repository itself was
created by `garden: initial scaffold` (`741e1519`, 2026-05-12).

**What it established.** The pattern that every later role follows was
already present:

> a focused agent that reads a red CI run, makes a surgical fix, pushes, and
> waits for green. Everything the garden became afterward is, in one sense,
> the scaffolding built to dispatch agents like this one reliably and at
> scale.

**Why it could not stay that way.** A shepherd that a person starts by hand is
a tool. Letting it act on GitHub by itself raises a safety question that the
first stage did not address.

### Stage two: containment, a container and a bot

**What changed.** The second metamorphosis put the garden in a container and
gave it an identity separate from the maintainer's.

- **The container.** On 2026-05-13 the garden gained a Dockerfile, an
  entrypoint, and the `garden` launcher script (`bdac01f7`). The launcher
  bind-mounts the host's garden directory into the container and pins the
  container's hostname, so each instance has a stable logical identity. In
  the same week, each subagent started running in its own worktree triple
  that was torn down afterwards (`2f434611`), so no subagent could modify the
  orchestrator's checkout.
- **The bot.** Routine work runs under a bot GitHub account (`kriscendobot`
  by default) and never under the maintainer's own account. The maintainer's
  identity is used for exactly one act, carrying finished work upstream. That
  act belongs to the **boatman** role, which was present in the initial
  scaffold (`efb2da2a`) and is gated by an `identity_switch_authorized` flag,
  "so the bot identity can never silently push as the maintainer."

**Why it was necessary.** `HISTORY.md` records the reason as a standing rule,
the **monitoring-safety constraint**. Standing monitors feed comment text and
pull-request bodies into a model's context, "so only repositories whose
comments and pull requests are gated against untrusted contributors are safe
to monitor; anything else is a prompt-injection hazard." A companion
**external-repo etiquette** rule (`362887fe`, 2026-05-12) forbids any
cross-repository comment, reaction, or cross-link unless the maintainer has
explicitly authorized it. Together these rules led to a lasting preference:
do the work on the garden's own forks, where the bot can push and the comment
surface is controlled, and send it upstream only through the boatman.

The division of authority that still frames the garden also dates from this
stage: the user-facing **liaison**, which holds broad authority and asks
before it acts, and an autonomous **steward**, which had narrower authority
inside the bot's sandbox (`b28dabe7`, 2026-05-12).

**What survives today.** All of it. The `./garden` launcher, the bot identity,
the boatman, and the monitoring-safety constraint are still in force.
`CLAUDE.md` adds a *container guard* (`scripts/check-in-container.sh`), which
the liaison runs before anything else in every session. Inside and outside the
container the files look identical, so it is easy to operate on the host by
mistake, where commands run under the maintainer's identity. The ferry has
also moved further outside the fleet. It is now a dedicated script that the
maintainer runs on a credentialed host outside the container, and the
ordinary job board rejects it mechanically.

### Stage three: supervision, many sessions on an always-online host

**What changed.** With a safe container and a safe identity, the garden could
run several things at once and keep running without a person present. The
third metamorphosis was about operating the garden continuously: "keeping
multiple Claude sessions alive, supervised, on a server that never goes
offline."

**What the record can and cannot show.** `HISTORY.md` is explicit about the
limits of its evidence here:

> **There is no commit, design doc, or journal entry in this tree that names
> `tmux` as the supervisor.** The maintainer's account of the arc places a
> phase of multiple Claude sessions supervised under tmux on an always-online
> server here, and that account is the authority for it; the repository
> corroborates the *shape* of that phase without naming the tool.

The repository does show a system designed from the start for concurrent,
independently supervised sessions that share state only through the journal.
The v1 design allowed several liaison and steward instances to run on
different hosts because "they communicate exclusively through the journal as a
message bus; no host has authoritative state the other lacks." The journal was
built as a cross-machine index keyed by host name (`f18dc344`, `edae9c2e`,
2026-05-12), which matters only when several hosts are running at once.

The clearest evidence of automated supervision is the **driver** container,
which the history calls "the bridge into the next stage." It was "a driver
container that runs systemd as PID 1 and manages the garden's per-lane driver
and per-feed watcher units." Instead of a person keeping several terminals
open, systemd kept several work lanes running, restarted them when they
failed, and let the maintainer change their number by hand ("I will manually
scale the pool of concurrent drivers").

**Why it could not stay that way.** Through v1, a language model sat on top
of the workflow. The steward and a companion *general-contractor* woke on a
timer, ran a model to read the state of the world, and dispatched subagents.
Every decision cost a model call, including routine decisions a short script
could have made, and the orchestrating agent's context accumulated details of
every job it touched. Supervision under systemd kept the sessions running,
but each session still held the whole workflow in its head.

### Stage four: automation between two layers of cognition

**What changed.** The fourth metamorphosis reversed the relationship between
the model and the workflow:

> Through v1, an agent sat *on top* ... The fourth metamorphosis puts a
> **script in the middle**, with cognition on either side of it: an outer
> layer that improves the machine, and an inner layer that does the work, with
> deterministic automation sandwiched between them.

The driver design doc (created 2026-05-29) described the change before it was
built, as a move from **claude-on-top** to **claude-under-script**
orchestration:

> a pool of bash worker scripts watches a generic job inbox, claims jobs
> deterministically, and runs a state machine that invokes claude only when
> judgment is needed.

It also stated the principle: "The script's loop is the orchestrator; the LLM
is the worker the script calls when it cannot decide deterministically." On
2026-06-03 the maintainer retired the general-contractor ("I have dismantled
the contractor ... I would like to reconstruct it on the driver") and rebuilt
its design-queue walk as a deterministic service.

**A fresh start, not an edit.** The new architecture was not reached by
editing v1. On 2026-06-24 `main2` was created as an **orphan branch with no
common ancestor with `main`** (`acb97c7f`), and `journal2` was seeded the same
day (`63816e45`). The migration was framed as "translation, not blind copy."
Every juror seat on the review panels was carried over verbatim. The judicial
roles were rewritten as a scripted panel-and-fixer loop. The steward and the
general-contractor were left behind.

**The three bands.** `HISTORY.md` describes the result as three layers:

- **The inner work layer** is the gardener fleet. Each gardener is a bash
  worker that claims a job and *supervises* a state-machine script instead of
  following a checklist itself. The script "shells out to `claude -p`
  subagents only for *decisions* (how to proceed, whether to loop)" and is
  written to "write essentially nothing when it is working well," which
  protects the supervising agent's context.
- **The coordination substrate** is the job board and message bus on
  `journal2`, with no separate lock service: "The real serialization point is
  the `git push` to `origin/journal2`, accepted only as a fast-forward, first
  pusher wins ... That rejection *is* the compare-and-swap." (A
  compare-and-swap is an atomic operation that succeeds only if the state has
  not changed since it was read.)
- **The outer self-improvement layer** makes the whole system self-healing.
  The **mentor** reads the journal looking for "ways to make scripted
  automation more reliable, or to move a responsibility off an agent into a
  script where it runs more reliably," and posts improvement jobs. Its role
  file states: "The garden's self-healing comes from this loop." The
  **watchman** watches `main2` itself and tells running agents how their roles
  and skills have just changed.

**Why it was necessary.** Stage three kept sessions alive but paid for a model
call at every step and gave each orchestrator an ever-growing context. Stage
four moves every decision that can be made deterministically into a script,
which is cheaper, reproducible, and uses no context. The model is called only
at the points that need judgment. The same move repeats inside the fleet
continuously: the mentor's standing bias is to move judgment out of agents and
into scripts. The README describes the resulting posture as "automation is
silent until an error, and every error feeds a loop that makes the automation
better."

## 1.4 Where the garden stands now

`HISTORY.md` was written on 2026-06-24, the day of the fourth rebuild, and
says of itself that the garden "is mid-metamorphosis even as this history is
written." At that time the judicial workflow was only a proposal, many v1
skills were marked "to be migrated," and the driver design that named the
claude-under-script pivot was still formally *Proposed*.

In the three months since, much of that shape has been built. `CLAUDE.md` now
describes a garden that is still recognizably stage four, with several
additions:

- **A scripted review gauntlet.** The panel (`skills/panel/SKILL.md`) sends a
  pull request to about forty specialized *juror* seats. Its findings feed a
  fixer loop, and the pull request is taken out of draft only at the end.
  Successful build jobs start this gauntlet automatically.
- **Several kinds of workers and model tiers.** Monks (Anthropic models) and
  clerics (OpenAI models) share one factored worker spine. Each job carries a
  *tier*, which says how much model capability it deserves: **mentat**,
  **mentor**, **minion**, or **myrmidon**. Automatic work never goes above
  mentor, and mentat work is posted only by hand.
- **Leader and follower hosts.** Several hosts share one journal. Gardeners
  run on every host and compete safely for claims. Singleton services such as
  the foreman, the scheduler, and the watchers run only on the host named in
  the journal's `leader` file. A deterministic per-host **sysop** daemon runs
  a closed set of host operations delivered over the bus, so a host with
  nobody at it can still be throttled or drained.
- **Deliberate deployment.** The root checkout is a *deployed version* and is
  no longer a working tree. It advances only through a drained, rolling
  deployment that updates follower hosts first, as canaries, and the leader
  last, and it never advances past a failed canary.
- **Orchestration jobs.** Multi-part work is split into parked child jobs
  plus one orchestration job. A deterministic watcher releases the children in
  order and stops to alert the maintainer on failure, so a failure does not
  cause a silent stall. This book is produced that way: each chapter is a
  child of the orchestration `garden-book-orch`.
- **Pool sizing tied to budget.** The fourth stage imagined "around 100"
  gardeners per host, most of them idle. Today the declared capacity of each
  host is "reconciled against backend health and budget limits," and the
  guidance is explicitly "not a fixed twenty-worker starting target."

Each of these additions follows the stage-four pattern: a responsibility that
used to depend on an agent's judgment or on a person's attention becomes a
script, a journal record, or a systemd unit. The README summarizes the
current shape as "deterministic scripts between two layers of cognition."

## 1.5 The next metamorphosis: the bidding market

The README names the next stage in its section "The bidding market: the next
metamorphosis":

> [`HISTORY.md`](HISTORY.md) traces four metamorphoses — shepherd, container,
> supervision, and the current shape: deterministic scripts between two layers
> of cognition. The fifth is designed and tracking
> ([#15](https://github.com/kriskowal/garden/issues/15)): replace the
> first-to-claim race with a **bid/accept market**.

**What is wrong with the race.** Today any eligible gardener can claim any job,
and the first push wins. This is simple, needs no lock, and cannot lose a
job. However, it ignores fit. A job goes to whichever worker was fastest,
not to the one whose role, skills, and model are best suited to it, and the
garden learns nothing from the outcome about who should have received it.

**What replaces it.** In the README's description:

> Workers become **differentiated** (by role, skill mix, and model tier) and
> **reputation-bearing**: effectiveness is controlled by the acceptance gate,
> so cost — normalized to dollars and duration — is the free variable a
> reputation ledger scores. A broker awards jobs to bids; a Thompson-sampling
> bandit explores new roles and models while exploiting known winners; a role
> refiner mints new bidders and a consolidator caps the roster.

The central idea comes from a maintainer directive recorded in
[`designs/gardener-bid-accept-market.md`][bid-design]: "We control for
effectiveness with the acceptance criterion, so the cost is a free variable."
Every accepted piece of work has, by definition, met the bar. The ledger
therefore does not need to score quality directly. It scores how much each
combination of role, model, and tier cost in dollars and time to produce
accepted work. *Thompson sampling* is a standard way to balance exploring
unproven combinations against exploiting proven ones: it draws from each
option's estimated distribution and picks the best draw.

**Continuity with today.** The design notes that the garden is already a
simple, degenerate version of such a market. The job board is the bounty
board, `claim-job.sh` is the award, the review panel is the oracle that
attests delivery, and the journal holds a reputation record that nobody has
scored yet. "Every new mechanism below reduces, when the bid phase is empty
and the broker is 'first bid wins,' to exactly today's behavior." That is why
the rollout can be phased without breaking anything. A job opts in with
`market: bid` in its frontmatter; every other job is claimed by the unchanged
race; and "both modes are permanent; the market is the generalization, not a
deprecation of the race."

**How far it has come.** The README calls the fifth stage "designed and
tracking," but the working tree shows it partly built. A later design,
[`designs/cleric-worker-bid-auction-reputation.md`][cleric-design], turned the
market into a *decentralized* auction with no central auctioneer. Every
worker computes the same award order from the journal, and the push
compare-and-swap is still the only point of serialization. It also redefined
reputation as "merge-worthiness achieved per aggregate dollar (human +
agentic)." The [`bid-auction`][bid-skill] skill describes machinery that
already exists: bids in `claim-job.sh` that involve no model call, reputation
events written by `complete-job.sh`, and a `garden-reputation-reducer` service
that maintains per-arm projections under `reputation/`. (An *arm* is one
combination of provider, model, and tier being scored.) The auction is still
opt-in, and on some hosts it is temporarily routed back to the plain race
because of quota constraints. The fifth metamorphosis has therefore begun but
has not replaced the stage-four shape. The race remains the default, and the
market is growing alongside it.

The bid-market design also sketches further directions without specifying
them: gardeners subcontracting to other gardeners, and a "meta-machine" in
which whole gardens compete. Both are listed as future work.

## 1.6 What to carry forward

A few points from this history explain most of the rest of the book:

- **Rules are recorded as infrastructure.** When the garden hits a problem, it
  first writes the lesson down as a rule, then turns the rule into a script or
  a gate. Examples include the monitoring-safety constraint, the container
  guard, and the root-repository guard. When something in the garden seems
  over-engineered, a past incident is usually recorded next to it.
- **Scripts orchestrate and models decide.** If you are adding a feature, the
  default assumption is that it belongs in a deterministic script that calls a
  model only at a real decision point, not in an agent's prompt.
- **Git is the coordination layer.** The job board, the message bus, the
  plan, and eventually the reputation ledger are all files on an orphan
  branch, serialized by fast-forward pushes. There is nothing else to back up
  or keep consistent.
- **The maintainer's identity and attention are scarce.** The bot does the
  routine work, the ferry is the only path upstream, the proxy answers routine
  questions, and the human keeps the weeding.
- **Every stage keeps its predecessor as a special case.** The shepherd still
  exists as a role. The container still exists. The race will still exist
  inside the market. Each metamorphosis has generalized the previous one
  rather than deleting it.

Chapter 2 explains how stage four runs in practice: the board, the job
lifecycle, the bus, and the services around them.

[readme]: https://github.com/kriscendobot/garden/blob/main2/README.md
[claude-md]: https://github.com/kriscendobot/garden/blob/main2/CLAUDE.md
[history]: https://github.com/kriscendobot/garden/blob/main2/HISTORY.md
[bid-design]: https://github.com/kriscendobot/garden/blob/main2/designs/gardener-bid-accept-market.md
[cleric-design]: https://github.com/kriscendobot/garden/blob/main2/designs/cleric-worker-bid-auction-reputation.md
[bid-skill]: https://github.com/kriscendobot/garden/blob/main2/skills/bid-auction/SKILL.md
