---
title: Body
source: "Sleeper Channels and Provenance Gates (arXiv:2605.13471, 2026)"
source_kind: paper
source_authors: [Narek Maloyan, Dmitry Namiot]
source_year: 2026
source_venue: "arXiv:2605.13471 [cs.CR]"
source_url: https://arxiv.org/abs/2605.13471
source_pdf_sha256: c2ddd8158d47f8e7ac62b8e624170a1736d76f4c3e0b949702e8502c238b1db5
source_paper_pages: "4-6 (§VII A-H — Defense: Provenance with Enforcement, through the soundness theorem and adaptive-attack discussion)"
ingested: 2026-05-17
ingested_by: liaison-direct-draft
topics: [capability-security, capability-theory, agent-conventions]
status: current
parent: papers--maloyan-namiot-sleeper-channels-2026--provenance-gate-d2-and-soundness-theorem
---

### §VII-A Notation — source tags, provenance, action-instance digest

The defense maintains two functions over the artifact set `A`:

- **`τ : A → 2^S`** — the *at-source tag* of each artifact, where `S = Channel × Principal × Device`. `τ` is written *only* by mediated creation hooks (H1-H5), never by the model.
- **`Π : A → 2^S`** — the *accumulated provenance*. `Π(b) = τ(b)` on fresh intake; for derived artifacts, `Π(f(b1, ..., bn)) = ⋃ᵢ (τ(bᵢ) ∪ Π(bᵢ))`. Monotone propagation: any untrusted input *strictly enlarges* `Π`.

The lattice rule is Denning's 1976 *secure information flow* applied to the agent-runtime artifact domain rather than to program variables.

A consequential action `α` is a tuple `(kind, causal, args, target, ownerDevice)`. The **action-instance digest** is:

```
δ(α) = H( kind, sort(causal), cjson(args), target, ownerDevice )
```

where `H` is collision-resistant (SHA-256 in the reference) and `cjson` is a deterministic canonical-JSON encoder. The digest is computed over the action's *post-normalisation dispatch bytes*: the runtime applies default-inference, alias rewriting, and schema validation *before* the gate sees `α`, so two semantically equal actions with different pre-normalisation syntax produce the same `δ`.

An owner-issued attestation `g = (δg, νg, tg, qg)` carries the digest, a one-shot nonce, an expiry, and the issuing principal. `attest(α)` holds iff *some* grant `g` in the runtime's grant set has `δg = δ(α)`, `tg > now`, `qg ∈ T` matching `α.ownerDevice`, and a nonce `νg` not yet consumed. On allow, `νg` is *consumed* (atomically inserted into a durable ledger). The one-shot discipline is necessary: without it, a single owner approval would authorise *repeated identical dispatches* across the entire expiry window.

### §VII-B The closed action set `C`

`C` is specified by *closure rule*: an operation is in `C` if its effect (a) escapes the agent process, (b) persists beyond the session, or (c) mutates state another principal will later read. The closure covers messaging emission, network egress, file writes outside scratch, skill/plugin/MCP create-modify-load-exec-install, manifest writes, scheduler entry mutations, writes to agent bootstrap or system prompt or model-router config, every `contact-list-read` (rate-limited by a sliding-window budget `(Ncontact, Wcontact)` with defaults N=10, W=24h), outbound attestation issuance, and host shell exec outside a documented allowlist. **Anything outside `C` that mutates state is denied fail-closed**, mirroring the default-deny discipline of seccomp-bpf sandboxing.

### §VII-C Causal-set construction

`causal(α)` is the *complete model-visible and runtime-mediated artifact dependency set* of `α`. The runtime maintains a *transcript provenance set* `Pt ⊆ A` — the running union of every artifact whose content has appeared in the model's context window since session start, minus artifacts pruned by *provenance-preserving compaction* (compaction summaries inherit `Π` from what they summarise).

