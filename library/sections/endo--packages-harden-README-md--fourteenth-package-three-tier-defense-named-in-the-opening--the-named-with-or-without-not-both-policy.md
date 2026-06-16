---
title: §the-named-with-OR-without-NOT-both-policy
source: endo--packages-harden-README-md
url: https://github.com/endojs/endo/blob/master/packages/harden/README.md
authors: [Kris Kowal, Mark S. Miller, Jean-Francois Paradis, Endo project (collective)]
repo: endojs/endo
path: packages/harden/README.md
total-lines: 158
ingest-cycle: 337
ingest-date: 2026-06-15
lane: designs
section-tags:
  - the-named-three-tier-defense-named-in-the-opening
  - the-named-threat-model-named-first
  - the-named-supply-chain-attack-IS-named-threat-model
  - the-named-place-to-stand-toward-its-own-defense-metaphor
  - the-named-dual-purpose-of-harden
  - the-named-Object-Symbol.for-harden-intrinsic
  - the-named-intrinsic-over-endowment-discipline
  - the-named-build-condition-as-policy-knob
  - the-named-two-named-build-conditions
  - the-named-multiple-instances-first-call-wins
  - the-named-shim-like-behavior-pre-lockdown
  - the-named-with-OR-without-NOT-both-policy
  - the-named-temporal-ordering-creates-vulnerability
  - the-named-helpful-stack-on-misuse
  - the-named-stack-points-to-the-offending-module
  - the-named-isFake-deprecated-with-named-regret
  - the-named-honest-regret-in-README
  - the-named-migration-path-with-named-alternative
  - the-named-Without-HardenedJS-degradation-mode
  - the-named-partial-safety-with-named-tradeoff
  - the-named-test-and-UI-framework-acknowledgment
  - the-named-six-section-policy-README-shape
  - the-named-fourteenth-package-in-the-pivot-cluster
  - twenty-eight-cycles-with-named-pivot-domain-stay
  - fifty-six-citation-arc-closures-in-pivot-now
  - the-named-substrate-package-with-policy-README
parent: endo--packages-harden-README-md--fourteenth-package-three-tier-defense-named-in-the-opening
---

Section heading lines 99-116 — *"With or Without not Both"*:

> However, initializing a hardened module before setting up a HardenedJS environment (before calling `lockdown`) and then proceeding on the assumption that it's hardened after `lockdown` would leave the apparently-hardened module **vulnerable**.

**§the-named-with-OR-without-NOT-both-policy** — first-explicit-observation. The section heading itself encodes the policy with explicit NOT BOTH language. The discipline:
- **WITH HardenedJS** is fine (transitive freeze + intrinsic-protected harden)
- **WITHOUT HardenedJS** is fine (partial-safety degraded mode)
- **MIXED (start without, switch to with)** is NOT fine because the apparently-hardened module is actually only partially hardened, and post-lockdown code assumes full hardening

**§the-named-temporal-ordering-creates-vulnerability** — first-explicit-observation. The vulnerability is **temporal** — it's not about WHAT but about WHEN. A module hardened *before* lockdown is structurally identical to a module hardened *after* lockdown — but the *guarantees* differ because the *environment* changed between them.

**§the-named-helpful-stack-on-misuse** — lines 109-113:

> So, `@endo/harden` arranges for `lockdown()` and `repairIntrinsics()` to throw an exception with a **_helpful_** stack if `harden` gets called before either one.
> The stack **points to the module that was initialized before `lockdown`** and which should be moved after `lockdown`.

**§the-named-helpful-stack-on-misuse** — first-explicit-observation. The package implements a runtime check: if harden was called before lockdown, the lockdown throws with a stack that **points to the offending module**. The stack is the *diagnostic*; the module reference is the *fix-location*.

**§the-named-stack-points-to-the-offending-module** — first-explicit-observation. Compare to cycle 87 pass-style/error.js's §V8-own-stack-accessor (capability channel via stack); cycle 336 memo-race's §honest-TODO-with-named-obstacle (acknowledges the gap but doesn't fix at runtime); §the-named-helpful-stack-on-misuse is a third stack-based discipline — runtime-detected misuse with stack-pointing-to-the-fix. **§three-cycles-with-named-stack-as-diagnostic** (87 + 336 + 337) — first-explicit-observation.

**§the-named-prepare-star-convention** — line 115-116: *"The `lockdown` call often occurs as a side-effect of initializing `@endo/lockdown`, `@endo/init`, or **by convention, modules with names like `prepare-*`**."* The README names a NAMING CONVENTION explicitly. Modules whose names start with `prepare-` are by convention initialization-side-effect modules. **§the-named-naming-convention-as-import-time-side-effect-marker** — first-explicit-observation as a tier-3 meta-pattern. Sibling to cycle 187's prepare-endo.js + prepare-endo-config.js — those are instances of the named convention.
