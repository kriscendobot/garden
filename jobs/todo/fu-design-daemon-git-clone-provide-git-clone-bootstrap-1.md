---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
In endojs/endo-but-for-bots, build `build-daemon-git-clone`, rooted at `llm`. The builder implements phases 1–4 of `designs/daemon-git-clone.md` (design PR #709): the new `provideGitClone` signature with the `origin` policy record, cleanup on failure, moving the floot and test callers to it, and the new tests. Open a DRAFT PR; the standard gauntlet stages automatically on completion.
