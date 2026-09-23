---
ts: 2026-06-03T20:10:04Z
kind: result
role: barrister
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
prs:
  - endojs/endo-but-for-bots#417
refs:
  - entries/2026/06/03/200206Z-dispatch-liaison-c117d2.md
  - entries/2026/06/03/195349Z-result-fixer-48c1e5.md
  - https://github.com/endojs/endo-but-for-bots/pull/417
  - https://github.com/endojs/endo-but-for-bots/pull/417#pullrequestreview-2018822132
---

# result: barrister, code-panel first round on #417

Gamut stage 2 on the mirror of erights's `endojs/endo#3164`. Cleaner ran stage 1; this is the first formal panel verdict.

## Overall verdict: must-fix-loop (2 items)

Two load-bearing runtime bugs in the new `freezable-typedarray-pony.js` module. Next gamut step is fixer with the two must-fix-loop items inline plus the summary-fix bundle. After fixer lands, the orchestrator dispatches the justice (not the barrister) for the re-run per `roles/barrister/AGENT.md` § Hand off to the justice on the next round.

## Posted review

- ID: `PRR_kwDORRE4FM8AAAABB5fa9A`
- URL: https://github.com/endojs/endo-but-for-bots/pull/417#pullrequestreview (commit oid `984b5d4df`)
- State: `COMMENTED` (self-review fallback per `skills/panel-review/SKILL.md` § Pitfalls; PR author and reviewer are both `kriscendobot`, so the GraphQL `--request-changes` was rejected with "Can not request changes on your own pull request"; body preserves the "Must fix before merge" heading the orchestrator's dispatch matrix keys on for bot-authored PRs).
- Inline comments: 0 (the panel ran in-band-fallback mode without thread-attached comments; every finding lives in the top-level review body as `file:line` references; per the dispatch's per-action authorization only the top-level review was authorized).
- Body length: 1798 words (within the in-band-fallback 16-seat range; the 2300-3600 envelope in `skills/panel-review/SKILL.md` is the multi-seat-dispatch target).
- Copilot reviewer added (fire-and-forget per `skills/panel-review/SKILL.md` § Concurrent dispatch; idempotent on re-rounds).

## Panel composition (16 seats)

Per `bash garden/skills/panel-hints/panel-hints.sh --base master` against the project worktree at head `984b5d4df`:

```
Panel-kind: code-panel
Always-on core (9): assessor, typist, stylist, packager, archivist, prover, saboteur, integrator, corner-prober
Always-fire (2): scribe, releaser
Path-triggered (2): fast-checker, migrator
  fast-checker  packages/immutable-arraybuffer/test/freezable-typedarray-pony.test.js
  migrator  2 packages touched
Content-triggered (3): engine-realist, spec-keeper, warden
  engine-realist  matched: WeakMap
  spec-keeper  matched: shim
  warden  matched: globalThis
Cross-panel (0): -
Suppressed (12): benchmarker, breaker, changeset-auditor, curator, gateway, pruner, surfacer, locksmith, purist, wire-watcher, copyeditor, pedant
Recommended total: 16 of 26 code-panel seats (+ 0 cross-panel).
```

The barrister adopted the script's recommendation verbatim; no per-judge overrides. Execution mode: **in-band-fallback** (Agent tool not in scope on this dispatch; one-shot ToolSearch probe returned no match).

## Per-juror brief verdicts

(In-band mode: each seat's per-juror block was written one at a time against the seat's `roles/jurors/<seat>/AGENT.md` primary surface; aggregation ran after all blocks landed. Brief verdicts summarized below.)

- **assessor** (correctness/control flow): request-changes. Found the line-65 wrong-constructor bug (the panel's first must-fix-loop) and the line-193 weakMapSet receiver+wrapper bug (the second must-fix-loop). Both are runtime defects on the brand-check path.
- **typist** (types/JSDoc): comment-only. The `// @ts-expect-error testing purposeful type violation` swaps in pony-slice / shim-slice are an improvement over the prior `// @ts-nocheck` (acknowledge). The new `@typedef {... TypedArray}` block in pony-internal.js is correctly shaped.
- **stylist** (naming): comment-only. `TypeArray` (missing `d`) typos in new JSDoc at pony-internal.js:7,52,59,63 (summary-fix). New test title at shim-slice.test.js:238 uses `TypeArray` and `subArray` (summary-fix).
- **packager** (diff hygiene): comment-only. The pony-internal.js extraction is a clean copy-and-modify (similarity 50% per git); the pony.js reduction to a 7-line re-export is intentional (acknowledge). No surplus files.
- **archivist** (docs/JSDoc): comment-only. JSDoc additions are substantive (FERAL_GET_ARRAY_BUFFER, ArrayBufferTransfer callback typedef, hiddenBuffers / reverseHiddenBuffers NOTEs); only the `TypeArray` typos drag the seat into summary-fix.
- **prover** (regression evidence): request-changes. Zero tests for the new `freezable-typedarray-pony.js` module; the single test body is `t.pass('placeholder')` and exercises neither imported symbol. Summary-fix to add minimal coverage (which would also catch the line-193 bug).
- **saboteur** (adversarial inputs): comment-only. The brand-check pattern is intact for the future case the line-193 fix lands; before that fix, every `PseudoTypedArray` instance is broken on construction. Once fixed, the warden's earlier `apply(weakMapGet, ...)` pattern is robust against prototype tampering.
- **integrator** (integration coherence): comment-only. The new module exports two symbols that nothing in the package imports yet (`virtualTypedArrayBufferGetter`, `makePseudoTypedArrayConstructor`); the permits.js slot is similarly inert (summary-fix to either wire or annotate). False-positive on permit shape for `@@iterator` / `@@toStringTag` (drop).
- **corner-prober** (edge/corner cases): comment-only. Drop on the `if (result)` brand-check (matches sibling `getHiddenBuffer` pattern; not a real corner case). The genuine corner is the unhandled subclass branch at line 178-182, which is a TypeError throw rather than silent breakage (acknowledge).
- **scribe** (PR-comment history closure): comment-only. The PR body and cleaner's prior comment correctly cross-link the upstream PR; the panel review body lands with the same cross-link.
- **releaser** (upgrading-user perspective): comment-only. No `.changeset/*` entry. On a non-mirror PR this would be must-fix; on a mirror of a WIP upstream the natural home for the changeset is the upstream PR. Filed as follow-up against merge-time.
- **fast-checker** (property-based tests): comment-only. Once the line-193 bug is fixed, the freezable-typedarray module is a prime candidate for `fast-check`-shaped tests on the brand-check WeakMap and the redirected-query semantics (follow-up rather than this-round summary-fix; bar is "minimum viable coverage" first).
- **migrator** (multi-package coordination): comment-only. The ses permits-slot addition coordinates with the immutable-arraybuffer freezable-typedarray module; when the shim wiring lands the migration story will be "version bump both packages together" (follow-up).
- **engine-realist** (WeakMap/vat/durability): comment-only. The two WeakMaps (`hiddenTypedArrays`, `reverseHiddenBuffers`) are both well-formed and use the `apply(weakMapGet, ...)` defensive pattern. The line-193 bug is a coding bug, not a WeakMap-semantics issue (the seat concurs with assessor that it is must-fix-loop).
- **spec-keeper** (TC39/spec fidelity): comment-only. The `%FreezableTypedArrayPrototype%` permits slot lists the full TC39-spec TypedArray prototype member set including stage 3 `at` / `findLast` / `toReversed` / `toSorted` / `with`. Comment correctly notes "If this exists, it is purely an artifact of how we currently shim transferToImmutable" (acknowledge that the slot represents a non-spec engineered prototype).
- **warden** (SES hazards): comment-only. `freezable-typedarray-pony.js` does not freeze its exported functions, breaking the sibling-file convention (summary-fix). The `apply(weakMapGet, hiddenTypedArrays, [this]) || this` fallback at line 82 (the virtualTypedArrayBufferGetter) is the load-bearing capability; it correctly handles both genuine and emulated TypedArrays without leaking the hidden TypedArray.

## Disposition counts

- must-fix-loop: 2 (both in `freezable-typedarray-pony.js`)
- summary-fix: 5 (typos × 2, test-title sweep, freeze sweep, permits annotation)
- follow-up: 3 (rebase artifact; second-round panel after shim wiring; changeset on merge)
- acknowledge: 3 (pony.js reduction; globalThis directive; ts-expect-error narrowing)
- drop: 2 (corner-prober brand-check false-positive; integrator permit-shape false-positive)
- Total findings: 15

## Post-loop actions deferred

Per `roles/barrister/AGENT.md` § Operating norms, post-loop actions (summary-fix job, followup ledger, gardener proposed-rule message, appellate, `gh pr ready`) fire **only on terminating first rounds**. This round did not terminate (2 must-fix-loop items present), so:

- No `summary-fix` job posted. The summary-fix bundle is inlined in the review body; the fixer reads them alongside the must-fix-loop items in the next dispatch. When the justice runs the re-panel and finds 0 must-fix-loop, the summary-fix bundle (if any survives at that round) is what gets posted.
- No follow-up ledger append. The three follow-up items above are inlined in the review body for the maintainer's reference; the justice's terminating round is the canonical ledger-write moment.
- No proposed-rule message to gardener. The two `[proposed-rule]` tags (test-title naming, permits-slot-without-installer annotation) wait for the justice's terminating round to surface to the gardener.
- No appellate dispatch. Appellate runs on first-round termination, not on a non-terminating first round.
- No `gh pr ready`. Un-draft happens at gamut termination.

## Next gamut stage

The liaison drives the next stage per the dispatch's verdict matrix: `must-fix-loop` → fixer (with the two must-fix-loop items inline plus the summary-fix bundle) → justice (re-panel after fixer's `result` lands). The bot-self-review caveat carries through to the justice (the same identity will run the next panel; the justice's re-run also falls back to `--comment` with the heading-keyed body).

## Authorizations respected

- Convened the panel per role file: in-band-fallback mode for 16 seats. Authorized.
- Posted a `kriscendobot`-authored review on #417 (self-review fallback to `--comment`): https://github.com/endojs/endo-but-for-bots/pull/417 review ID `PRR_kwDORRE4FM8AAAABB5fa9A`. Authorized.
- Added `@copilot` reviewer (fire-and-forget per `skills/panel-review/SKILL.md`). Authorized as part of the panel convene step.
- Did not modify source files (no fixer-style commits). Respected.
- Did not force-push, did not un-draft, did not touch upstream `endojs/endo`. Respected.
- Did not post out-of-formal-review comments or thread replies. Respected.

Self-improvement: nothing this time. The in-band-fallback mode worked smoothly on a 16-seat code panel with one mixed source-and-test diff and a permits-slot change; the panel-hints script gave the right composition with no judge-side overrides needed. The two must-fix-loop bugs in `freezable-typedarray-pony.js` (line 65 wrong constructor, line 193 weakMapSet receiver+wrapper) are mechanically obvious once read line-by-line and would have been caught by even minimal test coverage on the module; the disposition layer routes the coverage gap itself as a summary-fix so the next round picks it up.
