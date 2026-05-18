---
title: Executable Policy Specification, Preregistered Measurement Plan, and Discussion (D2 gate as TypeScript reference; OpenClaw integration sketch; ethics + canaries)
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
---

## Abstract

§VII-I describes the paper's *executable artifact* — a TypeScript reference implementation of the D2 gate at `github.com/maloyan/sleeper-channels` (42 tests, Node ≥ 20). The artifact ships four subsuites: a *gate suite* (23 cases exercising every decision rule including multi-input laundering, grant replay on consumed nonce, and the rate-limiter fail-closed path); a *mock-runtime suite* (3 cases replaying the smoke-probe majority output and confirming that D0 and D1 dispatch while D2 denies on mixed-provenance input); a *static-audit suite* (13 cases reading the vendored OpenClaw source and asserting that load-bearing line citations are present at the claimed lines); and a *runtime adapter* (3 cases wiring H1/H2/H3/H6/H9 around the cron path with faithful stubs of the OpenClaw normalisation functions). §VII-J sketches three OpenClaw integration points (`external-content.ts:356` for H1, `local-loader.ts:50` for H4-H5, `cron-tool.ts:637` for H9) — *audited but not yet patched upstream*. The measurement plan is **preregistered**: A3 measured under P1, A2/A4/A5 under P2, primary endpoint is *Action rate at delay τ\* = 50 benign turns*, eight Holm-Bonferroni contrasts across D0/D1/D2 and A2-A5 at n ≥ 200 seeds per cell, deterministic canary oracles, an adaptive-attack budget implementing five specific vectors, and a 50-task benign suite for utility-cost parity. §VIII names what the paper *delivers* (definition, taxonomy, source-anchored feasibility argument, formal defense with theorem and reference) and what it *defers* (empirical attack-success rates, defense efficacy under deployment, utility cost — all to the preregistered follow-on). §IX commits to coordinated disclosure norms: working A4/A5 templates are gated to patched-version disclosure; D1/D2 reference defenses are filed as upstream patches; all harms instrumented via canaries (synthetic secrets, sink mailboxes, sandboxed filesystem markers, isolated-VM cron entries, synthetic contact lists).

## Body

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

## Translation block (paper artifact → garden equivalent)

| Paper artifact                              | Garden / Endo equivalent                                                                                       |
| ------------------------------------------- | -------------------------------------------------------------------------------------------------------------- |
| `d2-gate/` TypeScript pure-function gate    | No counterpart in the garden today. Closest analog is the boatman's *host preconditions* check, which is procedural (a bash check) rather than a pure decision function. |
| Static-audit suite                          | The garden has no static audit of its own source. The closest existing discipline is `journal/inventory/*.md` audits run periodically by the inventory role. |
| Runtime adapter wiring H1/H2/H3/H6/H9       | The garden's `dispatch-worktree` is the structural analog for H1-equivalent (the source of a dispatch is named at prepare-time). No counterpart for H6/H9. |
| Preregistration of measurement design       | The garden has no precedent for preregistration. The `roadmap-projection` and `journalism` skills are the closest discipline — capturing intent before action. |
| Canary instrumentation for harms            | The garden's monitor daemons read real events from real surfaces; there is no canary substrate today. If the garden ever needed to test its own defenses, canaries would be the right primitive. |

## Implications for the garden

This section is the most practical of the three. The artifact-and-measurement framing has several uses:

1. **The garden could adopt the source-anchored-citation discipline.** The paper's static-audit suite reads vendored source and asserts that line citations remain valid. The garden's journal entries that reference specific files (`roles/<name>/AGENT.md § Operating norms`, etc.) could carry a similar audit — a periodic check that the cited section still exists at the claimed name. This would catch silent drift between journal claims and current source.
2. **The garden's authorization shapes could move toward action-instance digests.** Today, `identity_switch_authorized: true` is a flag in a journal entry. The paper's `δ(α)` discipline says the authorization should bind to the *exact post-normalisation bytes* of the action being authorized. A boatman ferry currently relies on the maintainer trusting the dispatch description; a digest-based authorization would bind the trust to the actual PR title, body, and target repo at the moment of dispatch.
3. **The preregistration framing is a useful discipline.** Before running a new monitor on a new repo, the garden could *preregister* what counts as success and what counts as evidence of a problem — making the "monitoring safety constraint" reviewable rather than just procedural.
4. **The canary framing applies to garden self-testing.** If the garden ever needed to verify that the monitor-safety-constraint actually narrows the attack surface in practice, canary repos (with synthetic adversarial content) would be the right substrate — the garden already has a `worktrees/` directory structure that could host them in isolation.

None of these are immediate library-side actions. They are *gardener-side discussion seeds* — design changes the gardener could consider if the garden's autonomy posture were to widen.

## See also

- [[confused-deputy]] — *placeholder*. The A4 scenario is one canonical citation; the implementation sketch (gating at `cron-tool.ts:637`) is the operational answer.
- [[principle-of-least-authority]] — *placeholder*. The D3 Agents-Rule-of-Two construction is POLA at the agent-runtime layer.
- `papers--miller-tulloh-shapiro-structure-of-authority-2004--multiplicative-pola-and-security-as-modularity` — the paper's "fractal hollowing of attack surface" argument and this paper's "mediation hooks at every artifact-creating code path" prescription are the same architectural idea at different abstraction levels.
- `papers--miller-tribble-shapiro-concurrency-among-strangers-2005--partial-failure-and-when-catch` — the partial-failure handler-registration discipline (handlers register *within the sending vat*, outliving the broken connection) is structurally analogous to "attestations bind to action-bytes, outliving the model's emission of those bytes."

## Common confusions

- **"The artifact is a production runtime."** No — it is a *reference implementation* of the gate decision function and the static audit. Production deployment would require integrating H1-H10 into the live runtime, providing the hardware-attested companion channel, and the deployment work the paper explicitly defers.
- **"Preregistration replaces empirical evidence."** The paper is careful here: preregistration is a *commitment about how the follow-on study will be run*. It doesn't replace the study; it constrains it.
- **"Canaries are real attack instrumentation."** Canaries in this paper's sense are *synthetic substitutes* for real harms. Real secrets, real mail recipients, real filesystem targets are never the experimental subject. The discipline is structurally analogous to *honeypot* design but for measuring defense efficacy rather than for attracting attackers.
- **"D2 must be deployed to be useful."** The paper's contribution is partly *the formalism itself* — the seven invariants give the garden (or any agent system) a checklist to diagnose how close its existing architecture is to D2-equivalent. The "Implications for the garden" subsection above is one such diagnostic.
