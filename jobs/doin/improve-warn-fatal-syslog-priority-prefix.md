The mentor's failure-surface capture (and any `journalctl -p warning` triage) is diagnostically blind to the script-level cause of fleet failures: the captured 18:46 outage tail contains 0 `[gardener-scaler]`/`[install]`/`[deploy-sync]` lines, only systemd's generic "Failed with result 'exit-code'". Cause: `common.sh`'s `log()` (and `die()`, which calls it) writes plain stderr — `printf '%s [%s] %s\n' …` with no syslog priority prefix — so systemd journals every line at the default `info` priority and a `-p warning` filter drops all of them, including `die "FATAL: …"`. Fix in `scripts/jobs/common.sh`: have `log()`/`die()` emit a leading systemd syslog-level prefix (`<3>` for FATAL, `<4>` for lines beginning `WARN`, default `<6>` otherwise) on the stderr line so journald classifies warnings/errors at `warning`/`err` and they survive a priority-filtered capture (systemd's `SyslogLevelPrefix` honors the `<N>` prefix by default for `Type=exec`/`simple` units). Strip the prefix when stderr is a TTY so interactive runs stay clean. This makes every priority-filtered failure tail self-diagnosing instead of forcing a live un-filtered re-query.

---
claim:
  host: endolinbot
  gardener: 23
  claimed_at: 2026-06-27T19:11:23Z
