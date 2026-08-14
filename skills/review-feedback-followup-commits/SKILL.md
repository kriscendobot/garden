---
created: 2026-05-13
updated: 2026-08-14
author: gardener
---

# Skill: review-feedback-followup-commits

Shape and structure of fix-up commits in response to PR review feedback.

Consumed by the fixer step of the gardening state machine ([`scripts/jobs/gardening/garden-pr.sh`](../../scripts/jobs/gardening/garden-pr.sh); design [`../../designs/gardening-state-machine.md`](../../designs/gardening-state-machine.md)). When a maintainer's review asks for changes on a PR, the triager maps the directive to a job on the board ([`../job-board/SKILL.md`](../job-board/SKILL.md)); a gardener claims it and applies the fix-ups under this discipline.

## Triggers

Inline review comments, top-level review feedback, or maintainer "please address X" asks on an open PR.

## Core rules

- **Add a follow-up commit on top; do not amend.** Amending forces the reviewer to recompute the diff between the prior PR state and the current one. A follow-up makes the new-since-last-review diff trivial. Amend only the just-rebased tip when nobody else has pushed since, or when a maintainer review explicitly asks for an author-only or message-only amend that does not change the tree.
- **One concern per commit.** Conventional-commit message, parenthesized PR number. A reviewer who agrees with three points and disagrees with the fourth can request the fourth be dropped without unwinding the others. Examples: `fix(ci): restore line accidentally regressed in rebase (#NNN)`, `refactor(pkg): clarify mock transport's pair-of-pipes (#NNN)`.
- **Rebase before applying fix-ups.** See [`../rebase-before-followup/SKILL.md`](../rebase-before-followup/SKILL.md). Even an apparently no-op rebase matters.
- **Lockfile changes ship in their own commit** as a separate `chore: Update yarn.lock` commit.
- **Reply on each thread after the push** citing SHAs per [`../pr-review-thread-replies/SKILL.md`](../pr-review-thread-replies/SKILL.md), then post a top-level summary.

## Patterns that trigger a deeper read

Each line below is a trigger. If the pattern matches, the cited reference (or a future ported skill) carries the full handling.

- **Reviewer asks to pin an external dependency.** Capture the actual sha256 from a fresh download. See [verify-upstream-state-before-pinning].
- **A review item demands a major rewrite.** Land the rewrite as commit A; treat any subsequent follow-ups as additive sharpenings that a reviewer could request be dropped without unwinding A. Don't split the rewrite into theatrical phases.
- **The job summarizes review threads with line numbers and suggested actions.** Treat the line number as authoritative and the action summary as a hint. Read the file at the line yourself before applying; the producer that posted the job can mismatch a line to the wrong file or identifier.
- **A package rename.** Sweep the cascade across package directory, `package.json`, AVA test files, `.changeset/*.md`, error-message strings, design docs, and `yarn.lock`. After the sweep, `grep -rn '<old-name>'` should return only intentional historical references. See [`../rename-discipline/SKILL.md`](../rename-discipline/SKILL.md).
- **A post-retcon style, lint, or format correction.**
  On a PR that has already been retconned, a commit whose only change is clearing a CI-flagged style, lint, or format failure ships as `git commit --fixup=<introducing-sha>` rather than a standalone conventional commit, so the conductor can autosquash it into its target at merge time.
  See [`../retcon/SKILL.md`](../retcon/SKILL.md) and [`../../roles/conductor/AGENT.md`](../../roles/conductor/AGENT.md).

## Output

A stack of one-concern-per-commit follow-up commits pushed to the PR head, each thread closed with a SHA-citing reply, and a top-level summary listing each item, the commit that addressed it, and any deferrals. The job's completion report (via `complete-job.sh`) records the same mapping for the gardener that supervises the step.

## Notes from the field

- _2026-05-13_: adopted from the reference. The per-pattern skill files (`package-rename-cascade`, `ses-intrinsic-naming`) were not ported here; their lore is in the reference and can come over if a future engagement needs them as active library.
- _2026-05-17_: the "do not amend" rule's tree-changing target was clarified after a PR #238 review item asked the fixer step to reset the feat commit's author header to the upstream playground PR's original author. An author-only amend is byte-identical to reviewers, was the maintainer's explicit ask, and falls outside the rule's actual hazard (forcing a re-diff). The core bullet now names this carve-out alongside the just-rebased-tip carve-out.
- _2026-08-14_: a PR can merge between the fixer's preflight and push. If the
  reviewed head branch disappears before the fix lands, rebase the follow-up
  commits onto the live base, open a follow-up PR, and map every review ask to its
  new commit in the original PR thread. Never recreate or force-push the deleted
  merged branch. Trigger: https://github.com/kriscendobot/minion.town/pull/40;
  recovery landed as https://github.com/kriscendobot/minion.town/pull/46.
