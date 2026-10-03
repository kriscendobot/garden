Fix round 5 for kriscendobot/minion.town#148 is pushed (head `4605078` → `dea0146`) and CI is green (3/3 checks, `ci-wait-merge` rc 0). One must-fix can't be cleared by code: the PR is still marked as a probe, which keeps the gauntlet blocked (see the last section).

**Must-fix items fixed, one commit each:**
- **`f9df1f5` — vault `active` flag** (raised by wire-watcher, breaker, purist and corner-prober): a stored credential record missing its `active` field was treated as already probed. The field is now required, and only `active === true` releases the token. A record without it reads as needs-auth. A new test covers the missing-field case.
- **`9153149` — test for the pruned-tool check** (prover): the fake `claude` binary now reports the server's `evaluate`/`eval`/`define` tools as reachable unless `--disallowedTools` names them. A new backend test strips those names at launch and confirms the confinement probe fails with "pruned tools are reachable".
- **`b73068d` — `toMinionOutcome` coverage** (corner-prober): tests now cover the result types that had none, plus `null`/`undefined` input.
- **`dea0146` — formatter churn reverted** (packager, integrator): `designs/mcp-daemon-guest-tools.md` and `designs/ocapn-cbor-browser-frontend-lessons.md` are back to the base's tables and asterisk emphasis. The dedented list line is fixed. Only the real content edits from `729533f` and the ASCII arrows from `daf9cfc` remain. A whitespace- and emphasis-normalized comparison against the old head shows no content difference.

**Verification:**
- Typecheck is clean.
- The three affected test files pass (30 tests).
- I confirmed the two new tests fail when their fix is taken out: with the pruned-tool check disabled, and with the old vault code.
- The full suite has 1 failure out of 790: `test/git-remote/capability.test.ts`. It isn't in the files this round touches and was already known to fail on this host.

**Still open:**
- **Probe status:** the phase/evidence pre-pass reports `probe-must-remain-draft` (integrator must-fix). The PR body still declares itself a non-deliverable probe. That stays until the production canary evidence lands under `minion-town-claude-cli-production-20261003`, or the maintainer takes #148 out of the gauntlet. Panel-6 will hit the same block.
- **Should-fix items not done this round:**
  - Make the probe's tool check an exact allowlist (locksmith, breaker).
  - Narrow the root-host authority held by the confined server (#149).
  - The purist's type-reuse and lifecycle notes.
  - The engine-realist's notes on a token persisting on disk across a crash and on a per-inference `claude --version` call.
  - The PR body is 310 words, over the 300-word limit.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr148-gauntlet-restage-20261003-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 64 tokens (2519187 cached reads)
- Output: 14008 tokens
- Cost: $1.5544934000000004
- Wall-clock: 472s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
