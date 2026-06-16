---
title: Implications for the garden
source: "Sleeper Channels and Provenance Gates (arXiv:2605.13471, 2026)"
source_kind: paper
source_authors: [Narek Maloyan, Dmitry Namiot]
source_year: 2026
source_venue: "arXiv:2605.13471 [cs.CR]"
source_url: https://arxiv.org/abs/2605.13471
source_pdf_sha256: c2ddd8158d47f8e7ac62b8e624170a1736d76f4c3e0b949702e8502c238b1db5
source_paper_pages: "6-7 (§VII I-J — Executable Policy Specification and Integration Sketch; §VIII Discussion; §IX Ethics and Disclosure; §X Conclusion)"
ingested: 2026-05-17
ingested_by: liaison-direct-draft
topics: [capability-security, agent-conventions]
status: current
parent: papers--maloyan-namiot-sleeper-channels-2026--executable-policy-and-measurement-plan
---

This section is the most practical of the three. The artifact-and-measurement framing has several uses:

1. **The garden could adopt the source-anchored-citation discipline.** The paper's static-audit suite reads vendored source and asserts that line citations remain valid. The garden's journal entries that reference specific files (`roles/<name>/AGENT.md § Operating norms`, etc.) could carry a similar audit — a periodic check that the cited section still exists at the claimed name. This would catch silent drift between journal claims and current source.
2. **The garden's authorization shapes could move toward action-instance digests.** Today, `identity_switch_authorized: true` is a flag in a journal entry. The paper's `δ(α)` discipline says the authorization should bind to the *exact post-normalisation bytes* of the action being authorized. A boatman ferry currently relies on the maintainer trusting the dispatch description; a digest-based authorization would bind the trust to the actual PR title, body, and target repo at the moment of dispatch.
3. **The preregistration framing is a useful discipline.** Before running a new monitor on a new repo, the garden could *preregister* what counts as success and what counts as evidence of a problem — making the "monitoring safety constraint" reviewable rather than just procedural.
4. **The canary framing applies to garden self-testing.** If the garden ever needed to verify that the monitor-safety-constraint actually narrows the attack surface in practice, canary repos (with synthetic adversarial content) would be the right substrate — the garden already has a `worktrees/` directory structure that could host them in isolation.

None of these are immediate library-side actions. They are *gardener-side discussion seeds* — design changes the gardener could consider if the garden's autonomy posture were to widen.
