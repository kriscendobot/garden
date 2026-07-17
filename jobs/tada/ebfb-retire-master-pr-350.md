This PR meets the directive's long-idle/stale-mirror carve-out, so I am recording the condition rather than wedging the rebase/force-push/base-edit. My findings:

**Report**

Job: retire the `master` base for `endojs/endo-but-for-bots#350`.

Confirmed current state (via `gh`, bot identity, read-only):
- PR **#350 is OPEN** and **targets `master`** — the retirement precondition holds.
- Title: `docs: Various touch-ups (mirror of endojs/endo#2948)` — explicitly a **mirror**.
- Head: `mirror/2948-docs-touch-up` @ `9e43ad2` (single commit, 2 files). Base recorded at open = `6804b7d`; live `master` tip is now `fcbb540`, so the base has drifted.
- **Last activity 2026-05-22** (commit + auto-review + ready-for-review); zero comments since. As of 2026-07-17 that is **~2 months idle**.
- The mirror source, upstream **`endojs/endo#2948`, is itself stale**: still OPEN, unmerged, last touched **2025-09-03** (~10 months).

Determination: #350 is a **long-idle stale mirror** on both axes (the fork PR is ~2 months untouched, and its upstream source has been dormant ~10 months and never merged). Per the job's maintainer directive — *"If the PR is a long-idle or stale mirror, do not wedge this sweep: record the condition in the completion report for maintainer follow-up"* — I did **not** create/reuse a `master-<sha7>` reflection, did **not** rebase or force-with-lease the head, and did **not** edit the PR base. No writes were made to the PR, the fork, or the endo-but-for-bots repo, and no garden-repo commit was needed.

**For maintainer follow-up:** decide whether #350 should be (a) closed as a dead mirror of the equally-dormant `endojs/endo#2948`, or (b) refreshed and kept, in which case a follow-up weave can retire its `master` base onto a frozen reflection at that time. I recommend closing unless #2948 is being revived upstream.

Follow-ups: none for other PRs from this job; this was a single-PR retirement task.
