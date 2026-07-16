Opened DRAFT PR https://github.com/endojs/endo-but-for-bots/pull/756 against `llm` with the recovered hardened URL shim design reconciliation. The document already existed on `llm` with identical substantive content, so the PR avoids a duplicate and normalizes its prose and table markers to ASCII while fully qualifying project references. The PR body links endojs/endo-but-for-bots#84, merge commit 4cb1ed4d2, open endojs/endo#2635, and partially addressing open endojs/endo#3322.

Verification: `git diff --check origin/llm...HEAD` and a non-ASCII-byte scan passed. `npx corepack yarn prettier --check designs/hardened-url-shim.md` was not run because this fresh worktree has no installed dependencies (Yarn reported that the project has not been installed).

Self-improvement: nothing this time.
