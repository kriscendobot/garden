The work is complete and verified on `origin/main2`.

## Completion report

**Job:** Harden `scripts/jobs/repo-watcher.sh` against a never-rendered watcher template causing an unbounded arming-failure loop, and recover the live auto-shepherd CI watch on endolinbot.

**Context found:** A prior commit (8788b24bf) had already landed the core self-heal (render a missing template via `install-units.sh install` before arming, guarded once-per-tick, plus a happy-path test). But it diverged from the spec on the tail case: when the source template is *genuinely* gone from `scripts/systemd/` (install renders nothing, template stays absent), it swallowed the failure and **fell through to arm anyway** — re-logging a per-slug `"could not arm"` WARN every tick, exactly the spam the fix exists to stop.

**What I changed (`scripts/jobs/repo-watcher.sh`):**
- `reconcile_set` now gates the arming loop on a `can_arm` flag. When the template is still absent after the once-per-tick self-heal install, it **skips arming that set this tick** (a single WARN was already logged by `ensure_template_installed`) and records `"armed 0 of N wanted"` in the summary. The disarm loop still runs — tearing down a now-unwanted instance never needs the template.
- Indirected the install call through `GARDEN_INSTALL_UNITS` (same pattern as `unit_ctl`), so a test can point it at a no-op stub; the default is unchanged.

**Test (`scripts/jobs/test/run-test.sh`, SUBTEST 3):** added a still-absent case — fresh empty `$DEST` + `GARDEN_INSTALL_UNITS=/bin/true` (renders nothing) — asserting the instance is NOT armed, no per-slug `"could not arm"` spam, one missing-template WARN, and the `"armed 0 of"` summary. Validated all repo-watcher cases (11/11 pass, including the pre-existing self-heal and no-drift cases) with a focused standalone harness; `bash -n` clean on both files.

**Live recovery on endolinbot:** Confirmed the exact drift — `garden-ci-watcher@.{service,timer}` source present (Jul 1) but never rendered into `~/.config/systemd/user/`, while `garden-comment-watcher@` was (Jun 30). Ran the **deployed** root's `install-units.sh install` (renders `@GARDEN_ROOT@`=`/home/kris`), then the deployed repo-watcher, which armed `garden-ci-watcher@{endojs-endo-but-for-bots,kriskowal-garden}.timer` (both now `enabled` + active, next fire ~1 min). Verified the systemd manager sees this host as leader (`GARDEN=endolinbot`, `is-main-host` exit 0), so the CI-watcher `ExecCondition` passes and ticks actually run — auto-shepherd-on-red is live again.

**Landed:** commit `4e6e274f3` on `origin/main2`.

**Follow-ups / notes:**
- The code fix reaches the deployed `/home/kris` root via the normal deliberate deploy (`deploy-garden.sh` on the next upgrade signal); I did not hand-edit the deployed tree. The live template render + arming above is the immediate recovery.
- Incidental observation (not acted on — out of scope): my interactive shell had a stale `GARDEN=endolinbot2` export, but the systemd manager and `environment.d` are clean (`GARDEN=endolinbot`), so there's no live leader-predicate drift.