`Pt` contains: the system prompt, prior assistant turns, tool-call results, every loaded skill manifest and body, planner state, any retrieved memo or attachment or contact-list entry, env values, cwd snapshots, clipboard entries. For action `α` at time `t`: `causal(α) = Pt ∪ {α.args.resolved, tool-call-text}`. The **tool-call text is itself an artifact with `τ = ∅` and `Π = ⋃ Π(x) for x ∈ Pt`**, registered at H6.

This is the design choice that *defeats paraphrase laundering*: a model rewriting an attacker memo into a tool-call argument cannot wash the contribution by passing it through itself. The provenance flows into the tool-call text via the union over `Pt`.

If any contributor to `Pt` cannot be enumerated (e.g., a skill runs under a sandbox the runtime does not mediate), `causal(α) := ⊥` and the gate denies fail-closed.

### §VII-D The ten mediation hooks

D2 requires *complete mediation* (Saltzer-Schroeder 1975): every read or write of an artifact in `A` traverses one of ten runtime hooks.

**Update hooks (H1-H5)** — populate `τ` and propagate `Π`. They never decide whether to allow:

- **H1** Inbound adapter: sets `τ(b)` from the gateway's authenticated source identifier.
- **H2** Memory write: closes `Π` over causal sources at write time.
- **H3** Memory retrieval: registers recalled memos as causal contributors to the next gate.
- **H4** Skill / plugin / MCP creation or modification: propagates `Π`, seeds `τ = ∅`.
- **H5** Skill / plugin / MCP load: registers manifest and body as *separate* artifacts.

**Gate hooks (H6-H10)** — decision points. Each fires before a side-effecting dispatch, computes `Πα` over the action's causal set, and either allows or denies:

- **H6** Tool-call construction: registers model-emitted tool-call text and submits to the gate.
- **H7** Host shell-command dispatch.
- **H8** Filesystem write outside scratch.
- **H9** Scheduler entry create / modify / remove.
- **H10** Outbound network or messaging emission.

Every kind in `C` traverses *exactly one* gate hook. The paper's Table III maps each action kind to its gate. Any kind not listed denies fail-closed — making (I-Mediation) checkable against the spec rather than against generic complete-mediation language.

Operations that escape mediation (FFI, side-channel storage, unseeded env vars, browser plugin state) are *residual surface*: any artifact with unset `τ` has `Π` treated as **universal-untrusted**, so `Πα ⊄ T` by construction.

### §VII-E The D2 gate decision rule

```
Allow(α) ⇔ α.kind ∈ C ∧ wf(α) ∧ (Πα ⊆ T ∨ attest(α))
```

where `wf(α)` holds iff `causal(α) ≠ ⊥` and every `x ∈ causal(α)` has `Π(x) ∪ τ(x) ≠ ∅` (no unprovenanced contributor). Fail-closed reasons (unknown artifact, empty causal, empty-provenance, expired or digest-mismatched grant, exceeded budget, unclassified kind) each produce a *named* deny in the reference implementation.

### §VII-F The seven invariants and the soundness theorem

The mediation invariants (**I-Mediation, I-Tag, I-Causal**) for the A4 path are backed by source-anchor regression tests against the pinned OpenClaw source (13 cases in `src-audit/audit.ts`). Each load-bearing line citation becomes a test that fails if the vendored source drifts.

The cryptographic and channel invariants (**I-Channel, I-GrantAuth, I-Nonce, I-Hash**) are *deployment assumptions* on the runtime, stated precisely but not source-checked:

