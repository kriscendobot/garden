I've resolved all 13 inline comments from review 5307103246 on PR #1336 and pushed. Each thread has a reply naming the commit, and there's one summary comment. **CI has not finished:** after 25 minutes of watching, every job on head `3c3d8cf` was still pending (8 checks had passed, none had failed).

**Pushed to `build/endo-guest-stdio-mcp`:**
- `7d3cf4eb7f` fix(agent-mcp-stdio): address review 5307103246
- `3c3d8cfd3c` chore: Update yarn.lock (separate commit, as asked)

**What changed:**
- **Rename:** the package is now `@endo/agent-mcp-stdio` in `packages/agent-mcp-stdio`, and `guest-interface.js` is now `agent-interface.js`. Package.json, the regenerated tsconfigs, README, design doc, changeset and yarn.lock are updated. I kept the bin name `endo-mcp-stdio` and gave the reason in the thread.
- **minion.town removed:** the changeset no longer mentions it, and the adapter has no reserved-name list of its own. A caller can pass its reserved names as `advisoryReservedNames`, which defaults to empty.
- **Evaluators:** `evaluate` and `define` are now tools, and the comment says they are deliberately present. The adapter and its tests no longer reject those names.
- **`args` spelled out** in identifiers: `argumentsShape`, `normalizeArguments`, `MessageNumberArgumentShape`, `toolArguments`, and `commandArguments` for the config option. The `args` key in the generated MCP config file stays, because that's the MCP config format.
- **`makePath`** added beside `makeDirectory`. The daemon has no guest-level `makePath`, so it calls `has` on each part of the path and `makeDirectory` only where one is missing.
- **Tools the daemon already had:** the rest of the inbox and mail methods, `glob`/`grep`/`glorp` through a mount the guest holds, and the locator, identifier and content-locator tools. `storeLocator` is the guest's way to adopt a locator. `invite` and `accept` are in too.
- **Follow tools:** since MCP calls are request/response, each `follow*` tool returns a handle. `readFollower` then returns up to a set number of items, waiting a limited time for each, and `closeFollower` releases the handle. This covers the inbox, name changes and a stream stored under a pet name. The README and the file header document this.
- **Formula ids:** the daemon now exports its formula-identifier helpers as `@endo/daemon/formula`, and `server.js` uses them instead of its own regex. The changeset now covers `@endo/daemon` too.
- **Test fakes:** they use `makeExo` with interface guards instead of `Far`, and import `makePromiseKit` from `@endo/promise-kit` instead of local copies.

**Checks:**
- `@endo/agent-mcp-stdio`: eslint, tsc and 23 tests pass.
- `@endo/agent-tools`: tsc and the adapter and exports tests (17) pass.
- The repo-wide `tsc` run and the composite-tsconfig check are clean.
- The garden pre-push probes pass against the base.

To pass the probes I added opt-out markers with a reason in the file headers for a few names that aren't ours to change:
- `temp` is a field name set by `@endo/where`.
- `num_turns` is a field in Claude's stream output.
- `stdio.js` needs a streaming UTF-8 decoder, which `@endo/bytes` doesn't have.
- `index.js` is the package's own entry point, not a re-export shim.

**Gaps listed in the thread, not invented:**
- There are no streaming versions of grep/glob/glorp in the daemon.
- `adoptFromLocator` exists only on hosts, not guests.
- Methods that only take or return object references can't be expressed as JSON tool arguments. They stay reachable through `evaluate`.
- The makers for confined apps exist only on hosts. The already-posted designer job `design-agent-mcp-confined-app-makers` owns them; it is parked on the plan queue and needs promoting to run.

My first reply on the confined-app thread named the host's makers wrongly. I edited it in place with the correct list.

**Follow-ups:**
- Someone should check CI on `3c3d8cf` once it runs.
- The build-versus-buy check for duplicated exports that the maintainer suggested is a garden self-improvement idea. I didn't do it here.

The PR is still a draft, and no gauntlet was run.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1336-fix-review-5307103246.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 136 tokens (9383443 cached reads)
- Output: 58259 tokens
- Cost: $4.5664045999999985
- Wall-clock: 728s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
