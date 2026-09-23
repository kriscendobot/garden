---
title: Implications for the garden
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

This section is the *threat-class anchor* for several garden-meta discussions:

1. **The Monitoring Safety Constraint is the garden's existing partial defense.** The constraint (only monitor repos gated against untrusted contributors) is the garden's enactment of "narrow the attack surface" at the substrate level — restrict which surfaces are eligible to be `σ0`. The paper's framing makes explicit what the constraint was implicitly hedging against.
2. **The journal is an M2-equivalent substrate.** Journal messages from one role to another (`to: scholar`, `to: boatman`) are read at later times, in different contexts (different dispatches), under owner credentials. A malicious journal message could persist between cycles. The garden's mitigation today is *all journal authorship is bot-identity-only* (no external write surface to the journal), but this is an architectural property, not an enforcement gate.
3. **Standing-monitor daemons match the OS-live agent description.** Each daemon reads untrusted event bodies and feeds them into agent context. The garden's current posture (only `endojs/endo-but-for-bots` monitored among active repos) is the prudent narrowing. Re-enabling another monitor requires explicit maintainer authorization recorded in a journal `message` entry — this is the garden's *capability-discipline* for monitoring scope.
4. **The confused-deputy framing applies to the boatman.** When a boatman ferries a PR under owner credentials based on a journal directive, the boatman's dispatch is structurally identical to A4's owner-trampoline: the visible action (a `gh pr create`) is benign, but the message contents driving the action came through a different surface (the journal). The garden's protection is that journal authorship is itself bot-identity-only; if that invariant were ever broken, the boatman would be a confused deputy by this paper's definition.
5. **The paper's "M3 self-authored skill" matches the garden's `roles/` and `skills/` directories.** The garden allows scholar (via the gardener) to land new skills based on observed patterns. The discipline that requires gardener-mediation for skill landing (rather than letting any role write skills directly) is the garden's enactment of *mediation* in the paper's H4 sense.
