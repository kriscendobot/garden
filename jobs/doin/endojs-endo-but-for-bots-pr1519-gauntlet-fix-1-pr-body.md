---
role: gardener
requires: host=endolin-garden-ece02cb4
pr: https://github.com/endojs/endo-but-for-bots/pull/1519
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Refresh PR #1519 title and body (integrator must-fix, gauntlet fix-1)

The gauntlet fix-1 worker on oros-studio could not edit the PR (bot PAT 403 on endojs PR writes from that host). Apply exactly this, then stop:

1. `gh pr edit 1519 -R endojs/endo-but-for-bots --title "fix: run SES, module analysis, and passable errors on Bun; gate Bun in CI"`
2. Replace the PR body with the markdown between the BODY markers below, verbatim (write it to a file, then `gh pr edit ... --body-file`). Preserve any existing `<!-- garden-... -->` marker comments from the current body by appending them at the end.
3. Verify with `gh pr view 1519 -R endojs/endo-but-for-bots --json title,body` that headings render as real Markdown headings (the old body was one quoted, escaped string).

Do not push code, re-run the panel, or change draft state.

----- BODY -----
Refs: #1516 (Bun probe)

## Description

On Bun 1.4.3, `lockdown()` throws before any test runs, and every Babel-based module transform fails. This PR makes SES, `@endo/module-source`, `@endo/parser-pipeline`, and `@endo/pass-style` work on Bun, and adds a Bun CI job.

- `packages/ses/src/permits.js`: Bun adds a non-configurable `URLSearchParams.prototype.length` accessor that lockdown cannot delete. SES now permits it. Bun's nonstandard, configurable `toJSON` is marked `false`, so lockdown removes it without a warning.
- `packages/module-source` and `packages/parser-pipeline`: accept Bun's binding of the `@babel/traverse` default import.
- `packages/pass-style/src/error.js`: accept JavaScriptCore source-location properties on passable errors.
- `scripts/test-bun.mjs` and `scripts/ava-bun-preload.mjs`: run AVA suites under Bun. An explicit `--package` or `--file` selection that schedules no run fails.
- `.github/workflows/ci.yml`: a `test (Bun)` job. It requires every package that passes all configurations under Bun, plus targeted `ses` and `@endo/parser-pipeline` test files that cover the fixes above. It runs every other supported package as an advisory step.
- Several tests replace engine-specific error-message assertions with error-type assertions.

### Security Considerations

The only new shared intrinsic is Bun's `URLSearchParams.prototype.length`. It is the native getter behind `size`, returns a number, discloses only the receiver's entry count, and is frozen by lockdown. Lockdown removes Bun's `toJSON` instead of permitting it. `packages/ses/test/url.test.js` fails on Bun if either decision regresses.

### Scaling Considerations

The Bun job adds one CI job: 35 required packages, a targeted `ses` and `@endo/parser-pipeline` run, and an advisory run of the rest.

### Documentation Considerations

None beyond the changeset.

### Testing Considerations

The Bun job runs the targeted files and package suites listed in `.github/workflows/ci.yml`. It also checks that the runner rejects an unknown package. The remaining Bun failures are tracked on #1516.

### Compatibility Considerations

On Node and XS, behavior is unchanged: the Bun-only members are absent, and the Babel interop accepts both import shapes.

### Upgrade Considerations

None. All changes are patch-level.
----- END BODY -----

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-21T11:12:08Z
