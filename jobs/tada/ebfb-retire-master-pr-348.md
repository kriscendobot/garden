Confirmed: PR #348's last activity of any kind was 2026-05-22 (~56 days idle). This is a textbook long-idle stale mirror, and per the job's explicit escape hatch I will not wedge the sweep. No git mutations were made.

---

**Completion report — `ebfb-retire-master-pr-348` (weaver)**

**Disposition: skipped as a long-idle stale mirror — recorded for maintainer follow-up. No rebase, no force-push, no base edit, fork master untouched.**

**What I checked**
- **PR #348** (`endojs/endo-but-for-bots`) — confirmed `state: OPEN`, `base: master`, head `mirror/2902-dedup-bundle-lite` (owned by `endojs`, the `mirror/` prefix and title "mirror of endojs/endo#2902" confirm it is a mirror branch). `mergeable: CONFLICTING`.
- **Idleness** — `updatedAt` = 2026-05-22; last commit 2026-05-22T01:44Z; sole comment + review both 2026-05-22T01:44Z. **~56 days with zero activity** as of today (2026-07-17).
- **Upstream source `endojs/endo#2902`** — also still `OPEN`, base `master`, likewise idle since 2026-05-22T00:56Z. The mirror is tracking an upstream PR that is itself frozen in place.
- **Base history** — no `base_ref_changed` events; the PR still targets the live `master` and has never been given a frozen base.
- Inbox drained: empty.

**Why I did not perform the retirement**
The job spec states: *"If the PR is a long-idle or stale mirror, do not wedge this sweep: record the condition in the completion report for maintainer follow-up."* This PR meets every marker of that condition — a `mirror/` branch mirroring an idle upstream PR, ~56 days untouched, and already `CONFLICTING`. Rebasing the head onto a fresh `endojs/endo` master and force-pushing would (a) almost certainly land in non-trivial conflicts (it is already conflicting against the older fork master), and (b) diverge the mirror from the upstream PR it exists to reflect, defeating the mirror's purpose — all on a PR no one has touched in two months. That is exactly the "wedge" the directive tells the sweep to avoid.

**What changed**
Nothing. No branches created, no pushes, no PR base edit, no changes to the fork's `master`, no garden-repo commits.

**Follow-ups for the maintainer**
- Decide the fate of the mirror pair before retiring the base: since `endojs/endo#2902` is itself idle, the mirror may be a candidate to **close/abandon** rather than freeze. If it should live on, the base retirement is best deferred until the mirror is refreshed against a current upstream head (a refresh/weave), since a plain rebase onto a new frozen base would conflict.
- If you instead want the base frozen **as-is** regardless of staleness (snapshot current fork/upstream master and force-rebase despite conflicts), re-post the job with that explicit instruction and I/the fleet will carry it through the conflict resolution.
