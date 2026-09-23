All three daemon must-fix findings are addressed, verified, pushed, and dispositioned. Here is my completion report.

---

## Completion report — PR #910 panel response, child 04/10: `daemon` slice, must-fix

**Slice scope:** 3 must-fix findings (DMN-01, DMN-02, DMN-03). All fixed. No refutals, no deferrals within the must-fix daemon slice.

**Code commit:** `c5e8ea35f` pushed as a follow-up on `feat-readableblob-range-attenuation` (rebased over the platform child's `2ef332079`; no force-push).

### Fixed

- **DMN-01** (14-seat, most-corroborated) — `mount.js` `hashBytes` was casting `undefined` past tsc (`/** @type {() => Sha256} */ (makeSha256)()`), so `range().getInfo()` on any mount not built by `manager.js` crashed with a bare `TypeError: makeSha256 is not a function`. Removed the type-laundering cast; `hashBytes` now `throw`s a located `@endo/errors` `Fail` naming the missing power. Weighed and rejected two menu options with reasons recorded in the checklist: `filePowers` can't back it (its `sha256(path)` is a whole-file-by-path hash, not a byte digester), and a construction-time hard-require would break ~25 legit `makeMount` sites that never call `getInfo`. Added two mount tests — one threads a real `makeSha256` and asserts a derived range's `{algorithm,hash,size}`; one pins the located error when the power is absent.
- **DMN-02** — `generate-help-text-data.mjs` now Prettier-formats its output (resolving the repo config) before writing, so regeneration is idempotent and no longer re-breaks CI lint that a hand-Prettier'd artifact would revert.
- **DMN-03** — added `glob` / `grep` / `glorp` sections to `help.md` (live guards existed but `help.md` never carried them, so the prior regeneration deleted the only copy) and regenerated `help-text-data.js`. `E(mount).help('glob'|'grep'|'glorp')` returns text again.

### Local verification (per local-verify / pre-push-gates)
- `tsc` (daemon `lint:types`): clean.
- `eslint`: 0 errors (only pre-existing warnings, none from new code).
- `prettier --check` on all five touched files: clean.
- `ava`: `mount.test.js` 77 passed (incl. both new tests), conformance + glob/grep/glorp 43 passed, help-text + helpdown 23 passed.

### Journal
Checklist `artifacts/pr910-panel-findings.md` updated with DMN-01/02/03 dispositions and landed on `origin/journal2` (base-blob-guarded via `land-journal-edit.sh`, preserving the platform child's dispositions).

### Follow-ups (not my slice; noted for orchestration)
- DMN-04/05/06 are should-fix daemon (a sibling child owns them).
- DMN-01's deeper "make getInfo work everywhere" would require threading `makeSha256` through the ~25 non-manager call sites (tests, agent-tools, agentry); left as a broader follow-up since the interface promise is now honored where the power is supplied and fails loudly + located where it isn't.

No un-draft, no merge, no panel re-run.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/pr910-panel-response-04-mustfix-daemon.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 120 tokens (6371863 cached reads)
- Output: 34940 tokens
- Cost: $5.3013825000000026
- Wall-clock: 600s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
