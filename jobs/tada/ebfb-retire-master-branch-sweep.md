Enumerated 34 open `master`-base PRs and parked 34 per-PR weave children.

Recorded serial orchestration `ebfb-retire-master-branch-sweep-orchestration` with a final guarded deletion child. It halts on child failure.

`master` was not deleted: 34 PRs still target it. The final child rechecks emptiness before deletion.
