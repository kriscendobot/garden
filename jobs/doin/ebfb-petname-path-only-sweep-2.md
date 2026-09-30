---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Continue the pet-name-path-only sweep on endojs/endo-but-for-bots#1390 (part 3)

Repo: endojs/endo-but-for-bots. Continue on the EXISTING draft PR
https://github.com/endojs/endo-but-for-bots/pull/1390 (head `build/pet-name-path-only`,
pinned base `llm-8e53cc0`). Push follow-up commits to that head; do NOT open a new PR.
Predecessors: ebfb-petname-path-only, ebfb-petname-path-only-sweep (head b7c33a65d1).

Done in the previous sweep (b7c33a65d1): the tsc errors CI reported in chat / space-chat /
spaces-util / space-file-explorer / agent-tools (makeDaemonEvaluate) / claude-sandbox
setup-hosted / daemon git-authority test-d, plus a real fetch bug (lookupOptional passed a
bare string; the daemon rejection was swallowed as "no policy authority"). `tsc` is clean
locally for packages/daemon, chat, claude-sandbox, agent-tools; fetch tests pass.

Remaining:
1. Bare-string-VARIABLE pet names still reach the daemon at runtime (tsc does not catch
   them where the receiver is `any`). Check each and wrap as `[x]` (or `x.split('/')` for
   slash-delimited UI strings) when x is a single pet name, not already a path. Watch
   especially for try/catch around lookup that silently hides the new TypeError (the
   fetch pattern). Candidates from
   `grep -rnE "E\((powers|host|guest|agent|...)\)\.lookup\([a-zA-Z_.]+\)"`:
   fae/endo-skill.js (agentName/channelName, ~9 sites), fae/src/credentials.js:130,
   fae/src/tool-makers.js:1609, jaine/agent.js:422, daemon/src/networks/{tcp-netstring,ocapn}.js
   (LISTEN_ADDR_NAME), cli/src/commands/checkout.js:36, floot/machine-admin-setup.js:297,
   floot/agent.js (2140,2217,2254,2293,2312,2358,2710), floot/src/container-mounts.js:254,
   floot/test/dev-review.test.js:226/236, agent-mcp-stdio/src/agent-interface.js:677/742,
   lal/agent.js:261, lal/tool-dispatch.js:189, claude-sandbox/src/claude-session-provisioner.js:211
   (`lookup(...clientPath)` spread — should be `lookup(clientPath)`),
   codex-sandbox/src/audit-journal.js (494,523,535), agentry/src/code-mode-provision-host.js
   (102 `remote.credential`, 162 `remoteAlias`). Also sweep other daemon methods
   (storeValue/remove/move/copy/send/provideGuest/makeUnconfined powersName/resultName).
2. Re-run CI (lint = eslint + per-package lint:types; test matrix) and fix what remains;
   then the daemon suite locally (copy worktree to a short path like /var/tmp/eb for the
   unix socket; better-sqlite3 may need `npx node-gyp rebuild`). Known suspects at the
   first hand-off: channel.test.js UI flows, code-mode-provisioning-*, content-store-gc*,
   directory-read-only-view, debugger-captp (check the codemod did not wrap a non-daemon
   `evaluate(source)`).
3. Audit codemod false positives outside daemon (non-daemon receivers such as mount
   `writeText(content)`, `path.resolve`, traces `lookup(id)`, ReadableTree/mount `lookup`);
   revert those that are not daemon pet-name-path arguments.
4. Ask the maintainer (message-user.sh) whether the mount / `@endo/platform` fs surface
   (`platform/src/fs/interfaces.js` NameOrPathShape; `EndoMount` string-or-array paths)
   follows the same rule; it was deliberately left out of #1390. Do not block on the answer.
5. Pre-push gates + typecheck, CI green, update the PR body status section, post the
   pr-completion summary comment.

Coordinate with #1343 (endowment value side); rebase over it if it lands first.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-30T09:42:47Z
