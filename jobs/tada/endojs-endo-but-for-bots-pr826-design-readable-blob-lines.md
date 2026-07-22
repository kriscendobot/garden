Completed design PR: https://github.com/endojs/endo-but-for-bots/pull/832

- Added `readableblob-lines.md` defining `lines(buffer = 0)`, terminator semantics, implementation coverage, tests, and open compatibility questions.
- Updated roadmap, dependency graph, M3 plan, and estimate.
- Commit: `13647b622`.

Verified: Prettier and Mermaid parsing passed. `yarn docs` not run because the warmed worktree lacked Yarn install state and `typedoc`.

Follow-ups: resolve shared-guard compatibility, `BlobRef` scope, and default buffer policy.

Self-improvement: notified liaison that the designer role links to a missing prompt-discovery skill.
