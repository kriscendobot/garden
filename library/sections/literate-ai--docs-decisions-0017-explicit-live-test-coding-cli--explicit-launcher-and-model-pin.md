---
title: "ADR 0017: Explicit launcher and model pin"
source: docs/decisions/0017-explicit-live-test-coding-cli.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, testing]
status: current
---

> Abstract: Every live generation path inside release qualification binds a CLI and model before first egress, disables provider fallback, and fails with a typed unconfigured-selection error rather than adopting the first available executable.

The contract covers installed-project live tests, samples, and any other model-backed
step in the release check. It leaves non-live validation and unit tests unchanged because
they do not invoke a coding CLI. Once pinned, a run does not silently switch provider in
response to authentication or quota failure.

Source: [docs/decisions/0017-explicit-live-test-coding-cli.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0017-explicit-live-test-coding-cli.md) at commit `fcc40bc6`.
