I've opened draft PR **endojs/endo-but-for-bots#1409**. It makes the confined broker serve only an allow-listed set of tools, and refuse any other tool when it is called. Tests, lint and type checks pass locally; CI on the PR has not been watched yet.

**The problem:** `startGuestBroker` handed out the guest's full tool list. Only `claude`'s `--allowedTools` flag held back `evaluate`/`define`, so they still appeared in the broker's `tools/list` and in `claude`'s `init.tools`.

**The fix** (in `@endo/agent-mcp-stdio`, based on frozen `llm-d4124e6`, which is `llm` after #1371 merged):
- **Allow-list:** a new `src/confined.js` holds `confinedToolNames`, a fixed list of the tools a confined turn may use. Any tool added to the full guest list later stays hidden from confined turns until someone adds it here.
- **Broker:** `startGuestBroker` now builds every session from that list only. A withheld name is missing from `tools/list` and is refused if called, with error `-32001 tool-not-permitted` (`name-scope`); the guest method is never reached.
- **Option:** a new `allowedToolNames` option can narrow the list further. If the list matches no real tool, the broker refuses to start.
- **Withheld:**
  - code evaluation: `evaluate`, `define`;
  - identifier and locator tools: `identify`, `reverseIdentify`, `listIdentifiers`, `storeIdentifier`, `locate`, `listLocators`, `reverseLocate`, `storeLocator`, `invite`, `accept`, `followLocatorNameChanges`.
- **Unchanged:** `@endo/claude`'s own pruning stays in place as a second check. The single-tenant `endo-mcp-stdio` server still serves the full list.
- **Also included:** a changeset, README updates for both packages (the "absent at the boundary" paragraph now covers the broker), and the export-list test update.

**Coordination with the identifiers job:** that job became PR #1404, which removes identifiers and locators from guests at the daemon. This PR hides the same tools at the broker, so the confined path is closed whichever PR merges first, and neither needs editing for the other. Like #1404, it keeps the content-locator tools (including `internalizeContentLocator`), since they carry no authority. The PR body says this is a one-line change if the maintainer wants it hidden too.

**Tests run locally:**
- **Broker, through the real `env -i` relay:** only allowed names are listed. Calls to `define`, `evaluate` and `storeIdentifier` are refused and never reach the guest. The narrowing option and the refuse-to-start case are covered.
- **Allow-list:** every allowed name is a real tool, every real tool is either allowed or withheld, and the list is frozen.
- **End-to-end confined turn in `@endo/claude`:** the broker's tool list contains no withheld name. This assertion fails on `llm` without the change.
- **Results:** `ava` passes in both packages (`claude`: 78 tests). Per-package `tsc` and `eslint` show no errors. The repo-root `tsc -p tsconfig.json` is clean.

**Follow-ups:**
- I have not run a live `claude` turn to confirm `init.tools`; the PR body says so.
- The review steps after a build (clean, panel review, fixes, un-draft) should be staged automatically when this job completes.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endo-claude-broker-catalog-pruning.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 92 tokens (4433833 cached reads)
- Output: 26424 tokens
- Cost: $2.355990600000001
- Wall-clock: 378s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
