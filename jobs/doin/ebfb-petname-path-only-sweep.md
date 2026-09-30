---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Finish the pet-name-path-only sweep on endojs/endo-but-for-bots#1390

Repo: endojs/endo-but-for-bots. Continue on the EXISTING draft PR
https://github.com/endojs/endo-but-for-bots/pull/1390 (head `build/pet-name-path-only`,
pinned base `llm-8e53cc0`). Push follow-up commits to that head branch; do NOT open a new PR.
Predecessor job: ebfb-petname-path-only (kriskowal's request in
https://github.com/endojs/endo-but-for-bots/pull/1343#pullrequestreview-5360774903).

The core change is on the branch: daemon guards (`NamePathArgumentShape`), `namePathFrom`
now throws the instructive "try again with an array of path components" TypeError on a
string, types, CLI, help docs, changeset, and a codemod pass (string literals at pet-name
argument positions → one-element arrays) over daemon tests and `E(host|guest|agent|powers|*Host|*Guest|*Agent|*Powers).method('lit')`
call sites elsewhere. Remaining work:

1. Convert callers that pass pet names via string VARIABLES: e.g. `powersName: agentName`
   / `resultName: x` / `E(powers).lookup(name)` in `packages/*/setup*.js` (fae, jaine,
   floot, workflow, lal, claude-sandbox, space-*), spaces-util `command-executor.js`
   (`provideHost(String(handleName))`, etc.), chat, lal tools, and `@endo/agentry`
   (`code-mode-provision-host.js` `remote.credential` is `string | string[]` in the
   manifest types — make it a path).
2. Get the daemon suite green. Known failing at hand-off: `channel.test.js` UI-flow tests
   (variable string args), `code-mode-provisioning-*` (agentry), `content-store-gc*`
   (`storeBlob(reader, 'name')` — fixed in daemon tests, recheck), `directory-read-only-view`,
   `debugger-captp` (check the codemod did not wrap a non-daemon `evaluate(source)`).
   Local-run notes: the worktree path is too long for the daemon unix socket (copy the
   worktree to a short path such as /var/tmp/eb to run ava); better-sqlite3 in the store may
   need `npx node-gyp rebuild` against the local Node.
3. Audit codemod false positives outside daemon: it matched method names only, so
   non-daemon receivers (a mount's `writeText(content)`, `path.resolve`, a traces `lookup(id)`,
   ReadableTree/mount `lookup`) may have been wrapped needlessly; revert any that are not
   daemon pet-name-path arguments.
4. Decide with the maintainer whether the mount / `@endo/platform` fs surface
   (`platform/src/fs/interfaces.js` NameOrPathShape; `EndoMount` string-or-array paths)
   follows the same rule; it was deliberately left out of #1390.
5. Run pre-push gates + typecheck (`tsc` in packages/daemon covers agentry) and CI to green,
   update the PR body's status section, then post the pr-completion summary comment.

Coordinate with #1343 (endowment value side); rebase over it if it lands first.

---
claim:
  host: oros-studio-garden-ce242c49
  gardener: 3
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-30T06:03:26Z
