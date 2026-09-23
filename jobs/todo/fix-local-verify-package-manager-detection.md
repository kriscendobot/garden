---
role: fixer
priority: normal
posted_by: liaison
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Fix: local-verify.sh hardcodes Yarn; select the package manager as the skill documents

Repo: the garden itself (`kriscendobot/garden`, branch `main2`, push direct — no PR).

## Problem
Self-improvement finding (liaison bus msg `role/liaison/20260923T161700Z-2b6f6a`, from
https://github.com/kriscendobot/minion.town/pull/112): `skills/local-verify/SKILL.md`
says the harness picks npm from `package-lock.json`, but
`scripts/jobs/gardening/local-verify.sh` (~lines 175–184) always resolves `$YARN` to
`yarn` or `npx corepack yarn` unless `GARDEN_YARN` is set. On npm-only repositories such as
minion.town, the default run fails with "This package doesn't seem to be present in your
lockfile"; with `GARDEN_YARN=npm` it passes. Every minion.town gauntlet has had to
remember that override.

## Ask
- The pre-push gates already solved this in `0389ac0130` (improve-pre-push-gates-package-manager):
  they detect npm/Yarn/pnpm/Bun from `packageManager`, fall back to lockfiles, and then
  to Yarn. REUSE that detection. If it's inline in the pre-push script, lift it into a
  shared helper (e.g. in `scripts/jobs/common.sh` or a sibling) that both call, rather
  than copying it. `GARDEN_YARN` stays as the explicit override and still wins.
- Make sure every invocation form works per runner (`<runner> run <script>`, plus any
  yarn-only spellings such as `corepack yarn tsc` in the parity steps, which must keep
  their Yarn behavior on Yarn repositories and be skipped or mapped sensibly on npm).
- Reconcile `skills/local-verify/SKILL.md` with the resulting behavior, and drop the
  now-unneeded "GARDEN_YARN=npm mandatory" guidance for npm repositories wherever the
  library states it.
- Add npm regression coverage alongside the existing local-verify tests (a stubbed
  runner, as those tests already use). Run the local-verify and pre-push-gates test
  suites and push to `main2`.

Report: commit sha and which paths still assume Yarn, if any.
