---
title: Limitations and verification
source: packages/gatekeeper-confluence/README.md
source_repo: cloudflare/cloudflare-os
source_commit: 657aa96504f23fda775df46a5a6a95eaf135ec6d
source_date: 2026-08-17
source_authors: [Maximo Guk]
ingested: 2026-08-24
ingested_by: scholar
topics: [capability-mediated-integrations, testing]
status: current
---

The Confluence connector exposes provider limitations explicitly and verifies its translation, parsing, conversion, and simulated-action boundaries with package-local builds and tests.

Markdown conversion may replace unsupported macros, actor metadata may contain only account IDs, and remaining v1 operations may become unavailable as Atlassian retires endpoints. The development contract separately builds configurator interfaces, type-checks the package, and tests URL and CQL parsing, Markdown conversion, v2 converters, and action simulation. The Worker itself runs through the repository development server rather than an isolated package entrypoint.

Source: [packages/gatekeeper-confluence/README.md](https://github.com/cloudflare/cloudflare-os/blob/657aa96504f23fda775df46a5a6a95eaf135ec6d/packages/gatekeeper-confluence/README.md) at commit `657aa965`.
