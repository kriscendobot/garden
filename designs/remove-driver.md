# Remove the driver dead code

| Created | 2026-06-25 |
| Author  | gardener (scout + designer) |
| Status  | Proposed |

## Summary

The **"driver"** was the June-2026 systemd-automation attempt: the reconstructed
general-contractor's PR-pipeline driver, a `claude-under-script` worker pool with
role-specific job boards (`designs/driver.md`). It has been **superseded by the v2
gardener fleet** ("driver-specific lanes superseded by the gardener pool", per the
v1→v2 migration in `designs/v1-migration-manifest.md`). The driver subsystem is now
**dead code**: no installed systemd unit, no live caller, no enabled lane.

This document is the **removal plan**, not the removal. It records the classified
inventory, the evidence that the driver is dead, the live dependencies that block a
naive deletion, and a phased removal order. A follow-up PR executes the deletion
once the maintainer approves this plan.

## Evidence the driver is dead

- **No installed unit, none running.** `systemctl --user list-units 'garden-driver*'`
  returns 0 units on the active host (`endolinbot`). No `garden-driver@N.service`
  instance is enabled anywhere.
- **`install-units.sh` does not enable a driver instance.** It globs
  `garden-*.service`/`garden-*.timer` (so it *copies* `garden-driver@.service` into
  place as a template) but the explicit `enable --now` list covers only
  `garden-gardener@`, `garden-repo-watcher`, `garden-reaper`, `garden-watchman`,
  `garden-gardener-scaler`, `garden-scheduler`, `garden-bulletin`, `garden-mentor`,
  `garden-follow-up`, `garden-foreman`, `garden-proxy`, `garden-deadmail`,
  `garden-mention-watcher`, `garden-mirror-closer`. **No `garden-driver` instance is
  ever instantiated.** (Removing the unit file simply stops the glob from copying a
  template nothing references.)
- **No live caller in the v2 job system.** `git grep -nE 'scripts/driver|\./driver|garden-driver|driver\.sh'`
  over `scripts/jobs/` returns nothing. The gardener fleet
  (`scripts/jobs/gardener.sh`, the scheduler, the watchman) never invokes the driver
  launcher or `scripts/driver/driver.sh`.
- **The daemon wrappers default to zero driver lanes.** `scripts/daemons/{start,stop,status,logs}.sh`
  each set `GARDEN_DRIVER_LANES=()` by default, so their driver-lane loops iterate
  over nothing unless a host-local `config.sh` (gitignored, not present) opts in. The
  driver code paths in those scripts are inert.
- **Only `driver-tests.yml` exercises the driver**, in CI. There is no production
  consumer.

## Classified inventory

### (a) DELETE — dedicated driver artifacts (11 files)

Hard dead code with no live caller:

| Path | Note |
| --- | --- |
| `driver` | ~10 KB root launcher; nothing invokes it |
| `scripts/driver/driver.sh` | the driver worker script |
| `scripts/driver/README.md` | driver script docs (whole `scripts/driver/` dir goes) |
| `scripts/systemd/garden-driver@.service` | template; no instance enabled |
| `tests/driver/run.sh` | driver test harness |
| `tests/driver/lib/mock-garden.sh` | driver test fixture |
| `tests/driver/test_skeleton.sh` | driver test |
| `tests/driver/test_design_only_happy_path.sh` | driver test |
| `tests/driver/test_loop_capture_and_self_improve.sh` | driver test |
| `tests/driver/test_trap_fires_on_error.sh` | driver test (whole `tests/driver/` dir goes) |
| `designs/driver.md` | the driver design doc (this plan supersedes it) |

The four **`driver-*-workflow` skills** named in `CLAUDE.md`
(`driver-pr-creation-state-machine`, `driver-design-only-pr-workflow`,
`driver-gardener-workflow`, `driver-librarian-workflow`) **do not exist as files** —
`git ls-files 'skills/*driver*'` returns nothing. They were never created (or were
already removed). There is nothing to delete; they only need to be scrubbed from the
`CLAUDE.md` inventory prose (see UPDATE).

