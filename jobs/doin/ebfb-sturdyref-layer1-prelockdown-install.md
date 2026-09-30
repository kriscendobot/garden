---
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
repo: endojs/endo-but-for-bots, PR #774 (head build/sturdyref-shim-first-wins), layer 1 of the SturdyRef stack (orchestration ebfb-sturdyref-layering-20260930; arc kriscendobot/garden#47).

Gap found by layer 2 (endojs/endo-but-for-bots#1391, the SES accommodation): importing `@endo/sturdyref/shim.js` BEFORE `lockdown()` makes lockdown throw "Cannot lockdown (repairIntrinsics) if a prior harden implementation has been used and installed". The cause is that `makeSturdyRefConstructor` calls `@endo/harden` when the shim is imported, which installs `Object[@harden]`. The directive (endo-but-for-bots#695 comment 5903472512, item 2) needs SturdyRef present at repairIntrinsics time so that SES can pass it to child compartments.

Task: add a pre-lockdown install path, analogous to the HandledPromise shim, that installs the constructor WITHOUT calling `@endo/harden` and leaves hardening to lockdown. For example, use `harden` only when `lockdown` has already run, detected by a present `globalThis.harden` or `Object[Symbol.for('harden')]`, and otherwise just `freeze` the refs. Keep first-wins and the non-configurable global descriptor; #1391 makes SES tolerate that descriptor. Add a test that imports the shim, then `ses`, runs `lockdown()`, and checks that `new Compartment().globalThis.SturdyRef === SturdyRef` (ses as a devDependency of @endo/sturdyref, based on layer 2's branch or with an equivalent local permit check). Update the shim's docs (the "install AFTER lockdown" framing) and design #1389 as needed. After pushing #774, restack #1391 onto a new frozen `build/sturdyref-shim-first-wins-<sha7>` (skills/frozen-base-branch § Stacked PRs). PR stays draft.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 3
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-30T06:27:42Z
