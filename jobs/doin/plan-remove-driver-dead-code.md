# Identify the "driver" dead code and open a removal-PLAN pull request against the garden

Wear the **scout** then **designer** role. The **"driver"** was the prior systemd-automation
attempt (the reconstructed general-contractor's PR-pipeline driver, ~June 3), **superseded by the
v2 gardener fleet** (per the v1→v2 migration: "driver-specific lanes superseded by the gardener
pool"). It is now dead code. **Identify all of it, verify it is truly dead, and open a PR against
`kriskowal/garden` (base `main2`, DRAFT, bot identity) containing a removal PLAN** — the plan is
the deliverable; do NOT delete the code in this PR. Work in an isolated worktree off
`origin/main2`; scratch via `$GARDEN_SCRATCH`.

## Grounding inventory (the liaison's initial sweep — verify and COMPLETE it)

Dedicated driver artifacts (hard dead code, candidates to delete):
- `/home/kris/driver` — a ~10KB executable launcher at the garden root (tracked as `driver`).
- `scripts/driver/` (`driver.sh`, `README.md`).
- `scripts/systemd/garden-driver@.service`.
- `tests/driver/` (run.sh, lib/mock-garden.sh, test_*.sh).
- `designs/driver.md`.
- `.github/workflows/driver-tests.yml`.
- The **driver-*-workflow skills** named in `CLAUDE.md` (`driver-pr-creation-state-machine`,
  `driver-design-only-pr-workflow`, `driver-gardener-workflow`, `driver-librarian-workflow`) —
  locate them (they may be under `skills/` or already partly gone) and confirm.

Verification so far: **no `garden-driver` systemd units are installed or running** (0) — consistent
with dead. There are **~629 "driver" references** tree-wide; most are passing mentions in docs.

## What to do

1. **Complete the inventory.** Enumerate every driver artifact and every reference, and **classify
   each**: (a) **delete** — dedicated driver code/tests/units/design/skills; (b) **update** —
   references in living docs (`CLAUDE.md`, `HISTORY.md`, `designs/README.md`, `designs/*-manifest`,
   the various `README.md`s, `scripts/checks/`, `scripts/daemons/`, `scripts/jobs/common.sh`,
   `scripts/systemd/README.md`, etc.) that mention the driver and must be reworded, not removed;
   (c) **leave** — incidental matches of the word "driver" unrelated to this subsystem (e.g.
   "driver" used generically). Be careful: 629 raw hits ≠ 629 deletions.
2. **Verify it is truly dead.** Confirm nothing **live** invokes it: the gardener fleet / v2 job
   system does not call `scripts/driver/` or the `driver` launcher; `garden-driver@.service` is
   not enabled; `install-units.sh` / the checks / daemons do not depend on it; CI's
   `driver-tests.yml` is the only thing exercising it. Flag any live dependency you find — that
   blocks removal of that piece.
3. **Write the removal plan** as a design doc (e.g. `designs/remove-driver.md`): the classified
   inventory (delete / update / leave), the dead-verification evidence, a safe **removal order**
   (e.g. disable+remove the CI workflow and service first, then code/tests, then the doc, then
   sweep doc references), and what to re-check after (no dangling references, CLAUDE.md inventory
   updated, checks still pass). Note any piece whose deadness is uncertain.
4. **Open the DRAFT PR** against `kriskowal/garden` (base `main2`) with the plan; the PR body
   summarizes the inventory and removal order and asks the maintainer to approve the plan before a
   follow-up PR executes the deletion. Post the standard summary in the PR body.

## Definition of done

A draft garden PR containing `designs/remove-driver.md`: a complete, classified inventory of the
driver dead code, evidence it is dead (no live caller, no installed unit), and a phased removal
plan — opened against `kriskowal/garden` base `main2` for maintainer review. Report the PR number,
the count of files to delete vs references to update, and any piece whose deadness you could not
confirm. Do not delete anything in this PR.

Posted by the liaison on behalf of the maintainer.

---
claim:
  host: endolinbot
  gardener: 17
  claimed_at: 2026-06-25T22:44:04Z