- **I-Mediation**: Every read or write of an artifact in `A` traverses a hook in `{H1, ..., H10}`.
- **I-Tag**: `τ(b)` is set by H1 from the adapter's authenticated source identifier; the model has *no edit primitive* on `τ`.
- **I-Causal**: `causal(α)` is the closure of §VII-C over `Pt`; if the runtime cannot enumerate it, `causal(α) := ⊥` and the gate denies.
- **I-Channel**: Attestations `g` arrive only over the hardware-attested companion channel `Σ`; the model has *no emit primitive* into `Σ`.
- **I-GrantAuth**: Each grant carries an unforgeable authenticator (e.g. a signature from `qg`) whose verification is performed by the runtime, not by data supplied alongside the grant. `qg` is set from the verified authenticator, never from grant fields the model can influence.
- **I-Nonce**: The consumed-nonce ledger is durable and globally unique within the runtime; concurrent dispatches serialize on ledger insertion. Every fresh grant carries a nonce `νg` drawn uniformly from a space large enough that collision probability is negligible.
- **I-Hash**: `H` is collision-resistant; `cjson` is deterministic.

**Theorem (D2 soundness).** Under the seven invariants above, for every action `α` that D2 dispatches, either `Πα ⊆ T` *or* there exists a grant `g` with `δg = δ(α)`, `tg > now`, `qg ∈ T` matching `α.ownerDevice`, and a nonce `νg` that was unconsumed at dispatch and was atomically consumed against the durable ledger before `α` was emitted. `g` was issued by an owner-trusted principal over `Σ` for the *exact* action-instance bytes the gate observed.

**Proof sketch.** By I-Mediation and I-Causal, `causal(α)` is either ⊥ (denial) or a finite set whose source tags were set at intake by H1 or inherited through mediated propagation under I-Tag. Monotone propagation puts every contributing `τ(bᵢ)` into `Πα`. The rule only dispatches when `Πα ⊆ T` or `attest(α)`. In the attested branch, I-Hash forces `δg = δ(α)` to bind the exact post-normalisation bytes. I-Channel restricts `g` to arrive over `Σ`. I-GrantAuth forces `qg` to come from the verified authenticator rather than from data. I-Nonce prevents replay since the ledger is durable and unique. Together, the only way a dispatch is allowed is if every contributor in `causal(α)` has a tag in `T` or an owner-trusted principal in `T` has issued a fresh, authenticated, action-bound grant for the exact instance.

For A4: `causal(α)` is the owner request, recalled memory note, model-emitted tool-call text, and cron payload. The memory note carries the email gateway's principal tag, so `Πα ⊄ T` and the gate denies. A5 and A2 decompose analogously.

### §VII-H D3 and adaptive attacks

**D3** adds per-skill capability manifests on top of D2. A manifest declares the subset of `C` a skill may attempt and is signed at install time by a principal in `T`. `manifest-write` is itself in `C`. The composition with the **Agents Rule of Two** (Meta AI Security, 2025): a skill may *communicate externally, modify state, or process untrusted content*, but no more than two of those without explicit attestation. D3 keeps a self-improving skill from quietly widening its own capability set, in the same spirit as POLA and Android permission manifests.

The paper enumerates five adaptive-attack vectors and how D2 handles them:

1. **Tag forgery at H1** — fails under I-Tag (only the adapter writes `τ`).
2. **Approval-UX confusion** — the case where a malicious action's canonical preimage looks benign on the companion device. Surfacing the full preimage mitigates most of this; residual risk is human visual error on long preimages, to be quantified against prior signing-UI usability work.
3. **Poisoning the attestation channel** — runs into the hardware-attested companion `Σ`, leaving hardware compromise as the residual.
4. **Mediation escape** — a skill performs side effects without traversing any H1-H10 hook. By construction the gate cannot fire when no hook does, so an enclosing sandbox (seccomp, container, microVM) is mandatory.
5. **Digest-preimage manipulation** — killed by I-Hash because the digest covers the full preimage including target and owner-device.

The paper closes the §VII-H discussion: "The model cannot be coerced into emitting `attest` because I-Channel keeps that primitive out of the model's emit alphabet." The mediation-escape vector is the *deepest* unresolved one; the paper's prescription is enclosing-sandbox enforcement as the structural answer.
