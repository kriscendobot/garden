---
role: designer
---
<!-- garden-promoted-from-plan: gate=blocked priority=normal at=2026-08-06T14:41:16Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Design: move the npm-via-CAS registry proxy (endor) into a compartment-mapper-backed JS worker + endor fixture parity tests

Follow-up requested by maintainer @kriskowal in the approval review of
endojs/endo-but-for-bots PR #875
(https://github.com/endojs/endo-but-for-bots/pull/875#pullrequestreview-4871669598),
which merges the #-prefixed package `imports` field resolution into the
Endor archive runtime.

Design (do NOT build in this job — produce a design doc / plan) how to:

1. **Refactor the npm-via-CAS registry proxy ("endor") to move more of its
   implementation into a JavaScript worker that reuses the shared code in
   `packages/compartment-mapper`** rather than re-implementing package
   resolution (exports/imports subpath patterns, etc.) in the Rust archive
   runtime. Identify which resolution logic in `rust/endo/` (execute.rs,
   xsnap/src/archive.rs) can be delegated to a JS worker calling
   compartment-mapper's shared resolver, and the worker/host boundary.
2. **Test the "endor" feature against the packaged application fixtures in
   `packages/compartment-mapper`.** PR #875 already points the Rust parity
   tests at compartment-mapper's `fixtures-package-imports-exports`; extend
   this so endor exercises compartment-mapper's packaged-application fixtures
   generally, giving a single shared fixture corpus across Node parity,
   compartment-mapper, and the endor runtime.
3. **Consider moving fixtures to a shared top-level `test/fixtures`
   directory** so all three runtimes consume one canonical fixture set
   (the maintainer flagged this as likely needed).

Reference the endor design doc `designs/endor-npm-registry-proxy.md`.

This is a follow-up; it is blocked on PR #875 landing so the design targets
the merged shape of the code, not the pre-merge shape.
