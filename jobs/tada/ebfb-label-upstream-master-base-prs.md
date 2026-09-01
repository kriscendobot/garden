Created the `upstream` label in `endojs/endo-but-for-bots`:

- Color: `5319e7`
- Description: `PR's base is upstream master (or a master-pinned snapshot), not the fork's llm trunk`

Applied it to all 60 qualifying open PRs:

- #1099 feat(pass-style)!: narrow byteArray to a frozen Uint8Array
- #1063 fix(harden): reject resizable TypedArrays
- #1061 refactor(marshal): move public types to declarations
- #972 docs: specify the Justin subset that expresses pass-style
- #893 docs: catalog package.json cross-tool semantics
- #847 chore(ci): establish current master baseline
- #779 fix(ses): cyclic star export with renaming reexport (issue #59) - retargeted to frozen base
- #771 chore: npm migration experiment from upstream master
- #769 chore: migrate monorepo to pnpm experiment
- #768 chore: npm migration experiment from upstream master
- #765 fix(compartment-mapper): cache global intrinsics (mirror of endojs/endo#2780)
- #764 fix(compartment-mapper): cache global intrinsics at module init (mirror of endojs/endo#2780)
- #763 feat(pola-io): least-authority file, net, cmd access
- #762 chore: Lint for kebab-case with wildcard test262 exemptions
- #761 fix(patterns): preserve literal inference in compound matchers
- #759 Reconstructs endojs/endo-but-for-bots#69 (fix(pass-style): treat document.all-like values as objects)
- #758 feat(stream): add flatMapReader for 1-to-many reader transforms (reconstruct #545 on master)
- #757 refactor(eslint-plugin): concise-method shorthand for rule visitor objects (reconstruct #542 on master)
- #630 docs: Translate Miller's Grant Matcher Puzzle for docs.endojs.org
- #629 docs: Distributed Confinement (Miller/Svoboda, modernized to HJS + OCapN)
- #608 feat: Docker self-hosting image for the daemon
- #594 chore(lint): lint per package to avoid the typescript-eslint project-service ceiling
- #589 refactor: retire function-keyword in favor of arrow/method syntax (reconstruct #474 on current master)
- #586 test(immutable-arraybuffer): exhaustive byteOffset+length constructor boundary tests
- #555 chore(eslint-plugin): ratchet jsdoc/require-param to error; fix 4 daemon defects
- #554 chore(eslint-plugin): error on jsdoc/check-tag-names
- #546 feat: support .ts runtime modules via erasable type syntax
- #535 fix(compartment-mapper): trace static-literal dynamic import() during archival
- #534 fix(compartment-mapper): tolerate unresolved internal modules when bundling
- #533 fix(compartment-mapper): re-export from exit module via modules map
- #514 chore(lint+ts): tighten ESLint and TypeScript strictness; add --max-warnings 0
- #509 perf(bundle-source): cut multi-entry agoric bundling time and add detailed profiling
- #472 chore: document bytesToImmutable freezable-TypedArray usage
- #438 chore(types): switch lint:types to tsgo for the dev loop
- #377 fix(benchmark): retry esvu installs in install-engines.sh
- #355 perf(bundle-source): cut multi-entry agoric bundling time and add detailed profiling
- #353 fix(module-source): propagate live-export writes for export let bindings (fixes endojs/endo#2982)
- #350 docs: Various touch-ups (mirror of endojs/endo#2948)
- #348 refactor(bundle-lite): Deduplicate bundle-lite (mirror of endojs/endo#2902)
- #347 feat(ocapn): CBOR alternative encoding (mirror of endojs/endo#3033)
- #346 fix(bundle-source): bind aliased exports correctly in nestedEvaluate format (fixes endojs/endo#2981)
- #344 docs: populate READMEs (mirror of endojs/endo#3047)
- #334 fix(compartment-mapper): Correct moduleSpecifier/moduleLocation naming mistakes
- #311 fix(module-source): pass defineProperty through functor calling convention
- #303 chore(workspace): break devDependency cycles via synthetic test packages (mirror of llm Cuts 1-5, refs #206)
- #280 chore(ci): drop Node.js 18 and 20 from the test matrix
- #263 feat(ses): permit URL and URLSearchParams as universal intrinsics
- #258 ci(ocapn-guile-interop): cache the Guix runtime store across runs (iteration III)
- #253 chore: general package uniformity checker (broadens endojs/endo#3258 scope)
- #251 feat(eslint-plugin): support destructuring in harden-exports (mirror of endojs/endo#2404 + gibson042 feedback)
- #250 ci: disable npm lifecycle scripts in workflows (master-base mirror of #126)
- #239 mirror: endojs/endo#1967 (test for bundled dependency name collision)
- #235 chore: break devDep cycles via @endo/<pkg>-test sibling packages
- #186 feat(eventual-send): eager-shim/lazy-main delegate ponyfill (per #175)
- #182 test(ses): isImmutableDataProperty regression for iOS Safari fix (closes #947)
- #155 fix(ses): exported namespace consistency between VirtualModuleInstance and ModuleInstance [mirror of endojs/endo#3246]
- #96 design(compartment-mapper): auxiliary package.json overrides
- #79 test(ses): pin namespace mutation parity with Node.js
- #71 test(env-options,marshal): per-compartment options are scoped (#2879)
- #60 test(ses): replace deleted get-intrinsics test (closes #390)

Final `gh pr list` verification found 289 open PRs, 60 qualifying bases, zero qualifying PRs missing the label, and zero nonqualifying open PRs carrying it. No PRs were ambiguous or skipped. Closed and merged PRs were intentionally excluded because this is a triage-facing label for active work.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-label-upstream-master-base-prs.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 215s

<!-- garden-usage-end -->
