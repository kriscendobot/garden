---
ts: 2026-05-20T06:44:14Z
kind: result
role: builder
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
---

G14 from PR #231 design (`designs/familiar-release.md` L375): "third-party LICENSE aggregation in `make-distributables.mjs`. Please dispatch a builder." Delivered as PR #323 (draft, base `llm`).

Branch: `feat/familiar-license-aggregation`. Commit `62a2645e6`. PR URL: https://github.com/endojs/endo-but-for-bots/pull/323

Pipeline change in `packages/familiar/scripts/`:

1. `bundle.mjs` emits an esbuild metafile per build to `bundles/.metafiles/<name>.json` via a single `buildWithMetafile()` wrapper that replaces all six `build()` call sites.
2. New `aggregate-licenses.mjs` reads every metafile, walks each input file up to its nearest named `package.json`, dedupes by `name@version`, and emits `bundles/LICENSE.third-party.txt`. Also walks the transitive production dep tree of `@endo/chat` to cover the Vite bundle.
3. `make-distributables.mjs` copies the aggregated file into `out/make/LICENSE.third-party.txt` next to each platform archive.
4. `build.mjs` invokes the aggregator between bundle and prepare.
5. `.github/workflows/familiar-release.yml` adds a "Aggregate and verify third-party licenses" step after the bundle step with `--verify`; the step fails the build when any production dep ships with neither a LICENSE file nor a declared license.

Aggregated file format: `Package`, `Version`, `License`, `Repository` heading followed by the full LICENSE file text, or an SPDX-only note when the package omits LICENSE (libp2p / multiformats / etc.) but declares the SPDX expression.

Verification classifier: `file` (LICENSE shipped) or `spdx` (declared license, no file) both pass; only `missing` (neither) fails verify. `@endo/*` packages excluded from the aggregated file (covered by repo's top-level LICENSE) but still verified locally; missing-license gaps there are reported as in-repo bugs.

Local run on `origin/llm` (HEAD `5a63ea22f`): 84 third-party packages emitted, 16 SPDX-only, 0 verify failures. One first-party gap surfaced (`@endo/relay-server@0.1.0` has neither LICENSE file nor declared license); out of scope for this PR.

Pre-push gates: `yarn format` (auto-fixed and re-staged, no diff beyond my files), `yarn lint` (1 pre-existing warning on `daemon-manager.js`), `yarn typecheck` (clean for familiar package). Repo-wide gate failures (`security-md-hash-uniform`, broader lint errors in `errors/test/deep-stacks.test.js` etc.) are pre-existing and not related to this PR; unrelated auto-fix mutations from `yarn lint --fix` were discarded before commit.

Out of scope (called out in PR body): Electron's framework licenses (Chromium, V8) bundled by @electron/packager into the .app framework dir, and the embedded Node.js binary's attribution (lives in upstream distributions).

Self-improvement: the `pre-push-gates.sh` script's `yarn lint --fix` stage operates repo-wide and mutates files outside the PR's target package. The builder must check `git status` after the gate and discard unrelated working-tree changes before staging. Worth a note in `skills/pre-push-gates/SKILL.md` § Pitfalls so future builders know to filter out cross-package auto-fixes; the gate itself could narrow `yarn lint --fix` to changed packages, but that is a larger change.
