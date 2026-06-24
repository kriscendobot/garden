---
created: 2026-06-24
updated: 2026-06-24
author: journalist
---

# A history of the garden

The garden has never held still. It is a system that keeps re-architecting
itself: each time a way of working hits a ceiling, the maintainer and the agents
tear out the coordinating layer and rebuild it, carrying the parts that still
earn their place and leaving the rest behind. What survives every rebuild is not
an architecture but a habit, the habit of turning a lesson into a rule and a rule
into infrastructure.

This document traces four metamorphoses. The spine of the arc comes from the
maintainer; the dates, commit SHAs, and architectural detail are grounded in the
repository's own history across the `main`, `main2`, `journal-v1`, and `journal2`
branches, the archived v1 corpus (the `v1/` tree preserved on the `main` branch),
the [reference shelf](references/), and the [design corpus](designs/). Where the
evidence is thin, this document says so rather than inventing the detail.

## Stage one: genesis, the shepherd

The garden's first capability was narrow and concrete: drive a single pull
request's continuous-integration run back to green. That capability arrived as a
**shepherd**, and it predates this repository.

The shepherd was born in an earlier garden, the one built for the
`endojs/endo-but-for-bots` project and kept on that repo's `garden` branch. The
garden imported a snapshot of it as a read-only reference shelf on 2026-05-12,
recording its provenance precisely: branch `garden`, commit `cc79140a6`, dated
2026-05-11 (see [`references/endo-but-for-bots/README.md`](references/endo-but-for-bots/README.md)).
That predecessor garden already described the shepherd in one line, "keep CI
healthy across many in-flight PRs," alongside the other roles this garden would
inherit (fixer, weaver, conductor, steward, and the watchman functions). So the
genesis capability is attested by the artifact it left behind, not by a first
commit in this tree: the literal first-ever shepherd skill lived in the
`endo-but-for-bots` garden, and this repository's own record of it begins with
the reference-shelf import (`c68a23c8`, 2026-05-12) and the port of the shepherd
and conductor roles into the active library a day later (`83b03907`,
2026-05-13).

The shape of the idea was already settled by then: a focused agent that reads a
red CI run, makes a surgical fix, pushes, and waits for green. Everything the
garden became afterward is, in one sense, the scaffolding built to dispatch
agents like this one reliably and at scale.

**Approximate range:** the capability predates 2026-05-11 in the predecessor
garden; it enters this repository's history on 2026-05-12 through 2026-05-13.
**Key artifacts:** [`references/endo-but-for-bots/`](references/endo-but-for-bots/),
the ported `shepherd` and `conductor` roles, and the `garden: initial scaffold`
commit (`741e1519`, 2026-05-12) that opened the repository.

## Stage two: containment, a container and a bot

A shepherd that drives CI to green is useful, but turning it loose to act on
GitHub on its own raises an obvious question: what can it reach if something goes
wrong, or if an outside contributor feeds it hostile text? The second
metamorphosis answered that question by putting the garden inside a box and
giving it an identity that is not the maintainer's.

