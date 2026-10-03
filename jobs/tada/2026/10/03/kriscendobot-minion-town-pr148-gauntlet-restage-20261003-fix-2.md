I applied round 2's fixable findings to PR #148 and pushed them as four commits (head `e924e92` → `551f155`). CI is green on the new head (`ci-wait-merge` rc 0; all 3 checks ran on `551f155`). Panel-3 will still block, because of the PR's probe disposition. No code change can clear that.

**Must-fix items**
- **PR body length:** done. I cut the body from 1,232 words to under 300. The pruner probe now returns `skip pruner` (no signals), and the phase-evidence gate in author mode returns `probe`. The ledger's statuses are unchanged; only its wording is shorter.
- **Probe in the panel (`probe-must-remain-draft`):** not fixable. The ledger correctly says `non-deliverable-probe`: phases 3–6 are production canaries that belong to the later canary child, and acceptance is not met. `phase-evidence-gate.sh` in panel mode always adds this finding for a probe, so panel-3 will block again. Calling the PR `deliverable` would be false. I sent the maintainer this deciding question: stop the gauntlet here and leave the PR a draft probe for the canary child, or gather the canary evidence on this PR before it re-enters the gauntlet.

**Code fixes from the should-fix findings**
1. `fix(endo)`: the `/opt/endo` pin check now compares real paths. A symlink into the tree or a `..x` directory inside it no longer skips the `ENDO_COMMIT` check. Two new tests cover this.
2. `fix(claude)` (launcher): the process group is signalled at most once and never after the child exits. A test asserts exactly one group kill under an output flood.
3. `fix(claude)` (guest bridge): it now drops and retries the shared daemon connection only when that connection has actually closed. A daemon refusing one request no longer tears down every concurrent call. The connection type now exposes `closed`, and the reconnect tests are rewritten to cover both cases.
   - The same commit corrects the boundary comments: `env -i` keeps the token out of the MCP command's environment, but both processes run as the same user. Tool confinement is what actually keeps them apart.
   - A test now pins the exact argument list that passes `ENDO_SOCK` to the MCP command.
   - I opened kriscendobot/minion.town#149 to track the guest-scoped bootstrap and the root-host mail edge.
4. `fix(claude)` (binary and identifiers):
   - Before the Claude binary first runs, its SHA-256 is checked against `release.json`'s `binarySha256` for this architecture.
   - Minting rejects malformed guest identifiers, and refuses to rebind a formula number to a different node.
   - JSON parse errors now name the file or command they came from.
   - The vendor test fails if any unrecorded file appears under `vendor/endo-claude`.

Typecheck passes. Locally, Vitest failed only `git-remote/capability.test.ts`, which also fails on `main` on this host and passes in `main`'s CI.

**Not done**
- I did not regroup the branch's commits (integrator, should-fix). That needs a history rewrite, which belongs before un-draft.
- I did not make production refuse an `ENDO_DAEMON_MODULE` or `ENDO_CHECKOUT` override outside `/opt/endo`. That could change how CI and dev resolve the daemon, so it needs its own decision.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr148-gauntlet-restage-20261003-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 124 tokens (6474746 cached reads)
- Output: 33385 tokens
- Cost: $2.9823212000000003
- Wall-clock: 522s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
