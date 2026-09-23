---
project: endo-but-for-bots
pr_repo: endojs/endo-but-for-bots
pr_number: 311
upstream_mirror_repo: null
upstream_mirror_pr: null
created_at: 2026-05-22T22:34:00Z
last_appended_at: 2026-05-22T22:34:00Z
status: parked
---

# Follow-ups for endojs/endo-but-for-bots#311

Created from the code-panel verdict (15 seats, in-band fallback) on `fix(module-source): pass defineProperty through functor calling convention` (branch `fix/module-source-define-property`). The PR threads a `defineProperty` field through the precompiled-module functor calling convention so the emitted `Object.defineProperty(fn, 'name', ...)` cannot be hijacked by a module that shadows `Object` via `import { Object } from './x.js'`. Three deferrals warrant revisit when the PR (or its upstream mirror, if one is later ferried) merges.

## Items

- [ ] **Functor calling-convention versioning.**
  **Source juror(s)**: integrator, archivist.
  **Round**: 1.
  **Recommended action**: open a follow-up design doc or short PR proposing a private `FunctorInputRecord` type that names the functor signature and version-stamps additions. Today the calling convention grows ad-hoc (this PR adds `defineProperty` as field six); future additions (`harden`, `Reflect`, etc.) deserve a documented progression rather than another field-at-a-time grow.
  The functor signature is currently untyped at the type-definition layer (no entry in `packages/ses/types.d.ts`). Out of scope for this fix.

- [ ] **Audit other intrinsic references inside the functor body.**
  **Source juror(s)**: corner-prober, saboteur.
  **Round**: 1.
  **Recommended action**: open a follow-up PR (or first an investigation) running `grep -n 'Object\.\|Reflect\.\|Symbol\.' packages/module-source/src/transform-analyze.js` to enumerate any other places the emit code references `Object.X` / `Reflect.X` / `Symbol.X` inside the functor body. Each such reference is shadowable by a `let Object;` / `let Reflect;` / `let Symbol;` introduced by a hoisted import-decl in the user source.
  This PR fixes the `Object.defineProperty` case specifically; peer regressions on `Object.freeze`, `Object.keys`, `Reflect.has`, etc. would have the same shape. The audit is one grep plus a quick read.

- [ ] **Migration-cascade documentation for the three-package coordinated bump.**
  **Source juror(s)**: migrator, releaser.
  **Round**: 1.
  **Recommended action**: open a follow-up PR adding a peer-dep cascade entry on `packages/module-source/package.json` (or a release-note warning) so consumers that pin one of the three packages independently see the asymmetric-pairing constraint at install time. The current changeset bumps `@endo/module-source`, `ses`, and `@endo/compartment-mapper` all `patch`; the asymmetric pairing (new `module-source` + old `ses` or `compartment-mapper`) becomes a runtime-throw upgrade trap rather than a silent regression.
  Lands after this PR; the cascade entry itself does not need to be in this PR's diff.
