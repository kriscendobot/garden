---
role: gardener
requires: host=endolin-garden-ece02cb4
tier: mentor
fallback-tier: minion
pr: https://github.com/endojs/endo-but-for-bots/pull/1391
dispatch: automatic
---

# PR write handoff for #1391 (gauntlet fix round 4)

The fix-4 stage pushed `2a14a08e3fe` from host oros-studio-garden-ce242c49, whose bot PAT
cannot write PRs on endojs (403). On this host, do exactly two things and nothing else:

1. Replace the body of https://github.com/endojs/endo-but-for-bots/pull/1391 with the
   BODY block below verbatim (`gh pr edit 1391 -R endojs/endo-but-for-bots --body-file <file>`).
   Keep the `<!-- garden-job: ... -->` marker line.
2. Post the SUMMARY block below as a top-level comment on the PR (`gh pr comment`).
   If the CI for `2a14a08e3fe` has finished, replace "CI: see the checks on ..." with its result.

Do not push code or re-run the panel.

----- BODY -----
<!-- garden-job: ebfb-sturdyref-layer2-ses-20260930 -->
Refs: #695, #774, https://github.com/kriscendobot/garden/issues/47

## Description

Layer 2 of 9 in the SturdyRef stack requested in https://github.com/endojs/endo-but-for-bots/pull/695#issuecomment-5903472512, stacked on layer 1 (#774) via the frozen base `build/sturdyref-shim-first-wins-ef4662f`.

When a shim installs `SturdyRef` before lockdown, SES permits it and shares it with child compartments; without a shim, no `SturdyRef` global appears. Lockdown leaves only the shim's locked start-compartment binding in place: any other locked universal, or a `SturdyRef` of another shape, still throws.

### Security Considerations

The constructor confers no authority. Lockdown's shape check (a data property holding a function with own `enliven` and `isSturdyRef` statics) is a misconfiguration guard, not an authority boundary.

### Scaling Considerations

None.

### Documentation Considerations

`packages/sturdyref/README.md` § Child compartments already describes this.

### Testing Considerations

Node tests cover the shimmed, absent, misshapen, accessor, impostor, and non-function cases and child compartments; `test:xs` runs an XS smoke.

### Compatibility Considerations

Realms without the shim are unaffected. An existing application `SturdyRef` global of another shape now makes `lockdown` throw, so `ses` takes a major bump.

### Upgrade Considerations

The shim and the SES `SturdyRef` permit must release together: a shim that adds a member breaks an older SES's `lockdown`.

🤖 Generated with [Claude Code](https://claude.com/claude-code)
----- END BODY -----

----- SUMMARY -----
**Gauntlet fix round 4 — completion summary** (head `2a14a08e3fe`, previous `1a5ed2ee0f`)

Addressed (must-fix):
- **changeset-auditor #1** — `ses` changeset bumped `minor` → `major` (`2a14a08e3`); the changeset and PR body state that a previously-succeeding `lockdown` can now throw.
- **scribe #1** (breaker r3 #1 / saboteur r3 #1 / spec-keeper r3 #2; again breaker r4 #2, saboteur r4 #1, purist r4 #2, engine-realist r4 #3, corner-prober r4 #4) — `assertSturdyRefShape` now reads `globalThis.SturdyRef` once by `getOwnPropertyDescriptor` and refuses an accessor binding, so no getter runs and the checked value is the value `sampleGlobals` captures (`54760f44c`). New `sturdyref-accessor.test.js` uses a stateful getter (shaped on first read, bare function after); it fails on the previous head and passes now.
- **pruner #1–#3** — PR body trimmed from 411 to ~200 words: testing narrative collapsed to one sentence, opening and upgrade paragraphs tightened.

Also addressed (comment-only):
- corner-prober #2 / breaker #5 — new `sturdyref-non-function.test.js` pins the `typeof candidate !== 'function'` branch (`globalThis.SturdyRef = 42`).

Declined / deferred, with reasons:
- breaker #1 (`new.target` check in the shim constructor) — the constructor lives in `packages/sturdyref` (layer 1, #774), not in this SES layer; belongs in that layer's review.
- integrator #1 (regroup commits) — history is kept per review round while the gauntlet is running; regrouping is a pre-ferry retcon.
- purist #1 (start-compartment binding shape differs from child compartments) — deliberate first-wins design from layer 1; the changeset documents the locked start binding.
- purist #3 (authority wording), engine-realist #1/#2/#4, corner-prober #1/#3, fast-checker #1–#3, prover, migrator — comment-only; follow-up candidates (fast-check needs a new `ses` devDependency).

Verification: `packages/ses` `ava test/sturdyref-*.test.js test/global-locked-universal.test.js` 13/13 pass; `eslint`, `prettier --check`, and `yarn lint:types` clean on touched files. CI: see the checks on `2a14a08e3fe`.

No maintainer standing-orders asks on this PR.
----- END SUMMARY -----

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 4
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-30T20:07:40Z
