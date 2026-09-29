I built the confined shape of the guest stdio MCP and opened it as draft PR https://github.com/endojs/endo-but-for-bots/pull/1371. CI is green on head `9023562e2d`: 25 checks pass, 8 skipped, none fail.

The branch is `bot/build/claude-confined-stdio-mcp`, on the frozen base `llm-1706e63`, and GitHub reports it mergeable.

**What it adds**
- **`@endo/agent-mcp-stdio`:**
  - `startGuestBroker` runs in the harness process, outside the confined Claude process. It holds the daemon connection, looks up the one guest by formula id, and refuses any id that is not a guest. It serves that guest's tools on a private Unix socket (file 0600, directory 0700).
  - `src/relay.mjs` is the only thing Claude spawns: a plain-Node pipe between its stdio and the broker socket. It is launched as `env -i node relay.mjs <socket>`, so it starts with an empty environment. That fixes gap 2 from #1369 (the MCP child inheriting Claude's credential), without depending on the order in which Claude merges environments.
- **`@endo/claude`:**
  - The entry point is `runConfinedTurn({ formulaId, credential, prompt, model, claudePath })`, plus an `endo-claude-turn` bin. It reads the credential from a file and the prompt from stdin. It drives the #1015 `make()` harness with two new pieces:
    - `makeSpawnFilesPreparer` writes the config, settings and credential files as 0600. Claude gets the credential only through `apiKeyHelper = /bin/cat <file>`.
    - `makeLaunch` spawns Claude directly (no shell) with the #1015 environment, time and output limits, cancellation, and a kill that also takes down the relay.
  - **Stream-json:** the argv now includes `--output-format stream-json --verbose`, and the launcher parses the transcript with `parseClaudeStreamJson`. A turn only succeeds on exactly one final `result`; max-turns, rate-limit, parse-error and non-zero-exit outcomes each map to their own result type.
- Updated the design status, both READMEs, and added a changeset. `yarn.lock` is in its own commit.

**Tests**
- The `broker.test.js` and `confined-turn.test.js` suites use a scripted fake `claude` that behaves like Claude Code: it runs the `apiKeyHelper`, keeps the credential in its own `ANTHROPIC_AUTH_TOKEN`, and passes its whole environment to the MCP server. They show:
  - Claude's environment holds only the allowed variables; no `ENDO_SOCK`, `XDG_RUNTIME_DIR` or `HOME`.
  - Nothing Claude is handed names the daemon socket or the formula id.
  - Claude inherits no socket descriptor.
  - The MCP child's environment, read from `/proc`, is empty and does not contain the credential.
  - Only one guest is reached.
- Locally: 73/73 tests pass in `@endo/claude` and 55/55 in `@endo/agent-mcp-stdio`. `tsc`, eslint, prettier, the composite tsconfig check, package-uniformity and root `tsc` all pass.
- The first CI run failed on macOS: the OS adds `__CF_USER_TEXT_ENCODING` to every process, and the test's allowlist rejected it. I made the test tolerate that one variable and pushed the fix.

**Live verification against a real daemon**
- The stand-in for Claude was the **scripted stdio client**, because this job has no authorized credential. The daemon was real and isolated, with two guests, g1 and g2.
- g1 `writeText`, `list` and `readText` all worked. g2 cannot see g1's note (unknown pet name). A `formulaId` smuggled into a tool call was refused (`argument-scope`). The host's own id and an unknown id were both refused. On every turn the MCP child's environment was empty.
- As a canary, I also ran the real `claude` 2.1.280 through `runConfinedTurn` with a bogus key, so nothing was spent. It accepted the argv and config and spawned the relay, and the relay's `/proc` environment was empty even with a token planted in Claude's own environment. This was not a real model turn: the bogus key ended in the 401 retry loop that #1369 describes, and the turn timed out.

**Coordination**
- I did not build `@endo/inference`. The new pieces are what a #1369-style CLI backend would call.
- I built none of #1340's makers.

**Follow-ups (listed in the PR)**
- The kernel-level sandbox that makes the daemon socket truly unreachable still needs to wrap `claudePath`; `bwrap` isn't on this host, so nothing tests that layer. That sandbox must also supply a scratch `HOME`.
- A daemon-issued bootstrap scoped to the one guest should replace the root-host `lookupById`.
- The config is written as 0600 files, not the `/dev/fd` path the design prefers.
- The launcher does not fail fast on repeated 401s (#1369 gap 11), so a bad credential only ends at the wall-clock limit.
- The pinned CLI version stays at `2.1.232`; this host has 2.1.280.
- The credential file still sits inside the confinement boundary (the known DD7 gap).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endo-claude-confined-stdio-mcp-20260929.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 174 tokens (14216725 cached reads)
- Output: 72634 tokens
- Cost: $6.063161
- Wall-clock: 4436s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
