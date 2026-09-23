---
created: 2026-07-02
author: groom (gardener job groom-refine-endo-roadmap)
project: endo
repo: endojs/endo-but-for-bots
ledger: designs/README.md @ llm tip e50be0b0c
status: reconciliation-snapshot-for-maintainer
supersedes: none (append; does not edit the ledger or the 2026-06-11 resequencing draft)
---

# Endo roadmap reconciliation — 2026-07-02

A groom reconciliation snapshot, not an applied ledger edit. The
authoritative roadmap is `designs/README.md` on `endojs/endo-but-for-bots@llm`
(tip `e50be0b0c` at this pass). Its header still reads *Last updated:
2026-06-15* even though design-authors have touched individual rows since; the
Summary table and the milestone sections have therefore drifted from shipped
state over the 2026-06-16 → 2026-07-01 window. This snapshot reconciles that
window, sharpens and prunes the standing open questions, and re-projects the
near-term sequence, so the next fork-side groom PR (the surface that actually
edits the ledger, per PR #444's precedent) and the maintainer can act from a
current picture. Every status claim below is grounded in a merged PR number or
the ledger line it corrects; nothing here is applied to the ledger.

## A. Reconciliation with recent progress (2026-06-16 → 2026-07-01)

### A.1 Ledger rows that have drifted from shipped state

- **`fs-interface-reconciliation` and `fs-interface-consolidation`** — Summary
  rows (README lines 196–197) both read **In Progress**, but the 2026-06-19
  prose note in the same file already asserts *"all five phases have now
  landed — C2 shared records, C3/C4 daemon read-surface convergence, C1
  EndoNameHub+EndoDirectory unification, and C5 dead-guard removal,"* and
  **PR #467** (merged 2026-06-18, *"reconcile + consolidate filesystem/name-hub
  interfaces; align blobs on rich range-I/O; retire `@endo/endo-fs` into
  `@endo/platform/fs/extended`"*) carried that work. Recommended flip:
  **In Progress → Complete/Implemented** for both, verified against each design
  file's own Status block.

- **`endo-agent-tools` / `agentry-agent-builder`** — already reconciled to
  In Progress in the 2026-06-25 prose (PRs #517 `@endo/agentry` runtime, #523
  `ToolRecord` reconciliation, #524 TS declarations, #525 code-mode git loop);
  rows are current. No change; noted so the next pass does not re-open them.

### A.2 Merged workstreams the roadmap does not yet name

Four cross-cutting workstreams have shipped or advanced on `llm` that the
milestone tables do not track. They resemble M2 (Project Hygiene, Complete) in
kind — repo-wide refactors and diagnostic substrate rather than milestone
features — so they currently have **no ledger home**:

- **Arrow/method house style (retire the `function` keyword).** **PR #474**
  (merged 2026-06-26, *"retire function-keyword in favor of arrow/method syntax
  per erights review"*) landed the convention on `llm`. **PR #589**
  (*"reconstruct #474 on current master"*) is **open** — the same convention is
  not yet on `master`, so `llm`↔`master` diverge on house style. See § B.3.

- **Plain re-exports rule.** Design landed in two parts — **PR #543/#544**
  (intra-package rule, merged 2026-07-01) and **PR #548** (inter-package rule,
  merged 2026-06-30) — with mechanical passes **#570** (genie) and **#571**
  (follow-up) merged 2026-07-01. A repo-wide hygiene convention with no
  Summary-table row.

- **Error tracing across CapTP workers.** **PR #50** (design) and **PR #58**
  (implementation, *"error tracing across CapTP workers (#1879)"*) merged; the
  aggregator + `endo trace` verb is **in flight in the open PR #301**. The
  ledger references error-tracing only as an *integration point* of
  `formula-inspector` (README lines 898, 1248); the tracing substrate itself is
  untracked.

- **`@endo/pubsub` primitive.** **PR #513** created `@endo/pubsub` (Sink/Spring
  async linked list, changes + latest variants); the **`notifier-pubsub-
  migration` design (PR #507)** merged; the FRB→Endo→Exo reactive-collection
  investigation (`projects/endo/drafts/frb-reactive-exo-collections.md`,
  2026-06-24) sits downstream of it. This is new substrate under M4/M7 that no
  Summary row names.

### A.3 In-flight milestone work confirmed current (no drift, spot-check)

- **M3 gateway substrate (P0).** `gateway-package.md` is on `llm` (blob present;
  absorbed and removed the old `endo-gateway.md`, row updated 2026-06-29). The
  packaging/AWS siblings remain on the **open PR #356** (`gateway-packaging-ci`,
  `gateway-aws-deployment`, `gateway-aws-attuned`) — **not yet on `llm`**, so
  the ledger's M5 row (line 1297) that counts them "in-flight on PR #356 stack"
  is still accurate and § B.4's discrepancy is unresolved.
- **M4 Networking** advanced substantially: iroh transport landed (**#446 /
  #452 / #465 / #479**), libp2p removed (**#470**), exo-stream wire protocol
  adopted (**#462**). `ocapn-noise-network` stays Complete; the transport story
  is now iroh-first. A full pass should re-project M4's Gantt band.
- **UX/Chat** migrated to confined Preact (**#460** `@endo/preact-container`,
  **#471** chat migration, **#516** outliner + chat-split); `outliner-design-doc`
  (In Progress) is the live row.

## B. Open questions — sharpened and pruned

### B.1 Pruned (overtaken by events — close on the next ledger pass)

From the **groom #400 batch** (`entries/2026/06/02/184400Z-message-groom-4c3a95.md`):

- **"Promote `gateway-package`, retire `endo-gateway`?"** — **RESOLVED.** The
  ledger row now reads `gateway-package (absorbs the removed endo-gateway
  design)`; `endo-gateway.md` is gone. Close.
- **Design-gap M-bin assignments (oauth-bonding / key-recovery / stripe-adapter
  at M7).** — **SETTLED at M5.** The 2026-06-03 renumbering moved the hosting
  bucket to M5; all three sit as M5 gaps in the ledger (lines 679, 731, 1297).
  The M-bin question is closed; only the *scope* sub-questions remain (folded
  into § B.2 items 4–5).
- **"Raise `endopi-provider-registry-and-oauth`?"** — **SETTLED (leave).** The
  prior recommendation was "leave parked; the MCP-bridge cut does not depend on
  it," and nothing since changes that. Close.

### B.2 Standing (still need maintainer adjudication)

The **2026-06-11 resequencing proposal** (`drafts/resequencing-2026-06.md`) was
**never applied** — the ledger is still M1–M11 (no M7 Community Hub / M12). Its
seven open decisions are therefore all still live; the two most time-sensitive:

1. **P4 in the O1 exit criterion?** — does the hosted gateway (O1) ship on
   bearer-token auth with OAuth bonding as a fast-follow, or must bonding + key
   recovery be *implemented* to call O1 done? (resequencing §5.1)
2. **Dedicated O2 "Community Hub" milestone, or O2 distributed across M5/M11?**
   (resequencing §5.2–5.3) — this gates whether M7–M11 renumber to M8–M12.

Carried from **groom #400**, still standing and now sharper:

3. **Milestone 6 (MCP Bridge) exit criterion — which tool surface counts?** Now
   that the capability-scoped `Filesystem` read tool is reconciled onto the
   canonical `ToolRecord` (**#523**, merged), the exit criterion can finally pin
   whether "successful MCP call" means the static Lal tool set (namespace / mail
   / evaluate) or the `ToolRecord` Dir/Shell/Git surface. Recommend the maintainer
   name the surface.

Folded scope questions (from #400, subsumed by resequencing §5.4–5.5):

4. **`gateway-resource-classes` as its own design** vs a section of the Stripe
   adapter. (resequencing §5.4)
5. **Stripe vs AWS-MeterUsage billing channel** for the marketplace AMI, and
   whether resource-class dimension names are chosen to survive the AWS
   15-char / post-publication lock. (resequencing §5.5)

### B.3 New (raised by the reconciliation window)

6. **House-style / hygiene track — does the roadmap want one?** Three shipped
   or in-flight repo-wide conventions (arrow/method §A.2, plain re-exports §A.2,
   error-tracing substrate §A.2) have no milestone home. Options: (a) a standing
   "Ongoing Hygiene" note under M2 that these conventions accrete to; (b) leave
   them untracked as pure engineering hygiene; (c) give error-tracing its own
   Summary row (it has design + implementation + an open aggregator PR, unlike
   the two pure-convention items). Recommend (a)+(c).
7. **`llm`↔`master` house-style divergence.** #474 landed arrow/method on `llm`;
   #589 (open) reconstructs it on `master`. Confirm #589 is the intended path to
   re-converge, or whether the convention should ride the normal `master`-sync
   merge instead. (Engineering-sequencing call, not a taste call.)

## C. Re-prioritization and near-term sequence projection

The north-star sequence is unchanged (hosted Gateway → MCP bridge → public
hosting/billing). Grounded in current PR state, the near-term order:

1. **P0 — M3 gateway substrate.** Land the **PR #356** packaging/AWS stack onto
   `llm` (it is the §B.4 discrepancy and the precondition the resequencing §1
   critical path assumes). Merge cadence of #343/#356 is the pacing item.
2. **P1 — M6 MCP termination**, gated on M3 gateway-package phases 2/7/8
   (ledger line 1298). Pin its exit criterion first (§B.2 item 3).
3. **P2–P4 — M5 hosting/billing gaps**: author `gateway-oauth-bonding`,
   `gateway-key-recovery`, `gateway-stripe-adapter` design files (one designer
   dispatch each), sequencing gated by the §B.2 items 1/4/5 answers.
4. **Parallel, non-contending — the hygiene track** (§A.2): the arrow/method and
   plain-re-exports passes and the error-tracing aggregator (#301, #589) run
   alongside without contending for the gateway critical path.

Deferred and unchanged: M4 iroh-networking polish, M7 weblets, M8 peer
app-sharing, M9 UX, M10 confinement, M11 `endor`.

## D. Recommended ledger edits for the next fork-side groom PR

This snapshot cannot edit `designs/README.md` from the journal-lander lane; the
following are the concrete edits for the next groom PR against `llm` (or for the
maintainer to authorize):

1. Flip `fs-interface-reconciliation` + `fs-interface-consolidation` rows to
   Complete/Implemented (§A.1); bump the Totals line accordingly.
2. Refresh the *Last updated* header to 2026-07-02 with the §A window summary.
3. Add a hygiene-track note (or an error-tracing Summary row) per §B.3 item 6,
   pending the maintainer's choice of option (a)/(b)/(c).
4. Re-project the M4 Gantt band for the iroh-first transport landing (§A.3).
5. On the maintainer's answer to §B.2 items 1–2, either apply the resequencing
   §4 renumbering (M7 Community Hub; M7–M11 → M8–M12) or record the decision to
   keep M1–M11 so the resequencing draft can be marked resolved.

## Sources

- Ledger: `endojs/endo-but-for-bots@llm:designs/README.md` tip `e50be0b0c`.
- Resequencing proposal: `projects/endo/drafts/resequencing-2026-06.md`.
- Prior groom open questions: `entries/2026/06/02/184400Z-message-groom-4c3a95.md`;
  prior groom pass (M2 closure / PR #444):
  `entries/2026/06/15/205500Z-result-groom-f63ece.md`.
- Merged PRs cited: #50, #58, #121, #235, #343, #400, #444, #460, #462, #465,
  #467, #470, #471, #474, #479, #507, #513, #516, #517, #523, #524, #525, #543,
  #544, #548, #570, #571. Open PRs cited: #301, #356, #589. All PR states polled
  against `endojs/endo-but-for-bots` on 2026-07-02.
