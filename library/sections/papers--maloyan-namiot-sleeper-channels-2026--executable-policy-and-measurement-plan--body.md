---
title: Body
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

### §VII-I The executable artifact at `github.com/maloyan/sleeper-channels`

The artifact is a TypeScript reference implementation of the D2 gate decision function and the audit machinery the paper's source-anchored claims rest on. Concrete contents:

**`artifact/d2-gate/`** — pure TypeScript implementation of:

- The gate decision function `Allow(α) ⇔ α.kind ∈ C ∧ wf(α) ∧ (Πα ⊆ T ∨ attest(α))`.
- The action-instance digest `δ` (SHA-256 over canonical JSON; deterministic `cjson` encoder).
- The closed action set `C` (specified by closure rule).
- The channel-independent trust lifting (raising owner-configured `(p, d)` pairs to triples `(ch, p, d)`).
- The `Πα` union over `causal(α)`.
- The contact-read budget `(Ncontact, Wcontact)` defaulting to N=10 reads per W=24h window, fail-closed.

**Test suite (42 cases across 4 subsuites)**:

1. **Gate suite (23 cases)** — exercises every decision rule. Cases include:
   - Multi-input laundering: an action whose tool-call text aggregates contributions from one trusted source and one untrusted source. Gate denies because `Πα` includes the untrusted tag.
   - Grant replay on a consumed nonce: attestation with a valid digest but a nonce already in the ledger. Gate denies fail-closed.
   - Rate-limiter fail-closed path: `contact-list-read` exceeds the sliding-window budget. Gate denies.
