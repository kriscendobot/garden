# Report: a sequenced PR-review plan that unblocks progress (journal root)

**Deliverable:** land a report **at the ROOT of the journal** (journal2 root, e.g.
`pr-review-sequence.md`) giving the maintainer an **ordered sequence of pull-request
reviews** that, worked top to bottom, unblocks the most progress. Maintainer directive
(kriskowal, 2026-07-11): the fleet is **merge-bottlenecked on maintainer review** —
M3's exit-criterion capabilities have landed as green, mergeable PRs but cannot advance
without human review/merge. This report is the maintainer's worklist to clear that.

**Land it through the producer-clone discipline** (never the live `journal/` worktree,
which can be arbitrarily stale). Write to the journal2 root and CAS-push, mirroring how
the job-board producers land. Do not hand-`git` the live worktree.

## What to produce

1. **Enumerate the blocking/mergeable PRs.** Query open PRs on **`endojs/endo-but-for-bots`**
   (targeting `llm`, the roadmap branch — and note any that target `master`). Capture per
   PR: number, title, draft/ready, CI/mergeability state, base branch, and whether it is
   stacked on another PR (frozen-base branch → its predecessor). The foreman named a core
   set — **#608 (Docker self-host), #656, #667–672, #678–68x**, and the **#127 glob/grep
   stack** — but derive the full current set from `gh`, do not trust a stale list.
2. **Build the dependency graph** ([pr-dependency-graph](../../skills/pr-dependency-graph/SKILL.md))
   and **topologically sort** it ([pr-dependency-topo-sort](../../skills/pr-dependency-topo-sort/SKILL.md))
   so predecessors are reviewed before dependents (stacked PRs reviewed bottom-up).
3. **Order for maximum unblock.** Within the topo constraints, sequence so that reviewing
   an item **frees the most downstream work** first (a PR many others stack on ranks high).
   Group into "review these now (green, mergeable, unblock others)" vs "blocked until a
   predecessor merges" vs "still in flight / not ready."
4. **For each entry** give: the PR ref (**fully-qualified**, `owner/repo#N`), a one-line of
   what it delivers, its **current state** (green/mergeable, draft, CI-red, conflicts), what
   it **unblocks**, and any **rebase-needed** note (a stacked PR whose base must move once
   its predecessor merges — flag it so the maintainer merges in an order that avoids
   re-freezes).
5. **A short lede** at the top: the bottleneck in one paragraph, the count of
   green-mergeable-now PRs, and the single highest-leverage review to do first.

## Norms
- Read-only against GitHub (query state; **post no PR comments/reviews** — this is a
  planning report). Fully-qualify every issue/PR reference (`owner/repo#N`) per house style.
- Keep the report skimmable and current-dated; it is a snapshot the maintainer acts on.

## Skills
- [pr-dependency-graph](../../skills/pr-dependency-graph/SKILL.md),
  [pr-dependency-topo-sort](../../skills/pr-dependency-topo-sort/SKILL.md),
  [github-activity-poll](../../skills/github-activity-poll/SKILL.md),
  [relative-paths](../../skills/relative-paths/SKILL.md),
  [em-dash-style](../../skills/em-dash-style/SKILL.md),
  [self-improvement](../../skills/self-improvement/SKILL.md).

## Done
A dated report at the journal2 root presents a dependency-correct, unblock-ordered
sequence of `endojs/endo-but-for-bots` PR reviews, each with state + what-it-unblocks +
rebase notes, led by a one-paragraph bottleneck summary and the single first review to do.
Landed via the producer clone (CAS-pushed to `origin/journal2`). The `tada` report gives
the journal path, the PR count reviewed, and the top-of-sequence recommendation.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  claimed_at: 2026-07-11T16:43:47Z
