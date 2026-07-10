---
title: Operations standards for a self-editing monorepo — safety, staging, and lesson discipline
source: STANDARDS/operations.md
source_repo: jcorbin.tngl.sh/unum
source_commit: 339d53e230eccf14751af5dfce609e0e6bd81df9
source_date: 2026-06-20
source_authors: [jcorbin]
ingested: 2026-07-10
ingested_by: scholar
topics: [repository-governance, agent-conventions]
status: current
notes: |
  unum's cross-project operational/systems standards — the house-style rules that
  govern a self-editing agent monorepo. Focused on the transferable safety, staging,
  config, and lesson-capture conventions; the Go/bash idiom files are not ingested
  (unum-specific style, low cross-cutting value).
---

## Abstract

`STANDARDS/operations.md` is unum's cross-project **operational house style** — the platform, safety,
config, and workflow conventions every project in the monorepo shares. It is the *how-to-operate* sibling
of `STANDARDS/{bash,golang,monorepo}.md` (how-to-code) and of `LORE/` (why). Its transferable content is a
compact set of rules for running a **self-editing agent system safely**: the safety invariants that keep the
evocation loop from bricking itself, the "don't stage on production" discipline, the config-resolution order,
and the `lesson:`/`LORE/` capture pipeline the [LORE corpus section](./unum--lore-corpus-shape.md) consumes.

## Safety — this monorepo drives the agent that edits it

The governing frame: *this monorepo contains meta-systems — software that drives the agent which edits it.*
The rules follow from it:

- **Never break the evocation loop** — a broken harness cannot self-repair.
- **Validate all config before starting operations.**
- **Prefer failing loudly over silent corruption** (the runtime form of the log-and-swallow lesson).
- **The killswitch (`evoke/NOPE`) must always be checked and always work.**
- **Test changes to core scripts and binaries carefully before committing.**

## Don't stage on production

> A production flip/deploy must never be the *first* time a change's real behavior is exercised.

Validate any live-evocation-path or flag-gated change in a **staging E2E** — a real instance in an isolated
harness (for unum, the podman/QEMU staging runner) — *before* enabling it on a production worker. If a
behavior is hard to trigger on demand (it only fires on some state change), **build a deterministic forcing
hook in the staging test** rather than waiting for it to occur in the wild. The lesson behind the rule: a flag
flipped on the live worker once dirtied the harness's own workspace — trivially catchable in staging; the
tooling existed, the discipline didn't. (The garden's own analogue is the drained, deliberate
`deploy-garden.sh` and the rule that the root checkout is a *deployed* version, never a development tree.)

## Host capability source-of-truth, not re-guessing

A recurring waste is an agent re-discovering (or guessing away) a host capability a prior session already
established, then parking a task that was actually runnable. unum's fix: the vigil tick re-probes host
capabilities (podman / qemu / `/dev/kvm` / toolchain) every firing and writes a timestamped manifest to
`evoke/HOST.md` — **that file, not prose, is the authoritative always-fresh record**, injected into a resuming
agent's reentry context, with a health rubric that flags a missing/stale (>24h) manifest and auto-fixes by
re-probing. The rule: **read the manifest (or re-probe) before declaring a prerequisite unknown**; a stale
manifest means the health monitor isn't running — fix *that* rather than guessing.

## Config, logging, notifications

- **Config resolution order** (highest first): CLI flags → project-prefixed env vars (`DEVOKER_*`) →
  config files → compiled-in defaults. Populate a single config struct **once** and pass it to subsystems;
  **no global mutable config.**
- **Logging**: include operation context (`"next: found task %s"`); log at boundaries (start/end of major
  ops, external dispatch, lifecycle events); **no logging in library packages** — return errors and let the
  entrypoint decide what to log.
- **Notifications**: dispatch through wrapper functions, never call the notification script directly;
  standard fields `time`/`message`/`sender`/`status`; status lifecycle `running → done | next | error`.

## The lesson-capture pipeline

The standards define the **provenance chain that feeds `LORE/`**: a completed task records a portable insight
in an optional `lesson:` frontmatter field (`grep -rl "^lesson:" TADA/` is an instant index) and
context-specific observations in a separate `notes:` field. `lesson:` is the searchable signal; candidates for
promotion to `LORE/` emerge from a steward-driven lesson-mining pass. The four doc kinds are kept **distinct
on purpose**: `STANDARDS/` (how to code) vs `skills/` (how to do a recurring operation) vs `TOQU/` (open
questions) vs `LORE/` (durable design rationale that transcends a single task). LORE is written **by the
steward, never by invokers as busywork.**

Source: [STANDARDS/operations.md](https://tangled.org/jcorbin.tngl.sh/unum) at commit `339d53e`.
