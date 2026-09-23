---
source: quickjs.c, quickjs.h, tests/test_lockdown.js, tests/test_compartment.js
source_repo: danfinlay/quickjs
source_branch: native-ses
source_commit: 49dc75ede0d511ddea07236622378df7f652b65e
source_date: 2026-03-28
source_authors: [Dan Finlay]
ingested: 2026-07-03
ingested_by: scholar
section_count: 5
status: current
notes: |
  Sibling-implementation ingest (read for comparison/synthesis, NOT for
  import) of danfinlay's quickjs-ng fork on the **native-ses** branch, which
  adds `harden()`, `lockdown()`, and a native `Compartment` class to the C
  engine. Sourced from a **fork branch**, not a default branch: the upstream
  quickjs-ng default is `master`; this material lives only on `native-ses`.
  Re-check freshness against the branch HEAD (`git ls-remote
  https://github.com/danfinlay/quickjs native-ses`); on a new HEAD that
  touches the SES code, re-ingest. Ingested with the XS-evolution lens
  (job `scholar-ingest-quickjs-native-ses`, kriskowal 2026-07-03): each
  transferable strategy carries a performance-vs-JIT/memory-safety verdict.
  Cross-linked to the XS→Rust (Endor) cluster —
  `projects/endo-but-for-bots/xs-from-rust-investigation.md` and the
  `designs/xs2rust-endor-engine.md` / `daemon-rust-xs-performance.md` cluster
  on endojs/endo-but-for-bots PR #600.
---

> Abstract: danfinlay's quickjs-ng fork on the `native-ses` branch realizes
> the *hardening/immutability* half of SES natively in the C engine —
> `harden()` (a recursive C deep-freeze, `JS_DeepFreeze`), `lockdown()`
> (freeze-all-intrinsics, `JS_FreezeIntrinsics`), and a native `Compartment`
> class whose each instance owns a fresh `JSContext` sharing the parent
> `JSRuntime` — while deliberately omitting the *taming/permits* half (no
> permits whitelist, no intrinsic removal/repair, no determinism scrub, no
> `eval`/`Function`/`Error` taming, and endowments pass **live** parent-heap
> references across the compartment boundary with no membrane). It is a
> pure bytecode interpreter (no JIT), so nothing here leans on JIT; the
> memory-safety surface is hand-written C doing manual refcounting and
> pointer re-reads across a heap whose shape can move. This source page
> distills the engine-level realization and, under the XS-evolution lens,
> the transferable strategies with their performance-vs-safety verdicts —
> the key asymmetry being that the *freeze* is a pure interpreter-overhead
> win that translates to XS with no safety cost, but the *permits/taming*
> step cannot be dropped without losing the security property, so a
> freeze-only native `lockdown` (like this one) is not a substitute for
> SES's permits enforcement on a machine whose safety is the priority.

| Section | Topics | Status |
|---------|--------|--------|
| [architecture-overview](../sections/danfinlay-quickjs--native-ses--architecture-overview.md) | engine-implementation, hardened-javascript, compartments | current |
| [harden-c-deep-freeze](../sections/danfinlay-quickjs--native-ses--harden-c-deep-freeze.md) | engine-implementation, hardened-javascript | current |
| [lockdown-freeze-intrinsics](../sections/danfinlay-quickjs--native-ses--lockdown-freeze-intrinsics.md) | engine-implementation, hardened-javascript | current |
| [compartment-context-model](../sections/danfinlay-quickjs--native-ses--compartment-context-model.md) | engine-implementation, compartments | current |
| [xs-transferable-strategies](../sections/danfinlay-quickjs--native-ses--xs-transferable-strategies.md) | engine-implementation, hardened-javascript, compartments | current |

Source: [danfinlay/quickjs @ native-ses](https://github.com/danfinlay/quickjs/tree/native-ses) at commit `49dc75e`.
