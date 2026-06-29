# Remove the dead "driver" code (converted from PR #5's design per kriskowal's review)

Map: **build** (garden infra) on branch main2. Isolated worktree off origin/main2;
explicit-pathspec commits; push HEAD:main2 via git-rebase CAS. Converted from the design in
kriskowal/garden PR #5 ("plan: remove the driver dead code") per kriskowal's CHANGES_REQUESTED
review "Please convert the design into a todo job post" — the garden does not run PR workflows
against itself, so the removal lands directly on main2 via this job.

## What to remove
The **driver** (the June-2026 systemd PR-pipeline automation — the reconstructed
general-contractor's `claude-under-script` worker pool) is **dead code, superseded by the v2
gardener fleet**. Read `designs/remove-driver.md` (on PR #5's branch `plan/remove-driver`) for the
authoritative removal scope; it documents the evidence (0 `garden-driver*` units enabled,
`install-units.sh` never enables a driver instance, the gardener pool supersedes it). Execute the
DELETION the design plans:
- `scripts/driver/` and any `garden-driver@.service`/timer templates under `scripts/systemd/`;
- driver lanes/wiring in `install-units.sh` (the driver glob / enable list) and any scaler refs;
- the driver context skills that are now dead (`driver-pr-creation-state-machine`,
  `driver-design-only-pr-workflow`, `driver-gardener-workflow`, `driver-librarian-workflow`) and
  `designs/driver.md` — but VERIFY each is genuinely unreferenced before deleting (grep the tree;
  some driver *concepts* may have been folded into gardener docs — keep those, delete only dead
  driver-specific files);
- CLAUDE.md / doc references to the driver as a live posture (convert to past-tense/retired where
  the text still implies it runs).
Net invariant: no behavior change for the live fleet (the driver isn't running); only dead code +
stale docs removed. If anything turns out to still be referenced, STOP and report it rather than
breaking a live path.

## Deliverable
The dead driver code/units/skills/docs removed on main2, a grep-gate (or report) showing no live
path referenced them, and the `designs/remove-driver.md` plan either removed or marked executed.
PR #5 is being closed by the liaison as converted-to-job (no garden-own PR workflow).
