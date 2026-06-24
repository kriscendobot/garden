---
title: Status quo
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
parent: endo-but-for-bots--llm-designs-rpn--problem-and-status-quo
---

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
