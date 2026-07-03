---
title: Transferable strategies for XS evolution, with perf-vs-safety verdicts
source: quickjs.c
source_repo: danfinlay/quickjs
source_branch: native-ses
source_commit: 49dc75ede0d511ddea07236622378df7f652b65e
source_date: 2026-03-28
source_authors: [Dan Finlay]
ingested: 2026-07-03
ingested_by: scholar
topics: [engine-implementation, hardened-javascript, compartments]
status: current
notes: |
  The centerpiece of the quickjs-native-ses ingest (job
  scholar-ingest-quickjs-native-ses, kriskowal 2026-07-03). Each strategy
  carries a performance-vs-JIT/memory-safety verdict, and is cross-linked
  to the XS→Rust (Endor) design cluster so that program can pick it up.
---

> Abstract: The engineering value of danfinlay's native-SES fork, read for
> XS evolution, is a short list of transferable strategies, each with a
> verdict on the garden's axis — safety of a small, auditable, JIT-free,
> deterministic machine is the priority; performance is weighed against it,
> not above it. The load-bearing conclusion is an **asymmetry**: move SES's
> *freeze* (`harden`/`hardenIntrinsics`) into the engine for a large,
> safety-neutral speedup, but do **not** move SES's *taming/permits* out —
> a freeze-only native `lockdown` is not a secure `lockdown`. Nothing in the
> fork leans on JIT (quickjs-ng, like XS, is a JIT-free bytecode
> interpreter), so no strategy is rejected on JIT grounds; the real
> safety cost is memory-safety of hand-written C traversals, and the real
> perf/safety trade lives in the compartment isolation model (shared heap =
> fast + weak vs separate heap = slower + strong).

## The seven strategies and their verdicts

### S1 — Move the deep-freeze into the engine (`harden`/`hardenIntrinsics`)

**Technique.** quickjs implements `harden` as a C traversal
(`JS_DeepFreeze`) rather than the reflective JS walk the `ses` shim runs.
**XS translation.** Implement `harden`/`hardenIntrinsics` as a native XS
traversal over the slot heap (or as a Rust routine in the Endor wrapper).
XS's mark-and-sweep GC already walks the entire slot graph; a freeze pass
can piggyback on that walk and set a per-slot frozen/non-writable flag
inline, which is cheaper than a separate reflective pass.
**Verdict: IN BOUNDS, highest value.** Pure interpreter-overhead win, no
JIT, memory-safe (freezing is a metadata flip, no unsafe pointer surgery).
Deep-freeze is the dominant cost of SES startup; accelerating it costs
nothing on the safety axis. **Caveat — do not copy the data structure:**
the fork's visited set is a linear-scan array (O(n²) membership), tolerable
for a small `harden` but pathological for the intrinsic graph. Use a hash
set, or better an inline frozen-bit riding the GC mark, not the array.

### S2 — Force-resolve lazy intrinsics before sealing

**Technique.** `lockdown` touches every AUTOINIT global first so no lazy
intrinsic materializes (mutable) after the freeze.
**XS translation.** XS bakes intrinsics at *prepare* time, so it may not
have this exact lazy hazard — but the invariant generalizes: enumerate the
**full reachable set including on-demand-materialized objects** (hidden
iterator prototypes, accessor-produced objects) before sealing. This is the
same discipline as the library's *hidden-intrinsic sampling via
throwaway-instance-prototype-walk* (see conventions.md and the `hurl`
`iterator-prototype-sampling` section) and SES's `sampleAnonymousIntrinsics`.
**Verdict: IN BOUNDS, correctness (not perf).** No safety cost; it is a
completeness requirement for *any* native sealing pass, and confirms the
sampling step XS's SES layer already needs.

### S3 — Realize a Compartment as a reused realm, not a re-initialized one

