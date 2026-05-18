---
title: The D2 Provenance Gate and the Seven-Invariant Soundness Theorem (action-instance digest; mediation hooks H1-H10; one-shot attestations)
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
---

## Abstract

§VII presents the defense in three stages of increasing strength. **D0** dispatches every model-emitted action with no provenance and no gate (the conventional baseline). **D1** maintains source tags and provenance accumulators but encodes enforcement *inside the model loop* — the model is asked to refuse on untrusted provenance. The paper argues D1 is insufficient on two grounds: adaptive attacks against in-context defenses (Nasr et al. 2025) achieve ≥90% ASR across twelve settings, and the paper's own n=20 smoke probe against OpenClaw's existing in-context warning showed 19/20 attacker-successful dispatches. **D2** is the load-bearing contribution: enforcement moves *outside* the model loop, every consequential action passes through one of ten **mediation hooks** (H1-H5 update tags/provenance; H6-H10 gate decisions), and gating combines two predicates — either `Πα ⊆ T` (all contributing provenance trusted) OR `attest(α)` (a one-shot owner attestation matching the canonical **action-instance digest** `δ(α)`). The digest covers post-normalisation dispatch bytes; one-shot nonces prevent grant replay; attestations arrive only over a hardware-attested companion channel `Σ` the model has no emit primitive into. **D3** adds per-skill capability manifests on top of D2, composing the "Agents Rule of Two" — a skill may have at most two of (communicate externally, modify state, process untrusted content) without explicit attestation. The §VII-F soundness theorem states: under seven named runtime invariants (I-Mediation, I-Tag, I-Causal, I-Channel, I-GrantAuth, I-Nonce, I-Hash), every D2-allowed action either has trusted provenance or carries a fresh, authenticated, action-bound grant for the *exact* post-normalisation bytes the gate observed. The proof sketch shows that monotone propagation of source tags + one-shot nonce consumption + cryptographic binding of `δ` to action bytes are jointly sufficient to defeat paraphrase laundering, multi-input grant reuse, and replay.

## Body

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

## Translation block (paper formalism → garden / Endo equivalent)

| Paper concept                              | Garden / Endo equivalent                                                                                       |
| ------------------------------------------ | -------------------------------------------------------------------------------------------------------------- |
| Source tag `τ` from a Channel × Principal × Device triple | The garden's per-message frontmatter (`from:`, `role:`, `host:`) is the structural counterpart but lacks cryptographic binding. |
| Provenance accumulator `Π`                 | No direct counterpart in the garden today. The journal's append-only chain implicitly preserves authorship but doesn't propagate provenance through tool calls. |
| Action-instance digest `δ(α)`              | The garden's `worktree-per-pr` and `pr-formation` skills compute *deterministic descriptions* of dispatched actions but do not hash them. The digest is a stronger primitive. |
| One-shot owner attestation                 | The garden's authorization shapes (`identity_switch_authorized: true`, `mirror_authorized: true`) are *the same idea* without the nonce / digest binding. Currently, an authorization is a flag in a journal entry; replay-resistance is by *journal append-only* convention, not by enforcement. |
| Hardware-attested companion channel `Σ`    | No counterpart in the garden today. Maintainer authorization comes over the chat surface, where the model has full input/output access — so I-Channel would not currently hold. |
| Mediation hook                             | The garden's `dispatch-worktree` skill is structurally similar to a mediation hook for *dispatch construction*; the boatman's preconditions (host check, identity-switch check) are *partial* gates. |

## Implications for the garden

The seven invariants are useful as a *diagnostic checklist* for the garden's existing dispatch-and-monitoring posture. Walking the invariants against the garden as-is:

1. **I-Mediation**: *Partially holds.* The journal entries are append-only and authorship-bound, so journal writes traverse a clear path. Dispatch construction via `dispatch-prepare.sh` is similarly structured. *But* monitor daemons read event bodies directly into agent context without a corresponding tag write — they don't enact H1.
2. **I-Tag**: *Holds at the journal layer.* Journal frontmatter `from:`/`role:`/`host:` is set at write time by the authoring dispatch; the model cannot rewrite a frontmatter field through normal channels. Cryptographic binding is absent (the bot identity authenticates to GitHub but the journal entry's `from:` is plain text).
3. **I-Causal**: *Approximately holds, by convention.* A dispatch's causal set is the journal entries it reads + the role/skill files it loads + the source files it inspects. The dispatch worktree triple makes this enumerable. The garden doesn't formally compute `causal(α)`, but the architecture is compatible with the concept.
4. **I-Channel**: *Does not hold.* Maintainer authorization comes over the same chat surface the model emits to. There is no companion device the model cannot reach. This is the *largest gap* between the garden and the paper's D2 baseline.
5. **I-GrantAuth**: *Does not hold.* `identity_switch_authorized: true` is plaintext in a journal entry; the model could in principle author such a flag if it had write access to the journal. The garden's mitigation is procedural (only maintainer-authored journal entries should bear this flag), not cryptographic.
6. **I-Nonce**: *Approximately holds, by convention.* The journal's append-only nature means a given entry is referenced by its path, which is unique. But there's no consumption ledger — a journal authorization is *reusable* unless the maintainer adds a `consumed: true` note.
7. **I-Hash**: *Holds trivially.* The garden uses git commits as content-addressed identifiers; SHA-1 / SHA-256 are baked into the substrate.

The diagnostic suggests the garden is roughly at **D1** in the paper's hierarchy: tags exist (frontmatter), propagation is implicit (journal authorship), and enforcement is *in-context* (the maintainer reading the journal and exercising judgment). D2 would require: a hardware-attested authorization channel, action-instance digests with one-shot nonces, and runtime gate hooks before dispatch.

**Whether the garden should move toward D2 is a separate question.** The garden's threat model is narrower than the paper's (the maintainer is in-the-loop, not an absent owner being trampolined). The paper's framing is useful for *naming* where the garden's procedural discipline relies on conventions, and for thinking about which conventions would benefit from cryptographic enforcement if the garden's autonomy posture were to widen.

## See also

- [[confused-deputy]] — *placeholder concept page*. The A4 walk-through is one canonical instantiation.
- [[principle-of-least-authority]] — *placeholder*. D3's Agents-Rule-of-Two construction is explicitly POLA-flavored.
- `papers--miller-capability-myths-demolished-2003--four-models-and-seven-properties` — the seven properties (A-G) are the formal characterization of access-control models; the seven invariants here are the *agent-runtime* analog at a different level of abstraction.
- `papers--miller-tulloh-shapiro-structure-of-authority-2004--multiplicative-pola-and-security-as-modularity` — Table 1's "security as extreme modularity" mapping has direct parallels to the paper's H1-H10 enumeration: every modularity discipline is the strict reading of a security discipline.

## Common confusions

- **"Provenance tagging alone is the defense."** No — that's D1, which the paper argues is insufficient (90% ASR against adaptive attacks; 19/20 against OpenClaw's deployed warning). The defense is D2's *combination* of provenance with action-instance digests and out-of-loop attestations.
- **"The seven invariants are independent."** They are *coordinated*: dropping any one of them (e.g., relaxing I-Nonce to allow grant reuse) opens an attack path. The proof sketch uses all seven.
- **"The model can issue its own attestations."** No — I-Channel and I-GrantAuth jointly forbid this. The model has *no emit primitive* into `Σ`. The owner must authorize each unique action-instance digest separately.
- **"D2 prevents all prompt injection."** No — D2 prevents *consequential effects* from untrusted-provenance content. The model can still be coerced into emitting attacker-favored text; what changes is that side-effecting actions on that text deny at the gate.
