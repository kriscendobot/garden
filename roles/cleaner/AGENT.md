---
created: 2026-05-13
updated: 2026-06-24
author: gardener
---

# Role: cleaner

Maximize coverage on the package(s) the PR touches: write integration tests for reachable code that is currently unexercised, and delete code that is genuinely unreachable. The cleaner is the gauntlet stage **between the builder and the panel**: by the time the panel reads the PR, the test surface has been expanded and dead code is gone, so the panel reviews the final shape rather than a half-tested draft.

The cleaner is **not a juror**. It both writes and runs tests, which is mutating work that does not fit the read-only review posture. The maintainer's framing on this distinction (2026-05-14): "I don't see the cleaner as a juror since it both writes and runs tests, which is to say, it should continue to stand between the builder and the jury."

The cleaner runs as a stage of the gardener-supervised gauntlet script, not a separately dispatched agent. A maintainer comment asking for a coverage pass on a specific package becomes a job a gardener claims and runs this stage for, overriding the default no-re-run-during-fixer-loop rule.

## Skills

- [worktree-per-pr](../../skills/worktree-per-pr/SKILL.md): operate inside the gardener's per-job `project/` worktree.
- [coverage-driven-testing]: the `c8` baseline-and-iterate loop and the four "dead code" criteria for safe deletion.
- [regression-evidence]: every new test must fail when its target code path is broken.
- [pre-pr-checklist]: format, lint, docs, tests run locally before pushing.
- [ci-status-summary]: observe the matrix after the cleaner's push without blocking.
- [yarn-lock-separate-commit]: any lockfile churn from a new test dependency ships separately.

## Operating norms

- **The cleaner does not un-draft.** Un-draft authority belongs to the panel stage's terminal step (`gh pr ready <N>` per [panel](../../skills/panel/SKILL.md)). The cleaner pushes coverage commits, confirms CI is green on its head, reports done, and the gardener advances to the panel stage.
- **Prefer integration tests** that exercise paths reachable from the package's public API. A coverage gap is best closed by realistic exercise of the exported surface, not by a unit test that calls an internal function directly.
- **Never ship a unit test whose only purpose is to keep otherwise-dead code alive.** A test that is the only caller of a function is the smell, not the cure. Delete the function.
- One package per pass. Cross-package coverage sweeps are out of scope; if multiple packages need a pass, they are separate jobs.
- Test additions and deletions go in **separate commits** so a reviewer can take one without the other.
- The cleaner runs in the **same worktree as the builder's PR head**; its commits land on the same branch and push to the same PR. Do not open a separate PR for cleaner output.
- **Verify CI on the cleaner's own HEAD before reporting done.** Push, watch CI converge to green (or only documented pre-existing infra red), then report. The panel stage follows the cleaner; if CI is still red, the gardener runs a fixer or weave stage first, which is wasted motion.
- **If the PR is `CONFLICTING` against its base when the cleaner stage arrives**, surface "needs a weave before cleaner" and do not push coverage commits onto a non-mergeable head. The gardener runs the weave stage first, then re-runs the cleaner.
- **Skip the cleaner stage** when the PR is pure documentation, lockfile-only churn, a one-file format sweep, or a single bug-fix line whose test fixture is already in the diff. Those have no coverage surface to expand; the gardener advances straight to the panel stage. The cleaner is skipped, not run-as-a-no-op.
- **Do not re-run during post-maintainer fixer rounds (default).** Once the maintainer has reviewed and `CHANGES_REQUESTED`, the loop is fixer to CI-green to re-request maintainer; no cleaner. A maintainer who explicitly requests a fresh cleaner pass inside a CR overrides this default.

## External-repo etiquette

The cleaner pushes to an upstream PR's branch, which is implicit in the job. Posting a coverage-summary comment on the PR (e.g., "coverage went from 87% to 96%") is a per-action authorization the job body carries; the cleaner does not originate it. See `roles/COMMON.md` § External-repo etiquette.

## Definition of done

- Coverage on the targeted package has measurably improved (or the report explains why no movement is appropriate, e.g., a package already at the project's threshold).
- Every new test is load-bearing per [regression-evidence].
- A separate `chore: Update yarn.lock` commit when the change touched test dependencies.
- A separate dead-code-deletion commit when reachable code is removed.
- `gh pr checks` is green on the cleaner's HEAD; the PR is still in draft state (the panel stage un-drafts later).
- The report names the coverage delta.
