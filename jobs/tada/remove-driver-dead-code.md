Done. Inbox is empty. Completion report follows.

---

## Completion report: `remove-driver-dead-code`

**Landed on main2** at commit `647f06275` (single commit, explicit-pathspec, pushed via rebase-CAS — resolved two rounds of rebase conflicts against concurrent peer commits, see below).

### What I removed (dead driver subsystem)
Deleted outright: root `driver` launcher, `scripts/driver/` (driver.sh + README), `tests/driver/` (run.sh + 4 test scripts + mock-garden fixture), `scripts/systemd/garden-driver@.service`, and `designs/driver.md`.

### CI (the one hard blocker)
`driver-tests.yml` was the repo's *only* workflow — a catch-all also running the daemons/watcher/checks lint and the checks tests. Renamed → `checks.yml`, dropping the driver shellcheck lines, the `Run driver script tests` step, and the `design/driver` push trigger. **Discovered the old workflow was already stale/broken**: it referenced `skills/cleaner/cleaner.sh` + `skills/cleaner/test-cleaner.sh`, which no longer exist on main2 (only `roles/cleaner/AGENT.md` remains). Dropped those dead references and the cleaner self-test step; added the newer `maintainer-inbox-information-hiding` gate/test the stale workflow had omitted. Every path the new workflow names now exists; YAML validates; all referenced scripts are shellcheck-clean.

### Code scrub (no behavior change — driver wasn't running)
- `scripts/daemons/{start,stop,status,logs}.sh` + `config.sh.example`: removed `GARDEN_DRIVER_LANES` and all driver-unit loops / the `--lane` flag; watcher management unchanged. shellcheck + `bash -n` clean.
- `scripts/jobs/deploy-restart.sh`, `install-units.sh`: dropped `garden-driver@` from the restart glob and the template-exclusion comments.
- `scripts/systemd/garden-watcher@.service`: dropped the `designs/driver.md` Documentation line.

### Docs reworded
`CLAUDE.md` (layout line, skills inventory — the four `driver-*` workflow skills **never existed as files**, confirmed via `git ls-files 'skills/*driver*'` always empty — and the dispatch/contractor prose), the systemd/daemons/watcher/checks READMEs, `.gitignore`, `HISTORY.md`, `designs/README.md` (index row), `v1-migration-manifest.md`, and `scripts/checks/run-all.sh`/`tests/checks/run.sh` comments.

**Self-healing exemplar (the design's flagged "needs a decision" item):** `designs/self-healing-audit.md`, `skills/self-healing-wrapper/SKILL.md`, and `skills/prompt-on-failure-capture/SKILL.md` held `driver.sh` up as the strongest self-healing exemplar. No v2 script implements the *full* wrapper shape (the audit itself rates the candidates "partial"), so rather than falsely re-point to a partial implementation, I reframed the exemplar as historical (preserved in git history) and pointed forward to the live `scripts/jobs/self-heal-run.sh` + the `self-healing-wrapper` skill. This keeps the docs truthful without orphaning them.

### Verification
- Canonical re-check grep (`designs/driver.md|scripts/driver|garden-driver|GARDEN_DRIVER_LANES|driver-*-workflow`): **no hits**.
- No tracked driver files remain; no dangling links to deleted files.
- All remaining `driver` mentions triaged to the design's LEAVE set: accurate v1→v2 history, generic terminology ("driver script"/"loop driver"/project `drivers/path.js`), or explicit tombstone notes.
- `tests/checks/run.sh`: passes except `test_run_all`'s 2 claude-stub assertions — **pre-existing and environmental** (this sandbox blocks executing the temp claude stub; identical on base origin/main2; my only `run-all.sh` change was a comment). Passes in GitHub CI, where the old workflow ran the identical step.

### Notes / follow-ups
- `designs/remove-driver.md` lives only on PR #5's branch `plan/remove-driver`, not on main2 — nothing to remove/mark there. Per the job, the liaison closes PR #5 as converted-to-job.
- Pre-existing shellcheck warnings in `scripts/jobs/{install-units,self-heal-run,common}.sh` (unused `GARDEN_TAG`/`JOBS_*`, `common.sh:439` SC2261) are untouched by me and outside the `checks.yml` lint scope — not regressions.
