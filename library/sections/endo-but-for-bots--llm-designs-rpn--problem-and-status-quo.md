---
title: Problem + Status quo (graph.js, host.js, pet-name character set)
source: designs/retention-path-notation.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: dea3e7186cb482a5fc9c368d0cc95355e3f0271d
source_date: 2026-05-10
source_authors: [Kriscendo Bot]
ingested: 2026-05-14
ingested_by: scholar
topics: [daemon, capability-security]
status: current
notes: The pet-name character-set rules are load-bearing for any notation that has to embed pet names. The forbidden characters are `/`, `\0`, `@`; everything else is permitted including `:`, `~`, `#`, `*`, spaces, backticks, quotes. SpecialName regex: `/^@[a-z][a-z0-9-]{0,127}$/`. Both rules live in `packages/daemon/src/pet-name.js` and are referenced from this design as the constraint shaping the CLI notation.
---

> Abstract: PR #151's `endo workers` surfaces `listWorkerTenants(workerName)` returning `{name, type}` per tenant, but **two gaps**: (1) no reverse lookup that tells the operator *where* in the host namespace the tenant lives — `name` is the first pet name discovered, but a tenant may be reachable under several names, under nested directories, or only via retention edges with no pet name at all; (2) no syntactic convention for unambiguously rendering a retention path on a CLI line. **Status quo**: `packages/daemon/src/graph.js` already maintains the labeled formula graph and exposes `listRetentionPaths(targetId): RetentionPath[]` at line 748 — but private to GC, nothing outside `daemon.js` imports it. `host.js` exposes per-name lookups (`identify`, `locate`, `reverseLookup`) but no path-shaped reverse lookup — `reverseLookup(presence)` returns flat string array, doesn't traverse parents. Pet-store `reverseIdentify(id)` returns names within a single pet store; nested directory paths aren't reconstructed. Pet-name path syntax is `/`-delimited per `packages/cli/src/pet-name.js`. Locator format: `endo://{nodeNumber}/?id={formulaNumber}&type={formulaType}` per `locator.js`. Edge labels recorded by `graph.js`: `pet:<name>` (pet-store writes), field names from `extractLabeledDeps` (`worker`, `handle`, `petStore`, `hub`, `powers`, `slot0`, `bundle`, `agent`, `mailbox`, `mailHub`), and `retention` (cross-peer edges). **Pet-name character set**: `PetName` is 1-255 chars; forbidden: `/`, `\0`, `@`, exact `.` and `..`; everything else permitted (`:`, `~`, `#`, `*`, spaces, backtick, double-quote). `SpecialName` matches `/^@[a-z][a-z0-9-]{0,127}$/` (examples: `@self`, `@host`, `@endo`, `@known-peers-store`). **The notation surface is not blocked on graph plumbing**; what's missing is a typed bulk return shape, a host-facing entry point, and a CLI notation handling the real pet-name character set.

## What is the Problem Being Solved?

PR #151 adds `endo workers`, which prints each worker formula and the capabilities tenanted in it via `listWorkerTenants(workerName)`. The maintainer's review surfaced two concrete gaps:

1. There is no reverse lookup that tells the operator *where* a tenant capability lives in the host's namespace. `listWorkerTenants` returns `{ name, type }`, but `name` is just the first pet name discovered in the host's pet store; a tenant may be reachable under several names, under nested directories, or only via retention edges with no pet name at all.
2. There is no syntactic convention for unambiguously rendering a retention path at the CLI.

This document defines: a typed `RetentionPath` shape (extending the segment in `daemon-retention-paths.md`) where every component carries its own locator so consumers can drill in without a second round trip; a bulk host method `listRetentionPaths(targetIds)` that returns a best path for each target in one call, typed; a "best path" projection rule for row-oriented surfaces; and a canonical CLI string notation. The notation is owned by the CLI, not the daemon. The chat UI consumes the same typed `RetentionPath` and renders with markup directly.

## Status quo

- `packages/daemon/src/graph.js` maintains the labeled formula graph and exposes `listRetentionPaths(targetId)` (line 748) returning `RetentionPath[]`. Private to GC; nothing outside `daemon.js` imports it.
- `packages/daemon/src/host.js` exposes per-name lookups (`identify`, `locate`, `reverseLookup`) but no path-shaped reverse lookup. `reverseLookup(presence)` returns the local pet store's names for an id (a flat array of strings); it does not traverse parent directories and does not surface retention edges.
- `pet-store.js` `reverseIdentify(id)` returns names within a single pet store; nested directory paths are not reconstructed.
- The existing pet-name path syntax is `/`-delimited (`alice/inbox/2026-05`) per `packages/cli/src/pet-name.js` `parsePetNamePath`.
- The locator format is `endo://{nodeNumber}/?id={formulaNumber}&type={formulaType}` per `packages/daemon/src/locator.js`.
- Edge labels already recorded by `graph.js` include `pet:<name>` (set on pet-store writes), field names from `extractLabeledDeps` (e.g., `worker`, `handle`, `petStore`, `hub`, `powers`, `slot0`, `bundle`, `agent`, `mailbox`, `mailHub`), and `retention` for cross-peer edges.

### Pet-name and special-name character set

The exact rules from `packages/daemon/src/pet-name.js` are load-bearing for the notation.

A `PetName` is any string of length 1 to 255 that:
- does not contain `/`
- does not contain `\0`
- does not contain `@`
- is not exactly `.` or `..`

Every other printable character is allowed: `:`, `~`, `#`, `*`, ` ` (space), backtick, double-quote, and so on. The notation in this design **cannot assume any of those characters are absent** from a pet name.

A `SpecialName` matches `/^@[a-z][a-z0-9-]{0,127}$/` — an `@` followed by a lowercase ASCII identifier with hyphens. Examples: `@self`, `@host`, `@endo`, `@known-peers-store`. The `@` prefix is the boundary marker for special names; it does not appear in pet names (which forbid `@`).

A `Name` (the type accepted by directory paths) is `PetName | SpecialName`.

For the notation: the only characters guaranteed safe as pet-name-component delimiters are `/` and `\0`. `/` is already the path separator. `\0` is unprintable. Every other ASCII punctuation choice (`:`, `~`, `#`, `,`, etc.) can appear inside a pet name and therefore needs an escape mechanism.

The notation surface is therefore not blocked on graph plumbing. What is missing is (a) a typed bulk return shape, (b) a host-facing entry point, and (c) a CLI notation that handles the real pet-name character set.

Source: [designs/retention-path-notation.md](https://github.com/endojs/endo-but-for-bots/blob/dea3e7186cb482a5fc9c368d0cc95355e3f0271d/designs/retention-path-notation.md) at commit `dea3e718` on branch `llm`.
