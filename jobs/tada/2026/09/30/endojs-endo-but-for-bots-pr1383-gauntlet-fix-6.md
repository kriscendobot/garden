## Fix round 6: endojs/endo-but-for-bots#1383 (daemon lifecycle idempotency design)

I pushed one follow-up commit that applies the round-6 panel's must-fix items to the PR head. CI came back green: all 28 checks passed, none failed (`ci-wait-merge` rc 0).

- **Head:** `1f77b37d01` → `876624a8d8`, pushed with `safe-push-pr-head.sh --mode advance`.
- **Files:** `designs/daemon-lifecycle-idempotency.md` and `designs/README.md`.

**Must-fix items:**
- **critic (reclaiming a stale lock):** The design said two reclaimers could never both win, but a slow one could delete a fresh winner's lock file and claim too. Reclaiming a stale lock now goes through its own guard file (`endo.lock.reclaim`). Under that guard the reclaimer re-reads the lock and deletes it only if it is unchanged. Every claimant also re-reads the lock just before its first destructive step and exits 69 if it no longer holds it. The small remaining gap is now stated plainly rather than claimed closed, and a reclaim-race test was added.
- **skeptic #1 (`ping`):** `ping` keeps its full round trip to the daemon. The quick socket check is required but no longer enough on its own. If a daemon accepts connections but doesn't answer, `ping` and client commands exit 75. `status` is documented as the cheaper, weaker check, and a matching test was added.
- **ergonomist (daemon on a different socket):** When a live daemon serves a socket other than the one requested, `status`, `ping` and the no-auto-start client now exit 69 instead of 3. That matches the action commands. `stop` still acts in that case, but it now prints the mismatch before signaling the daemon, and `endo stop --help` states this.
- **pedant:** durations are spelled out ("five seconds", "ten milliseconds").
- **integrator #1:** the PR body was refilled against the repo's template and now includes the missing Scaling and Upgrade Considerations sections. I kept the four other Considerations sections the pruner wanted cut, because the integrator's template check is binding. They are shortened, and Testing now just points to the design.

**Should-fix and comment items, also applied:**
- **decomplector:** `run-daemon` only passes on its child's exit code; the lock names `manager-node.js`, not `run-daemon`. `engo` takes the claim before it starts `manager-go.js`.
- **integrator #2:** `ENDO_BIN` is reconciled with `daemon-capability-bus`. Its `endo-daemon-go` and `endor` daemons are claimants under the same lock rules, and that design is added to Dependencies.
- **integrator #3:** a note explains why `daemon-engo-supervisor` is still cited even though the roadmap marks it consolidated.
- **integrator #4:** the missing `dlife --> dckpt` (daemon-sqlite-shutdown-checkpoint) edge is added to the README graph.
- **skeptic:** a test for SIGKILLing `engo` itself was added, and the design now says exit code 3 comes from the LSB `status` convention and is extended here.
- **novice:** the "state directory is the identity" model is now introduced where the classifier first appears.
- **copyeditor:** the one prose touch-up is applied.

**Follow-ups:** none from this stage. The driver re-posts panel-7.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1383-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (1088015 cached reads)
- Output: 13529 tokens
- Cost: $1.137839
- Wall-clock: 1326s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
