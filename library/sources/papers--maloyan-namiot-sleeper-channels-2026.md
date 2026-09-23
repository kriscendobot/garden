---
source_kind: paper
source_authors: [Narek Maloyan, Dmitry Namiot]
source_title: "Sleeper Channels and Provenance Gates: Persistent Prompt Injection in Always-on Autonomous AI Agents"
source_year: 2026
source_venue: "arXiv:2605.13471 [cs.CR], 13 May 2026 (position and design paper)"
source_url: https://arxiv.org/abs/2605.13471
source_pdf_url: https://arxiv.org/pdf/2605.13471
source_pdf_sha256: c2ddd8158d47f8e7ac62b8e624170a1736d76f4c3e0b949702e8502c238b1db5
source_pdf_pages: 8
ingested: 2026-05-17
ingested_by: liaison-direct-draft
section_count: 3
status: current
---

A 2026 position-and-design paper introducing the **sleeper-channel** threat class for always-on autonomous AI agents (the "OS-live" agent posture: persistent process, messaging gateways, long-term memory, self-authored skills, host-adjacent execution, scheduler) and proposing a tiered provenance-gate defense (D1, D2, D3) with a soundness theorem against seven named runtime invariants. The paper is *directly relevant to the garden's own threat model*: the garden's standing-monitor daemons, journal-as-message-bus, and bot-identity dispatch posture are structurally similar to the "OS-live agent" the paper analyzes; the *monitoring safety constraint* documented in `CLAUDE.md` is the garden's existing partial defense against the same threat class.

## The sleeper-channel definition

A sleeper-channel attack is a tuple `(T0, u, σ0, S, T1, θ, σ1, κ1, α)`: untrusted-but-admitted content `u` enters surface `σ0` at time `T0` and persists in substrate `S` until time `T1`, with *no attacker interaction* in `(T0, T1]`. At `T1` a trigger `θ` (owner request, autonomous-loop tick, external event like cron) causes the persisted influence to manifest as consequential action `α` on surface `σ1` in execution context `κ1`. The channel is **cross-surface** when `σ1 ≠ σ0` and **cross-context** when `κ1` is not the agent process. The threat class is *defined by two independent axes*: the **persistence substrate** (M1 session context, M2 long-term memory, M3 self-authored skill, M4 filesystem state, M5 scheduled/external trigger) and the **firing-separation** (C0 same-surface-same-session, C1 same-surface-later-session, C2 cross-channel, C3 cross-actor, C4 cross-execution-context).

The §V coverage matrix marks four illustrative cells as the focus: **A2 (M3×C2)** skill-trojan via group chat; **A3 (M2×C2)** cross-channel exfil via memory; **A4 (M5×C4)** cron via confused deputy (walked end-to-end); **A5 (M4×C4)** dotfile patch.

## The defense — D0, D1, D2, D3

- **D0**: no provenance, no gate. Status quo for most agents.
- **D1**: provenance tags in model context; the model is asked to refuse on untrusted provenance. *Insufficient*: adaptive attacks against in-context defenses (Nasr et al. 2025) achieve ≥90% ASR; the paper's own n=20 smoke probe on OpenClaw's existing in-context security warning showed 19/20 attacker-successful dispatches.
- **D2**: the load-bearing contribution. Maintains `τ` (at-source tag) and `Π` (accumulated provenance) functions over the artifact set `A`. Every consequential action passes through one of ten **mediation hooks** (H1-H5 update; H6-H10 gate). Each action is gated on either `Πα ⊆ T` (all provenance trusted) OR `attest(α)` (a one-shot owner attestation matching the canonical **action-instance digest** `δ(α)`). The digest covers post-normalisation dispatch bytes; one-shot nonces prevent grant replay; the attestation arrives over a hardware-attested companion channel `Σ` the model has no emit primitive into.
- **D3**: per-skill capability manifests on top of D2. Composes the **Agents Rule of Two** (a skill may have at most two of: communicate externally, modify state, process untrusted content) without explicit attestation.

## The soundness theorem (D2)

