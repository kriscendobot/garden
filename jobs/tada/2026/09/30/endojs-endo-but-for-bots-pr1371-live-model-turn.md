## Completion report: endojs-endo-but-for-bots-pr1371-live-model-turn

I ran four real `claude -p` turns through #1371's confined launcher. They showed that the subscription token can't be delivered the way the PR was written, so I fixed that and added a fail-fast on rejected credentials. They also showed that the guest can take over its host's authority from a formula id in the prompt; that one needs a maintainer decision, so it's a follow-up. CI is green (25 pass, 8 skipping) and the PR is still **draft**.

**Where it ran.** On this garden host, not minion.town. The main question (can a subscription token go through `apiKeyHelper`?) doesn't depend on the host, and #1369 already covered the production binary and user. Nothing on production was touched.
- A scratch daemon built from #1371's head (base `llm-1706e63`), with its own state, socket and gateway port under `/tmp/e1371`.
- One guest, `pal-agent`.
- Claude Code 2.1.280. The branch still pins 2.1.232, so the runs passed `pinnedCliVersion` explicitly.
- Model `claude-sonnet-5`.
- Credential: kriscendobot's Max subscription OAuth token (`sk-ant-oat…`). It was kept in a `0600` file and shredded afterwards, and no token bytes are in the logs. The daemon was stopped afterwards.

**Evidence (posted as https://github.com/endojs/endo-but-for-bots/pull/1371#issuecomment-5901902627):**
- **Subscription token via `apiKeyHelper` (the PR as it was):** `claude` sends it as an API key and gets `401 authentication_failed` until the 120 s wall-clock limit. That answers the open question in the design: this delivery path doesn't work for a subscription.
- **Token in the `--settings` file's `env` key (my fix):** the stream-json result was `result/success` (tagged `ok`), in 11.4 s, with no retries. The model reached `mcp__endo__writeText` and `mcp__endo__readText`, and I confirmed the write from the host.
- **Invalid key with the fail-fast fix:** `auth-failed` (401) in 4.9 s, instead of waiting out the wall clock.
- **Environments during the turn:**
  - Claude had only `PATH, LANG, LC_ALL, ENDO_CLAUDE_SESSION_TAG`, with no credential.
  - The MCP relay had an empty environment in every turn. That closes #1369's gap 2 (the credential leaking into the MCP server) against a real `claude`.
- **Smuggled formula id:**
  - It was **refused** when passed as an extra `formulaId` argument (`tool-not-permitted`).
  - It was **accepted** through `storeIdentifier`: given the host agent's id in the prompt, the model stored it, and `endo locate pal-agent/smuggled` returned `?type=host`. The guest now holds its host.
- A call to `evaluate` was denied, but only by Claude's own allow-list; the broker still serves the full tool list.

**Commit on #1371, `ed7ffe23c2`:**
- `spawn-files.js`: an `sk-ant-oat…` token now goes in the settings file as `env.ANTHROPIC_AUTH_TOKEN`, and no credential file is written.
- `launch.js`: after two 401/403 retries the child is killed and the turn returns a new `auth-failed` result (`results.js`, `claude.types.d.ts`).
- New tests `test/launch.test.js` and `test/spawn-files.test.js`, and README known-gaps updated.
- The package passes 78/78 tests, with `tsc` and `eslint` clean.

**Follow-ups, named in the PR comment and not done here:**
1. Whether to prune the tools that store identifiers (`storeIdentifier`, `storeLocator`, `internalizeContentLocator`) from the allow-list, or have the daemon refuse ids the guest was never granted. This is the maintainer's call.
2. Enforce tool pruning in the broker itself, not only in Claude's allow-list; the README's claim that pruned tools are "absent at the boundary" doesn't hold yet.
3. The kernel `bwrap` sandbox around `claude`.
4. A daemon bootstrap scoped to the guest, so the harness doesn't hold a host-level connection.
5. Bump `PINNED_CLI_VERSION` after re-running the negative confinement checks. On 2.1.280, `init` reports `permissionMode: default` and the builtin plugins `agents-md` and `telemetry` even under `--bare`.
6. The credential-residual gap is unchanged: `claude` still holds the token in memory, and it sits in a `0600` file inside the boundary.

I also saved a memory note, `endo-pr1371-live-turn-findings.md`.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1371-live-model-turn.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 108 tokens (5393470 cached reads)
- Output: 34649 tokens
- Cost: $2.7344979999999994
- Wall-clock: 2615s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
