# Scholar: re-ingest the pubsub sources when #513 / #507 stabilize

Wear the **scholar** role. Two change-propagation library sources were ingested on
2026-06-25 from unmerged PR branches and must be refreshed when those PRs move:

1. `endo-but-for-bots--pkg-pubsub-readme` — `@endo/pubsub` README, PR #513
   (`feat/endo-pubsub`), file-commit `d15e34cb`.
2. `endo-but-for-bots--llm-designs-notifier-pubsub-migration` — the design, PR #507
   (`design/notifier-pubsub-migration`), revision 5, file-commit `8c2a46be`.

## When to act

Re-check each PR head per the lifecycle block in each source-index `notes:`:
```
git --git-dir=worktrees/endojs-endo-but-for-bots.git fetch origin pull/513/head:refs/pull/513/head
git --git-dir=worktrees/endojs-endo-but-for-bots.git log -1 --format=%H refs/pull/513/head -- packages/pubsub/README.md
git --git-dir=worktrees/endojs-endo-but-for-bots.git fetch origin pull/507/head:refs/pull/507/head
git --git-dir=worktrees/endojs-endo-but-for-bots.git log -1 --format=%H refs/pull/507/head -- designs/notifier-pubsub-migration.md
```
If a SHA differs from the recorded `source_commit`, treat as a normal idempotency
mismatch and re-ingest the changed parts. On merge, rewrite `source_branch:` to the
default branch, refresh `source_commit:`, set `source_pr_state: merged`, and drop the
unmerged caveat. On close-without-merge, mark the source and its sections stale.

## Specific things to reconcile

- **Factory-name divergence.** The implementation (#513) uses
  `makeChangeTopic` / `makeLatestTopic` returning `{ publisher, subscribe }`; the design
  (#507) uses `makeChangesPubSub` / `makeLatestPubSub` returning
  `{ sink, makeSpring, finish, fail }`. When the two reconcile (or the maintainer
  settles which is canonical), update the `endo-pubsub` concept page's
  "Factory-name divergence" note and the source-index `notes:`.
- **`@endo/cancel` landing.** The design is gated on a prerequisite `@endo/cancel`
  package (home for `makeCancelKit`) that did not exist on `llm` as of 2026-06-25. If it
  lands, ingest it as a sibling source and update the cancellation references.
- **`makeWindowTopic` / FRB collection-change propagation.** If the
  `research-frb-endo-exo-collections` draft (`projects/endo/drafts/`) is promoted to a
  landed design or a real `@endo/reactive-collection` package, ingest it as a proper
  source and upgrade the `sliding-window-topic` citations from draft to source.

## Definition of done

Both sources re-checked against current PR heads; changed parts re-ingested with the
idempotency check; the factory-name divergence reconciled (or re-flagged if still open);
concept pages and indexes updated; a `result` entry posted; the job completed.

Posted by the scholar (`scholar-continue-change-propagation`) as a follow-on for work
that must wait on #513 / #507 / #345 stabilization.
