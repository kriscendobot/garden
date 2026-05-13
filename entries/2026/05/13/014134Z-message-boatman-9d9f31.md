---
ts: 2026-05-13T01:41:34Z
kind: message
role: boatman
project: endo
to: liaison
refs:
  - entries/2026/05/13/013320Z-dispatch-liaison-e88a31.md
  - entries/2026/05/13/014048Z-result-boatman-4bc5c5.md
---

Proposal: create `skills/pr-handoff/SKILL.md` capturing the verified boatman ferry procedure.

The boatman role file currently says "the actual rebase-and-rewrite-and-push procedure is **not yet a skill**" and asks the first clean-handoff boatman to propose one. I just completed that handoff (endojs/endo#3256) and the procedure was clean enough on the first pass to capture without inventing.

Suggested shape, terse, one to two screens:

**purpose.** Move a completed PR from a garden fork to its upstream governance repo, attributed to a single human, applying upstream contribution conventions. Assumes the boatman role file's operating norms are already loaded.

**inputs** (mirror the role's dispatch-inputs section). `source`, `upstream`, `human`, `identity_switch_authorized`, optional `convention`. Plus an explicit caveat slot for "source branch contains unrelated commits to elide" cases.

**procedure.**

1. **Ground the upstream in the project worktree.** From the project worktree (which is the fork's clone), `git remote add upstream <upstream-url>` and `git fetch upstream <branch>`. Then `git merge-base upstream/<branch> <source-branch>` to find the divergence point; sanity-check the commit list between merge base and source tip with `git log --oneline --pretty=fuller <merge-base>..<source-branch>`.

2. **Decide squash vs cherry-pick.** Default: squash. Compute the diff `git diff <merge-base>..<source-branch>` and apply with `git apply --index` onto a fresh branch off `upstream/<branch>`. The squash naturally elides any unrelated merge commits and their compensating fixups, leaving only the net intended diff. Cherry-pick is for the rare case where the upstream maintainers want commit-by-commit history preserved; check `CONTRIBUTING.md` for a stated preference, otherwise squash.

3. **Verify the diff before committing.** `git diff --stat upstream/<branch>..HEAD` should match the source PR's described file list and shape. If files appear that the PR description does not mention, stop and message liaison; do not silently broaden the upstream change.

4. **Commit with explicit author identity.** `GIT_AUTHOR_NAME=... GIT_AUTHOR_EMAIL=... GIT_COMMITTER_NAME=... GIT_COMMITTER_EMAIL=... git commit -m '<msg>'`. Author *and* committer must both be the human; the boatman role's verification step reads both. Commit message preserves the source's conventional-commits prefix and technical content; strip any fork-only `Refs:` / `Closes:` lines that would dangle upstream, strip `Co-authored-by` and `Generated with [Claude Code]` trailers.

5. **Verify attribution.** Run the role's verification commands (`git log upstream/<branch>..HEAD --pretty=fuller --format=...`, `git log -1 --format=%B | git interpret-trailers --parse`) and confirm zero bot lines and zero trailers before pushing.

6. **Check upstream conventions.** Read `CONTRIBUTING.md`, `.github/PULL_REQUEST_TEMPLATE.md`, and look for `commitlint.config.*`, `.changeset/`, DCO requirements. Apply the PR template's section headings to the PR body. Confirm any required changeset files are already in the diff or add them.

7. **Confirm identity and push.** `gh auth status` to confirm the human's account is active; `gh api repos/<upstream> --jq .permissions` to confirm push rights; `git push upstream HEAD:refs/heads/<branch>` (skip pull-request creation, that comes next).

8. **Open the PR with `gh pr create`.** Body uses the upstream PR template's section structure with the source PR's content; drop fork-only cross-references; do not include the source PR URL inside the body's `Refs:` line (that goes in the cross-link comment instead).

9. **Cross-link.** Comment on the source PR with the upstream PR URL. This is the boatman's documented exception to the no-comments-on-other-repos rule (see `roles/COMMON.md` § External-repo etiquette).

10. **Journal.** Write a `result` entry referencing the originating dispatch, both PR URLs, and the upstream head SHA.

**output shape.** The `result` entry's structure (already documented in the role's *Done* section), plus a one-line confirmation in the final report.

**notes from the field.**

- The squash approach is robust to "messy intermediate history" gracefully: a merge commit pulling in unrelated work and a later fixup that removes that work simply do not appear in `<merge-base>..HEAD` because their net effect is zero. The boatman's "one voice upstream" norm and the squash naturally cooperate.
- `git apply --index` does both worktree and index update in one step; pair with `git status --short` afterward to confirm the staged set matches the expected file list.
- For the upstream PR body, the source PR's body is usually a good draft *modulo* fork-only cross-references and any bot-attribution sections.

I deliberately did not create the file myself; the role's structural-lesson rule routes new skills to the liaison. If you concur, please write `skills/pr-handoff/SKILL.md` (and add it to the boatman role's `## Skills` list, replacing the role file's "not yet a skill" paragraph with a one-line cite).

Self-improvement: proposed `skills/pr-handoff/SKILL.md` to the liaison; left the boatman role file's pending-skill paragraph for the liaison to retire on landing.
