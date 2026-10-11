---
title: "ADR 0017: Nondeterministic live qualification"
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

> Abstract: PATH-priority selection and provider fallback let equal revisions generate with different launchers or models, while interactive credential sessions did not survive SSH release fan-out, making expensive live qualification unreliable and incomparable.

Remote POSIX workers could not authenticate Cursor, Claude, or Codex through their SSH
login environment, while OpenCode accepted an environment API key and explicit model.
The existing selector searched PATH and could fall through after quota or authentication
failure, so a release gate might silently change providers during one run.

The ADR separates neutrality about which vendor an operator prefers from determinism
about live qualification: a costly acceptance run must name one launcher and model even
though the repository does not choose that tuple for the maintainer.

Source: [docs/decisions/0017-explicit-live-test-coding-cli.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0017-explicit-live-test-coding-cli.md) at commit `fcc40bc6`.
