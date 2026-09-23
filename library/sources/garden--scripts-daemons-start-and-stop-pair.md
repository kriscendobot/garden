---
title: "garden/scripts/daemons/{start,stop}.sh + config.sh.example — operational daemon control for the garden's driver lanes and per-feed watchers"
source-slug: garden--scripts-daemons-start-and-stop-pair
url: https://github.com/kriskowal/garden/blob/main/scripts/daemons/start.sh
authors: [Endo project (collective; the garden's named-role-as-author convention)]
repo: kriskowal/garden
path: scripts/daemons/{start.sh, stop.sh, config.sh.example}
total-lines: 174 (81 + 69 + 24)
ingest-cycle: 300
ingest-date: 2026-06-11
lane: chat
---

# `garden/scripts/daemons/{start,stop}.sh + config.sh.example`

A 174-line bash cluster implementing host-local daemon management for the garden's driver lanes and per-feed watchers via systemd's `--user` manager. The fifth garden source ingested. **§five-cycles-with-garden-repo-source-ingest** (281 + 297 + 298 + 299 + 300) + **§five-named-shapes-of-garden-self-documentation** (proposed-design + standing-reference + implementation-source + project-instructions + operational-daemon-control). Cycle 300 IS the **three-hundredth** cycle of the librarian's one-source-per-cycle cadence.

## Key moves

- **§the-named-paired-management-scripts (start.sh + stop.sh)** — extends cycle 298's prepare/teardown pair. **§two-cycles-with-named-script-pair-shape** (298 + 300).
- **§the-named-deliberate-`set -uo pipefail`-WITHOUT-`-e`** — distinct from cycle 298's `set -euo pipefail`; the daemons scripts want failure-tolerance on `systemctl stop`. **§two-named-bash-strictness-shapes-in-the-garden-scripts**.
- **§the-named-`systemctl --user`-IS-named-no-root-orchestration** — per-user systemd; bot account isolation; defense in depth.
- **§the-named-systemd-template-units** — `garden-driver@<lane>.service` (integer instance) + `garden-watcher@<feed>.service` (slug instance); one unit file, many instances.
- **§the-named-host-local-gitignored-config-AND-checked-in-`.example`-template-pair** — config.sh gitignored, config.sh.example checked in; config IS executable bash.
- **§the-named-graceful-fallback-when-config-missing** — exits 0 with named copy-the-template instruction. **§two-cycles-with-named-actionable-error-messages**.
- **§the-named-pre-flight-`command -v systemctl`-check** — dependency check before use; portable POSIX `command -v` over `which`.
- **§the-`exit 64`-for-usage-errors-extends-from-cycle-298** — sysexits.h EX_USAGE; **§two-cycles-with-`exit 64`-for-usage-errors**.
- **§the-named-three-flag-tristate-mode** — `(default) | --enable-only | --start-only`; product of two booleans collapsed.
- **§the-named-default-stop-leaves-enabled** — temporary deactivation; `--disable-too` named-explicit-opt-in-for-disable. **§the-named-asymmetric-defaults-between-start-and-stop**.
- **§the-named-empty-array-guard** — explicit zero-check; empty IS not-an-error.
- **§the-named-`+=` array-append-discipline** + **§the-named-two-phase-array-build**.
- **§the-named-`(s)` pluralization** — `unit(s)` reads correctly for all counts.
- **§the-named-prefix-discipline-on-every-stderr-line** — `start:` / `stop:` prefix for message attribution in journalctl.
- **§the-named-success-marker-IS-stdout** — `echo "start: done"` on stdout. **§two-cycles-with-named-distinct-uses-of-stdout-and-stderr** (298 return-value + 300 success-marker).
- **§the-named-`shellcheck disable=SC2034`-WITH-named-justification** — three-rule discipline (rule code + reason + narrow scope). **§two-cycles-with-distinct-shellcheck-stances** (298 no-suppressions + 300 justified-suppressions).
- **§the-named-tolerated-failure-via-`|| true`** — `systemctl stop ... || true`; **§two-cycles-with-named-`|| true`-tolerated-failure**.
- **§the-named-export-`GARDEN_ROOT`-for-downstream-wrappers** — context propagation via env var.
- **§the-named-decomposition-of-script-location-discovery** — `SCRIPT_DIR` for siblings + `GARDEN_ROOT` for cross-tree.
- **§the-named-config.sh.example-IS-the-named-self-documenting-template** — defaults and constraint comments pedagogical.
- **§the-named-top-of-file-docstring-extends-from-cycle-298** — purpose + behavior + usage. **§two-cycles-with-named-top-of-file-docstring**.
- **§the-named-Usage-line-microformat** — square brackets + pipe alternatives. **§two-cycles-with-named-Usage-line-microformat**.
- **§the-named-cycle-300-IS-the-named-three-hundredth-cycle-milestone**.

## Section files

- [§five-cycles-with-garden-repo-source-ingest + §the-named-deliberate-`set -uo pipefail` + §systemd-template-units + §host-local-gitignored-config + §shellcheck-suppression-with-justification + 30+ more first-explicit-observations](../sections/garden--scripts-daemons-start-and-stop-pair--five-cycles-with-garden-source-ingest-and-set-uo-pipefail-and-systemd-template-units.md) — full 174-line cluster in scope (81 start + 69 stop + 24 config-example).

## Ingest scope

Cycle 300 (chat-lane after cycle 299 designs-lane CLAUDE.md). Full 174-line triple (start.sh + stop.sh + config.sh.example) in scope. **First-explicit-observations (forty-plus)** at full scope: the named-paired-management-scripts shape, the named-deliberate-`set -uo pipefail`-WITHOUT-`-e` (distinct from cycle 298's `set -euo pipefail`), the named-systemd-template-units with two instance-identifier families (integer + slug), the named-host-local-gitignored-config + checked-in-`.example` template-pair, the named-graceful-fallback-when-config-missing (exit 0 not exit 1), the named-pre-flight-dependency-check, the named-three-flag-tristate-mode (product of two booleans), the named-default-stop-leaves-enabled (asymmetric default vs start), the named-shellcheck-suppression-WITH-justification (three-rule discipline), and the named-cycle-300-three-hundredth-cycle-milestone.
