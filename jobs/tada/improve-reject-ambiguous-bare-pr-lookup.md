Done. Committed and pushed to `main2` (`d6ff5ee322`).

## Completion report

**What the job asked:** Reject numeric `gh pr` operations that carry no explicit repository or PR URL when invoked outside a project worktree — so issue/PR number ambiguity can't turn completed work into a handler failure (the deadline-retirement requeue where a bare `#51` resolved as a nonexistent PullRequest).

**What I did:**

1. **New guard library `scripts/jobs/pr-numeric-scope-guard.sh`** — a pure, self-contained sourced library (mirroring the existing `comment-body-guard.sh`/`comment-provenance.sh` shape). `pr_numeric_scope_guard_argv` blocks a `gh pr <sub>` call when *all* of: the subcommand takes a PR selector (view/diff/checks/checkout/close/comment/edit/lock/merge/ready/reopen/review/unlock/update-branch); the selector is a bare number (`51` or `#51`); there's no `-R`/`--repo`; there's no PR URL; and the cwd is **not** a project worktree. Project-worktree detection is precise and robust: `git rev-parse --git-common-dir` != `$GARDEN_ROOT/.git` (a fork checkout's common dir is its bare clone under `worktrees/`; a garden root/journal/`gardener-wt-*` worktree shares the root `.git`). Fail direction is toward blocking on any doubt; `GARDEN_ALLOW_BARE_PR_NUMBER=1` overrides. The block message names the remedy (`-R <owner>/<repo>` or full PR URL).

2. **Wired it into `scripts/jobs/bin/gh`** — sourced before token resolution, so a blocked call does no pointless token lookup. Fail-open for every non-matching call.

3. **New regression suite `scripts/jobs/test/pr-numeric-scope-guard-test.sh`** — 29 cases using real throwaway git repos (a fake garden root + linked worktree = garden context; a bare clone + worktree = project context) plus a `bin/gh` end-to-end check. Covers block/passthrough matrix, override, and the no-repo case (isolated via `GIT_CEILING_DIRECTORIES`).

4. **Isolated the orthogonal token-fallback suite** (`gh-wrapper-fail-closed-test.sh`), which uses bare-numeric fixtures, by opting it out with `GARDEN_ALLOW_BARE_PR_NUMBER=1` and a comment.

**Verification:** all three affected test suites pass (scope-guard 29/29, fail-closed 49/49, comment-body-guard 25/25); shellcheck `-S warning` clean on all touched files; `bash -n` sweep over all of `scripts/`+`skills/` clean.

**Blast radius:** low — every deterministic code caller of `gh pr view/merge/edit/...` already passes `-R "$repo"` (verified across ci-wait-merge, ci-rollup-gh, pr-mergeable-gh, pr-maintainer-approval-gh, gh_pr_view_retry callers). The only affected shape is the bare agent-prose form that `panel.sh:274` already warns against; the guard now enforces that warning as code.

**Follow-ups:** none required. The per-test suites aren't in the CI shellcheck/exec scope (only `bash -n` runs fleet-wide), consistent with the other guard suites; no CI wiring change was needed.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-reject-ambiguous-bare-pr-lookup.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 96 tokens (4959705 cached reads)
- Output: 45113 tokens
- Cost: $4.717578499999999
- Wall-clock: 632s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
