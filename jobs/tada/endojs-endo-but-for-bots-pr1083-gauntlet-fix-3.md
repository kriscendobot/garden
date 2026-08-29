Confirmed: `CI GREEN`, `CI_RC=0`, head `293b6eb03`, PR `MERGEABLE`.

## Completion report — FIX round 3, endojs/endo-but-for-bots PR #1083

**Panel must-fix items applied** (design-only PR: `designs/npm-registry-as-directory-tree.md` + `designs/README.md`), commit `71a9c0d72`:

- **critic** — Migration step 2 now names the concrete worker-dispatch surface that changes (the `registry` `FormulaIdentifier` slot on `MakeFromPackageFormula`, the `registryP` dispatch arg) and notes `daemon-worker-import-from-mount` needs a companion revision; step 4 now states the deprecated adapter catches the tree's not-found `RangeError` and returns `undefined` to reconcile with the shipped `EndoRegistry.lookup` contract.
- **skeptic** — Added a mechanical enforcement seam for the resolver's vat-colocation invariant (an instrumented-tree dispatch-count assertion) plus a testing-plan bullet; added a deprecated-adapter test line asserting old-shape calls still return old-shape results.
- **decomplector** — Made the value-vs-place temporal contract observable at the capability layer via a `getInfo()` `temporal` descriptor (`'stable'` root / `'live'` package dir), not only prose.
- **ergonomist** — Distinguished the slash-bearing single-segment `lookup('@endo/patterns')` error from a plain not-found; specified the absent-method rejection shape for `list()` on a lookup-only hub; both asserted in the conformance suite.
- **pedant** — Removed the em-dash pair in the resolver section (design doc now has zero em-dashes).
- **novice** — Defined "XS" at first use; added forward pointers for `LookupTree`/`EnumerableTree` and `RegistryResolution` used before definition.
- **copyeditor/pedant comment-only** — Split the tangled migration step-3 sentence; dropped trailing periods on the new README table cells for column consistency.

**Base-advance conflict resolved (this was blocking CI).** On resume I found the head had **zero CI checks** and GitHub reporting `CONFLICTING/dirty`: upstream `endojs/endo-but-for-bots@llm` had advanced to `38ca1d189` and my head conflicted on `designs/README.md`'s rolling index rows, so GitHub could not build the test-merge commit and never scheduled `pull_request` CI. Merged upstream `llm` into the head (merge commit `293b6eb03`), resolving the sole conflict by keeping my M3 rename (`registry-capability` → `npm-registry-as-directory-tree`) and taking upstream's independent M4 edit (adds `cbor-encode-decode`, 9 items). Pushed in advance mode; the panel-reviewed commits are preserved intact.

**CI:** all 5 checks (build, test, lint, browser-tests, zizmor) completed **success**; `ci-wait-merge.sh --no-merge` exited **rc 0 (GREEN)**. PR is `MERGEABLE`.

**Follow-ups:** none required for this stage. The gauntlet driver re-posts panel-4 next. Note for future stages: this PR's base `llm` mirror on the kriscendobot fork lags upstream endojs; base-advance README-index conflicts on this long-lived design branch are likely to recur and may need a weave.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1083-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 116 tokens (6188396 cached reads)
- Output: 44231 tokens
- Cost: $6.30941
- Wall-clock: 1672s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
