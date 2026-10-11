---
title: "ADR 0037: Release channel and background staging"
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

> Abstract: An enrolled launcher asynchronously stages only a newer matching wheel from a stable GitHub Release whose repository identity is embedded in the installed distribution.

The channel excludes drafts, prereleases, PyPI, Git clones, rebuilds, and downgrades. Optional GitHub tokens are never logged.

The foreground never waits for GitHub. A detached worker observes a 24-hour success throttle, 15-minute failure retry, 10-second network timeout, and prefix-local logs and staging. It may download a wheel but never mutates the live environment.

Source: [docs/decisions/0037-prefix-installed-cli-self-update.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0037-prefix-installed-cli-self-update.md) at commit `fcc40bc6`.
