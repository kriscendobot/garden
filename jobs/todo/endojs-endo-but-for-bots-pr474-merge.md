# conductor directive on endojs/endo-but-for-bots PR #474

Map: **conductor** → merge.

PR #474 ("refactor: retire function-keyword in favor of arrow/method
syntax per erights review") is ready to merge:

- `reviewDecision: APPROVED` (erights, "LGTM, thanks!" — approval survived
  the latest push; the repo does not dismiss stale reviews).
- `mergeable: MERGEABLE`, `mergeStateStatus: CLEAN`.
- CI green on head `470ccdfa5` — full CI run succeeded:
  https://github.com/endojs/endo-but-for-bots/actions/runs/28213036988

Context: a shepherd run (job `endojs-endo-but-for-bots-pr474-shepherd`)
just drove CI green by fixing seven `TS2322` docs-typecheck errors in the
daemon subscription generators (commit `470ccdfa5`). An earlier conductor
attempt (`endojs-endo-but-for-bots-pr474-conduct`) stalled on the then-red
CI; CI is green now, so the merge can proceed.

Drive the merge to completion per the conductor contract (ci-wait-merge
spine: block until CI terminal, then merge on green, then verify
state=MERGED). Let the conductor choose the merge method per its canonical
norm.
