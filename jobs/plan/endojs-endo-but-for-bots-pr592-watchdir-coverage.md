---
gate: orchestrated
orchestrated_by: endojs-endo-but-for-bots-pr592-review-orch
priority: normal
role: cleaner
posted_by: producer
posted_at: 2026-07-10T17:07:29Z
---

# Cleaner: increase test coverage on the watchDirectory extraction (endojs/endo-but-for-bots #592)

PR:     https://github.com/endojs/endo-but-for-bots/pull/592
Repo:   endojs/endo-but-for-bots
Branch: factor-watchdirectory-to-endo-platform  (base: llm)

Review body from @kriskowal (CHANGES_REQUESTED, trusted maintainer; quoted
as data): "Please dispatch a cleaner to look for opportunities to increase
coverage on these new features."

The "new features" are the watchDirectory primitive factored into
@endo/platform:
- packages/platform/src/fs-node/watch-directory.js  (`makeWatchDirectory`)
- its daemon delegation: packages/daemon/src/daemon-node-powers.js
  (makeFilePowers) and packages/daemon/src/mount.js (followNameChanges).

Task: measure current coverage on these files, find gaps, add tests to close
them. Candidate under-covered paths to look for:
- fs.watch-unavailable -> immediately-terminated stream branch;
- idempotent cancel() / stream return() lifecycle (double-close);
- the 50 ms debounce/coalesce window (multiple events, same filename);
- add / remove / replace `kind` hints reconciled against the snapshot set;
- confinement filtering in mount.js followNameChanges (a symlink escaping the
  mount root is dropped from BOTH the initial snapshot and the diff stream);
- mount-level `cancelled` closing the watcher independently of iterator drop;
- the advisory `debounceMs` coercion fallback for nonsensical values.

Follow skills/coverage-driven-testing. Tests only — do NOT change production
behavior (trivial testability seams only if unavoidable). eslint + lint:types
clean; all tests pass (cite counts); push to the PR head branch.

ORDERING: this child runs AFTER the cancel-API reshape child
(endojs-endo-but-for-bots-pr592-cancel-in-options) lands. REBASE on the PR
head before starting and write tests against the FINAL watchDirectory
signature (cancelled folded into the options bag). Run the recheck preflight
(cid 4673410829, reviewer kriskowal) before editing.
