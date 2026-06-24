---
created: 2026-05-12
updated: 2026-06-24
author: gardener, liaison
---

# Role: monitor (re-homed onto triager + watchman)

In v1 the `monitor` watched one GitHub repository's activity feed (a long-lived `bash` poll daemon plus an LLM that woke on `NEW` lines) and reported meaningful changes back to the coordinator. That function splits in v2 across the two standing producer roles:

- [triager](../triager/AGENT.md) — the per-repo PR-comment watch. The monitor's "watch a repo, react to events" surface becomes the triager's deterministic directive→job mapping. A triager runs as `garden-triager@<slug>` on a timer, one per watched repo, and posts jobs for gardeners rather than waking an LLM to compose a reaction by hand.
- [watchman](../watchman/AGENT.md) — the garden-library evolution watch. The monitor's "surface a change the coordinator needs to know about" surface, applied to the garden's own `main2` branch, becomes the watchman's role/skill-evolution broadcast.

This file is retained so references to `roles/monitor/` resolve to the two successor roles. There is no separately dispatched monitor agent in v2; the watch surfaces are standing timer-driven services.

## What carried, and where

| v1 monitor concern | v2 home |
|---|---|
| poll a repo's activity, surface meaningful events | triager (PR-comment watch) |
| react to a directive on a PR | triager's deterministic directive→job mapping |
| one repo per dispatch | one triager unit per repo slug (`repos/` watch set) |
| last-seen / ETag state surviving across ticks | standing markers under `GARDEN_STATE` (never a reset-prone worktree) |
| surface garden-side evolution to running agents | watchman (`main2` broadcast on the message bus) |

The per-repo reaction rules that v1 carried as `skills/monitor-<slug>/SKILL.md` are re-authored as triager handler configuration; they are not carried as standalone skills.

## Monitoring-safety constraint (carries unchanged)

Both successor surfaces feed external text (PR/comment bodies, event payloads) into `claude -p`, so the watch set is gated to repositories whose comments and pull requests are gated against untrusted contributors. As of the v1 cutover only the garden's own forks and `endojs/endo-but-for-bots` meet this bar. Widening the watch set (`journal/repos/`) to a new repo requires explicit maintainer authorization recorded on the bus; this is a standing constraint, not a one-time decision. See `roles/COMMON.md` § Monitoring safety constraint and the triager's own *Monitoring safety* norm.
