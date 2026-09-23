---
ts: 2026-05-20T22:37:47Z
kind: result
role: fixer
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
worktree: dispatches/fixer--87a38b/project
---

Cleared the PR #75 CI `lint` TS2352 at
`packages/ses/src/compartment.js:363:21`.

**Root cause:**

The prior fixer commit `82c16b62a` ("style: clear two jsdoc lint
warnings exposed in PR #75 CI") merged the two adjacent JSDoc blocks
above the inner `Compartment(...args)` function into one block,
keeping the original `@param {...CompartmentOptionsArgs|LegacyCompartmentOptionsArgs}`
verbatim. That preserved the JSDoc rest sigil (`...`), so TypeScript
typed `args` as `(CompartmentOptionsArgs|LegacyCompartmentOptionsArgs)[]`
(array of tuples).

The compartmentOptions call site casts the spread argument to
`Parameters<typeof compartmentOptions>`. Because `compartmentOptions`
has `@param {CompartmentOptionsArgs|LegacyCompartmentOptionsArgs} args`
(no `...` sigil), TypeScript resolves `Parameters<>` to the bare tuple
union `CompartmentOptionsArgs|LegacyCompartmentOptionsArgs`. Array-of-
tuples to single-tuple has no sufficient overlap; the cast was rejected
with TS2352. The eslint lint pass missed it; only the typedoc tsc pass
in the `build API docs` CI step catches it.

The fix is a single-character edit: drop the `...` sigil from the
inner JSDoc so both sites declare args identically as the tuple union,
making the cast a no-op same-type cast. The `@this {Compartment}`
co-tenant in the same block survives unchanged.

**Fix commit:** `04abbe381` (`fix(ses): tuple-typed args restores
Parameters<typeof compartmentOptions> overlap`).

**Push:** `git push origin HEAD:kriskowal-random-chacha12` succeeded
(`b3d4c637b..04abbe381`). The first push attempt hit non-fast-forward
because the remote had advanced (the prior fixer's `82c16b62a` plus a
later `b3d4c637b chore: regenerate composite tsconfigs` had landed
after dispatch-prepare); fetched, rebased my one commit onto
`origin/kriskowal-random-chacha12`, resolved the conflict in
`compartment.js` by taking my dropped-`...` version against the
remote's preserved-`...` version, then re-pushed.

**Verification:**

- `yarn docs` (the CI step that surfaced the TS2352) now reports
  `Found 0 errors and 68 warnings`.
- `yarn lint` in `packages/ses/` returns clean (the prior
  jsdoc/require-param warning is also gone because the two blocks
  remain merged).

**Pre-push gate** (`pre-push-gates.sh` from `project/`, default
mode): stages 1 (`yarn format`) and 2 (`yarn lint --fix`) passed
clean after my edits. Stage 3 probes reported the same four findings
the prior fixer documented in `035441Z-result-fixer-8095e1.md` —
`no-inline-import-jsdoc` on `packages/evasive-transform/src/index.js:23,26`,
`security-md-hash-uniform` (whole-repo SECURITY.md hash divergence),
`sentence-per-line-md` on `AGENTS.md` and others, and
`test-package-no-main` on `packages/chacha12-fast-check-test/package.json`.
All four are pre-existing repo-wide items on paths the dispatch did
not touch and are out of scope per the dispatch's "diff-only scoping"
note. Stage 4 (`yarn typecheck`) skipped (no script).

**External-repo etiquette:** no comments, reviews, reactjis, or
re-request-review actions taken; the dispatch did not stage any of
those authorizations.

Self-improvement: a `pre-push-gates.sh` stage-3 follow-up worth
considering: a probe `no-jsdoc-rest-sigil-with-tuple-param` that
flags `@param {...Tuple|Tuple}` where the implementation uses
`(...args)` and a sibling function with the same param shape uses
the non-rest sigil. The TS2352 here is invisible to `yarn lint:eslint`
because it surfaces only in the typedoc CI step, so the gate's
stage-4 `yarn typecheck` does not catch it either when the project's
typecheck script delegates to a different tsconfig from typedoc's.
Below the threshold for a routed message this round (one observed
instance, narrow scope); flagging here for the next time a similar
finding surfaces.
