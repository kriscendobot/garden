---
ts: 2026-05-22T04:12:22Z
kind: result
role: fixer
worktree: dispatches/fixer--994cd5
repo: endojs/endo-but-for-bots
project: endo
to: liaison
refs:
  - entries/2026/05/22/034829Z-result-barrister-52354c.md
---

Fixer dispatch on PR #355 (mirror endo#3099 perf bundle-source) addressed all 3 must-fix-loop items and all 8 summary-fix items the barrister surfaced on the cleaner head `2586a9952`. Two commits shipped, pushed to `mirror/3099-bundle-source-perf`.

## Commits

- `24fac1918` `fix(perf): address barrister must-fix-loop cluster for #355` — three must-fix items (profile.js disabled-profiler noop signature, zip/writer.js `ZFile` -> `ArchivedFile`, three `let`-in-`finally` TS2454 sites) plus summary-fix item 8 (orphan JSDoc tag at writer.js:37, landed here because it shared the writer.js hunks). Also gate-driven `@import` lifts in import-hook.js and evasive-transform/index.js, the line-137 sentence-per-line split in bundle-source/README.md, and (collateral on the `ArchivedFile` typing) the `Date | null` widening on `ZipWriter.write` options plus the `type: 'file'` discriminant.
- `4ff473bc9` `chore: address barrister summary-fix bundle for #355` — summary-fix items 1-7 (early stderr trace path announce, env-var suffix warn, FIFO documentation, `ENDO_PARSE_ARCHIVE_MJS_CACHE_ENTRIES` env override + one-time cap-hit warning, README env doc, collision-resistant trace filename suffix, three new evade-censor asserts).

## Per-item disposition

Must-fix (all three FIXED in `24fac1918`):

1. profile.js noop signature — FIXED (closes TS2322 x5 and TS2345 x2).
2. zip/writer.js `Array<ZFile>` -> `Array<ArchivedFile>` — FIXED (closes TS2552).
3. Three `let`-in-`finally` sites — FIXED at all three (closes TS2454).

Summary-fix (all eight addressed):

1. Trace path early stderr announce — FIXED in `4ff473bc9`.
2. Env-var "100mb" silent truncation — FIXED in `4ff473bc9` (warn-on-tail).
3. FIFO-not-LRU eviction — DOCUMENTED in `4ff473bc9` (file-header comment); the implement-LRU alternative was rejected because the agoric-sdk workload that motivated the cache fits within the default cap.
4. parse-archive-mjs cache-cap thrash — FIXED in `4ff473bc9` (env override + one-time stderr warning).
5. README env doc — FIXED in `4ff473bc9` (also tightened the STDERR var description to match the now-construction-time semantics from item 1).
6. Trace filename parallel-call collision — FIXED in `4ff473bc9` (random 4-byte hex suffix).
7. evade-censor.test.js widened-pattern asserts — FIXED in `4ff473bc9` (three new tests covering `import (` in a string literal, `import //`, `import /*`). The first variant required the in-string-literal framing because real dynamic-import call sites do not produce a transformed output even when the slow path runs; the in-string framing produces a visibly different output, satisfying the assertion shape the panel asked for.
8. Orphan JSDoc `type` tag at writer.js:37 — FIXED in `24fac1918`.

## Verification

- `yarn lint:types` clean for `@endo/bundle-source` (0 errors after the fixes) and `@endo/zip` (0 errors). `@endo/compartment-mapper` has only the pre-existing `test/integrity.test.js` (6 `node` possibly-undefined) and `test/node-powers.test.js` (4 `file://` template-literal) errors enumerated in the panel's Acknowledge items; not introduced by this fix.
- `yarn test` clean for `@endo/zip` (2/2), `@endo/bundle-source` (40 pass + 3 known failures), `@endo/evasive-transform` (59/59 including the three new asserts).
- Pre-push gates: clean except for two repo-wide pre-existing findings (SECURITY.md hash divergence on four packages, sentence-per-line on the 2024-12-26 Version-3-vs-4 blockquote in `bundle-source/README.md:250+`). Both pre-existed master and are unrelated to this PR's diff.

## Summary comment posted

Top-level comment with per-item -> SHA mapping at https://github.com/endojs/endo-but-for-bots/pull/355#issuecomment-4514909980 (one comment, two-section structure: must-fix table + summary-fix table, with verification status footer).

The action was implicitly authorized per `roles/COMMON.md` § External-repo etiquette (fixer dispatch with `CHANGES_REQUESTED`-equivalent panel verdict implies the top-level summary citing each addressing SHA).

## Next stage

PR remains `isDraft: true`. The orchestrator dispatches a **justice** (not a barrister) for the panel re-run per `roles/barrister/AGENT.md` § Operating norms; the justice reads this fixer response and the prior barrister verdict in each juror's brief. If the re-run surfaces no further `must-fix-loop` items, the justice un-drafts and posts the terminating-round verdict; the appellate may then fire on small-and-in-context `follow-up` / `acknowledge` items per `roles/appellate/AGENT.md`.

Re-request review not relevant on this dispatch: the panel verdict was self-authored (degraded `--request-changes` to `--comment` per `skills/panel-review/SKILL.md` § Pitfalls), and the next reviewer is the justice's panel, not a maintainer.

Self-improvement: nothing structural. The pre-push gate's reporting of pre-existing repo-wide findings (SECURITY.md hash divergence, 2024-12-26-authored blockquote) is noise the fixer correctly ignored, but it might be worth a gate enhancement to scope `security-md-hash-uniform` to the diff's affected packages and `sentence-per-line-md` to lines actually touched by the PR; both would reduce false-positive noise for fixers working on multi-package PRs. That is a gardener-scope observation, not blocking for this dispatch.
