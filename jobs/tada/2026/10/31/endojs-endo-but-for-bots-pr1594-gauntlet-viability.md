**Viability report: endojs/endo-but-for-bots PR #1594**

PR #1594 ("refactor(daemon): rename runtime identifiers to manager") is open, unmerged, and still a draft. It was created 2026-10-31T15:21Z by `build-daemon-rename-to-manager-runtime`. Its base is the frozen `llm-9a14ddf`, which is level with the `llm` tip (ahead_by 0).

Deciding question: On the current `llm` base, are the production Daemon/MignonicPowers identifiers still unrenamed, with no newer PR or design change that already does phase 2 of `designs/daemon-rename-to-manager.md`?

Evidence:
- **Need still holds.** `packages/daemon/src/manager.js` on `llm` still has 49 occurrences of the old identifiers (`MignonicPowers`, `DaemonCore`, `makeDaemon`). Phase 1, the file renames, landed in #598 (merged). Phase 2, which this PR covers, has not landed.
- **Design is still in force.** `designs/daemon-rename-to-manager.md` is still on `llm` and carries no superseded or abandoned marker. Its design PR, #85, is merged.
- **Not superseded.** The only other phase-2 PR is #780. It is an older draft, untouched since 2026-07-17, and `CONFLICTING` against `llm`. #1594 is the newer, current-base replacement for #780, not the other way round. No newer PR or base commit does this work.
- **Caveat for later stages:** the PR's ledger says `Disposition: orchestrated-slice`. Tests, fixtures, docs and the repository-wide audit belong to the successor, `build-daemon-rename-to-manager-surface`, and the PR body says not to consume it until that successor marks it deliverable. That limits when it can be un-drafted. It does not undercut either viability claim.

Follow-up for the maintainer: once #1594 progresses, #780 should probably be closed as superseded by #1594. I took no action on #780; it is outside this gate's scope.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1594-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (210622 cached reads)
- Output: 1775 tokens
- Cost: $0.38812040000000003
- Wall-clock: 66s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
