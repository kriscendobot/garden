# shepherd (auto) retired: CI recovered/settled before claim

CI recovered/settled before claim — nothing to shepherd; ci-watcher retired
this stale auto-shepherd. The CI-status watcher minted `endojs-endo-but-for-bots-pr910-shepherd`
from a point-in-time RED rollup read; on a later tick the live rollup was
in progress/queued (settling) (no longer red), so this stale auto-shepherd was retired
deterministically (todo -> tada) rather than left to be claimed, re-fetch a
no-longer-red CI, and exit-0-unsatisfying.

Retired by: ci-watcher stale-shepherd re-validation sweep on endolin-garden2-5bcdff64.

<<<GARDEN-JOB-COMPLETE>>>
