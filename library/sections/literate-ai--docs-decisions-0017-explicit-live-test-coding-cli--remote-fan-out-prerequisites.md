---
title: "ADR 0017: Remote fan-out prerequisites"
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

> Abstract: Automated SSH release fan-out requires OpenCode, an explicit model argument, and an API key available in the worker login environment, failing before egress when prerequisites are absent and forbidding copied interactive credential caches or secrets in worker configuration.

The runner forwards the key through its existing OpenCode allowlist and constructs the
model argument explicitly. Cursor, Claude, and Codex interactive sessions are not
treated as unattended worker transports. A manual remote experiment may override the
tuple, but the release fan-out default remains fixed and prerequisite-checked.

Source: [docs/decisions/0017-explicit-live-test-coding-cli.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0017-explicit-live-test-coding-cli.md) at commit `fcc40bc6`.