### (a′) REFACTOR, NOT DELETE — `.github/workflows/driver-tests.yml` (LIVE DEPENDENCY — blocker)

`.github/workflows/driver-tests.yml` is the **only CI workflow in the repository**
(`git ls-files .github/workflows/` returns it alone). Despite its name it is a
catch-all that, in addition to the driver tests, runs:

- broad `shellcheck` over the daemons, the endo-but-for-bots watcher stub, the
  cleaner, the checks runner, and the per-test scripts;
- `bash -n` syntax check over **all** of `scripts/` and `skills/`;
- `bash tests/checks/run.sh` (the pre-dispatch grep-gate tests);
- `bash skills/cleaner/test-cleaner.sh` (the cleaner self-test).

**Deleting this file wholesale would drop all garden CI**, not just the driver tests.
The follow-up PR must therefore **rename and refactor** it (e.g. to `checks.yml`),
removing only the driver-specific pieces — the `scripts/driver/driver.sh` and
`tests/driver/*` shellcheck lines, the `tests/driver` portion of the `bash -n` find,
and the `Run driver script tests` step — while keeping the daemons/watcher/cleaner/
checks lint and the `tests/checks` + cleaner-self-test steps. The `on.push.branches`
entry `design/driver` should also be dropped. This is the single hard blocker to a
naive "rm the driver" pass; it is surgical, not a deletion.

### (b) UPDATE — living docs/scripts that mention the driver (reword, keep the file)

Each of these stays; the driver-specific wording or the `designs/driver.md` link is
removed or re-pointed.

