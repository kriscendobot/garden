Opened draft design PR: https://github.com/endojs/endo-but-for-bots/pull/853

- Added `designs/llm-dev-publish.md` (commit `60c9092c425f496d449542bb06276daa9fc83360`).
- Proposed FIFO publishing from `llm`, commit-derived dev versions, staged tags, retry recovery, and npm authentication boundaries.
- Commented on the originating issue.
- Verified Prettier and `git diff --check`; docs could not run because `typedoc` lacks execute permission in the warmed worktree.

Follow-ups: resolve the proposed `dev` versus `llm-dev` tag, package rollout scope, and npm trusted-publishing coverage.
