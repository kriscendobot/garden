Verified: PR #5 is DRAFT, base `main2`, against `kriskowal/garden`. Inbox empty. Worktree torn down.

---

## Completion report

**Job:** `plan-remove-driver-dead-code` — identify the dead "driver" subsystem, verify it's dead, and open a removal-PLAN PR (no deletions).

**Deliverable:** **DRAFT PR #5** against `kriskowal/garden` base `main2` (bot identity `endolinbot`), adding `designs/remove-driver.md` — a complete classified inventory, dead-verification evidence, and a phased removal order. Worked in an isolated worktree off `origin/main2`; nothing deleted.

**Counts:**
- **11 files to delete outright** — root `driver` launcher, `scripts/driver/` (driver.sh + README), `scripts/systemd/garden-driver@.service`, `tests/driver/` (run.sh, mock-garden, 4 `test_*.sh`), `designs/driver.md`.
- **~24 reference files to update** (reword, keep) — `CLAUDE.md`, `designs/{README,v1-migration-manifest,self-healing-audit}.md`, `scripts/systemd/README.md` + two `.service` docs, `scripts/daemons/*`, `scripts/checks/*`, `scripts/watcher/*`, four skills, `scripts/jobs/common.sh`, `.gitignore`.
- **~10 files to leave** — `HISTORY.md` and generic/incidental uses of "driver".
- The "629 references" resolved to **629 line-hits across 47 files**, dominated by the dedicated artifacts themselves.

**Deadness confirmed:** 0 `garden-driver` units installed/running; `install-units.sh` never enables a driver instance; no caller of `scripts/driver/` or the launcher anywhere in `scripts/jobs/`; daemon wrappers default `GARDEN_DRIVER_LANES=()` (inert).

**Pieces whose deadness I could NOT fully confirm (flagged for maintainer):**
1. **`.github/workflows/driver-tests.yml` is NOT dead as a whole** — it is the **repo's only CI workflow** and also runs the shellcheck/`bash -n` lint, `tests/checks/run.sh`, and the cleaner self-test. It must be **refactored/renamed (→ `checks.yml`), not deleted** — the single hard blocker to a naive removal.
2. **`driver.sh` is the documented self-healing *exemplar*** (cited by `designs/self-healing-audit.md` and `skills/self-healing-wrapper/SKILL.md`). A documentation dependency, not a live caller — the follow-up must re-point the exemplar to a surviving v2 script (or preserve the excerpt) before deleting.
3. The four `driver-*-workflow` skills named in `CLAUDE.md` **do not exist as files** — only the prose needs scrubbing.

**Follow-ups:** maintainer approves the plan → a follow-up PR executes the deletion in the documented order (refactor CI first → drop service template → re-point exemplar → delete code/tests → delete design + index row → scrub daemon lane code → sweep doc references → re-check no dangling refs / CLAUDE.md inventory / checks pass). PR #5 explicitly asks for that approval before any deletion.
