All work is complete and worktrees are cleaned up. Here is my completion report.

---

## Completion report: implement-plan-phase1-endo-redirect

Implemented **Phase 1** (endo redirect) and **Phase 4** (retire the sync discipline) of the plan-in-journal migration (garden#4, `designs/plan-in-journal.md`). The garden journal plan (`journal2`, `plan/`, 141 endo records) is now the single source of truth; the endo `designs/` is a generated mirror/redirect.

### What I did

**Phase 1 — endo redirect generator** (garden `main2`, SHA `6ea3703ab`)
- Added `scripts/jobs/plan/render-endo-redirect.sh`: generates a **non-authoritative courtesy redirect** for the endo fork's `designs/README.md` from the journal records — a "generated; do not edit; source of truth is the garden journal plan" banner, links to `plan/designs/…` and `plan/README.md`, then the familiar Design/Created/Updated/Status table (Complete/Active/Reference bolded, implementing PR appended as `(PR #N)`). Filtered to records targeting `endo-but-for-bots`, sorted by slug, deterministic (no clock/network). Clean under `shellcheck -x` (caught and fixed a real SC2318 bug in the status-cell helper before committing).
- Updated `scripts/jobs/plan/README.md`: new script row, "Where each runs" entry, and Phase 1/4 marked done in the cutover state.

**Weekly-job decision** (garden `journal2`, SHA `8d0195927`)
- The redirect regenerates on the **weekly Sunday recalibration job**, not the bulletin loop (it writes to a *different* repo and needs a network push at the slower cadence). Added step 6 to `schedules/plan-recalibrate.md`.

**Phase 4 + Phase 1 delivery to the fork** — endo-but-for-bots `designs/README.md` + `designs/CLAUDE.md`
- Generated the redirect (141 rows; all 141 `[slug](slug.md)` links resolve to existing mirrored narratives; status tally matches the live roadmap exactly: 42 Complete, 2 Active, 7 Reference, 21 In Progress, 38 Not Started, 28 Proposed, 2 Deprecated, 1 Superseded). Replaced the 1447-line hand-maintained README with the 95-line generated redirect.
- Rewrote `designs/CLAUDE.md` "Progress Tracking": removed the manual cross-document synchronization discipline, pointed it at `journal/plan/` + the reconciler, and noted narratives are mirrored from journal record bodies.

### Deviation worth flagging
The job (and the design) assumed a **direct push** to `llm` ("no PR needed"). The `llm` branch now carries a **"changes must be made through a pull request" repository ruleset**, so the direct push was rejected. I adapted: pushed branch `chore/plan-in-journal-endo-redirect` and opened **PR #536** (`endojs/endo-but-for-bots`, base `llm`, bot identity, commit `142966b`). I also encoded this constraint into the weekly schedule step so future regenerations land as a (reused) bot PR rather than retrying a doomed direct push.

### SHAs
- garden `main2`: `6ea3703ab3ae177790292c88782ee0983f1a9b53`
- garden `journal2`: `8d0195927`
- endo PR #536 commit: `142966b1246cb54585d4f7a6d55b439d02157373` — https://github.com/endojs/endo-but-for-bots/pull/536

### Follow-ups
- **PR #536 needs a merge** into `llm` to actually retire the old README/CLAUDE.md on the fork (blocked on the PR-required rule; a conductor/maintainer merge completes Phase 1+4 delivery).
- Phase 3 (cross-repo garden/endo records) and continuous gh reconcile remain tracked as separate `implement-plan-*` jobs.
- The redirect's per-design narrative files on `llm` are assumed already mirrored from journal bodies (all 141 present today); keeping them in sync is the broader Phase 4 mirroring story, not part of this job.