| Path | Change |
| --- | --- |
| `CLAUDE.md` | Remove `the driver (scripts/driver/)` from the `scripts/` layout line and its `designs/driver.md` pointer; drop the four `driver-*-workflow` names and the two sentences describing the driver workflow skills from the skills inventory; reword the "driver lane" phrasing in the dispatch-contract and contractor-retirement paragraphs to the gardener pool. |
| `designs/README.md` | Delete the `driver.md` index row (line 30); optionally add a `remove-driver.md` row. |
| `designs/v1-migration-manifest.md` | Reword the `Driver-shell`/`driver-lane` disposition cells (≈ lines 18, 20, 104, 115, 178, 208–214, 235) to past-tense "v1" framing; the disposition rows for the four driver-* skills should note the skills never materialized as files. |
| `designs/self-healing-audit.md` | Re-point the self-healing **exemplar** away from `scripts/driver/driver.sh` (see *Uncertain / needs a decision*). Mark its `driver.sh` rows as retired. |
| `scripts/systemd/README.md` | Delete the `garden-driver@.service` table row, the `ln -sf .../garden-driver@.service` install line, and the `garden-driver@1` enable/journalctl examples; remove `designs/driver.md` links; reword "driver pool". |
| `scripts/systemd/garden-design-poller.service` | Drop `Documentation=file:%h/designs/driver.md`; reword "one poller per driver container". |
| `scripts/systemd/garden-watcher@.service` | Drop `Documentation=file:%h/designs/driver.md`. |
| `scripts/daemons/README.md` | Remove driver-daemon wrapper docs and the `designs/driver.md` link; keep watcher/other-daemon docs. |
| `scripts/daemons/config.sh.example` | Remove the `GARDEN_DRIVER_LANES` block and the "Driver lanes" comments and the `driver-gardener-workflow` link; keep `GARDEN_WATCHER_FEEDS`. |
| `scripts/daemons/start.sh` | Remove `GARDEN_DRIVER_LANES`, the driver-unit loop, and `driver_units` from the `all_units` aggregation. |
| `scripts/daemons/stop.sh` | Same as start.sh. |
| `scripts/daemons/status.sh` | Same as start.sh. |
| `scripts/daemons/logs.sh` | Remove the `--lane` option and the `garden-driver@*.service` filter/glob; keep watcher logs. |
| `scripts/checks/README.md` | Reword "step 0 of the driver's pre-CI gauntlet"; drop the `designs/driver.md` link; if `driver-tests.yml` is renamed, fix the workflow reference. |
| `scripts/checks/run-all.sh` | Drop "driver" from the line-29 caller comment. |
| `scripts/watcher/README.md` | Drop the `designs/driver.md` link; reword "the driver (or a …)" consumer to the gardener pool. |
| `scripts/watcher/endo-but-for-bots/README.md` | Drop the `designs/driver.md` link; reword driver-subscription / "for the driver to read" language to the v2 job-posting model. |
| `scripts/watcher/endo-but-for-bots/watcher.sh` | Reword the contract comments (driver subscriptions/lanes) to the v2 "post a job for gardeners to claim" model; drop the `designs/driver.md` link. |
| `tests/checks/run.sh` | Fix the line-4 "Mirrors the shape of tests/driver/run.sh" comment (self-reference or descriptive). |
| `skills/self-healing-wrapper/SKILL.md` | Re-point the exemplar away from `driver.sh` (see *Uncertain*); mark its `driver.sh` code citations as retired. |
| `skills/prompt-on-failure-capture/SKILL.md` | Re-point the `designs/driver.md §` reference to `designs/self-healing-audit.md` (or the pattern's surviving home). |
| `skills/coverage-driven-testing/SKILL.md` | Line 155: reword "steward/driver-" to "v1 driver pool". |
| `skills/ci-failure-classification-loop/SKILL.md` | Line 304: qualify "driver-lane framings" as v1. |
| `scripts/jobs/common.sh` | Line 408 comment points to `designs/driver.md § Prompt-on-failure capture`; re-point to `designs/self-healing-audit.md` (code itself stays — it is v2 infra). |
| `.gitignore` | Reword the line-33 comment ("driver pool and per-feed"); the `scripts/daemons/config.sh` ignore entry stays (it still configures watchers). |

### (c) LEAVE — incidental or historical mentions (no change)

- `HISTORY.md` — chronicle of the garden's evolution; the driver container and the
  driver pivot are load-bearing historical facts.
- `designs/inbox-discipline-audit.md` — "Agent (driver → handler)" uses *driver* as a
  generic verb, not the subsystem.
- `skills/pre-push-gates/SKILL.md`, `skills/panel-hints/SKILL.md` — "the driver
  script" means the probe-aggregator/gate runner, generic terminology.
- `skills/pr-ci-watch/SKILL.md` — "a `/loop` driver / `Monitor` driver" means the
  supervising loop, generic.
- `skills/saboteur-adversarial-review/SKILL.md` — "container driver" / `drivers/path.js`
  refer to project code, not the garden subsystem.
- `skills/review-queue-poll/SKILL.md`, `skills/node-lts-window-watch/SKILL.md`,
  `skills/activity-feed-watcher/SKILL.md` — already correctly describe the v1→v2
  migration away from driver lanes; accurate history.
- `references/endo-but-for-bots/roles/chronicler.md` — imported reference shelf;
  "sandbox-driver" is project terminology.

## Tally

- **Delete outright:** 11 files (the `scripts/driver/` dir, the `tests/driver/` dir,
  the root `driver` launcher, `garden-driver@.service`, `designs/driver.md`).
- **Refactor (do not delete):** 1 file — `.github/workflows/driver-tests.yml`.
- **Update (reword):** ~24 files.
- **Leave:** ~10 files (plus the 4 nonexistent `driver-*-workflow` skills, scrubbed
  from `CLAUDE.md` prose only).

(The "629 driver references" from the initial sweep are **629 line hits across 47
files**, dominated by the dedicated artifacts themselves; the living-doc reword
surface is the ~24 UPDATE files above.)

## Removal order (for the follow-up PR)

1. **Stop CI from depending on the driver first.** Rename/refactor
   `.github/workflows/driver-tests.yml` → `checks.yml`: drop the driver shellcheck
   lines, the `tests/driver` `bash -n` scope, the `Run driver script tests` step, and
   the `design/driver` push branch; **keep** the daemons/watcher/cleaner/checks lint
   and the `tests/checks` + cleaner self-test steps. Verify the refactored workflow
   still references only surviving paths.
2. **Remove the service template.** Delete `scripts/systemd/garden-driver@.service`.
   (No instance is enabled, so nothing to disable; on hosts where the glob copied the
   template, a later `install-units.sh` run simply stops re-copying it. Optionally note
   that operators can `rm ~/.config/systemd/user/garden-driver@.service` by hand.)
3. **Re-point the self-healing exemplar** (see *Uncertain*) in
   `designs/self-healing-audit.md` and `skills/self-healing-wrapper/SKILL.md` to a
   surviving reference implementation **before** deleting `driver.sh`, so the docs are
   never left pointing at a deleted file.
4. **Delete the code and tests.** Remove the root `driver` launcher, the
   `scripts/driver/` directory, and the `tests/driver/` directory.
5. **Delete the design doc.** Remove `designs/driver.md` and its `designs/README.md`
   index row.
6. **Scrub the daemon driver-lane code.** Remove `GARDEN_DRIVER_LANES` and the
   driver-unit loops from `scripts/daemons/{start,stop,status,logs}.sh` and
   `config.sh.example`.
7. **Sweep the remaining doc references.** Apply every (b) UPDATE reword, including the
   `CLAUDE.md` inventory (drop the four nonexistent driver-* skill names and the
   driver layout/dispatch prose).

## Re-check after removal

- `git grep -niE 'designs/driver\.md|scripts/driver|garden-driver|GARDEN_DRIVER_LANES|driver-(pr-creation-state-machine|design-only-pr-workflow|gardener-workflow|librarian-workflow)'`
  returns **no hits** (every dedicated reference is gone or reworded).
- No remaining link points to a deleted file (`designs/driver.md`, `scripts/driver/`,
  `tests/driver/`).
- The renamed CI workflow still lints the surviving scripts and runs the checks +
  cleaner self-tests; `bash tests/checks/run.sh` and `bash skills/cleaner/test-cleaner.sh`
  pass.
- `CLAUDE.md`'s skill inventory no longer names the four driver-* workflow skills, and
  its `scripts/` layout line no longer claims a driver.
- `scripts/jobs/install-units.sh` and the daemon wrappers run clean with no
  driver-named unit or variable.

## Uncertain / needs a maintainer decision

1. **`driver.sh` is the documented self-healing exemplar.**
   `designs/self-healing-audit.md` (≈ 9 citations) and
   `skills/self-healing-wrapper/SKILL.md` (≈ 6 citations) hold up
   `scripts/driver/driver.sh` as *the strongest reference implementation* of the
   self-healing trap/retry wrapper. Deleting the file orphans those docs. This is a
   **documentation dependency, not a live caller** — it does not block deletion, but
   the follow-up PR must first re-point the exemplar to a surviving self-healing
   script (candidate: `scripts/jobs/gardening/garden-pr.sh` or the gardener loop's
   error handling, per `designs/gardening-state-machine.md`). If no v2 script
   implements the full wrapper shape, the maintainer may prefer to **preserve the
   `driver.sh` excerpt** inline in the audit/skill rather than lose the exemplar.
2. **CI workflow name and scope.** The follow-up renames `driver-tests.yml`; the
   maintainer should confirm the target name (`checks.yml` suggested) and that
   dropping the `design/driver` push trigger is acceptable.

Everything else is unambiguously dead and safe to remove in the order above.
