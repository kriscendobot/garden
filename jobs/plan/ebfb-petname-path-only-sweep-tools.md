---
gate: orchestrated
orchestrated_by: ebfb-petname-path-only-sweep-orch
priority: normal
role: builder
posted_by: builder
posted_at: 2026-09-30T07:56:52Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Pet-name paths in agent tool surfaces and endowment lists (#1390, part 1 of 3)

Repo: endojs/endo-but-for-bots. Continue on the EXISTING draft PR https://github.com/endojs/endo-but-for-bots/pull/1390 (head `build/pet-name-path-only`, pinned base `llm-8e53cc0`). Push follow-up commits to that head branch; do NOT open a new PR. Lineage: ebfb-petname-path-only -> ebfb-petname-path-only-sweep (commit e1f3522a3). Rule (kriskowal, https://github.com/endojs/endo-but-for-bots/pull/1343#pullrequestreview-5360774903): daemon pet-name arguments are arrays of path components only; a string is refused, never split. Note `NamePathsArgumentShape` (evaluate/send endowment lists) is `arrayOf(NamePathArgumentShape)`, so EACH entry must itself be an array (`[["a"], ["dir", "b"]]`). Variadic `.rest(NamePathShape)` methods (`has`, `remove`, `identify`, `locate`, `list`, `listIdentifiers`) still take spread components and need no change. Host note: this host is I/O-starved; checkout/grep over the monorepo can take minutes, so scope commands to package directories.

Already done in e1f3522a3: string-variable callers in setup/factory scripts (fae, jaine, floot, workflow, claude-sandbox, space-nixos-admin), chat add-space-modal, spaces-util command-executor, agentry credential (normalized to a path), platform fs extended modules.

Remaining in this part:
1. evaluate/send endowment lists and worker names built from strings, typically LLM tool inputs. Example: packages/fae/src/tool-makers.js ~L170-189 (workerName defaults to '@main'; petNames = Object.values(endowments: Record<string,string>)). Same shape in lal tools (packages/lal/tools/*.js), jaine, floot, hosted-agent, agent-mcp-stdio, codex-sandbox, claude-sandbox (evaluate petNames arrays such as ['@agent', underNamespace(...)] in src/claude-sandbox-factory.js ~L400 and src/provision-claude-session.js), chat (counter-proposal-form.js, eval-form / chat-bar-component in spaces-util), cli. Decide per surface: tool schemas an LLM sees should ask for arrays of path components (update the schema description and examples), and must NOT split strings on a delimiter. Browser form UIs may split user-typed text on '/' (the existing command-executor convention).
2. Re-scan for remaining identifier/String() args at guarded positions outside packages/daemon (lookup, storeValue, storeBlob, provideGuest/Host/Worker, invite, accept, adoptFromLocator, makeTimer, makeChannel, request, cancel, makeDirectory on a daemon receiver, and powersName/resultName/agentName/workerName option bags). About 400 grep candidates existed before e1f3522a3; most are already arrays. Check each variable's origin rather than wrapping blindly. Non-daemon receivers (mount/ReadableTree/git tree/9p cap/traces lookup, reminder root.makeDirectory on a vfs) stay as they are.
3. node --check + prettier on changed files, commit, push.
