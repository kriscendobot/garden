---
project: endo-but-for-bots
pr_repo: endojs/endo-but-for-bots
pr_number: 323
upstream_mirror_repo: null
upstream_mirror_pr: null
created_at: 2026-05-20T23:19:10Z
last_appended_at: 2026-05-20T23:19:10Z
status: parked
---

# Follow-ups for endojs/endo-but-for-bots#323

Created from the code-panel verdict (23 seats, in-band fallback) on the G14 LICENSE aggregation PR (`feat/familiar-license-aggregation`). The PR ships the aggregator, the verifier-gated CI step, and the distributable-side attribution copy that G14 of `designs/familiar-release.md` (#231) calls for. Five deferrals warrant revisit when the PR merges.

## Items

- [ ] **First-party @endo/relay-server attribution gap.**
  **Source juror(s)**: curator, migrator.
  **Round**: 1.
  **Recommended action**: open a follow-up PR that either adds a LICENSE file to `packages/relay-server/` or declares the license in `packages/relay-server/package.json`. The PR's local-run report ("1 first-party @endo gap flagged: `@endo/relay-server@0.1.0`") confirms the gap; the aggregator's first-party verification flagged it precisely as designed. Out of scope for the G14 deliverable; in scope for repo hygiene.

- [ ] **Bundles artifact bloat from .metafiles/ directory.**
  **Source juror(s)**: engine-realist, packager.
  **Round**: 1.
  **Recommended action**: in a follow-up CI hygiene PR, either exclude `packages/familiar/bundles/.metafiles/` from the `bundles` artifact upload in `build-artifacts` (add a `paths-exclude` or use `upload-artifact`'s `excludes:` field) or split the metafiles into a separate `bundles-metafiles` artifact consumed only by the aggregator step. The metafiles are ~10MB-class JSON enumerating every esbuild input; they are downloaded by every make matrix runner and never read there.

- [ ] **Attribution drift across peer-dep boundaries.**
  **Source juror(s)**: wire-watcher, migrator.
  **Round**: 1.
  **Recommended action**: when the chat dist's transitive surface grows, reconcile the aggregator's `node_modules`-walk against the consumer's `yarn.lock` so the recorded `name@version` matches the version actually resolved by the lockfile. The current code walks `dependencies` plus `peerDependencies` from the on-disk `node_modules` tree, which can drift from the lockfile under peer-dep version selection. Low priority at MVR scale; revisit when the Vite-bundled surface materially grows.

- [ ] **Electron framework attribution coverage.**
  **Source juror(s)**: integrator, locksmith.
  **Round**: 1.
  **Recommended action**: either (a) extend `aggregate-licenses.mjs` to walk the `Electron.app/Contents/Frameworks/Electron Framework.framework/Versions/A/Resources/` LICENSE and `LICENSES.chromium.html` files into the aggregated output, or (b) land a `LICENSE.README.md` (or analogous) in the distributable that points the reader at the framework-attribution paths within the bundle. The G14 design statement ("the packaged app must ship third-party attribution") is satisfied by the latter only if a user can locate the framework attribution from the binary alone. The current PR explicitly scopes Electron framework attribution out, and the design accepts that scoping; the follow-up closes the loop.

- [ ] **Unit-test coverage for the aggregator.**
  **Source juror(s)**: prover, assessor.
  **Round**: 1.
  **Recommended action**: open a follow-up test PR that adds a `packages/familiar/test/aggregate-licenses.test.js` (or `.mjs`) that points the aggregator at a fixture `node_modules` tree plus a fixture metafile, asserts the emitted file shape, and exercises the LICENSE-filename priority list, the malformed-package.json tolerance path, the per-file / per-SPDX / per-missing classifier, the first-party vs third-party partition, and each of the `--verify` / `--verify-only` / write-only flag-matrix branches. CI's existing integration step covers the happy path; unit tests pin the script's load-bearing branches against future refactors.