**Technique.** quickjs makes a Compartment a fresh `JSContext` on the shared
`JSRuntime`; contexts are light because they share heap/GC/atoms, so
per-compartment intrinsic setup is cheap.
**XS translation.** XS's `txMachine` fuses runtime and context — each
machine is its own heap and realm, so XS *cannot* split them the quickjs
way. But XS's **snapshot/clone** mechanism (`fxWriteSnapshot`/
`fxReadSnapshot`) delivers the same "don't re-initialize intrinsics per
compartment" payoff: snapshot one primed machine, restore it per
compartment/worker. This directly answers the open questions in
`projects/endo-but-for-bots/xs-from-rust-investigation.md` — its
open-question #3 (reuse the snapshot machinery as the per-compartment prime)
and #6 (one machine per worker thread; snapshot a primed parser machine to
amortize creation).
**Verdict: IN BOUNDS, but note the isolation inversion (S3′ below).** Use
snapshots — not a shared heap — to recover the setup cost.

### S3′ — Shared-heap object passing (the perf-for-safety trade to REJECT)

**Technique.** Because parent and child compartments share one heap,
quickjs endowments cross as **live references** and cross-compartment object
passing is a pointer hand-off — fast.
**XS translation / verdict: OUT OF BOUNDS as a security posture.** XS's
separate-heap machines force endowments and cross-boundary values through a
**marshaling membrane** — which is slower than a pointer hand-off but is the
*ocap-correct*, pass-style-disciplined boundary the garden wants. The
quickjs shared-heap model buys cross-compartment speed by weakening
isolation to realm-level (no membrane); on a machine whose safety is the
priority, that trade goes the wrong way. Keep XS's boundary a membrane; do
not chase quickjs's shared-heap object-passing speed. (Cross-link:
[[pass-style]], the compartment membrane discipline.)

### S4 — Endowments as globals injected into the child realm

**Technique.** Copy `globals` own-properties into the child global; strict
global eval in the child.
**XS translation.** The *shape* (endow named globals, strict-eval the guest)
transfers directly. But quickjs copies **live parent-heap references**
(the S3′ hole). On XS separate heaps the copy is necessarily a
marshal/wrap — which is the feature, not a limitation.
**Verdict: shape IN BOUNDS; the shallow live-reference copy OUT OF BOUNDS.**
Endow through a marshaling membrane, which XS's heap separation enforces
anyway.

### S5 — FREEZE-WITHOUT-TAME is the safety fulcrum — keep the permits step

**Observation.** The whole fork freezes but does not tame: no permits
whitelist, no intrinsic removal/replacement, no `Date`/`Math.random`
determinism scrub, no `eval`/`Function` restriction, no `Error`-stack
taming. It is the fast, simple, security-*incomplete* half of SES.
**Verdict: the transferable lesson is asymmetric.** Move the *freeze* into C
for speed (S1); you **cannot** move the *taming/permits* semantics out
without losing the security property. For XS: a native `hardenIntrinsics`
fast-path is welcome, but a native `lockdown` that only freezes (like this
one) is **not** a substitute for SES's permits enforcement — the removals,
replacements, and determinism scrub must still run (in JS, or faithfully
ported to C, but not dropped). This is the direct answer to the job's
directive that *safety of the simpler machine is the priority; performance
is weighed against it, not above it.* Determinism/metering compose
orthogonally: this fork does nothing for either, so XS+Endor's metering
(`fxBeginMetering`) and the determinism taming (cf. the ocap-kernel
per-vat `Date.now`/`Math.random` attenuation) remain necessary regardless.

### S6 — Dynamic import via string-spliced `import('spec')` — REJECT

**Technique.** `Compartment.import` builds `import('<spec>')` source text
and evals it in the child.
**Verdict: OUT OF BOUNDS / inferior.** Splicing an unescaped specifier into
source is injection-prone and offers no module map or import hook. XS/Endor
already has the structured path — native `ModuleSource` + `@endo/
compartment-mapper` (documented in
`projects/endo-but-for-bots/xs-from-rust-investigation.md`). Keep the
structured loader; do not adopt this hack.

