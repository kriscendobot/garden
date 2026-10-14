---
title: Engineering and operations lessons from building Scion
source_kind: web
source_url: https://www.anthropic.com/engineering/redesigning-source-control
source_content_sha256: b3d054963c3f39d437e21031240970f89ddca379738402fa31c6e6c9f3562a44
source_authors: [Nick G., S.G., R.K., Dan C., Garrett H., Ben L., Colin M., Joe P.]
source_date: 2026-10-13
ingested: 2026-10-14
ingested_by: scholar
topics: [source-control-architecture, agentic-sdlc, testing]
status: current
---

Abstract: Anthropic attributes Scion's five-month delivery to a seven-person team using Claude for implementation and optimization while engineers retained responsibility for system boundaries, design tradeoffs, rejecting locally plausible violations, adversarial-review calibration, security policy, and operational judgment.

An internal model rewrote an early Git-to-Scion ingestion prototype with one twentieth the memory use and four times the speed while preserving ordering and data-structure invariants. Anthropic nevertheless describes the engineers' high-level judgment as indispensable: agents repeatedly attempted locally familiar solutions that violated system constraints, such as scanning the commit log for merge times instead of consulting the review system, or adding excessive validation in response to hypothetical adversarial-review concerns.

The team shifted review toward change intent instead of line-by-line inspection. High implementation throughput also funded hermetic simulations of nontrivial infrastructure and source-control interactions, fuzzing, rate limiting, and repeated algorithmic optimization.

Scion adds repository- and directory-level access control, and Antique can express semantic approval constraints so sensitive logic and comment-only changes receive different review treatment. For operations, dedicated Claude "superfans" continuously inspect telemetry for individual components alongside conventional alerts.

The experience also challenges a serialized pre-merge queue: when hundreds or thousands of changes can land during one test run, Anthropic favors post-merge and pre-deploy automation and accepts that agents may repair concurrent conflicts faster than a global repository lock can prevent them.

Source: [Redesigning source control at Anthropic](https://www.anthropic.com/engineering/redesigning-source-control#what-we-learned-building-scion), retrieved 2026-10-14; content SHA-256 `b3d05496`.
