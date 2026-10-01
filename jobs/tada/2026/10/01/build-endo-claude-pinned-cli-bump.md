## build-endo-claude-pinned-cli-bump: completion report

I opened draft PR **endojs/endo-but-for-bots#1406** from `bot/build/claude-pinned-cli-bump` against the frozen base `llm-d4124e6` (the `llm` tip after #1371 merged). It raises `PINNED_CLI_VERSION` from 2.1.232 to 2.1.280 and cross-links #1371 and the approving review. Unit tests pass (80) and the pre-push gates pass. I did not wait for CI.

**What changed in `packages/claude`**
- **Pin:** `argv.js` now pins 2.1.280. The test fixtures and comments follow, and a new test checks that the old 2.1.232 pin is refused.
- **Permission mode:** without the flag, 2.1.280 reports `permissionMode: "default"`. The command line now always carries `--permission-mode dontAsk` (what the design's confinement recipe asks for) and `--permission-prompts none` (new in 2.1.280). The confinement check refuses to spawn if either is missing, has a different value, or appears twice, since a later copy would override the pinned one.
- **Builtin plugins:** 2.1.280 loads the `agents-md` and `telemetry` plugins even under `--bare`. The per-turn `--settings` file now turns both off with an `enabledPlugins` entry, and the live startup event confirms no plugins load. This works even though discovered settings files are switched off.
- **Docs:** the README flag table and its "Known gaps" entry record the 2.1.280 results, and one row of the design's evidence table now cites this re-run. The automatic typography fixer also changed two existing `…` to `...` in the design, one of them inside a quoted Anthropic passage.

**Live re-run of the negative checks against real `claude` 2.1.280**
I ran it against a scratch daemon under `/tmp` with a fresh guest, using kriscendobot's subscription token, on this PR's code. All checks behaved as intended:
- **Startup event:** reports `dontAsk`; no plugins, skills, slash commands or built-in tools; exactly one MCP server, `endo`.
- **Environment:**
  - `claude` saw only `PATH`, `LANG`, `LC_ALL` and `ENDO_CLAUDE_SESSION_TAG`.
  - The MCP relay's environment was empty.
  - The token appeared in neither process's environment nor command line.
- **No socket reaches the daemon:** `ss` and `lsof` aren't installed here, so I matched socket peers with a small kernel-query script.
  - `claude` held only its stdio pairs and TCP connections to the API on port 443.
  - The relay held only its stdio pairs and the per-turn broker `mcp.sock`.
  - Neither connected to `endo.sock`.
- **Smuggled id:** passing the host's full id as an extra `formulaId` argument to `list` returned `tool-not-permitted`.
- **Blocked tools:**
  - `evaluate` was denied by `dontAsk`.
  - No Bash, Read or subagent tool was offered.
  - A leading `/agents-md` line in the prompt was treated as plain text.
- **Positive path:** writing a note and reading it back through the guest worked.
- **Bad credential:** an invalid token ended as `auth-failed` (401) after two retries.

**Things to know**
- **Wall-clock timeout:** the very first run through the `endo-claude-turn` command hit the 120 s wall-clock limit. Two later runs, including the same six-step prompt, finished in about 28 s, so I treat it as a one-off.
- **minion.town:** the shipped minion.town binary is 2.1.268 (per the design doc). Any host whose `claude` isn't 2.1.280 now refuses to spawn until it is bumped or given an explicit version override after its own re-run. The PR body says so.
- **Builtin subagents:** the startup event still lists them (`Explore`, `general-purpose` and others). They can't be started because the Agent/Task tool is absent, which the live turn confirmed.
- **Cleanup:** the scratch daemon is stopped, the token files are shredded, and the evidence files and temporary driver script are deleted. No token bytes appear in the PR. The garden repo itself was not touched.

**Follow-ups:** the other items from #1371 remain open (1–4 and 6). A guest can still turn an id that appears in its context into authority through `storeIdentifier`, and the broker still serves the unpruned tool catalog. The kernel sandbox, a guest-scoped daemon bootstrap and the in-memory credential residual are also still open, and the live checks are still a manual script rather than an automated test. The review chain (cleaning, panel review, fix loop, un-draft) for #1406 follows automatically.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endo-claude-pinned-cli-bump.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 112 tokens (6062898 cached reads)
- Output: 36916 tokens
- Cost: $3.048227600000001
- Wall-clock: 1026s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