### S7 — Small correctness details worth carrying

Skip Proxies (freezing fires traps) and module namespaces during a freeze;
**re-read a moved object pointer after recursion** (quickjs comments this at
`quickjs.c:60060` — and XS's collector can relocate slots, so the point is
sharper on XS); preserve identity (`harden(x) === x`) and pass primitives
through. **Verdict: IN BOUNDS, correctness details.**

## Consolidated verdict table

| # | Strategy | Perf axis | Safety / JIT / mem-safety | Verdict |
|---|----------|-----------|---------------------------|---------|
| S1 | Deep-freeze in engine C/native | Large win (removes reflective JS overhead) | No JIT; freeze = metadata flip; mem-safe | **Adopt** (use a hash set / GC-mark bit, not the O(n²) array) |
| S2 | Force-resolve lazy intrinsics before sealing | Neutral | Completeness invariant; no cost | **Adopt** (correctness) |
| S3 | Reuse a primed realm via snapshot per compartment | Win (skip per-compartment intrinsic init) | Strong isolation retained | **Adopt** (answers xs-from-rust Qs #3/#6) |
| S3′ | Shared-heap live-reference object passing | Win (pointer hand-off) | **Weakens isolation to realm-level** | **Reject** (safety > speed) |
| S4 | Endowments as injected globals | Win | Live-ref copy is a membrane hole | **Adopt shape; marshal, don't copy live refs** |
| S5 | Freeze-only `lockdown` (drop permits/taming) | Win (skip whitelist walk) | **Loses SES security property** | **Reject the drop; keep permits** |
| S6 | `import('spec')` string-splice loader | — | Injection-prone; no hooks | **Reject** (keep structured ModuleSource path) |
| S7 | Skip proxies/module-ns; re-read moved ptr; keep identity | Neutral | Correctness | **Adopt** |

## Connection to the XS→Rust (Endor) design cluster

Where these bear on the active Endor program (PR #600 on
endojs/endo-but-for-bots; designs `xs2rust-endor-engine.md`,
`daemon-rust-xs-performance.md`, `daemon-xs-worker-{metering,debugger,
snapshot}.md`):

- **S1 + S7** are candidates for the Endor performance work
  (`daemon-rust-xs-performance.md`): a native `hardenIntrinsics` fast-path
  is the biggest safety-neutral SES-startup speedup available. The
  implementation-site tension is the one the xs-from-rust investigation
  already named — a per-object FFI walk from Rust would be too slow
  (the eval-round-trip-vs-direct-C-call trade); the fast path is a single
  C-side `JS_DeepFreeze`-equivalent inside XS, or a Rust routine that
  descends via a thin FFI, not per-object round-trips.
- **S3** slots straight into `daemon-xs-worker-snapshot.md`: it is the same
  "snapshot a primed machine, restore per worker/compartment" move, and
  resolves `xs-from-rust-investigation.md` open-questions #3 and #6.
- **S5** is a **guardrail** for `xs2rust-endor-engine.md`: if the Endor
  engine ever grows a native `lockdown`, it must carry SES's permits/taming
  semantics, not just freeze. The memory-safety framing (S1's C traversal is
  the archetypal place a hand-written engine bug becomes a memory-safety
  bug) is itself an argument for the Rust-over-libxs.a direction the cluster
  pursues.
- **S3′/S4** reinforce the membrane discipline: XS's separate-heap machines
  make the ocap-correct boundary the default, which is a safety advantage of
  XS's model over quickjs's shared-runtime contexts — worth stating
  explicitly in the engine design rationale.

Source: [quickjs.c](https://github.com/danfinlay/quickjs/blob/49dc75ede0d511ddea07236622378df7f652b65e/quickjs.c#L59935) at commit `49dc75e`, read against `projects/endo-but-for-bots/xs-from-rust-investigation.md`.
