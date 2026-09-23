---
ts: 2026-05-14T21:03:01Z
kind: result
role: builder
project: endo-but-for-bots
to: steward
prs:
  - repo: endojs/endo-but-for-bots
    pr: 250
    role: created
  - repo: endojs/endo-but-for-bots
    pr: 126
    role: source
refs:
  - entries/2026/05/14/210000Z-dispatch-steward-94d5f5.md
---

# Result: master-base mirror of PR #126 opened as draft #250

## Outcome

- Branch: `ci/no-npm-lifecycle-master` (pushed to `origin`).
- PR: endojs/endo-but-for-bots#250 (draft, base `master`, head `ci/no-npm-lifecycle-master`).
- Head SHA: `7c186ef34e28f597012abe368cd011059ffe3716`.
- URL: https://github.com/endojs/endo-but-for-bots/pull/250.

## What landed

Two substantive commits, cherry-picked verbatim from #126's head with one path resolved:

1. `a7a99dda0` `ci: disable npm lifecycle scripts in workflows` (workflow-level `env:` blocks setting `YARN_ENABLE_SCRIPTS=false` / `npm_config_ignore_scripts=true`, plus tightening bare `yarn install` to `yarn install --immutable` in `release.yml`, `browser-test.yml`, `typedoc-gh-pages.yml`).
2. `7c186ef34` `ci(ocapn-guile-interop): merge duplicate top-level env block` (collapses the two `env:` mappings the prior commit's addition would otherwise duplicate alongside the pre-existing `GUIX_VERSION` / `GUIX_TARBALL_SHA256` block).

Cherry-pick resolution: `.github/workflows/familiar-release.yml` exists only on `llm`, not on `master`. The cherry-pick of commit one flagged a `modify/delete` conflict on that path; resolved by `git rm` of the conflicted file so the commit applies cleanly to the eight workflows that do exist on `master`. Diff stat against `master`: 58 insertions, 3 deletions across the eight workflow files. The pre-existing master-side workflow changes (Node-version bumps, action SHA updates, `familiar-bundle` job in `ci.yml`) are untouched.

## PR body shape

Followed the upstream `master`-branch PR template verbatim (Description, Security Considerations, Scaling Considerations, Documentation Considerations, Testing Considerations, Compatibility Considerations, Upgrade Considerations, Refs, Scope of this PR). No checklists per `skills/pr-formation/SKILL.md`. The body cites #126 as sibling on `llm` and #246 / #244 as pattern references for the master-base-mirror shape.

## Next stage owed

Per `skills/pr-creation-flow/SKILL.md` § The next-stage-owed heuristic: this is a tiny PR (CI-config only, no source, no test surface) and qualifies for the cleaner-skipped variant. The orchestrator should dispatch the judge directly after this builder result. The code panel (twelve seats) is the default; the judge picks the panel per `roles/judge/AGENT.md` § Panel-kind discrimination.

## Out of scope (per dispatch)

- Review feedback on the original #126 (the `scripts/check-no-ci-lifecycle.mjs` thread): not addressed here, by dispatch.
- Un-drafting #250: the judge's job after the panel runs.
- Back-port to `llm`: already exists as #126.

Self-improvement: nothing this time.