The box arrived first. On 2026-05-13 the garden gained a Dockerfile, an
entrypoint, and a `garden` launcher script (`bdac01f7`, "container: Dockerfile,
entrypoint, garden launcher"). The launcher creates and enters a container,
bind-mounts the host's garden directory to the container's home, and pins the
container's hostname to its name so each instance has a stable logical identity.
The same week the garden hardened its internal isolation: every dispatched
subagent began running in a per-dispatch worktree triple, detached and torn down
on return (`2f434611`, 2026-05-13), so no subagent could mutate the orchestrator's
own checkout.

The identity arrived alongside it. Routine work runs under a bot account,
`kriscendobot` by default (and `endolinbot` on this host), never the maintainer's
own GitHub identity. The maintainer's identity is reserved for one act: carrying
finished work upstream. That act is the **boatman**, a role added in the
scaffold itself (`efb2da2a`, "boatman: ferries completed PRs from garden forks to
upstream governance," 2026-05-12), gated on an explicit `identity_switch_authorized`
flag so the bot identity can never silently push as the maintainer.

The reason for the box and the bot is recorded as a standing rule, not a passing
note. The **monitoring-safety constraint** (`CLAUDE.md` and
[`roles/COMMON.md`](roles/COMMON.md) both carry it) states that standing monitors
feed comment text and pull-request bodies into the model's context on every wake,
so only repositories whose comments and pull requests are gated against untrusted
contributors are safe to monitor; anything else is a prompt-injection hazard. As
of 2026-05-13 only `endojs/endo-but-for-bots` met that bar. The garden recorded a
companion **external-repo etiquette** rule the day before (`362887fe`, 2026-05-12):
no cross-repo comment, reactji, or cross-link without an explicit maintainer
authorization carried into the job.

Together these pushed the garden toward a durable preference: work on the
garden's **own forks** of other repositories, where the bot has direct push
rights and the comment surface is controlled, and ferry the result upstream only
through the boatman under a one-time authorization. The split-authority posture
that frames this stage, the user-facing **liaison** with excess authority that
asks before acting, and the autonomous **steward** with bounded authority in the
bot sandbox, also dates here (`b28dabe7`, "steward: autonomous bot-sandbox
counterpart to the liaison," 2026-05-12).

**Approximate range:** 2026-05-12 through 2026-05-13, hardening across the v1 era.
**Key artifacts:** the `garden` launcher and Dockerfile, the `boatman` role, the
per-dispatch worktree triple, and the monitoring-safety and external-repo
etiquette rules in [`CLAUDE.md`](CLAUDE.md) and [`roles/COMMON.md`](roles/COMMON.md).

## Stage three: supervision, many sessions on an always-online host

With a safe box and a safe identity, the garden could run more than one thing at
once. The third metamorphosis was about *operating* the garden continuously:
keeping multiple Claude sessions alive, supervised, on a server that never goes
offline, so the garden could make progress while no human watched.

This is the stage the repository attests least directly, and honesty requires
flagging it. **There is no commit, design doc, or journal entry in this tree that
names `tmux` as the supervisor.** The maintainer's account of the arc places a
phase of multiple Claude sessions supervised under tmux on an always-online
server here, and that account is the authority for it; the repository corroborates
the *shape* of that phase without naming the tool.

What the repository does attest is a system explicitly built to run as many
concurrent, independently-supervised sessions that coordinate only through shared
state. The v1 design records that multiple liaison and steward instances can run
at once across hosts (one in a Docker container, one on a laptop) precisely
because "they communicate exclusively through the journal as a message bus; no
host has authoritative state the other lacks" (see `v1/README.md`, preserved on
the `main` branch). The journal worktree was built from the start as a cross-machine index keyed by
each host's logical name (`f18dc344` and `edae9c2e`, 2026-05-12), which only
matters if several hosts are live at the same time.

The strongest committed evidence of *automated* supervision is the **driver**
container, the bridge into the next stage. The `v1/driver` script (preserved on
the `main` branch) describes "a driver container that runs systemd as PID 1 and
manages the garden's
per-lane driver and per-feed watcher units." That is the engineered successor to
hand-supervised sessions: instead of a person holding several terminals open,
systemd holds several lanes open, restarts them on failure, and lets the
maintainer scale the count by hand. The maintainer's disposition on that point is
quoted in [`designs/driver.md`](designs/driver.md): "I will manually scale the
pool of concurrent drivers."

So this stage is real and load-bearing in the arc, but its earliest, most
manual form (tmux on a server) lives in the maintainer's memory and in
operational practice rather than in the committed record. Treat the tmux detail
as maintainer-attested; treat the concurrent-instances design and the
systemd-supervised driver container as the repository's corroborating evidence.

**Approximate range:** through the v1 era (2026-05-12 to 2026-06-24), with the
driver container formalizing supervision from late May onward.
**Key artifacts:** the journal-as-message-bus and cross-host index, the
two-orchestrator (liaison and steward) posture, and the `v1/driver` systemd
container preserved on the `main` branch.

## Stage four: metamorphosis, automation between two layers of cognition

The most recent rebuild inverts the relationship between the language model and
the workflow. Through v1, an agent sat *on top*: the steward and the
general-contractor woke on a cron, ran a model tick to read the world, and
dispatched subagents through the `Agent` tool. The fourth metamorphosis puts a
**script in the middle**, with cognition on either side of it: an outer layer
that improves the machine, and an inner layer that does the work, with
deterministic automation sandwiched between them.

The pivot was articulated before it was built. The driver design
([`designs/driver.md`](designs/driver.md), created 2026-05-29) names the move
exactly: from **claude-on-top** orchestration to **claude-under-script**
orchestration, "a pool of bash worker scripts watches a generic job inbox, claims
jobs deterministically, and runs a state machine that invokes claude only when
judgment is needed." The principle is stated plainly: "The script's loop is the
orchestrator; the LLM is the worker the script calls when it cannot decide
deterministically." Along the way the old slot-machinery role was dismantled: on
2026-06-03 the maintainer retired the general-contractor ("I have dismantled the
contractor ... I would like to reconstruct it on the driver"), reconstructing its
design-queue walk as a deterministic `garden-design-poller` service.

The realized form of the pivot landed on 2026-06-24 as a fresh start. `main2` is
an **orphan branch with no common ancestor with `main`** (confirmed: `git
merge-base main main2` reports none), established that day by `acb97c7f`,
"Establish main2 as the garden v2 development branch." Its companion `journal2`
was seeded the same day (`63816e45`). The v1 line on `main` was pruned to what had
already migrated (`bbea983c`, "Prune v1 material already migrated into v2"). The
maintainer's framing of why is in [`designs/v1-migration-manifest.md`](designs/v1-migration-manifest.md):
the migration is "translation, not blind copy," carrying every juror seat
verbatim, translating the judicial roles into a scripted panel-then-fixer loop,
and leaving the steward and general-contractor behind.

The new architecture has three bands.

The **inner work layer** is the gardener fleet. A host runs a large pool of
gardeners (around 100, most cheaply idle-blocked waiting on messages), each a
bash worker that claims a job and *supervises* a state-machine script rather than
walking a checklist itself. [`designs/gardening-state-machine.md`](designs/gardening-state-machine.md)
is the clearest statement of the sandwich: it keeps the same PR workflow as v1 but
moves the state machine "into a shell script that a gardener supervises," and the
script "shells out to `claude -p` subagents only for *decisions* (how to proceed,
whether to loop)." The script is built to "write essentially nothing when it is
working well," protecting the supervising agent's context. The model is invoked,
deliberately, only at the joints.

The **coordination substrate** is the job board and message bus.
[`designs/job-board.md`](designs/job-board.md) describes a git-backed board on the
`journal2` branch where producers post and consumer gardeners race to claim, with
no separate lock service: "The real serialization point is the `git push` to
`origin/journal2`, accepted only as a fast-forward, first pusher wins ... That
rejection *is* the compare-and-swap." A rejected claim backs off to another job
rather than blind-retrying.

The **outer self-improvement layer** is what makes the whole thing self-healing.
The **mentor** role ([`roles/mentor/AGENT.md`](roles/mentor/AGENT.md)) watches the
journal for "ways to make scripted automation more reliable, or to move a
responsibility off an agent into a script where it runs more reliably," and emits
improvement jobs for gardeners to implement; its role file states the thesis
directly: "The garden's self-healing comes from this loop." The **watchman**
([`roles/watchman/AGENT.md`](roles/watchman/AGENT.md)) watches the `main2` branch
itself and broadcasts to running agents how their roles and skills just evolved.
Above the work, the garden watches and rewrites the work; below it, the script
runs the work and calls cognition only when it must. The mentor and watchman are
the outer band of cognition; the gardener fleet is the inner band; the
state-machine scripts and the git-backed board are the automation between them.

**Approximate range:** designed from 2026-05-29 (the driver pivot), realized
2026-06-24 with the orphan `main2` and `journal2` branches.
**Key artifacts:** [`designs/driver.md`](designs/driver.md),
[`designs/gardening-state-machine.md`](designs/gardening-state-machine.md),
[`designs/job-board.md`](designs/job-board.md),
[`designs/v1-migration-manifest.md`](designs/v1-migration-manifest.md), the
gardener / mentor / watchman / triager roles, and the `journal2` board.

## Where it stands, and what is still in flight

The garden today is the stage-four shape: a fleet of gardeners claiming jobs off
a git-backed board, each supervising a deterministic state machine that consults
a language model only at decision points, with a mentor-and-watchman layer above
that rewrites the machine as it learns. The journal is no longer just a
transcript; it is the message bus and the compare-and-swap lock all at once.

Several things are still in motion. The v1-to-v2 migration is explicitly **in
progress**: the migration manifest is a live reconnaissance document, the
judicial workflow ([`designs/judicial-workflow.md`](designs/judicial-workflow.md),
created 2026-06-24) is still *Proposed* rather than implemented, and a number of
v1 skills are marked "to be migrated." The driver design that named the
claude-under-script pivot remains formally *Proposed* even though its core idea is
now realized in the gardener fleet, a sign that the documentation is still
catching up to the running system. And the freshest commits on `main2` are still
filling seams the rebuild opened: a continuous journalist bulletin loop, an
idle-pump foreman that posts the next milestone step when the board drains, and a
garden-proxy watcher that stands in for an absent maintainer on gating questions
(`f20a4ca7`, `9145aa20`, `cf1574cf`). The garden, true to form, is mid-metamorphosis
even as this history is written.
