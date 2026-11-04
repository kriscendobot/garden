**Fix round 4 for kriscendobot/minion.town#235 is pushed at `19a218d0` and CI is green.** Three of the four must-fixes are fixed. The fourth (decomplector) is answered in docs and left to the maintainer, not implemented. CI was read from the Actions runs API only, because this token can't read the check rollup. The PR is still a draft.

**Must-fix items**
- **wire-watcher (locator compiled as code):** fixed in `ced92d24`. Accept now reads the locator from a bound file instead of `source`. A recipe shows a hostile locator fails with `Invalid locator` and runs nothing, and a lint rejects `LOCATOR` in `source`.
- **saboteur (cleanup dismissed other people's mail):** fixed in `ced92d24`. Everything a run sends carries a per-run marker, and it matches and dismisses only those messages. A daemon test delivers mail during a run and checks it survives.
- **integrator (stop gate with no ledger or owner):** fixed in `19a218d0` and the PR body. I added an `orchestrated-slice` ledger, and `phase-evidence-gate.sh` now answers `hold-draft`, which withholds the un-draft.
- **decomplector (graft duplicates an endowment path):** answered, not implemented, so this seat may raise it again at panel-5.
  - **Docs:** `19a218d0` says nothing delivers the primer yet and relates it to #78, which puts validating a mutable primer first.
  - **Tested:** `storeTree` plus `storeIdentifier` works at the pinned daemon. A guest reads through `lookup` and `text`, not `readText`, and a daemon test pins this.
  - **Why not implemented:** provisioning every guest is posed as a maintainer question in the PR body, because merging deploys.

**Should-fix items**
Most are applied in `ced92d24` through `19a218d0`:
- cleanup failures now fail the run, and every `CALLS` entry must be exercised
- the file method check runs in CI
- warnings on `resolve` and on incoming mail
- stricter frontmatter parsing and the empty guide-directory setting
- the generated union grouping
- documented and pinned `evaluate` result changes and SES rejections
- the Dockerfile guide directory and `.env.example`
- the design corrections

**Not applied**
- **decomplector 2 (load once at boot, drop slice 4):** this changes the design's deploy plan, so it's the maintainer's call.
- **purist (`values` schema):** left loose, with a comment explaining why.
- **pruner 1-6:** the design's repetition, the primer copy and the PR body's tables are still there.
- **Comment-only items:** the clip URL host check and the dangling pointers after a guide load failure, among others.

**Testing**
- **Passed locally:** the live-daemon recipe suite (10 tests at the pin), `test/resources.test.ts`, the adjacent tests and `tsc`. The style probes also pass.
- **Not run:** the full suite, locally.
- **Production:** the recipe run from 2026-11-03 predates these recipe changes and was not repeated. The PR body says so.

**Follow-ups for the maintainer**
- **Go-ahead needed:** I parked `minion-town-mcp-guide-remaining-slices-20261104`, confirmed on `origin/journal2`. It owns the rest of slice 1 (the § 3.3 CapTP session and the production re-run) and slices 2, 4, 5 and 6, and it waits on a maintainer go-ahead. The PR can't merge or leave draft until that work records the baseline.
- **Decisions in the PR body:** whether to revert #233, and how a guest should get the primer.
- **Unverified citation:** the design's old #227 citation didn't contain the 2026-11-03 direction. I replaced it with a paraphrase from the build job, which I couldn't check against an original, so please confirm the wording.
- **Journal warning:** while parking the job, `decision-append` reported it could not record the decision and latched a journal outage on this host. The job itself landed.

The per-finding summary is on the PR: https://github.com/kriscendobot/minion.town/pull/235#issuecomment-6619106698

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr235-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 62 tokens (4673478 cached reads)
- Output: 58464 tokens
- Cost: $3.7126156000000003
- Wall-clock: 1746s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
