---
ts: 2026-05-14T18:24:10Z
kind: result
role: shepherd
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
to: liaison
refs:
  - entries/2026/05/14/182128Z-dispatch-liaison-3ddcfe.md
---

# Result: shepherd opens no-changes PR on llm to diagnose CI failure

## PR

- URL: https://github.com/endojs/endo-but-for-bots/pull/245
- Base: `llm`. Head: `ci/poke-llm-3ddcfe` at `cfd7231e2` (empty commit atop `e56e9940d`).
- State: draft. Title: `ci: empty-commit poke to reproduce llm CI failure`.

## CI conclusion on PR #245

Both PR checks reached terminal state:

- `browser-tests`: SUCCESS in 2m42s.
- `build` (workflow: `Test project mutual dependency versions`): SUCCESS in 23s.

**The `CI` workflow (`ci.yml`) did NOT dispatch on this PR.** That is the diagnostic finding, and it explains why an empty-commit poke is the wrong probe for the maintainer's reported failure.

## Why ci.yml did not run

`.github/workflows/ci.yml` has:

```yaml
on:
  pull_request:
    paths-ignore:
      - '**/*.md'
      - 'docs/**'
```

GitHub's `paths-ignore` semantics: the workflow runs only if at least one changed file is **not** in the ignore set. An empty commit changes zero files, so nothing matches "not in the ignore set", and the workflow is skipped. The sister `ci-docs.yml` uses the mirror `paths: ['**/*.md', 'docs/**']` and also requires at least one changed file matching the listed set, so it also skips on a zero-file commit. The empty-commit poke cannot trigger ci.yml.

## Confirmation of the maintainer's hypothesis (out-of-band)

Even though the PR could not surface the failure, I ran `scripts/check-security-md.sh` locally against the `llm` head (`e56e9940d`). Output:

```
packages/harden-test: missing SECURITY.md
packages/hex-test: missing SECURITY.md
```

This is wired into ci.yml's `lint` job as the step `Check SECURITY.md uniformity` (`ci.yml:67-68`, after `yarn lint` and before `yarn docs`). Any PR against `llm` that changes a non-doc file will trip this step on lint.

The cause is the maintainer's hypothesis, with specifics:

- PR #228 (`ci: enforce uniform SECURITY.md across packages`, merged to master at `243e23283`) introduced the script and wired it into the `lint` job.
- PR #210 (`harden-test`, merged into `llm` at `e56e9940d`) and PR #211 (`hex-test`, merged into `llm` at `68246ad92`) added new packages without a `SECURITY.md`. Both packages are "Cut N of #206 design" devDep-cycle breakers and probably forgot the boilerplate file.
- The fix is two files: `packages/harden-test/SECURITY.md` and `packages/hex-test/SECURITY.md`, each a byte-identical copy of the canonical `packages/<other>/SECURITY.md`.

The fix is mechanical and ~2 files, so within shepherd's repair scope, but the dispatch explicitly says do not auto-fix and do not un-draft. Reporting back to liaison for routing (a fixer dispatch, or pass to the maintainer).

## PR #245 disposition

- Remains in draft.
- No comment posted.
- The PR demonstrates that the empty-commit-poke pattern does not reproduce ci.yml failures on this repo. Liaison may want to close it as superseded by the out-of-band diagnosis above, or hold it as a record of the path-ignore gap.

Self-improvement: nothing this time.
