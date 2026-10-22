---
arc: minion-town-git-remote
role: designer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Design step for endojs/endo-but-for-bots (base `llm`): write `designs/daemon-git-clone.md`, specifying `provideGitClone(...)` repository bootstrap (mount creation + endpoint policy + sealed credential authority + clone into the new mount) and the commit-author/identity boundary as a capability shape. This is the open item in `daemon-git-next-steps` that the `GitRemote` composition (`daemon-git-remotes` § Repository Bootstrap) now unblocks, and it serves the capability git remote arc.
