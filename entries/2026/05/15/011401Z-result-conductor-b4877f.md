---
ts: 2026-05-15T01:14:01Z
kind: result
role: conductor
repo: endojs/endo-but-for-bots
project: endo
refs:
  - entries/2026/05/15/011200Z-dispatch-steward-b4877f.md
---

# Result: PR #126 title and body refreshed; merge blocked by OAuth `workflow` scope

Per maintainer comment 4454679616 on PR #126.

## Title

Before: `ci: disable npm lifecycle scripts in workflows (re-opened from #26 under the bot)`
After:  `ci: disable npm lifecycle scripts in workflows`

## Body

Refreshed to address the eventual squash-merge commit reader, following the upstream PR template (`Description`, `Security Considerations`, `Scaling Considerations`, `Documentation Considerations`, `Testing Considerations`, `Compatibility Considerations`, `Upgrade Considerations`) with `Refs: #26 (superseded)` at the top. Three categories of content were dropped per the dispatch brief:

1. Forwarding preamble (the "Forwarded from #26 under the bot per the re-open-under-bot pattern" paragraph and the "## Original PR body" heading) and bot trailers (cc @kriskowal, Co-Authored-By, Generated with Claude Code).
2. The "Test plan" checklist (per `pr-formation` no-checklists rule).
3. The "Forwarded inline review comments" section (kriskowal's "Let's remove this" / "And remove this" inline comments on `ci.yml:393` and `check-no-ci-lifecycle.mjs:1`, both already addressed in the diff via the commits that removed those lines).

Substantive content retained and reshaped into template sections: the env-var posture description, the immutable-install tightening, the design-document reference (`designs/ci-no-npm-lifecycle.md`), and the scope-of-this-PR / out-of-scope statements about the dropped lint script and deferred follow-ups.

## Merge result

Blocked. `gh pr merge 126 -R endojs/endo-but-for-bots --squash` returned:

> GraphQL: refusing to allow an OAuth App to create or update workflow `.github/workflows/ci.yml` without `workflow` scope (mergePullRequest)

The bot's GitHub token does not carry the `workflow` OAuth scope; squash-merging this PR would update files under `.github/workflows/` which requires that scope. Per the dispatch brief's contingency, posted a top-level comment on PR #126 naming the block and handing back to @kriskowal: comment 4456013946. No force, no delete-branch.

PR state on exit: `state=OPEN`, `mergeable=MERGEABLE`, CI still green from the post-shepherd run. The maintainer can issue the merge under their own credentials, which carry `workflow` scope.

## Merge convention note

Recent merges on `llm` (`#255`, `#148`, `#245`, `#228`, `#121`) are all squash-merged (single commits with `(#N)` suffix), so `--squash` matches repo convention here. The conductor role's "always `--merge`" default is overridden by the explicit dispatch authorization "or `--merge` per repo convention". This is a maintainer-directed one-off merge rather than a queue-drain, so the role's linearization rationale (preserving per-PR clusters for unit-revertibility) does not apply.

Self-improvement: the conductor AGENT.md's "always `--merge`, never `--squash`, never `--rebase`" rule is silent on the bot-fork ⇒ llm-branch case where repo convention is squash. A line acknowledging that maintainer-directed dispatches may override the merge-shape default would save the next conductor reading the role file from re-deriving this from the dispatch prompt. Logging as a candidate `message` to the liaison if a second use confirms.
