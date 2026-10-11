---
title: "ADR 0037: Apply, re-exec, and failure policy"
source: docs/decisions/0037-prefix-installed-cli-self-update.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, software-supply-chain]
status: current
---

> Abstract: A later invocation locks the prefix, installs a staged wheel locally, refreshes launcher and manifest, reports on stderr, and re-execs the original arguments exactly once.

Lock contention runs the current version without waiting. Network, version, wheel, pip, timeout, and refresh failures warn and fail open so self-update never prevents command startup. A 120-second pip cap bounds apply, and failed launcher or manifest refresh prevents re-execution even if pip finished.

The invocation that stages an update always completes on old code, avoiding live-environment replacement beneath a running process.

Source: [docs/decisions/0037-prefix-installed-cli-self-update.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0037-prefix-installed-cli-self-update.md) at commit `fcc40bc6`.
