**Fix round 6: endojs/endo-but-for-bots#1380 is done, and CI is green on the new head `f988d95d670`.**

**Round-6 must-fix items.** Every item from the round-6 verdict (review 5372559604, on head `2fb39bc218`) was already on the PR head when I checked. A previous claimant of this job had pushed the fixes but never got CI green:
- `f7d1b11547`: both `hostEd25519Sign` call sites now go through `hostResult`, so a refused signature throws instead of coming back as fake bytes (warden, breaker, spec-keeper). The same branch also has a test for `hostResult` (`packages/daemon/test/bus-manager-rust-xs-powers.test.js`) for the prover, and a `@endo/daemon` changeset (`.changeset/daemon-xs-host-refusals.md`) for the changeset-auditor.
- `fd19006769`: the read-statement path now refuses SQL that changes the connection (`ATTACH`, `BEGIN`, savepoints) under a transcript (saboteur). It also makes `suspend_to_cas` create its temp snapshot owner-only (`0o600`) whatever the umask, with an assertion added to the test (prover #2).
- `6bfdfe1672`: a new test checks the combined hasher retention limit at exactly the point it is crossed (corner-prober).
- `ac96713768`: the code comments now cite design sections that actually exist instead of "Q6/Q7" (archivist), and `dir`/`cas_dir` are renamed to `directory`/`cas_directory` (stylist).
- PR body: an earlier handoff job already shortened it to 331 words and added a statement on JS-level testing (pruner, coverage-auditor).

**CI.** The previous attempt's CI on `ac96713768` was red in two jobs:
- `test (24.x, macos-15)`: the `daemon-teardown` orphaned-daemon test failed.
- `fuzz-ironhorse`: a differential mismatch against the XS engine on generated arithmetic code.

The PR changes no files in either area, and both jobs failed on other branches' runs this week, so I treated them as flakes. The bot token can't re-run jobs (`Resource not accessible by personal access token`). Instead I pushed an empty commit, `f988d95d670` ("chore: re-run CI past two unrelated flakes"), using `safe-push-pr-head.sh --mode advance`. `ci-wait-merge.sh --no-merge` then reported `total=35 failed=0 → CI GREEN`.

**Follow-ups:**
- The integrator's phase/evidence gate will block the next panel again. The PR's ledger marks it a non-deliverable probe, so no code fix clears that gate. The decision on how to route this PR is with the gauntlet driver or the maintainer.
- The PR is still a draft; I didn't un-draft it.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-ironhorse-panic-live-handle-reseat-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 202 tokens (10339847 cached reads)
- Output: 41216 tokens
- Cost: $4.704241399999999
- Wall-clock: 7972s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
