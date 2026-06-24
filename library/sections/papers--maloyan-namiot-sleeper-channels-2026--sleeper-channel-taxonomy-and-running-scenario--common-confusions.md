---
title: Common confusions
source: "Sleeper Channels and Provenance Gates (arXiv:2605.13471, 2026)"
source_kind: paper
source_authors: [Narek Maloyan, Dmitry Namiot]
source_year: 2026
source_venue: "arXiv:2605.13471 [cs.CR]"
source_url: https://arxiv.org/abs/2605.13471
source_pdf_sha256: c2ddd8158d47f8e7ac62b8e624170a1736d76f4c3e0b949702e8502c238b1db5
source_paper_pages: "1-4 (§I Introduction, §II Background, §III Related Work, §IV Threat Model, §V Taxonomy, §VI Illustrative Scenarios)"
ingested: 2026-05-17
ingested_by: liaison-direct-draft
topics: [capability-security, agent-conventions]
status: current
parent: papers--maloyan-namiot-sleeper-channels-2026--sleeper-channel-taxonomy-and-running-scenario
---

- **"Sleeper channels and sleeper agents (Hubinger 2024) are the same thing."** No — the paper is explicit about this. Hubinger's "sleeper agents" are *training-time deceptive behavior* surviving safety training; this paper's sleeper channels are *inference-time persistence* in a deployed agent. The shared metaphor doesn't transfer to the mechanism.
- **"The defense is just provenance tagging."** Provenance tagging is the *substrate*; the defense is *gating on provenance at enforcement points outside the model loop*. The §VII paper makes the boundary placement load-bearing: in-context-only provenance is bypassable (D1), so the gate must sit at H1-H10 in the runtime (D2).
- **"OpenClaw is a real runtime."** It is treated as real by the paper, with a pinned commit hash. As of this section's writing, whether the repo at `github.com/openclaw/openclaw` is a published real artifact, a synthetic example, or a forthcoming runtime cannot be verified from inside the library. The paper's analysis is structured and self-contained regardless.
