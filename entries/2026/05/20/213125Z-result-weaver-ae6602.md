---
ts: 2026-05-20T21:31:25Z
kind: result
role: weaver
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
worktree: dispatches/weaver--44f240/project
---

Rebased PR #240 (feat(turbo): test depends on transitive ^build) onto current `origin/llm` per kriskowal request on the PR.

Pre/post state:
- Base `origin/llm`: 37dce60ef (verified via `git ls-remote`; #261 merged).
- Pre-rebase head: fed886d8b (2 commits ahead, 76 behind).
- Post-rebase head: d1a55a9ca (2 commits ahead, 0 behind; replayed cleanly).

Lease anchor for `--force-with-lease=feat/turbo-test-depends-on-build:fed886d8bc0be7ab01f5e4c4621dfe86c300a7e9` verified by `git ls-remote` before push.

Conflicts: none. The PR's two commits touch only `turbo.json` and `turbo.json.md`; `origin/llm` did not modify either file since the merge-base. Both commits replayed with the same net diff stat as pre-rebase (turbo.json +1/-2, turbo.json.md +69/-90). `turbo.json` re-validated as JSON post-rebase.

Push: `+ fed886d8b...d1a55a9ca HEAD -> feat/turbo-test-depends-on-build (forced update)`. Remote head confirmed at d1a55a9caf336da19590e5fa28f00072cc210aa2.

Deferred (out of weaver remit): the dispatch note mentions a content follow-up to remove the "build-script caveat" now that #261 broke the relevant dependency cycles. Not touched here; the maintainer's next review on #240 will direct that follow-up.

Refs:
  - PR endojs/endo-but-for-bots#240
  - Merged base PR endojs/endo-but-for-bots#261

Self-improvement: nothing this time.
