All four panel round-1 must-fix items on endojs/endo-but-for-bots#1398 are addressed, and CI is green on head `289b48d445` (`ci-wait-merge.sh` rc 0, 33 checks, 0 failed).

**What was already there:** an earlier claimant of this job had pushed commit `289b48d445`, "fix(daemon): hold the layer-8 changeset until a published surface exists", and rewritten the PR body. Item by item:
- **curator:** the minor changeset is gone, because `sturdyRefForFormula` and `formulaIdOf` can't be reached from any published entry point yet. The Documentation Considerations section now says the changeset belongs with the layer that publishes them.
- **pruner:** the restating comment in `manager.js` is removed, and so is the "Stack index" section of the PR body.
- **integrator:** the Security Considerations section now names #695's outstanding changes-requested concern (confinement and retention). It says this layer mints refs for daemon-core-internal use only.
- **benchmarker:** the Scaling Considerations section now states why no benchmark is planned: the claim is structural, not about throughput.

**What I did this round:**
- **PR body:** I fixed a stale line. It said the base was `build/sturdyref-ocapn-enliven-f212191`, but the PR's actual base is `build/sturdyref-ocapn-enliven-0e0b333`. I made no code changes and pushed nothing.
- **CI:** the first wait came back RED on the two macOS jobs. Both look like flakes unrelated to this change, which only touches the daemon formula-SturdyRef code:
  - `test (22.x, macos-15)` failed one UI test: `component › heat-bar › composite locked shows bottleneck cooldown`.
  - `test (24.x, macos-15)` failed one test: `daemon-teardown › an orphaned daemon shuts itself down…` (the daemon's pid wasn't recorded in time).

  I re-ran just those two jobs (run 36892180106). After about 20 minutes in the runner queue, both passed.

**Follow-up:** these two macOS tests may fail again intermittently on other PRs. Panel round 2 is next; the driver posts it.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-sturdyref-layer8-daemon-formula-20260930-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (918284 cached reads)
- Output: 4906 tokens
- Cost: $0.7403688
- Wall-clock: 2387s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
