Fix round 1 for https://github.com/kriscendobot/minion.town/pull/148 is pushed (head `e924e92`, down from `8ea1b79`) and CI is green: `ci-wait-merge` returned rc 0 with 3/3 checks passing. One thing will still block it: panel-2 will fail again no matter what this round fixed, because the PR declares itself a probe (details at the end).

**Must-fix items fixed:**
- **packager / integrator (fixup commits):** I removed the two `fixup!` commits by regrouping them into standalone commits: `docs(designs): write prose arrows as ASCII` and `chore(claude): mark the vendored SECURITY.md as typist-exempt`. The `use the daemon-exported MCP client` commit now has a body. The resulting tree is identical to the old head, and the push went through `safe-push-pr-head.sh --mode rewrite`.
- **assessor (`withHost`):** a failed connect is no longer cached, and a failed call retries once on a fresh connection. New test: `test/claude-guest-bridge-reconnect.test.ts`.
- **spec-keeper and three other seats (`cli-launch.ts`):**
  - stdout is decoded with a `StringDecoder`, so a character split across two reads is no longer corrupted.
  - `killWith` does nothing once the run has settled, so a late cancel can't kill an unrelated process group.
  - A kill now resolves within a 5-second grace even if a descendant holds stdout open.
  - Two new fake-claude tests cover the split character and the late cancel. Both fail on the old code.
- **prover:** the agent-MCP refusal test now checks each entry with the other one present, and the refusal message names the missing path.
- **pin check:** minion-mcp refuses to import from `/opt/endo` unless its `ENDO_COMMIT` stamp equals `PINNED_ENDO_COMMIT`. Tests cover a missing stamp, a malformed stamp and a wrong commit. The deploy and rollback scripts now make the tree root-owned and not writable by other accounts. The `/opt/endo` fallback now applies only in production (also the transplanter's finding).
- **integrator #2:** the ledger in the PR body now names `designs/endo-reminder-minion-town.md` as a reference-only design. Running the phase gate locally confirms the missing-design finding is gone.

**Should-fix items also done:**
- The four outcome types that were passed straight through are now rebuilt to their declared shapes.
- The CLI version parser rejects pre-release and build suffixes.
- The deployment model list is frozen.
- The probe's hook path is shell-quoted.
- The vendoring script no longer relies on GNU-only `sed`.
- The lockdown test's comment no longer overstates what it covers.
- The PR body describes the current MCP setup (the stdio relay it described was already removed), and the pruner's trims are applied. I left the rest of the body alone, so it is still about 1,240 words, over the concision probe's 300-word guide.

**Not fixed:**
- **locksmith #1 (MCP child gets root-host authority):** I didn't restructure this. It conflicts with kriskowal's explicit review direction to use the daemon's own client over its local socket. I documented the trade-off, and the related mail-edge finding, in the bridge header and the PR body. A structural fix needs Endo to provide a guest-scoped connection.
- **integrator #1 (a probe reached panel):** this can't be fixed inside the PR. The ledger says `non-deliverable-probe`, and the phase gate reports `probe-must-remain-draft` in panel mode for any probe. I ran it: in panel mode the gate exits 20 with that as its only finding. It will stay that way until the canary child of `minion-town-claude-cli-production-20261003` records Phase 3–6 evidence.

**Follow-ups:**
- I messaged the maintainer to decide whether to park this gauntlet or accept the locksmith trade-off.
- I posted a summary comment on the PR.
- The local Vitest run had one test failure, `git-remote/capability.test.ts`, which the PR body already records as failing the same way on `main` on this host. The two `tools/claude-harness` files also showed up as failing, but they are node:test files the `npm test` script excludes.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr148-gauntlet-restage-20261003-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 124 tokens (7412802 cached reads)
- Output: 39725 tokens
- Cost: $3.517348400000001
- Wall-clock: 607s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
