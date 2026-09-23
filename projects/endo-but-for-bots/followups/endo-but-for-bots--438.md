---
project: endo-but-for-bots
pr_repo: endojs/endo-but-for-bots
pr_number: 438
created_at: 2026-06-13T06:14:37Z
last_appended_at: 2026-06-13T06:14:37Z
status: parked
---

# Follow-ups for endo-but-for-bots#438

## Items

- [ ] Cascade-residual re-routing on the 36 packages remaining after the harden fix.
  **Source juror(s)**: typist, assessor (round 3, justice 3dfbc3)
  **Round**: 3 (justice)
  **Recommended action**: extend option (a) "fix root cause" to the four other arrow-vs-predicate sites (`packages/pass-style/src/passStyle-helpers.js`, `packages/eventual-send/src/local.js`, `packages/promise-kit/src/memo-race.js`, `packages/ses/src/commons.js`) to clear the predicate-shaped cascade everywhere it appears; open per-package follow-up PRs for the non-predicate error classes (TS2775 implicit-`this` in `compartment-mapper`, `marshal`, `pass-style`, `ses`; TS2344 `unknown` in `eventual-send/src/E.js`; TS2749 value-used-as-type in `ses` and `eventual-send/src/E.js`; TS2339 missing-property in `ses` tests; TS2578 unused `@ts-expect-error` in `pass-style`); or pick option (b) "documented exclusion list" for whatever residual remains after the per-package work. The empirical 3-of-39 yield from the harden site alone falsifies the round-1 panel's "single root cause" framing; the orchestrator's next routing call needs to engage the maintainer with the revised cascade-shape evidence.

- [ ] Pre-existing `TS1003: Identifier expected` in `packages/ocapn/src/syrup/codec.js:218` now visible in CI.
  **Source juror(s)**: integrator (round 3, justice 3dfbc3)
  **Round**: 3 (justice)
  **Recommended action**: open a single-file follow-up PR repairing the JSDoc syntax issue on line 218 (`tsc` also flags this; it predates the PR but was masked by the Go-runtime panic; now that the Gap 2 pin eliminates the panic, the line surfaces as the first lint failure). Once cleared, `typecheck-all` will surface the 36-package `typecheck-packages` residual in CI rather than fail-fasting on the `TS1003`.

- [ ] Pre-push gate `sentence-per-line-md` probe scopes too widely.
  **Source juror(s)**: scribe (round 3, justice 3dfbc3); also flagged by fixer 6beb46
  **Round**: 3 (justice)
  **Recommended action**: the probe scans every changed `.md` file's full body, not just the diff hunks, so pre-existing prose lines (in this case AGENTS.md lines 54, 58, 69 authored on 2026-03-21) surface as violations the PR did not introduce. Either narrow the probe to diff-only hunks, or open a separate maintenance PR sweeping AGENTS.md's pre-existing violations as a clean prerequisite for stricter md-prose enforcement. The probe-side fix is the smaller change and the orthogonal one; surface to the pre-push-gates skill author (gardener).
