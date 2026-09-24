## Completion report: build-endo-guest-stdio-mcp

I built the single-tenant shape of the endo-guest-stdio-mcp design and opened it as draft PR **endojs/endo-but-for-bots#1336**. The PR targets a pinned base, `llm-6726b0f`, which is where #1226 merged. The confined shape is not built (see Follow-ups). As the manual-gauntlet regime requires, I stopped at the draft and staged no gauntlet. I did not wait for CI on the PR.

**What changed** (branch `build/endo-guest-stdio-mcp`: one feature commit, plus a separate `chore: Update yarn.lock` commit)
- **`@endo/agent-tools/adapters/mcp.js`** was a stub and is now implemented:
  - **Catalog check:** `makeToolCatalog` validates the fixed tool list and refuses to start with a specific reason: `empty-interface`, `malformed-name` or `catalog-name-conflict`. A clash with minion.town's reserved names only produces a warning.
  - **Request handling:** `makeMcpToolServer` returns the design's error codes:
    - `-32001` with `name-scope` or `argument-scope` for a tool name or argument outside the catalog.
    - `-32010 bridge-down` when the daemon connection is lost.
    - An `isError` result when the guest's method throws.
    - The standard JSON-RPC codes for malformed requests.
  - It also has the logging facet. A changeset is added.
- **New private package `@endo/guest-mcp-stdio`**, which provides the `endo-mcp-stdio` command:
  - It reads the guest id from `ENDO_GUEST_FORMULA_ID`, connects with the ordinary daemon client, and looks up that one guest with `lookupById`. It refuses anything that is not a guest, including a host.
  - Messages are split on `\n` only.
  - The tool list is fixed at 14 guest tools, with no code-evaluation tools.
  - It includes the harness-side helpers `makeMcpConfig` and `renderGuestAllowedTools`, and `parseClaudeStreamJson` for reading `claude -p` output.
- The design's Status is now In Progress, in both the design doc and `designs/README.md`.

**A gap between the design and the daemon:** the design treats the formula id as 64 hex characters. The daemon's actual ids are `<number>:<node>`, and `lookupById` needs the full form. The server accepts either form. For the short form, it fills in the local node taken from the host's own id (`identify('@agent')`). This is recorded in the design's Status section and in the PR.

**Verification**
- **Tests:** 19 pass in the new package and 15 new adapter tests pass in agent-tools. `tsc` and eslint report no errors, and the composite tsconfigs are up to date.
- **Failing test:** one test in agent-tools fails, `git-flow` ("Git repository identity changed"). It comes from the native git backend and doesn't touch the adapter, but I did not confirm whether it also fails on unmodified `llm`.
- **Live check against a real, isolated daemon:**
  - Protocol: `initialize` and `tools/list` worked.
  - Tool calls: they reached the guest, and a read of a missing file came back as an `isError` result.
  - Refusals: `evaluate` got `name-scope`, and both an unknown id and the host's own id got `invalid-formula-id`.
  - Lifecycle: after `endo stop`, the next call got `-32010 bridge-down`, and the server exited 0 when its input closed.
- **Setup notes:** the local install used the node-modules linker and skipped native builds. So the daemon would start, I copied a prebuilt `better_sqlite3.node` from another worktree into this checkout's `node_modules`, which is not committed.

**Follow-ups (not in this PR)**
- **The confined shape:** a harness-owned daemon connection outside the sandbox (a broker or a guest-scoped bootstrap), plus the test that the sandboxed process cannot reach the daemon socket. This belongs with `@endo/claude` (#1015) and endo-posix-sandbox; the entry point for it is `makeGuestMcpServer({ guest })`.
- **Harness wiring:** connecting `@endo/claude` to `makeMcpConfig`, `renderGuestAllowedTools` and `parseClaudeStreamJson`, and passing the config through a pipe or memfd path rather than a file.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endo-guest-stdio-mcp.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 146 tokens (9980748 cached reads)
- Output: 73908 tokens
- Cost: $5.053885599999999
- Wall-clock: 770s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
