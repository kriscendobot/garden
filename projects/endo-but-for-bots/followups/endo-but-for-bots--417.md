---
project: endo-but-for-bots
pr_repo: endojs/endo-but-for-bots
pr_number: 417
upstream_mirror_repo: endojs/endo
upstream_mirror_pr: 3164
created_at: 2026-06-03T20:35:03Z
last_appended_at: 2026-06-03T20:35:03Z
status: parked
---

# Follow-ups for endojs/endo-but-for-bots#417

Created from the code-panel rounds on `feat(immutable-arraybuffer): freezable virtual typedarrays` (mirror of erights's `endojs/endo#3164`). Branch `mirror/3164-freezable-typedarrays`. Three deferrals carried from the round-1 (barrister) verdict survived the round-2 (justice) terminating verdict and park here for revisit on merge of either the bot-side PR or the upstream `endojs/endo#3164`.

## Items

- [ ] **Rebase-artifact carry.**
  **Source juror(s)**: packager (round 1), via the cleaner's stage-1 flag.
  **Round**: 1.
  **Recommended action**: when the upstream PR (`endojs/endo#3164`) merges, confirm the four upstream-master commits the mirror is behind (`04083b872` `fix(benchmark): install xs/v8 via direct download instead of esvu`, `84a3f2a16`, `8ff084968`, `ba26f4cdb`) reconcile cleanly. A weaver pass or the boatman's carry rebase handles the conflict if any; the bot-side mirror inherits whatever the upstream PR resolves to.

- [ ] **Post-shim-wiring second-round re-panel.**
  **Source juror(s)**: integrator, fast-checker, spec-keeper (round 1).
  **Round**: 1.
  **Recommended action**: when the shim wiring lands (presumably in the upstream PR's continuation that wires `makePseudoTypedArrayConstructor` into `immutable-arraybuffer-shim.js`), open a follow-up bot-side PR (or mirror the upstream continuation) and run a fresh code-panel pass. The current panel reads only the static plumbing; the live behavior of the freezable TypedArray (the `virtualTypedArrayBufferGetter`'s brand-check semantics across genuine vs emulated TypedArrays, the `PseudoTypedArrayPrototype.constructor` cycle on `new`, the `setPrototypeOf(PseudoTypedArray, TypedArray)` chain) is not exercised by anything in this PR and warrants a second-round look at completion. Property-based fast-check shapes (mentioned by the fast-checker round-1) become appropriate at that point.

- [ ] **Changeset on merge.**
  **Source juror(s)**: releaser (round 1).
  **Round**: 1.
  **Recommended action**: when the upstream PR merges, confirm the changeset names both `@endo/immutable-arraybuffer` and `@endo/ses` (the permits slot is an ses-side change) at the right semver level. No `.changeset/*` entry is present on the bot-side mirror; the upstream PR is the natural home for the changeset and the bot-side mirror inherits it.
