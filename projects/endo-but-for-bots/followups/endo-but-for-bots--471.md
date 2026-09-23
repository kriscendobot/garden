---
project: endo-but-for-bots
pr_repo: endojs/endo-but-for-bots
pr_number: 471
created_at: 2026-06-17T09:00:00Z
last_appended_at: 2026-06-17T09:00:00Z
status: parked
---

# Follow-ups for endo-but-for-bots#471

## Items

- [ ] `@endo/preact-container` and `@endo/space-file-explorer` declare `preact` as a direct dependency rather than a peer dependency. If either package goes public, dual-instance Preact risk arises at the host level (the packages hook into Preact's `options` object and a second instance would not see the hooks). Revisit before any future `"private": false` change.
  **Source juror(s)**: migrator
  **Round**: 1
  **Recommended action**: when publishing these packages, move `"preact"` from `dependencies` to `peerDependencies` in both `@endo/preact-container/package.json` and `@endo/space-file-explorer/package.json`.

- [ ] `sanitizeUrl`, `sanitizeUrlList`, `sanitizeElementProps` in `@endo/preact-container/src/renderer.js` would benefit from fast-check property-based tests covering the full allowlist/denylist domain. The current example-based tests cover the obvious cases; property tests would increase confidence in edge cases (protocol prefix variants, Unicode whitespace leading bytes, srcset comma edge cases).
  **Source juror(s)**: fast-checker
  **Round**: 1
  **Recommended action**: file a follow-up PR adding fast-check property tests to `packages/preact-container/test/`.

- [ ] UA feedback from kumavis (recorded in PR comment 2026-06-17): buffer inventory and messages to avoid round trips; stream messages per mailbox in sender-filtered channel views; file-explorer column continuation after selecting a git tree object; always-present Spaces selector bar; audit codebase for DOM-API cruft from incremental migration; "edit space" button broken; peer info red side border unnecessary; reauthor commits as @ph0ngb0t; package names should match `@endo/space-*` form.
  **Source juror(s)**: scribe
  **Round**: 1
  **Recommended action**: migrate all items to `packages/chat/designs/preact-confinement-migration.md` tracking section before merge; address "edit space" and peer info border in a follow-up PR; coordinate @ph0ngb0t reauthorship with maintainer.
