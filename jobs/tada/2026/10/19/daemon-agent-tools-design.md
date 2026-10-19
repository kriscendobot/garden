## Completion report: `daemon-agent-tools-design`

**PR:** endojs/endo-but-for-bots#1497 (draft), from head `design/daemon-agent-tools-next-slice` against the frozen base `llm-ca5aaef`. It changes two files: `designs/daemon-agent-tools.md` and `designs/README.md`. Design slug: `daemon-agent-tools`.

### The job's premise was out of date
The job said `daemon-agent-tools` was "Not Started". In fact the design already existed and was In Progress, and its record was behind the code. Checked against `llm` at `ca5aaefb23`:
- `makeHttpTool` and the daemon `provideHttpClient` formula landed on 2026-07-10 (commit `38b6274d81`, Phase 3.6).
- The `@endo/fetch` plugin landed on 2026-07-25.
- #707 landed workspace provisioning and the worked loop (Phase 4).
- #1336 landed the MCP adapter and `@endo/agent-mcp-stdio`.

So instead of writing a new design, I updated the existing one and scoped what is still left.

### What the design now covers
- **Status update** to 2026-10-19, in both the design and its row in `designs/README.md`.
- **§ Next Slice: the sandbox shell engine (Phase 2c).** This is the minimal first slice:
  - a `makeSandboxSpawner(slice)` adapter in `@endo/host-spawner`;
  - a new `ShellPolicy.engine: 'host' | 'sandbox'` field, defaulting to `'host'`;
  - the host passes in the sandbox factory capability, and each shell gets one slice with no network and its own mount at `/work`;
  - if no sandbox backend is available, creating the shell is refused; it never falls back to the unconfined host engine;
  - tests that pair a negative check with a positive one.

  It comes first because a shell running on the host, granted to a confined `endo-claude` guest, would let that guest escape its OS sandbox.
- **§ Relationship to Neighboring Designs:**
  - **`daemon-mount`:** the mount stays the root authority, and the sandbox engine is a second consumer of the same mount capability.
  - **`endo-claude` / `endo-agent-tools`:** the confined guest reaches these capabilities through the `evaluate` tool of `@endo/agent-mcp-stdio`. No new JSON tool is needed, so the JSON tool wrappers stay parked (#731).
  - **fs-interface reconciliation:** this design uses its `Filesystem` method catalog and adds no new methods.
- **§ Ownership Map** for the host → shell formula → engine → sandbox slice → guest boundaries.
- **Phased plan:**
  - Phase 2c: the sandbox shell engine.
  - Phase 7: the `endo-claude` acceptance loop, scripted through `evaluate`, plus a check that a host-engine shell is refused.
  - Phase 8: one HTTP provisioning path, plus an `http` group in `makeWorkspaceTools`.
- **Open questions:** Q1 is marked Resolved. Q2 now notes that the daemon mount's `glob` / `grep` have landed. Three are new:
  - Which HTTP provisioning path should be canonical? Both the daemon formula and the `@endo/fetch` plugin are on `llm`.
  - Should a sandboxed shell require an attested slice? Today only the hosted-agent profile has an attestation.
  - Should each shell get one slice, or should each `exec` get its own?

No build was started. The PR stays draft for the design-panel gauntlet.

## Follow-ups
- Build: Phase 2c, the sandbox shell engine, as specified in § Next Slice of `designs/daemon-agent-tools.md`. That is the next builder job once the design gauntlet passes.
- Open Question 4 (daemon `provideHttpClient` formula or `@endo/fetch` plugin) needs a maintainer decision before Phase 8 can proceed.
- Unrelated to this job: the "Not Started" status that produced this job's prompt must come from somewhere other than the `designs/README.md` M3 row, which already said In Progress. Whatever produced it may need correcting.

<!-- garden-design-build-handoff: successor=daemon-agent-tools-design-build state=recheck:endojs-endo-but-for-bots-pr1497-gauntlet pr=https://github.com/endojs/endo-but-for-bots/pull/1497 -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/daemon-agent-tools-design.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 66 tokens (3266081 cached reads)
- Output: 23693 tokens
- Cost: $2.0732682
- Wall-clock: 315s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
