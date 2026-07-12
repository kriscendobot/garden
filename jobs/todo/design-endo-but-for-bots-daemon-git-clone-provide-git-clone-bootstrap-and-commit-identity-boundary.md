---
role: designer
---

Author the new `daemon-git-clone.md` design record in endojs/endo-but-for-bots: specify `provideGitClone(...)` (composing mount creation + endpoint policy + sealed credential authority + clone-into-the-new-mount, returning the resulting `EndoMount` + `Git`) and the paired commit-author / identity boundary, closing the "you give me a URL, the agent runs, and its commits are attributed correctly" gap named in `daemon-git-next-steps.md` § Open Work; cross-link `daemon-git-remotes` § Repository Bootstrap and the in-flight commit-identity work (PR #706).
