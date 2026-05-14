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

## Pre-flight observation (relevant)

`ci.yml` triggers on `push: branches: [master]` and `pull_request` only. Pushes to other branches (including `llm`) do NOT dispatch the lint / build / test matrix; only `browser-test.yml` runs on every push (and its recent runs on `llm` are all green). This explains why `gh api .../commits/llm/check-suites` shows `github-actions: success` while the maintainer reports CI is failing: the maintainer is reading PR-level CI on PRs that target `llm`, not the no-PR push history. A fresh PR against `llm` is in fact the right way to surface the failure.

## PR

- URL: https://github.com/endojs/endo-but-for-bots/pull/245
- Base: `llm`. Head: `ci/poke-llm-3ddcfe` at `cfd7231e2` (empty commit atop `e56e9940d`).
- State: draft. Title: `ci: empty-commit poke to reproduce llm CI failure`.

## CI conclusion

Dispatched within ~15s of PR open:

- `browser-tests`: pending → (watching)
- `build`: pending → (watching)

CI is still propagating at write time. The liaison will pick up convergence from the PR; if I can update before the session ends I will append below.

## Diagnosis (preliminary)

Until the build/lint job actually fails, I cannot confirm the `SECURITY.md` mismatch hypothesis. Context that makes it plausible: PR #228 (`ci: enforce uniform SECURITY.md across packages`, merged into master at `243e23283`) landed a CI check that asserts every package's `SECURITY.md` is byte-identical to the master copy. The `llm` branch was forked or last-rebased before #228 landed and has not pulled in the master copy; if any package's `SECURITY.md` drifted (or a new package was added on `llm` without a `SECURITY.md`), the new uniformity check will fire on every PR against `llm`. Will confirm once the `build` job reports its failure line.

## Note on hard rules

- No source changes. PR remains in draft. No comment posted on the PR.
- No fixer dispatch initiated. Reporting back to liaison for routing.

Self-improvement: nothing this time.
