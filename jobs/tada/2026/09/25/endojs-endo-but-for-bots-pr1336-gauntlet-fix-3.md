---
orchestration-failed: true
---
orchestration-failed: true

# Fix round 3 for PR #1336: fixes pushed, CI red on one macOS cell

I pushed fixes for the round-3 panel findings to `build/endo-guest-stdio-mcp`, taking the head from `4ff416dd32` to `cbadcf336e`. CI then came back red (`ci-wait-merge` rc 3). Of 33 checks, one failed: `test (22.x, macos-15)`. It failed on `daemon-teardown › an orphaned daemon shuts itself down instead of lingering` at the assertion "daemon recorded its pid before its launcher exited". I re-ran the failed job once and it failed the same way.

I don't think our changes caused it, but I haven't proved that:
- This PR changes `@endo/daemon` only by adding one `exports` entry in its `package.json`. No daemon code changed.
- The same test file passes on Linux in my checkout (3 of 3 tests).
- The previous head, `4ff416dd32`, passed `test (22.x, macos-15)`. The CI runs on `4ff416dd32` and before were green.

It looks like a macOS race in the test itself (the pid file isn't there yet when the launcher exits). Because it failed twice in a row on this head, it may not clear on its own. A maintainer or shepherd should decide whether to re-run again or harden that test.

## Changes, as five follow-up commits
- **`fcd6094d8f`** (saboteur, breaker, purist, wire-watcher):
  - Every integer bound a tool's `inputSchema` advertises is now enforced:
    - `grep`/`glorp` `maxResults` must be an integer of at least 1.
    - `readFollower`'s `maxItems` and `waitMilliseconds` must be integers.
    - Anything else is refused as argument-scope before it reaches the guest.
  - A new test builds boundary values from each integer-typed schema property and checks the gate refuses them.
  - The guest check now requires the daemon's `EndoGuest` interface name. `hostOnlyMethods` is now derived from the daemon's `HostInterface` minus `GuestInterface` instead of being a hand-kept list.
  - Two new tests: a facet with the full guest method set plus `provideShell`, and a guest-shaped facet under the `EndoHost` name. Both are refused.
  - `openFollower` checks the follower cap before opening the daemon subscription.
- **`87064be43d`** (engine-realist must-fix, assessor):
  - `main` returns only after stdout and stderr have flushed, so exiting no longer drops the last frames.
  - On the error path, the bin exits from the stderr write callback.
  - A failed `writeLine` now goes to `onError` instead of failing the other in-flight replies.
- **`63d49755d3`** (typist, procurer): `ClaudeStreamParse` and `PrimitiveRecord` moved to `types.ts`. The local check is renamed `isJsonPrimitive`, with a note on why it is narrower than the `@endo/pass-style` one.
- **`be59e2073f`** (purist, spec-keeper, assessor):
  - `reason` and `names` on construction errors are no longer enumerable, and a test covers it.
  - The protocol version and log levels cite the MCP spec.
  - The declared-argument set is built once per call.
- **`cbadcf336e`** (changeset-auditor must-fix, integrator):
  - `@endo/agent-mcp-stdio` now starts at 0.1.0 with a stub `CHANGELOG.md` and a `major` changeset entry, so its first release is 1.0.0.
  - The design-doc paragraph is rewrapped.

I also corrected the PR description to name `@endo/daemon/formula-identifier.js`. I posted one summary comment covering rounds 2 and 3 (scribe's finding): https://github.com/endojs/endo-but-for-bots/pull/1336#issuecomment-5824287598

**Declined:**
- pruner's `SECURITY.md` removal: 129 packages in the repo carry the same file.
- procurer's `renderToolResult` import: the package that has it is private.

**Local checks:** `@endo/agent-mcp-stdio` tests pass (41) and lint shows 0 errors in both packages. All `@endo/agent-tools` `mcp-adapter` tests pass. One `git-flow` test there fails locally with "Git repository identity changed". It doesn't involve this PR's code and looks environmental.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1336-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 144 tokens (8073883 cached reads)
- Output: 33736 tokens
- Cost: $3.4304806
- Wall-clock: 4673s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
