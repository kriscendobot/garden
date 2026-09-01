---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Maintainer directive (2026-09-01, liaison session): add a new "upstream" label
to every `endojs/endo-but-for-bots` pull request whose merge base is `master`
or a `master`-rooted branch — including a frozen-base `master-<sha>` snapshot
per the garden's `skills/frozen-base-branch/SKILL.md` (used when a PR is a
curated reconstruction destined for upstream `endojs/endo`'s `master`, as
opposed to the fork's own `llm` trunk). "Merge base of `master*`" means: the
PR's base branch name is exactly `master`, or matches the glob `master-*`
(hex-suffixed frozen-base branches such as `master-abc1234`) — not PRs whose
base happens to be `llm` even if `llm` itself descends from `master` upstream.

You are explicitly authorized, per this directive, to edit each qualifying
PR's labels (`gh pr edit --add-label`) and to create the `upstream` label on
the repo if it does not already exist — this satisfies the per-action
authorization the garden's `roles/COMMON.md` § External-repo etiquette
requires for a PR edit.

## Procedure

1. `gh label list --repo endojs/endo-but-for-bots` — check whether an
   `upstream` label already exists. If one exists but its description/color
   suggests a **different** meaning than "this PR's base is master, not llm"
   (e.g. it's used for something unrelated), stop and report the ambiguity to
   the maintainer inbox rather than overloading it. Otherwise reuse it, or
   create it (`gh label create upstream --repo endojs/endo-but-for-bots
   --description "..." --color ...`) with a description along the lines of
   "PR's base is upstream master (or a master-pinned snapshot), not the fork's
   llm trunk" and a color that doesn't collide with an existing label's.

2. Enumerate pull requests: `gh pr list --repo endojs/endo-but-for-bots --state
   open --json number,baseRefName --limit 500` (raise `--limit` if the repo has
   more open PRs than that). Filter to `baseRefName == "master"` or
   `baseRefName` matching `^master-`.

   Default to **open** PRs — that's where a triage-facing label earns its
   keep. Use your judgment on whether closed/merged PRs are also worth
   labeling for historical searchability; if you decide to include them, say
   so and why in your report, and if you decide not to, say that too rather
   than silently scoping down.

3. For each matching PR: `gh pr edit <N> --repo endojs/endo-but-for-bots
   --add-label upstream`. Skip (don't error out the whole job) a PR that
   already carries the label.

4. Report the final list of PRs labeled (numbers + titles), any you found
   ambiguous or skipped and why, and the label's final description/color.
