The PR is `MERGEABLE` against the advanced base. All work is complete and verified.

---

## Completion report — `endojs-endo-but-for-bots-pr440-preact-views`

**Done.** Converted PR #440's formula-inspector chat views to confined Preact, advancing the PR across the conversion that had landed underneath it.

### What I did

1. **Advanced the base across the conversion.** PR #440's frozen base `llm-6d889af` predated #471/#516 — it had `preact-container` but not the `space-*` packages, and the value modal was still the imperative `packages/chat/value-component.js` that #516 deleted and moved to `@endo/spaces-util`. Re-snapshotted a fresh frozen base `llm-f1a786a` (current `llm`), pushed it, and rebased. The daemon (`getFormula`, `formula-record.js`, retire `@info`) and CLI (`endo inspect`) commits **cherry-picked cleanly** (those files were byte-identical between old and new base); the chat views were rebuilt. Updated the PR's base field to `llm-f1a786a`.

2. **Rebuilt the views as confined Preact** in `@endo/spaces-util` (the modal's new home):
   - `formula-view.js` — `FormulaView` renders a `FormulaRecord` as a confined vnode. **Untrusted daemon property values, identifiers, and reference-list keys reach the DOM only as escaped text through `renderConfined`** — the substance of kumavis's ask, closing the XSS surface the imperative code hand-escaped.
   - `formula-view-registry.js` — carried verbatim, including **`keypair` `privateKey` suppression**.
   - `value-component.js` — the post-#516 modal grew the card-flip back face: F/gear/flip toggle, `getFormula` fetch + cache, reference navigation via `lookupById` + Backspace back stack, remote fallback, readable-tree children on both faces, aria-live, focus capture/restore — formula view and tree both rendered through `renderConfined`. No `chat.js` change needed (modal owns its frame).
   - `index.css` — 3D flip (reduced-motion cross-fade), formula-view, value-tree styles.

3. **Ported all three test suites** to the new shape + happy-dom confined-render harness; kept the `test.fixme` e2e stub.

4. **Folded in kriskowal's open 2026-06-15 CHANGES_REQUESTED** (the only inline ask: changeset must cover chat) — changeset now lists `@endo/spaces-util` + `@endo/chat`; replied in-thread.

5. Posted a top-level summary comment (head SHA + what changed + verification).

### Verification
- `yarn ava` (packages/chat): **39 tests pass** (formula-view 11, registry 7, flip 14, existing value-component 7) — including privateKey-never-in-DOM, flip semantics, reference nav, remote fallback, focus restore.
- `tsc --noEmit` (spaces-util): **0 errors**. `eslint`: 0 errors (only pre-existing `safe-await-separator` warnings that `llm` already carries). `formula-record.test.js`: passes on new base.
- PR is **MERGEABLE**; head `a59c665c9`.

### Follow-ups / notes
- The full daemon `endo.test.js` (heavy daemon-fork integration test, part of the clean-cherry-picked daemon commit) was **not** re-run locally — it's identical to the original PR's CI run since host.js/endo.test.js were unchanged between the two bases; CI will exercise it. The fast `formula-record.test.js` unit test passes.
- Skipped the original PR's unrelated `@playwright/test` version bump (orthogonal test-tooling churn that would have forced a yarn.lock change; the e2e spec is `fixme`).
- No yarn.lock commit needed — the only `package.json` edit was adding two `exports` entries to `@endo/spaces-util` (no dependency change).
- Old frozen base `llm-6d889af` is left in place (sweep on PR close, per `frozen-base-branch`).
