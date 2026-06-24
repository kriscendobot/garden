---
ts: 2026-05-19T05:50:36Z
kind: dispatch
role: steward
to: "*"
project: endo-but-for-bots
prs:
  - repo: endojs/endo-but-for-bots
    pr: 288
    role: target
---

# Dispatch: fixer (retcon) on #288 per kriskowal directive

kriskowal at `05:46:40Z` on PR #288: *"Please reset and stage into
grouped commits per standing instructions."*

Plus an inline note at `cbor-frame.test.js:169` from the
`COMMENTED` review at `05:45:37Z`: *"`mapReader` exists already."*

Dispatch root: `/home/kris/dispatches/fixer--57e420` on `feat/cbors-package`. The fixer
applies the retcon discipline per
`skills/retcon/SKILL.md`: per-package commits, separate
`chore: Update yarn.lock` commit, implementation and tests
combined. **PR net diff is invariant** — the rewritten branch's tree
must match the current tree exactly.

The mapReader note is a follow-on: the fixer should use
`mapReader` from `@endo/stream` (which exists, per kriskowal) in
the test refactor that was previously TODO-noted in commit
`598b54a43` (deferred to "future revision once @endo/stream gains a
mapReader-style helper"). The retcon is the opportunity to replace
the TODO note with a concrete use of `mapReader`.

Per-action authorizations: force-push-with-lease to
`feat/cbors-package` is implicit in the retcon dispatch. Reply on
the directive comment thread; top-level summary; re-request
kriskowal review after CI green via `gh pr edit --add-reviewer`.
