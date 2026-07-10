---
title: Self-evocation orchestrator architecture
source: README.md
source_repo: jcorbin.tngl.sh/unum
source_commit: 39d7e59678bccc0439078561a4ef0d1b1b5b6538
source_date: 2026-06-29
source_authors: [jcorbin]
ingested: 2026-07-10
ingested_by: scholar
topics: [agent-fleet-orchestration]
status: current
---

## Abstract

**unum** is a task-queue automation monorepo for AI coding agents: "evoke agents
to work on tasks, one at a time, as managed systemd services." It is a
sibling-implementation to the garden and to OpenAI's Symphony — a third
independent convergent design for the same problem (a fleet of AI coding-agent
invocations driven off a shared work board, run continuously as system services,
with humans reviewing results rather than supervising sessions). It develops
itself: the same evoker system that runs tasks is what builds the repo
(self-evocation). This section maps unum's architecture and names the parallels
to and divergences from the garden's job system, so a reader can locate unum's
subsystems against the ones they already know.

## The board (file-backed, not a database)

unum's control plane is a set of top-level directories, each a lane of the task
lifecycle — the direct analogue of the garden's `journal2` job board:

| unum | Purpose | Garden analogue |
|------|---------|-----------------|
| `TODO/` | pending tasks | `jobs/todo/` |
| `TOQU/` | open operator-decision questions | maintainer inbox / plan queue |
| `TADA/` | completed-task archive (with cost stanza) | `jobs/tada/` |
| `PLAN/` | planning documents | `designs/` |
| `LORE/` | distilled lessons / incident post-mortems | `designs/` + skill notes |
| `STANDARDS/` | shared conventions (Go, Bash, ops, monorepo) | `roles/COMMON.md`, house-style skills |
| `evoke/` | agent config: personas, channel config, runtime state | `roles/` + `evoke`-style config |

A task is a Markdown file whose YAML frontmatter carries its lifecycle state
(`status`, `session_id`, `session_model`, `reentry_count`, `last_situation`,
`last_indicator`, …). Moving the file between lanes *is* the state transition —
the same "the board is the state machine" move the garden makes with its job
directories and Symphony makes with a Linear board.

## The engine (`devoker`, one Go binary, four subsystems)

- **Invoker** — claims a task from `TODO/`, runs the agent (a headless
  `claude`-CLI evocation), archives the result to `TADA/`. The garden's gardener
  claiming a job and running it in a per-job worktree.
- **Televoke** — the Telegram bot control plane: the operator's interface,
  hosting the `steward`, `liaison`, and `foreman` **personas** that manage the
  backlog and report status. The garden splits these across the liaison (human
  relay), foreman (board-idle pump), and gardener roles.
- **Vigil** — a proactive monitor on a ~5-minute systemd `oneshot` timer:
  watches for idle invokers with pending work, stale dead-claims, and killswitch
  conditions, and kicks the invoker when needed. The garden's watchers +
  reaper + foreman-when-idle. Vigil's verified-quiet health signal is also the
  substrate for the [[vigil-charge]] initiative budget.
- **Refinery** — a branch-merge pipeline that integrates task branches into the
  realm and re-parents channel substance. The garden's weaver/conductor merge
  path.

Personas run as **systemd one-shot services**; each evocation is a fresh
process, so all cross-invocation state (claims, cost ledger, vigil charge) must
be persisted to disk rather than held in memory — a recurring design constraint
throughout unum (see the oneshot note in [[vigil-charge]]).

## Divergences worth noting

- **Central vs. decentralized claim.** unum has a single invoker/vigil per realm
  coordinating one host's lane; the garden has **no central authority** —
  gardeners on every host race to claim via a git-push compare-and-swap, and the
  accepted push is the serialization point. unum's coordination is more like
  Symphony's single authoritative orchestrator.
- **Telegram as the operator surface.** unum's control plane is a chat bot with
  named personas; the garden's is the liaison in a terminal plus a GitHub
  issue/@-mention inbox. Both reduce the human's job to *steering + review*.
- **A built cost ledger.** unum's most transferable single artifact is its
  per-run token/compute cost ledger — see [[cost-ledger]] and the
  [token-cost-ledger section](./unum--token-cost-ledger.md).

Read this against the garden as an independent convergent design (as the
[`agent-fleet-orchestration`](../topics/agent-fleet-orchestration.md) topic frames
Symphony): the claim to draw is convergence under the same pressure — human
attention is the bottleneck — not shared lineage.

Source: [`README.md`](https://tangled.org/jcorbin.tngl.sh/unum) at commit `39d7e59` (with `devoker/DESIGN.md` / `devoker/README.md`), unum on tangled.org.
