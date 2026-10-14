---
title: Redesigning source control at Anthropic
source_kind: web
source_url: https://www.anthropic.com/engineering/redesigning-source-control
source_content_sha256: b3d054963c3f39d437e21031240970f89ddca379738402fa31c6e6c9f3562a44
source_authors: [Nick G., S.G., R.K., Dan C., Garrett H., Ben L., Colin M., Joe P.]
source_date: 2026-10-13
ingested: 2026-10-14
ingested_by: scholar
topics: [source-control-architecture, agentic-sdlc]
status: current
---

Abstract: Anthropic presents Scion, an in-house source-control system built and adopted in five months after AI-assisted development raised its monorepo merge rate from about 2,500 to more than 30,000 changes per day; the article frames source control, builds, and CI as the new bottlenecks once code generation becomes cheap.

Anthropic reports that coding itself stopped being the limiting factor for systems and research work. Its merge volume increased more than tenfold between May and September 2026, while demand continued to grow whenever infrastructure constraints were removed.

The response was Scion plus a surrounding development stack: the Antique review surface, code search, source-control IAM, and new mechanisms for managing and landing reviewed code. The article concentrates on Scion as a case study in a feedback loop: Claude-created code produced workloads that strained human-scale infrastructure, while Claude also accelerated construction of the replacement.

Source: [Redesigning source control at Anthropic](https://www.anthropic.com/engineering/redesigning-source-control), retrieved 2026-10-14; content SHA-256 `b3d05496`.