Seven named invariants — **I-Mediation, I-Tag, I-Causal, I-Channel, I-GrantAuth, I-Nonce, I-Hash** — together imply that every D2-allowed action either has trusted provenance or carries a fresh, authenticated, action-bound grant for the *exact* post-normalisation bytes the gate observed. The theorem prevents paraphrase laundering (because tool-call text is itself an artifact with `Π = ⋃ Π(x) for x ∈ Pt`), multi-input grant reuse (because `δ` covers the whole causal set), and replay (because nonces are one-shot, ledger-durable).

## Why this paper matters for the garden

Several library concepts gain direct support from this paper:

- **Confused deputy** (Hardy 1988) is the cross-cutting condition the A4 scenario exemplifies; the garden's bot-identity dispatch posture has the same structural risk. Adding a `[[confused-deputy]]` concept page (deferred from cycle 67) would now have *two* canonical citations: Hardy's original and this paper's instantiation.
- **Mediation hooks** (H1-H10) are a structured enumeration of the points where authority crosses an enforcement boundary. The garden's dispatch-worktree-triple architecture serves a similar role architecturally; the H-vocabulary is useful for naming where checks would go if the garden ever needed to formalize them.
- **OS-live agent** as a threat-class name. The garden's *steward* posture (autonomous, owner-credentials, bounded by sandbox + monitoring-safety-constraint) is essentially an OS-live agent. The paper's framing makes explicit what the garden's `CLAUDE.md § Monitoring safety constraint` was hedging against.
- **Action-instance digest + one-shot nonces** as a concrete mechanism. If the garden ever needs to gate a sensitive dispatch (e.g. a boatman ferry under disputed authorization), the digest-plus-nonce pattern is well-specified by the paper.
- The paper cites Hardy [7], Miller's Robust Composition [8], Saltzer-Schroeder [19], and Capability Myths Demolished [20] as its capability-security basis — the same lineage already in the library's `capability-theory` topic.

## OpenClaw as the running runtime

The paper anchors all "confirmed-from-source" claims to a pinned commit of OpenClaw (`github.com/openclaw/openclaw` at commit `3120401f53e789caf565e60ba29cb9751829b1b6`, 2026-04-27). Whether OpenClaw is a real published runtime as of the paper's date or a synthetic / forthcoming artifact is *not verifiable from inside the library*. The paper's analysis is structured and self-contained regardless: each cell of the persistence × firing matrix is reasoned about independently of OpenClaw, and the D2 defense formalism is substrate-independent. The artifact at `github.com/maloyan/sleeper-channels` is the paper's reference implementation (42 tests, Node ≥ 20). The garden cites this paper as a *threat-class definition*, not as a deployment recipe.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [sleeper-channel-taxonomy-and-running-scenario](../sections/papers--maloyan-namiot-sleeper-channels-2026--sleeper-channel-taxonomy-and-running-scenario.md) | capability-security, agent-conventions | current |
| [provenance-gate-d2-and-soundness-theorem](../sections/papers--maloyan-namiot-sleeper-channels-2026--provenance-gate-d2-and-soundness-theorem.md) | capability-security, capability-theory, agent-conventions | current |
| [executable-policy-and-measurement-plan](../sections/papers--maloyan-namiot-sleeper-channels-2026--executable-policy-and-measurement-plan.md) | capability-security, agent-conventions | current |

## Provenance

- Fetched 2026-05-17 from `arxiv.org/pdf/2605.13471` per maintainer's explicit add request.
- PDF SHA-256 `c2ddd8158d47f8e7ac62b8e624170a1736d76f4c3e0b949702e8502c238b1db5`, 8 pages.
- Drafted by the liaison via orchestrator-direct-draft. Three sections cover the paper's full content (§I-VI / §VII A-H / §VII I-J + §VIII-X) without losing material.
- This paper is *not* part of the Mark Miller corpus; it cites Miller's Robust Composition (2006) and Capability Myths Demolished (2003) as foundational. The slug `papers--maloyan-namiot-...` follows the same `papers--<lastname-first>-<title>-<year>` convention.
