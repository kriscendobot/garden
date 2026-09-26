Inbox empty. Work complete.

## Completion report

**Job:** `improve-library-regenerator-safety-net-timers` — add standing systemd safety-net timers so the library's deterministic count/index regenerators run off-agent.

**Key finding:** Half the job was already done. The `garden-regenerate-sections-index.{timer,service}` pair landed on origin/main2 in commit `cdd895416` (timer at `*:37`) before I claimed. I did **not** clobber it. Only the topics-counts pair was missing.

**What I did:** Added `scripts/systemd/garden-regenerate-topics-counts.{timer,service}`, modeled on the already-merged sections-index twin (its closest sibling), which in turn derives from the drift-scan pair:
- **service** — `Type=oneshot`, `SuccessExitStatus=143 130 75 SIGTERM SIGINT`, `TimeoutStartSec=900`, `ExecStart` wraps `regenerate-topics-counts.sh --land` in `self-heal-run.sh ... --expect 75`.
- **timer** — absolute `OnCalendar=*:17` + `Persistent=true`, offset clear of clone-keeper (`:00/:30`), drift-scan (`:07`), link-scan (`:22`), and the sections-index regen (`:37`), avoiding the relative-window re-arm bug.

**One deliberate deviation from the literal spec:** the job text said to model "exactly on the drift-scan pair," which carries `ExecCondition=is-main-host` (leader-only). I omitted that gate — matching the merged sections-index twin — because the regenerators `--land` through `land-journal-edit.sh`'s idempotent producer-clone CAS, which is safe fleet-wide; leader gating is only needed for the drift-scan because it *posts jobs* (double-posting hazard). This keeps the two regenerator units symmetric.

**Verification:** `systemd-analyze calendar '*:17'` normalizes correctly; no syntax errors (only the expected `@GARDEN_ROOT@` placeholder, resolved at install time). Both units are non-template and not in `EXCLUDED_UNITS`, so `install-units.sh` auto-discovers them with no list edit.

**Pushed:** commit `0ff5d476e` to `origin/main2`, clean CAS push on first attempt.

**Follow-ups:** None required. The timers arm on the next `install-units.sh enable-services` / daemon-reload on each host (the deliberate-deploy path handles fleet restart).
