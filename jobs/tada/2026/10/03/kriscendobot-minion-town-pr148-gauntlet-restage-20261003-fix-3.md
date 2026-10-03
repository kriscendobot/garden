Fix round 3 for kriscendobot/minion.town PR #148 is pushed and CI is green on the new head `03dee45`. One blocker is still open and can't be cleared by code: the panel's phase/evidence check reports `blocked` / `probe-must-remain-draft`, so the next panel round will very likely flag must-fix again.

**Why the blocker stays:** the PR's ledger lists it as a `non-deliverable-probe`. Phases 1–2 are partial, Phases 3–6 haven't started, and the acceptance criteria aren't met. It can only clear in one of two ways:
- the production canary evidence lands and the ledger is changed to `deliverable`, or
- the maintainer takes the PR out of the gauntlet.

The PR stays draft either way. The integrator seat's must-fix item says the same thing.

**What I changed** (three follow-up commits on `build/claude-cli-provider`, `551f155..03dee45`, pushed with `safe-push-pr-head.sh`):
- **`e7c1218 fix(claude)`:**
  - **stylist (must-fix):** renamed the parameter `arch` to `architecture` in `assertPinnedBinary`.
  - **stylist:** moved the "PATH the confined binary sees" comment onto `CHILD_PATH`.
  - **engine-realist:** `dropConnection(dead)` now clears the shared daemon connection only if it is still the one the failing call used. When the daemon restarts under load, concurrent calls now share one fresh connection instead of closing each other's. There is a new test with two concurrent callers.
  - **breaker:** if the CLI's startup event lists an MCP server, tool or slash command the code can't read, the confinement check now fails. Before, that entry was silently skipped.
  - **curator:** `LaunchLimits` is now `LaunchSpec["limits"]`, taken from the vendored `@endo/claude` types, so it can't drift from them.
  - **purist:** the server name `"endo"` and its tool prefix are one constant. The token settings-file write is one helper, `writeTokenSettings`.
- **`7cef67a test(claude)`** (transplanter, must-fix): the fake MCP server now reports its own environment. Before, the test fixture read `/proc/<pid>/environ`, which only exists on Linux, so the test that checks the token isn't passed to the MCP server can now run on any OS.
- **`03dee45 docs(designs)`** (pruner, integrator): in `designs/endo-reminder-minion-town.md`, redeploy steps 4–8 had been merged into paragraphs and some code spans broke list items. The numbered steps are back on their own lines and the code spans are each on one line.

**Tests:** typecheck is clean and the four Claude test files pass (40 tests). The full local run has 3 failing test files, all outside the Claude code this round touches:
- `tools/claude-harness/install.test.mjs` and `release-verifier.test.mjs` fail at file level; I didn't check the cause.
- One test in `test/git-remote/capability.test.ts` is a failure already known on this host.

`ci-wait-merge` returned rc 0 with 3 of 3 checks passing.

**Should-fix items I didn't do:**
- breaker: re-check the pinned files on every spawn, or restart `minion-mcp` after an Endo swap.
- engine-realist: kill the leftover process group after exit; remove entries from the per-child maps when a child is removed or revoked.
- purist: harden the remaining returned objects; reuse the vendored formula-id check.
- integrator: split the formatter churn out of commit `729533f`, and squash the fix commits before un-drafting.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr148-gauntlet-restage-20261003-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 58 tokens (2148565 cached reads)
- Output: 15147 tokens
- Cost: $1.4106450000000001
- Wall-clock: 495s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
