# comment-source-gh.sh: poll reviews on ALL open PRs, not just the gh-pr-list default 30

Map: **build** (garden infra) on branch main2. Isolated worktree off origin/main2;
explicit-pathspec commits; push HEAD:main2 via git-rebase CAS. Touches
`scripts/jobs/handlers/comment-source-gh.sh` (review-body enumeration, "section 3"). Sibling to
`comment-watcher-no-silent-trusted-drop-always-reactji` (that one fixes the action loop; THIS
fixes the SOURCE silently not emitting reviews at all).

## Observed failure (proven)
kriskowal's COMMENTED review on endojs/endo-but-for-bots **#284** (review 4587189118,
2026-06-28T07:20:42Z, body "Please refresh.") was NEVER surfaced by the source — the watcher
slid its cursor past 07:20:42 with no #284 row, no job, no log. The maintainer flagged it
("don't ignore comments like this").

## Root cause
Section 3 enumerates open PRs with `gh pr list -R "$repo" --state open --json number` — **no
`--limit`**, so it returns gh's DEFAULT of **30** PRs (and via the search API). endo-but-for-bots
currently has **169 open PRs**; the 30 returned are the most recent (down to ~#450). **#284 (and
~139 other open PRs down to #57) are never iterated, so their review BODIES are never polled.**
Issue-comments are unaffected (section 1 lists comments repo-wide), which is why issue-comment
feedback worked but a review-only PR like #284 was invisible.
Verified: authoritative `gh api repos/<repo>/pulls?state=open&per_page=100 --paginate` returns
all 169 (incl. #284, min #57); `gh pr list` default returns 30 (min ~#450).

## Required fix
Enumerate **ALL** open PRs for the review-body poll (both the `rids=` inline-id set and the
`/reviews` loop). Use the authoritative paginated REST list, not the default-limited
`gh pr list`:
`gh api "repos/$repo/pulls?state=open&per_page=100" --paginate --jq '.[].number'`.
- **Recommended optimization (also cuts per-tick latency):** request the open PRs sorted by
  recent activity — `...&sort=updated&direction=desc` — and STOP iterating once a PR's
  `updated_at` is older than the cursor `since` (a PR with a new review/comment has a fresh
  `updated_at`, so all PRs with activity since the cursor are at the top). This bounds the
  per-tick work to recently-active PRs while still catching every PR with a new review
  (including the #284 case, whose `updated_at` jumped when the review landed). Don't iterate all
  169 every tick if this bound is available.
- **No silent truncation:** never rely on a default page size; if you cap iteration, LOG the
  bound and why (the no-silent-caps lesson). `require_tools gh jq` (fail loud).

## Audit the same anti-pattern elsewhere
Grep the watcher/handler scripts for `gh pr list` / `gh issue list` used WITHOUT an explicit
high `--limit` or pagination (e.g. issue-inbox-watcher.sh, mention/comment sources). Any
unbounded-default list that gates which PRs/issues are surveilled is the same blindness bug —
fix or justify each.

## Tests
Stub the PR list so there are >30 open PRs and a trusted COMMENTED review (body-only) sits on an
OPEN PR OUTSIDE the most-recent-30: assert the source EMITS a `pr-review-body` row for it (and
that the updated-desc early-stop still includes it). Regression-pins #284.

## Deliverable
The review-body source enumerates all open PRs (paginated REST, activity-bounded), so trusted
reviews on older open PRs are surfaced; the `gh pr list` default-limit audit done across the
watcher scripts; tests pinning the no-missed-review property.
