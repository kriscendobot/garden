## Completion report: improve-minion-mcp-stdio-config-replace

The Codex bridge is now declared as one complete server table, as the job asked, but that change alone does not fix the bug. I tested codex 0.156.0 directly: it merges `-c` overrides key by key into the saved config even when the override is a whole table. That covers `-c mcp_servers.minion-town={command=…,args=…}` and also the whole `-c mcp_servers={…}`. Both still fail with "url is not supported for stdio" when `~/.codex/config.toml` already has a `url` entry for `minion-town`. Nothing Codex accepts on the command line replaces a saved entry outright.

What does stop the failure is the fix already on main2 in 288829c8196 (05:22Z, after the 04:52Z incident). When a saved `minion-town` entry exists, it switches that entry off and attaches the bridge as `minion-town-garden`. I kept it and added tests against the real Codex CLI.

**Changes (pushed to main2 as `988cd230cfb`):**
- **`scripts/jobs/minion-mcp-lib.sh`:** `minion_mcp_codex_args` now emits a single `-c mcp_servers.<name>={command,args,env,startup_timeout_sec,tool_timeout_sec}` instead of five dotted per-key overrides. The comment explains why that alone is not enough and why the rename stays.
- **`scripts/jobs/test/minion-mcp-test.sh`:**
  - The arguments must be exactly one server table that parses as TOML and holds only stdio keys.
  - The real Codex CLI must load and list `minion-town-garden` with each of three saved URL configs: a plain `url`, `url` plus `bearer_token_env_var` and `http_headers`, and an inline URL table.
  - A probe prints a NOTE if a future Codex starts replacing table overrides, at which point the rename can be retired.
- **`context/operations/minion-town-mcp.md`:** the cleric row now describes the single table and the merge behaviour seen in 0.156.0.

**Verification:** `minion-mcp-test.sh` passes 56 of 56, including the real-CLI checks. Shellcheck shows no new warnings beyond the file's usual style notes.

**Follow-ups:** none needed. If the NOTE probe ever fires after a Codex upgrade, the `minion-town-garden` rename can be removed.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-minion-mcp-stdio-config-replace.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 20 tokens (552051 cached reads)
- Output: 8288 tokens
- Cost: $0.7306582
- Wall-clock: 127s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
