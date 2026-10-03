---
role: gardener
requires: host=endolin-garden-ece02cb4
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# PR-write handoff for endojs/endo-but-for-bots#1392 (gauntlet fix round 6)

The fix-6 stage (job `ebfb-sturdyref-layer3-pass-style-20260930-gauntlet-fix-6`) ran on
oros-studio-garden-ce242c49, whose bot PAT gets 403 on endojs PR writes. It pushed
`63137a13c..b39ee2bde` to `build/sturdyref-pass-style-recognition` but could not edit the
PR body or post the push summary. Do ONLY these two writes, from this capable host:

1. Replace the PR body of https://github.com/endojs/endo-but-for-bots/pull/1392 with the
   text between the BODY markers below, verbatim (`gh pr edit 1392 -R endojs/endo-but-for-bots --body-file <file>`).
   It adds the reconciliation against #695's changes-requested review (panel round 6,
   integrator must-fix). First check that the live body still starts with
   `<!-- garden-job: ebfb-sturdyref-layer3-pass-style-20260930 -->`; if someone changed it
   since, merge the paragraphs below into the live body instead of overwriting.
2. Post the top-level comment between the COMMENT markers (`gh pr comment`).

Push no code. Do not run the panel.

----- BODY -----
<!-- garden-job: ebfb-sturdyref-layer3-pass-style-20260930 -->
Refs: #695, #774, #1391, https://github.com/kriscendobot/garden/issues/47

## Description

The pass-style recognition step of the SturdyRef stack (https://github.com/endojs/endo-but-for-bots/pull/695#issuecomment-5903472512), stacked on the SES accommodation (#1391). `passStyleOf` now returns the new pass style `'sturdyRef'` for a SturdyRef, which it admits the way it admits a presence: object identity, no data.

This answers the maintainer's change request on #695 (sturdyrefs are a new kind of passable, not remotables). `'sturdyRef'` is its own pass style, not a remotable, and recognition never enlivens. #695's other concerns, the confinement of enlivening an arbitrary ref and the GC retention and revocation it implies, belong to the later enliven and locator layers, not this pass-style step.

Most important to review:

- Recognition, in `packages/pass-style/src/sturdyref.js`, uses only the brand check of a frozen `globalThis.SturdyRef`, captured once found. Its statics are read as own data properties, its prototype must be frozen and shim-shaped, and only a frozen, property-less object inheriting directly from that prototype is asked. pass-style does not depend on `@endo/sturdyref`.
- Ordering, in `passStyleOf.js`: the brand check runs only after every other helper declines, so an impostor global cannot reclassify a value. A brand check that reenters `passStyleOf` is declined rather than recursing.
- Types: `'sturdyRef'` joins `PassStyle`, and `Passable` admits `SturdyRefObject`, which a type test keeps equal to `@endo/sturdyref`'s `SturdyRef`. It is not a `PassableCap`; its slot kind belongs to the marshal step.
- Marshal and patterns: encoding, marshalling (and so membrane passage), rank ordering and `getRankCover` each throw an error naming `'sturdyRef'`. A SturdyRef is neither a key nor a pattern. `compareRank(ref, ref)` answers 0, as for any identical operands.

### Security Considerations

Recognition never enlivens. Passing a SturdyRef hands the receiver the authority to enliven it. A lying global installed before the shim can only make its own empty objects passable.

### Scaling Considerations

Only objects no other helper claims reach the brand check.

### Documentation Considerations

Both READMEs updated.

### Testing Considerations

`sturdyref*.test.js` in pass-style, marshal and patterns. XS tests are deferred to the repository-wide effort to enable `test:xs` for these packages.

### Compatibility Considerations

Without the shim, behavior is unchanged. Exhaustive `PassStyle` maps must handle or exclude `'sturdyRef'`; the `spaces-util` value renderers now show one. `@endo/sturdyref` drops its `@endo/pass-style` devDependency, and pass-style, marshal and patterns take `@endo/sturdyref` as a devDependency only, so no runtime dependency cycle forms.

### Upgrade Considerations

None.

🤖 Generated with [Claude Code](https://claude.com/claude-code)

----- END BODY -----

----- COMMENT -----
Round-6 panel response, pushed `63137a13c1..b39ee2bdec` (head `b39ee2bdec`):

- **saboteur** (must-fix): `5488aed36` adds a module-level reentrancy guard around the `isSturdyRef` brand check, so a brand check that calls back into `passStyleOf` gets a reentrant rejection instead of unbounded recursion. New `test/sturdyref-reentrant-global.test.js` asserts the brand check runs once; it fails with the guard disabled.
- **corner-prober** (must-fix) / **assessor**: `29b36108f` drops the unreachable `case 'sturdyRef'` from `dot-membrane.js` (the membrane converter only ever sees remotables and promises; the encoder refuses a SturdyRef first) and pins the membrane test to the encoder's `a "sturdyRef" cannot be marshalled` message. If the encoder ever gains a representation, the membrane's `default` still throws.
- **corner-prober** / **spec-keeper** (should-fix): `985375b00` adds a `'sturdyRef'` case to both `spaces-util` value renderers, so the `value-render.js` default is no longer reachable.
- **pruner**: `b39ee2bde` trims the `SturdyRefObject` JSDoc and both changesets.
- **integrator** (must-fix): the description now reconciles this build against #695's changes-requested review and names the devDependency-cycle cleanup.
- **engine-realist**: the XS deferral was already named under Testing Considerations; left as is.

Local verification: pass-style and marshal `ses-ava` suites pass, `lint:types` is clean for both, and eslint/prettier are clean on the touched files.
----- END COMMENT -----

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-03T04:07:47Z
