Confirmed. PR #259 implements exactly this design — the same `universalPropertyNames` entries, the same permits subtrees (with `encodeInto`/`ignoreBOM` etc.), tests, and changeset. My local re-implementation is redundant; I'm discarding it and surfacing the existing PR rather than opening a duplicate.

## Completion report

**Job:** Build the hardened `TextEncoder`/`TextDecoder` vetted shim in `endojs/endo-but-for-bots` per design `hardened-text-codecs-shim` (M2).

**Outcome: no new PR opened — the work is already complete in PR #259.**

The pre-flight duplicate check (a builder norm) found an existing open PR that fully implements this design:

- **PR #259** — *"feat(ses): permit TextEncoder and TextDecoder as universal intrinsics"*, by kriscendobot, base `master`, head `feat/hardened-text-codecs-shim`.
- **State:** OPEN, **not draft** (the gauntlet already ran and un-drafted it), `mergeable: MERGEABLE`, `mergeStateStatus: CLEAN`.
- **CI:** every check green — including `test-xs`, `test262` (22.x/24.x), `test-hermes`, `cover`, `lint`, `build`, and the full Node test matrix.
- **Files:** `packages/ses/src/permits.js` (adds `TextEncoder`/`TextDecoder` to `universalPropertyNames` plus the two permits subtrees), `packages/ses/src/cauterize-property.js`, `packages/ses/test/text-codecs.test.js`, `packages/ses/test/text-codecs-missing.test.js`, and `.changeset/hardened-text-codecs.md`. This is Phases 1 and 2 of the design, exactly what the job scoped.

**What I did:** Set up an isolated project worktree, independently implemented the shim (permits entries on `universalPropertyNames`, the `%TextEncoderPrototype%`/`%TextDecoderPrototype%` permit subtrees, plus a present-codecs test and a host-without-codecs degradation test and a changeset), bootstrapped the SES package, and verified my version green — the new tests passed, the full `ses` ava suite passed (347 passed, 1 pre-existing known-failure, 2 skipped), and lint was clean. That work confirmed the design is correct and buildable, but on discovering PR #259 already carries an equivalent, CI-green, merge-ready implementation, I **did not open a duplicate PR** and discarded my local branch (per the "verify no open PR already implements the issue / skip and surface it" builder rule, and the standing "no inter-instance GitHub loops" rule — kriscendobot is a sibling instance, so I did not touch its PR).

**Follow-ups for the maintainer/liaison:**
1. **PR #259 is ready to merge** — non-draft, mergeable, fully green. M2's "hardened text codecs" hygiene row is effectively done pending merge; a `merge #259` (conductor) job is the only remaining action.
2. **Design-status drift:** `designs/hardened-text-codecs-shim.md` (on `llm`) still reads **Status: Not Started**, which is what caused this job to be posted as a fresh build. Its status should be advanced to reflect the merge-ready PR so the M2 row isn't re-dispatched again. (Phase 3, the downstream `Buffer.from(...)` / `.toString('utf...')` audit, remains a separate informational follow-up per the design and PR #259's "Out of scope" note.)
