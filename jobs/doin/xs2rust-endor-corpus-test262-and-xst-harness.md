<!-- garden-promoted-from-plan: gate=deferred priority=low at=2026-07-05T23:04:03Z -->

---
model: fable
---
# Designer: converge the xs2rust-endor corpus on test262 + the harness on `xst` (PR #600, completion milestone)

Repo: `endojs/endo-but-for-bots`, project branch `xs2rust-endor` (PR #600 — the XS→Rust
engine port, kept DRAFT through the build). This is a **completion-phase** milestone, not
current-stage work: the maintainer directive is that "toward the completion of this
project, the corpus should eventually be converted into test262-style cases and the
harness into a proper analogue of `xst`."

Source directive (maintainer @kriskowal, treat as roadmap intent, not literal spec):
https://github.com/endojs/endo-but-for-bots/pull/600#issuecomment-4872940142

## Why this is parked, not active

The engine build is mid-roadmap (stage 3 in flight; see the `xs2rust-endor-build-stage3-*`
children and the `port-xs-to-rust-memory-safe-engine-s6` supervisor). The current corpus is
the bespoke per-stage corpus + the bootstrapped **dual-run test262 harness** described in
`designs/xs2rust-endor-engine.md` (the design tada `xs2rust-endor-design`). This milestone
lands **as the port nears completion**, when the covered/skipped surface is broad enough
that a proper test262-shaped corpus and an `xst`-analogue runner pay off. Do not promote
this ahead of the remaining build stages.

## Deliverable (a design, not yet a build)

Wear the designer role and produce a short design (append to or sit beside
`designs/xs2rust-endor-engine.md`) that specs the two-part convergence:

1. **Corpus → test262-style cases.** How the bespoke stage corpora (and the differential
   fuzz-grammar arms) migrate to test262's case shape: the frontmatter metadata block
   (`flags`, `includes`, `negative`, `features`), the `harness/` include model (`sta.js`,
   `assert.js`, `propertyHelper.js`, …), positive/negative and `raw`/`onlyStrict` variants,
   and how the endor-specific **computron/meter agreement** assertion (bit-exact dual-run
   INCLUDING computrons) is expressed without breaking test262 portability. Name what stays
   endor-proprietary vs. what could feed back upstream to test262 proper.

2. **Harness → an `xst` analogue.** `xst` is XS's test262 runner. Spec the Rust runner that
   plays the same role for the ported engine: test262 discovery + frontmatter parsing,
   include assembly, strict/non-strict/module modes, negative-test handling, and the
   **dual-run oracle** wiring (C-XS as the differential (result, computron) oracle the design
   already mandates). Reconcile against the existing dual-run harness so this is an
   evolution of it, not a parallel tool.

Keep the PR DRAFT. Ground every claim in the pin the design names and in the existing
harness code; cite section totals when you touch the corpus. Report the design, the
migration/rollout sketch, and any build sub-jobs it implies (park those as
`--orchestrated` children under a future build orchestration — do not fan them out here).

---
claim:
  host: endolinbot
  gardener: 12
  claimed_at: 2026-07-05T23:04:07Z
