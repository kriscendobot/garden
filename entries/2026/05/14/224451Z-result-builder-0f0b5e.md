---
ts: 2026-05-14T22:44:51Z
kind: result
role: builder
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
prs:
  - repo: endojs/endo-but-for-bots
    pr: 253
    role: this-pr
  - repo: endojs/endo
    pr: 3258
    role: source-of-narrow-version
  - repo: endojs/endo-but-for-bots
    pr: 228
    role: source-of-narrow-version
refs:
  - entries/2026/05/14/223603Z-dispatch-liaison-0f0b5e.md
---

# Result: master-base general package-uniformity checker landed as DRAFT PR

## Deliverable

- PR: https://github.com/endojs/endo-but-for-bots/pull/253 (draft, base `master`, head `chore/package-uniformity-master`).
- Head SHA: `d6a5df80828d2c1d163d4061ac377efa02ec267a`.
- 6 commits, 20 files changed, +1208/-15.

## Checks the new `scripts/check-package-uniformity.sh` enforces

- `SECURITY.md` byte-identical to `packages/skel/SECURITY.md`.
- `LICENSE` matches `packages/skel/LICENSE` modulo the copyright line; the copyright line must be either the skel placeholder or `Copyright <YYYY> Endo Contributors` (preserves the existing `scripts/set-license-text.sh` year-stamping convention).
- `package.json` fields: `author`, `license`, `type`, `repository.type`, `repository.url`, `bugs.url` match skel; `repository.directory == packages/<dir>`; `name` ends with `/<dir>` or equals `<dir>` (unscoped historical names like `ses`); `publishConfig.access == public` for non-private packages; `description` is non-empty and not equal to skel's default placeholder.
- Small `EXCEPTIONS` allowlist with one initial entry: `packages/eslint-plugin` permitted to ship without `.type` because it is a CommonJS ESLint v8 plugin.

CI wired via a `Check package uniformity` step in the existing `lint` job at `.github/workflows/ci.yml`.

## Drift-fixes applied (per commit, in apply order)

1. `chore: align SECURITY.md across packages` (3 packages: `hex`, `immutable-arraybuffer`, `panic`; same alignment as endo#3258).
2. `chore: add LICENSE to packages that were missing it` (5 packages: `eslint-plugin` 2021, `far` 2022, `init` 2022, `lockdown` 2022, `stream-types-test` 2021; years from `git log --diff-filter=A --follow`).
3. `chore(packages): fix repository/bugs fields and document type exception` (4 packages: `bundle-source` `.url` gained `.git`; `common` gained `.directory`; `eslint-plugin` gained `.repository.type` `.repository.url` `.bugs.url`; `test262-runner` gained `.repository.type` `.repository.url`; plus the `EXCEPTIONS` entry for `eslint-plugin.type`).
4. `chore(packages): fill in descriptions for ocapn and ocapn-noise` (2 packages; descriptions derived from each README).
5. `chore(packages): align .author on SES-heritage packages to 'Endo contributors'` (4 packages: `lockdown`, `module-source`, `ses`, `ses-ava`; one substantive maintainer-attention change, called out in the commit body with a revert recipe).

After all five drift-fix commits, `bash scripts/check-package-uniformity.sh` exits 0 locally. Sad-path tested (drift in SECURITY.md and drift in `.description`); both fail with named-package output.

## CI status

Not yet polled; PR is open as draft and the new `Check package uniformity` step should pass since the local run passes. Lint and full test suites pending CI completion.

## Field-survey notes (for the orchestrator)

- 47/48 packages already agreed on `author = "Endo contributors"`, 4 outliers were the SES-shim heritage (`lockdown`, `module-source`, `ses`, `ses-ava`); flipped to `Endo contributors` with an explicit commit-body invitation to revert if the maintainer prefers `Agoric` retained as a label.
- `homepage` was below the 80% homogeneity threshold (about 24/48 matched the `tree/master/packages/<name>#readme` shape), so it was left out of v1 per the dispatch's threshold rule. PR body names this as v2 follow-up.
- `.type` was 47/48 = 97.9% homogeneous; the one outlier (`eslint-plugin`) is the legitimate CommonJS plugin, granted an `EXCEPTIONS` entry instead of an ESM migration.

## Out of scope (honored)

- No upstream `endojs/endo#3258` comment.
- No fork-side close of `endojs/endo-but-for-bots#228`.
- No edit to llm-side `scripts/check-security-md.sh`.

The PR remains draft per the new flow; the cleaner -> judge -> fixer-loop runs from here.

Self-improvement: nothing this time.