2. **Mock-runtime suite (3 cases)** — replays the §VII-G smoke-probe majority output:
   - D0 dispatch (no provenance, no gate): action allowed.
   - D1 dispatch (provenance tagged, in-context warning): action *still* allowed in the worst case (the smoke probe's 19/20 attacker-successful result).
   - D2 denial: mixed `(email, attacker)` and `(owner-direct, owner)` provenance fails `Πα ⊆ T` and there's no matching attestation.
3. **Static-audit suite at `src-audit/audit.ts` (13 cases)** — reads vendored OpenClaw source and asserts each load-bearing A4/A2/A3 line citation is present at the claimed line. The audit *checks the citations*, not the operational mediation; it fails if the vendored source drifts.
4. **Runtime adapter at `openclaw-integration/` (3 cases)** — wires H1/H2/H3/H6/H9 around the cron path. The adapter uses faithful stubs of `normalizeCronJobCreate` and `normalizeHttpWebhookUrl` matching `cron-tool.ts` lines 637 and 670-675. End-to-end demonstrations:
   - A4 attacker call is denied with `untrusted-provenance` surfacing the email gateway's principal.
   - A benign owner-only cron is admitted as `all-trusted`.
   - H6 unions provenance correctly over multi-source recalls.

The paper is *explicit* about scope: the audit and runtime adapter check I-Mediation and I-Causal *for the H1/H2/H3/H6/H9 slice* on the pinned commit. The other five hooks (H4/H5/H7/H8/H10) and a full deployment proof are explicit follow-on work.

### §VII-J Integration sketch and measurement plan

Three OpenClaw integration points are audited at file/line granularity but *not yet patched upstream*:

1. **Tagging at `external-content.ts:356`** — sidecar a `(ch, p, d)` triple on inbound content. This is the H1 hook.
2. **Sidecar manifests at `local-loader.ts:50`** — co-located with each `SKILL.md`. This is the H4-H5 hooks.
3. **Gating in `cron-tool.ts`** — between `normalizeCronJobCreate` at line 637 and runtime submission. This is the H9 hook. The paper notes that this gate would block A4 *where `exec-approvals` does not* — the existing approval surface keys on the visible command string rather than on the provenance of the data that drove the call.

The preregistered empirical study commits to:

- The OpenClaw SHA used in the paper (`3120401f...1829b1b6`).
- A3 measured under P1; A2, A4, A5 measured under P2 (matching the profile each scenario's firing context requires).
- **Primary endpoint**: *Action rate at delay τ\* = 50 benign turns*.
- **Statistical design**: 8 Holm-Bonferroni contrasts across D0/D1/D2 and A2-A5 at n ≥ 200 seeds per cell.
- **Canary oracles**: deterministic synthetic-secret triggers that fire only on attacker-favored dispatch.
- **Adaptive-attack budget**: implementing the five vectors enumerated in §VII-H (tag forgery, approval-UX confusion, attestation-channel poisoning, mediation escape, digest-preimage manipulation).
- **Utility-cost parity**: a 50-task benign suite checking that D2 does not regress utility on legitimate workflows.

The §VII-J framing is careful: this is a *preregistration*, not a result. Quantitative D1 vs D2 efficacy claims are deferred to the follow-on.

### §VIII Discussion and limitations

The paper delivers four things:

1. **A definition** of the sleeper-channel threat class.
2. **A taxonomy** (persistence × firing-separation, with the 5×5 coverage matrix).
3. **A source-anchored feasibility argument** (A4 walked end-to-end at file/line granularity in OpenClaw).
4. **A formal defense** (D2 with the seven-invariant soundness theorem and the executable reference).

It defers:

- **Empirical attack-success rates** — measured in the follow-on.
- **Defense efficacy under deployment** — also follow-on.
- **Utility cost** — likewise.

The taxonomy is substrate-independent: it applies to any agent runtime that mediates artifact creation through identifiable code paths and can host a hardware-attested companion channel. Memory poisoning, provenance tagging, and the confused-deputy condition are each well-known on their own; the combination on the OS-live substrate, together with the move of treating model-emitted tool-call text as an artifact whose provenance must be tracked to defeat paraphrase laundering, is what the paper claims as novel.

Limitations the paper itself enumerates:

- **A2/A3/A5 are sketches with *requires-deeper-trace* invariants** — only A4 is walked end-to-end.
- **A2 needs the non-default `rw` workspace mode** — load-bearing for the M3 cell.
- **The defense has not been deployed or stress-tested against an adaptive attacker** — the artifact is a reference, not a production deployment.
- **The integration points are OpenClaw-specific** — generalizing to other OS-live agents would require analogous file/line audits.

### §IX Ethics and disclosure

The paper omits runnable payloads and real credential targets. Attack abstractions match maintainer-published documentation and the already-public upstream defense proposal cited as [10] (anonymized for double-blind review). The follow-on study commits to:

- **Canary instrumentation for all harms** — synthetic secrets, sink mailboxes, sandboxed filesystem markers, isolated-VM cron entries, synthetic contact lists. Real attacker payloads are *never* run against real surfaces.
- **Coordinated-disclosure norms** — working A4 and A5 templates gated to patched-version disclosure.
- **Upstream defense patches** — D1 and D2 reference defenses filed as patches against the pinned OpenClaw commit, not just abstract recommendations.

The §IX framing positions the paper as defensive-security research with operational uptake as the goal, not adversarial demonstration.

### §X Conclusion (and what the paper claims as contribution)

"Always-on OS-live agents fold messaging, memory, skills, scheduling, and shell into a single persistent authority boundary that admits sleeper-channel attacks. The paper fixed the class on two axes, took A4 end-to-end through OpenClaw at a pinned commit, and worked out a tiered provenance defense whose load-bearing piece sits outside the model loop. Seven invariants underwrite the D2 soundness theorem. A canonical action-instance digest, paired with one-shot grant nonces, defeats paraphrase laundering and replay. The 42-test reference runs on Node ≥ 20. Empirical study is preregistered."

The closing line carries the architectural prescription: *enforcement must sit outside the model loop, on a closed action set, with action-instance-scoped attestation the model cannot emit*. Provenance tagging *inside* the model loop is bypassable; provenance tagging *paired with out-of-loop enforcement* is the load-bearing combination.
