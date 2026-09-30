---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Continue the pet-name-path-only sweep on endojs/endo-but-for-bots#1390 (part 4)

Repo: endojs/endo-but-for-bots. Continue on the EXISTING draft PR
https://github.com/endojs/endo-but-for-bots/pull/1390 (head `build/pet-name-path-only`,
pinned base `llm-8e53cc0`). Push follow-up commits to that head; do NOT open a new PR.
Predecessors: ebfb-petname-path-only, -sweep, -sweep-2 (head 3eb4c48bc4).

Done in sweep-2: wrapped the remaining bare-string pet-name VARIABLES at lookup/storeValue
sites (fae, jaine, floot, lal, codex-sandbox, agentry, networks LISTEN_ADDR_NAME,
claude-session-provisioner spread); fixed a real daemon bug (host makeUnconfined defaulted
the worker to the bare string '@node', which namePathFrom rejects -> now ['@node']); string
worker names / resultName in makeUnconfined callers (space-file-explorer, platform fs
attach/mkmem, setup-iroh + its test, endo.test.js, endo-fs-exec test); fae subagent-host and
reminder plugin test fakes now accept array paths. tsc clean for daemon, floot, fae,
space-file-explorer, platform, agentry, claude-sandbox, codex-sandbox, lal.
Maintainer was asked (message bus) whether the mount / @endo/platform fs surface follows
the same rule; do not block on it.

Remaining:
1. Watch CI on 3eb4c48bc4 (lint, test matrix incl. macOS, cover). Fix remaining failures;
   they are most likely test FAKES keyed by bare strings (the fae/reminder pattern:
   `lookup(name)` fakes that compare `name === 'x'`) or remaining string worker args
   (`provideWorker('x')`, `makeBundle('x', ...)`, `evaluate('x', ...)` worker slot).
2. Daemon suite locally (copy worktree to a short path like /var/tmp/eb for the unix socket;
   better-sqlite3 may need `npx node-gyp rebuild`). Suspects: channel.test.js UI flows,
   code-mode-provisioning-*, content-store-gc*, directory-read-only-view, debugger-captp.
3. Audit codemod false positives outside daemon (mount writeText(content), path.resolve,
   traces lookup(id), ReadableTree/mount lookup); revert non-daemon ones.
4. Pre-push gates, CI green, update the PR body status section, post the pr-completion
   summary comment.

Coordinate with https://github.com/endojs/endo-but-for-bots/pull/1343 (endowment value side); rebase over it if it lands first.
