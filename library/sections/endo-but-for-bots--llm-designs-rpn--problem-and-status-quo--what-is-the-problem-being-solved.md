---
title: What is the Problem Being Solved?
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

PR #151 adds `endo workers`, which prints each worker formula and the capabilities tenanted in it via `listWorkerTenants(workerName)`. The maintainer's review surfaced two concrete gaps:

1. There is no reverse lookup that tells the operator *where* a tenant capability lives in the host's namespace. `listWorkerTenants` returns `{ name, type }`, but `name` is just the first pet name discovered in the host's pet store; a tenant may be reachable under several names, under nested directories, or only via retention edges with no pet name at all.
2. There is no syntactic convention for unambiguously rendering a retention path at the CLI.

This document defines: a typed `RetentionPath` shape (extending the segment in `daemon-retention-paths.md`) where every component carries its own locator so consumers can drill in without a second round trip; a bulk host method `listRetentionPaths(targetIds)` that returns a best path for each target in one call, typed; a "best path" projection rule for row-oriented surfaces; and a canonical CLI string notation. The notation is owned by the CLI, not the daemon. The chat UI consumes the same typed `RetentionPath` and renders with markup directly.

Source: [designs/retention-path-notation.md](https://github.com/endojs/endo-but-for-bots/blob/dea3e7186cb482a5fc9c368d0cc95355e3f0271d/designs/retention-path-notation.md) at commit `dea3e718` on branch `llm`.
