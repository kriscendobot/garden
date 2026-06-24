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
kind: index
section_count: 2
---

> Abstract: PR #151's `endo workers` surfaces `listWorkerTenants(workerName)` returning `{name, type}` per tenant, but **two gaps**: (1) no reverse lookup that tells the operator *where* in the host namespace the tenant lives — `name` is the first pet name discovered, but a tenant may be reachable under several names, under nested directories, or only via retention edges with no pet name at all; (2) no syntactic convention for unambiguously rendering a retention path on a CLI line. **Status quo**: `packages/daemon/src/graph.js` already maintains the labeled formula graph and exposes `listRetentionPaths(targetId): RetentionPath[]` at line 748 — but private to GC, nothing outside `daemon.js` imports it. `host.js` exposes per-name lookups (`identify`, `locate`, `reverseLookup`) but no path-shaped reverse lookup — `reverseLookup(presence)` returns flat string array, doesn't traverse parents. Pet-store `reverseIdentify(id)` returns names within a single pet store; nested directory paths aren't reconstructed. Pet-name path syntax is `/`-delimited per `packages/cli/src/pet-name.js`. Locator format: `endo://{nodeNumber}/?id={formulaNumber}&type={formulaType}` per `locator.js`. Edge labels recorded by `graph.js`: `pet:<name>` (pet-store writes), field names from `extractLabeledDeps` (`worker`, `handle`, `petStore`, `hub`, `powers`, `slot0`, `bundle`, `agent`, `mailbox`, `mailHub`), and `retention` (cross-peer edges). **Pet-name character set**: `PetName` is 1-255 chars; forbidden: `/`, `\0`, `@`, exact `.` and `..`; everything else permitted (`:`, `~`, `#`, `*`, spaces, backtick, double-quote). `SpecialName` matches `/^@[a-z][a-z0-9-]{0,127}$/` (examples: `@self`, `@host`, `@endo`, `@known-peers-store`). **The notation surface is not blocked on graph plumbing**; what's missing is a typed bulk return shape, a host-facing entry point, and a CLI notation handling the real pet-name character set.

Sections:

- [What is the Problem Being Solved?](endo-but-for-bots--llm-designs-rpn--problem-and-status-quo--what-is-the-problem-being-solved.md)
- [Status quo](endo-but-for-bots--llm-designs-rpn--problem-and-status-quo--status-quo.md)

Source: [designs/retention-path-notation.md](https://github.com/endojs/endo-but-for-bots/blob/dea3e7186cb482a5fc9c368d0cc95355e3f0271d/designs/retention-path-notation.md) at commit `dea3e718` on branch `llm`.
