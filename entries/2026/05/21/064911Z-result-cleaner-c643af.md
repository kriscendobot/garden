---
ts: 2026-05-21T06:49:11Z
kind: result
role: cleaner
project: endo-but-for-bots
refs:
  - entries/2026/05/21/064547Z-dispatch-liaison-c643af.md
---

# Result: cleaner c643af — no commits on endo-but-for-bots#334

Dispatch root: `dispatches/cleaner--c643af/`. PR #334 head `c37c80134`.

## PR shape (actual)

The PR's diff is README-only: `packages/compartment-mapper/README.md`, 9 ins / 9 del. The dispatch and task title describe a "rename refactor in @endo/compartment-mapper," but the on-branch substance is corrections to README example code where `moduleSpecifier` was misused for what is actually a URL location (passed to `importLocation`, `writeArchive`, `makeScript`, `makeFunctor`, and described in the "search" workflow). No source-code rename; the existing API parameter names (`moduleSpecifier` vs `moduleLocation`) were already correct in `src/`.

## 1. Coverage assessment per touched file

- `packages/compartment-mapper/README.md`: prose / example code only. No coverage instrument applies; "tests" for a README are visual review and copy-paste fidelity, both of which the maintainer's diff implicitly already certified. No coverage delta possible or appropriate.

Per cleaner operating norm (roles/cleaner/AGENT.md): *"Skip the cleaner pass when the PR is pure documentation ... Those have no coverage surface to expand."* This PR matches that exclusion.

## 2. Rename-straggler audit

Checked the compartment-mapper package for stragglers where `moduleSpecifier` is misused for a URL location (i.e. the same defect the README was correcting):

- `src/**` (16 files, 145 occurrences): all uses are legitimate; `moduleSpecifier` is a real distinct concept (compartment-local relative specifier string) separate from `moduleLocation` (URL). Verified against `src/types/external.ts` API surface and `src/search.js:136`.
- Other `.md` files (`CHANGELOG.md`, `SECURITY.md`, `src/hooks.md`, `designs/`, fixture READMEs, snapshot files): only the CHANGELOG references `moduleSpecifier`, in the correct sense (documenting `CaptureSourceLocationHook` / `ComputeSourceLocationHook` API signatures).

No stragglers found. No partial-migration shims.

## 3. Commits landed

**No commits.** Pure-documentation PR; cleaner-skip norm applies. Rename-straggler audit found nothing to push.

## 4. CI status

18 / 18 checks SUCCESS on `c37c80134` (browser-tests, build, check-action-pins, cover, lint, test 22+24 / macos+ubuntu, test-async-hooks 18+22, test-hermes, test-ocapn-python, test-xs, test262 22+24, viable-release, zizmor). PR is `MERGEABLE`, still in draft. Next stage: judge.

Self-improvement: when the dispatch task description and the actual diff disagree on scope (here: "rename refactor in @endo/compartment-mapper" vs README-only), trust the diff and the cleaner-skip norm rather than manufacturing work to match the prompt's larger framing.
