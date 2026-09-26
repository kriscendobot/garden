Done. Completion report:

---

**Job: improve-unit-execstart-stable-interpreter — complete**

**What I did**
Hardened the garden systemd unit templates against the 2026-06-27 18:46 fleet-wide `status=203/EXEC` outage, where `deploy-sync.sh` advances the live checkout under `$GARDEN_ROOT` in place while units may be (re)starting — so a unit whose `ExecStart` `execve()`s the script directly hits a momentarily absent/non-executable file and 203/EXECs, counting toward `StartLimitBurst` and wedging workers DOWN past the deploy.

All work was done in an isolated worktree off `origin/main2` (shared `/home/kris` main2 tree is concurrently mutated by the fleet), committed with explicit pathspecs, rebased onto the advancing tip, and pushed `HEAD:main2`.

**What changed** (commit `91498baa4` on `main2`)
- **All 24 `scripts/systemd/garden-*.service` templates**: `ExecStart=` now execs a stable, always-present interpreter — `ExecStart=/bin/bash @GARDEN_ROOT@/...`. systemd then execs `/bin/bash` (never 203/EXEC); a transient unreadable script becomes an ordinary nonzero bash exit that `Restart=on-failure`/the next timer tick retries cleanly. (The job named gardener + scaler + "the other long-running unit templates"; I covered every `.service` so the regression assertion is total and `driver@`/`reaper` are protected too. Confirmed `self-heal-run.sh`, `driver.sh`, `reaper.sh`, `gardener.sh` are all `#!/bin/bash`, so `/bin/bash` is the correct interpreter.)
- **`garden-gardener@.service` and `garden-gardener-scaler.service`**: added `StartLimitIntervalSec=0` to the `[Unit]` section so a deploy-window burst of failures can never hold a worker DOWN indefinitely.
- **`scripts/jobs/test/run-test.sh`**: added SUBTEST 27, which renders every `garden-*.service` exactly as `install-units.sh render()` does (`sed @GARDEN_ROOT@`) and asserts every `ExecStart=` begins with `/bin/bash` (24 lines checked).

**Verification**
- `bash -n run-test.sh` parses; the new assertion logic passes against the new templates (24/24) and correctly fails against the old gardener template.
- `systemd-analyze verify` on the rendered gardener/scaler/reaper units raised no structural complaints about the new `ExecStart` form or `StartLimitIntervalSec` placement.

**Follow-ups**
- The fix only takes effect once `deploy-sync.sh`/`install-units.sh install` re-renders the units into `~/.config/systemd/user/` and a `daemon-reload` runs on each host; currently-running units keep their old rendered ExecStart until then. The next deploy applies it fleet-wide automatically — no manual action required, but worth noting the gap is closed only after the next re-render.
