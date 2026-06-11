---
title: "garden/scripts/daemons/{start,stop}.sh + config.sh.example — five-cycles-with-garden-repo-source-ingest; the-named-deliberate-`set -uo pipefail`-WITHOUT-`-e` (distinct from cycle 298's `set -euo pipefail`); systemd `--user` instance-template-units; host-local-gitignored-config + checked-in `.example`; `shellcheck disable=SC2034`-WITH-justification; `exit 64` extends cycle 298; named-graceful-fallback (`exit 0`) when config missing"
section-slug: garden--scripts-daemons-start-and-stop-pair--five-cycles-with-garden-source-ingest-and-set-uo-pipefail-and-systemd-template-units
source-slug: garden--scripts-daemons-start-and-stop-pair
url: https://github.com/kriskowal/garden/blob/main/scripts/daemons/start.sh
authors: [Endo project (collective; the garden's named-role-as-author convention)]
repo: kriskowal/garden
path: scripts/daemons/{start.sh, stop.sh, config.sh.example}
total-lines: 174 (81 start + 69 stop + 24 config-example)
ingest-cycle: 300
ingest-date: 2026-06-11
lane: chat
scope: full
---

# `garden/scripts/daemons/{start,stop}.sh + config.sh.example` (daemon-management triple ingest)

A 81+69+24=174-line cluster of bash scripts implementing **the-named-host-local-daemon-management-discipline** for the garden's driver lanes and per-feed watchers, layered on top of systemd's `--user` manager. The fifth garden source ingested. **§five-cycles-with-garden-repo-source-ingest** (281 + 297 + 298 + 299 + 300). **§the-named-cycle-300-IS-the-named-three-hundredth-cycle-milestone**.

The cycle 297 WORKTREES.md and cycle 299 CLAUDE.md both *reference* the daemon scripts in prose; cycle 300 *ingests their source*. **§the-named-design-to-implementation-bridge-across-multiple-cycles** (296 + 297 + 298 + 299 + 300): the prose names the contract; the scripts realize it.

## Key moves

- **§the-named-paired-management-scripts (start.sh + stop.sh)** (first-explicit-observation): the same pattern as cycle 298's `dispatch-prepare.sh + dispatch-teardown.sh` — **§two-cycles-with-named-script-pair-shape** (298 prepare/teardown + 300 start/stop). The pair shape: one script realizes the creation/start; the sibling realizes the inverse. **§the-named-symmetric-script-pair-as-a-named-shape** is now a multi-cycle pattern, not a one-off.

§the-named-asymmetric-line-counts-extend: cycle 298 prepare 65 + teardown 46 = 65/46 ≈ 1.4×; cycle 300 start 81 + stop 69 = 81/69 ≈ 1.17×. Cycle 300's pair IS more symmetric because both start and stop iterate the same config-derived list and call systemctl with different verbs; cycle 298's prepare had additional roll-back logic that cycle 300's start doesn't need (systemd handles partial-failure cleanup). **§the-named-asymmetric-asymmetry-across-script-pairs**: the *amount* of asymmetry IS itself cycle-distinct.

- **§the-named-deliberate-`set -uo pipefail`-WITHOUT-`-e`** (first-explicit-observation):

```bash
set -uo pipefail   # NOTE: no -e
```

(start.sh line 17; stop.sh line 17)

Cycle 298's dispatch-prepare/teardown use `set -euo pipefail` (WITH `-e`). Cycle 300 deliberately omits `-e`. **§the-named-`-e`-omission-IS-the-named-tolerated-failure-discipline**: with `-e`, any non-zero exit terminates the script; without `-e`, the script reads each command's exit code and decides locally. The daemons scripts WANT to tolerate `systemctl stop` failing on an already-stopped unit, and they use `|| true` to make that explicit on the relevant lines.

§the-named-`-e`-vs-`|| true`-as-named-distinct-error-discipline-shapes: with `-e`, every failure-tolerant line needs `|| true`; without `-e`, only the *intolerable* failures need explicit checks. Cycle 300 chooses the without-`-e` shape because most systemctl calls are failure-tolerant; cycle 298 chose the with-`-e` shape because most operations should fail fast.

§the-named-two-named-bash-strictness-shapes-in-the-garden-scripts: `set -euo pipefail` (cycle 298) + `set -uo pipefail` (cycle 300). Same `-u` (error-on-undefined-var) + `-o pipefail` (pipe-failure-propagation); distinct `-e` discipline. **§the-named-`-u`-and-`-o pipefail`-as-named-universal-strictness** (both cycles); **§the-named-`-e`-as-named-cycle-distinct-choice**.

- **§the-named-`systemctl --user`-IS-named-no-root-orchestration** (first-explicit-observation):

```bash
systemctl --user daemon-reload
systemctl --user enable "${all_units[@]}"
systemctl --user start "${all_units[@]}"
```

**§the-named-per-user-systemd-IS-the-named-bot-account-isolation**: the garden runs as the bot user (kriscendobot or endolinbot); `--user` scopes the units to that user's systemd manager; no `sudo` needed; no host root touched. **§the-named-defense-in-depth-via-user-scope**: even if a unit were compromised, its blast radius IS confined to the bot user's processes.

§the-named-`systemctl --user daemon-reload`-IS-named-cheap-and-idempotent: the comment in start.sh names this property explicitly — "Cheap and idempotent." **§the-named-comment-with-named-property-attribution**.

- **§the-named-systemd-template-units-IS-the-named-instance-shape** (first-explicit-observation):

```bash
driver_units+=("garden-driver@${lane}.service")
watcher_units+=("garden-watcher@${feed}.service")
```

**§the-named-`@` syntax-IS-systemd's-named-template-instance-marker**: `garden-driver@.service` IS a template; `garden-driver@1.service` and `garden-driver@2.service` are instances of that template. **§the-named-one-unit-file-many-instances**.

§the-named-instance-name-via-string-interpolation: bash string interpolation builds the instance name from the lane number or feed slug. **§the-named-config-value-becomes-systemd-instance-identity**.

§the-named-two-named-template-unit-families: `garden-driver@<lane>.service` (numeric lanes) + `garden-watcher@<feed>.service` (slug feeds). **§the-named-distinct-instance-identifier-types** (integer vs slug).

- **§the-named-host-local-gitignored-config-AND-checked-in-`.example`-template-pair** (first-explicit-observation):

```bash
CONFIG_FILE="$SCRIPT_DIR/config.sh"
if [ -f "$CONFIG_FILE" ]; then
  # shellcheck source=/dev/null
  source "$CONFIG_FILE"
else
  echo "start: $CONFIG_FILE not found." >&2
  echo "start: copy scripts/daemons/config.sh.example to scripts/daemons/config.sh and edit." >&2
  exit 0
fi
```

**§the-named-template-and-realization-pair**: `config.sh.example` IS checked in (the template); `config.sh` IS gitignored (the realization). **§the-named-host-local-customization-via-template-instantiation**.

§the-named-config-IS-executable-bash: the config defines `GARDEN_DRIVER_LANES=(1 2)` and `GARDEN_WATCHER_FEEDS=(endo-but-for-bots)` as bash arrays; the scripts source the file via `source "$CONFIG_FILE"`. **§the-named-config-IS-not-JSON-not-YAML-not-INI-IS-bash**. The advantage: arbitrary bash logic in the config (host-specific guards, computed values); the disadvantage: untrusted config IS a code-execution vector — but the config is host-local-gitignored, so it's authored by the host operator.

§the-named-`# shellcheck source=/dev/null`-discipline: tells shellcheck not to try to follow the source (because config.sh doesn't exist in the checked-in repo). **§the-named-shellcheck-direction-comment**.

- **§the-named-graceful-fallback-when-config-missing** (first-explicit-observation): when `config.sh` IS not found, start.sh prints a helpful message ("copy scripts/daemons/config.sh.example to scripts/daemons/config.sh and edit.") and exits **0** (success). Stop.sh does the same — "config.sh not found; nothing to stop" + exit 0. **§the-named-missing-config-IS-not-an-error**: it means "nothing to do".

§the-named-actionable-error-message-with-named-fix: the error message names *what to do next* (the copy command). **§two-cycles-with-named-actionable-error-messages** (298 + 300): cycle 298's "clone first via: git clone --bare ..." + cycle 300's "copy scripts/daemons/config.sh.example to scripts/daemons/config.sh and edit."

§the-named-exit-0-on-missing-config-vs-exit-1-on-missing-systemctl: missing config = "nothing to do, exit successfully"; missing systemctl = "can't do anything, exit with failure". **§the-named-distinct-failure-modes-deserve-distinct-exit-codes**.

- **§the-named-pre-flight-`command -v systemctl`-check** (first-explicit-observation):

```bash
if ! command -v systemctl >/dev/null 2>&1; then
  echo "start: systemctl not available; nothing to do" >&2
  exit 1
fi
```

**§the-named-dependency-check-before-use**: the script verifies systemctl exists before attempting to use it. **§the-named-bash-`command -v`-IS-named-portable-which**: `command -v` IS POSIX (vs `which` which IS not). **§the-named-portability-discipline-extends-into-error-checking**.

§the-named-pre-flight-vs-fail-on-use: the script chooses pre-flight (check + early exit with named message) over fail-on-use (let systemctl fail with bash's exit code). **§the-named-pre-flight-discipline-IS-named-better-UX**.

- **§the-`exit 64`-for-usage-errors-extends-from-cycle-298** (first-explicit-observation; **two-cycles-with-`exit 64`-for-usage-errors**):

```bash
case "${1:-}" in
  --enable-only) START=0 ;;
  --start-only) ENABLE=0 ;;
  '') ;;
  *) echo "start: unknown flag: $1" >&2; exit 64 ;;
esac
```

**§the-named-sysexits.h-EX_USAGE-IS-64-extends-to-cycle-300**: same canonical exit code for usage errors. **§the-named-canonical-exit-code-discipline-IS-cross-cycle-consistent**: both the dispatch-prepare/teardown pair (cycle 298) and the daemon-management pair (cycle 300) use `exit 64` for unknown flags.

§the-named-`case ${1:-} in`-named-flag-parsing-shape: `${1:-}` provides a default-empty if `$1` IS unset (so `set -u` doesn't crash); `''` explicit case for no-flag (the common path); `*)` catch-all for unknown flags. **§the-named-four-case-flag-parsing** (two flags + empty + catch-all).

§the-named-`exit 64`-IS-named-fail-loud-on-unknown-input: a typo IS NOT silently ignored.

- **§the-named-three-flag-tristate-mode** (first-explicit-observation): start.sh accepts `(default) | --enable-only | --start-only` — three modes from one binary by combining two boolean flags (ENABLE + START). **§the-named-flag-product-collapsed-to-tristate**.

§the-named-default-favors-the-common-case: the default does `enable + start`, the most common pre-boot setup. **§the-named-common-case-IS-named-the-flag-less-default**.

§the-named-`--enable-only`-IS-named-pre-boot-setup: enables the units but doesn't start them; useful when staging units before the next boot. **§the-named-`--start-only`-IS-named-already-enabled-just-relaunch**: starts the units without re-enabling; useful when units are already enabled at boot.

- **§the-named-default-stop-leaves-enabled** (first-explicit-observation): stop.sh's default behavior IS to stop the units BUT leave them enabled (so next host boot brings them back). **§the-named-`--disable-too`-named-explicit-opt-in-for-disable**: only when explicitly requested does stop disable the units.

§the-named-default-stop-IS-temporary: "stop now, restart on reboot" IS the named default. **§the-named-asymmetric-defaults-between-start-and-stop**: start defaults to "enable + start" (fully activate); stop defaults to "stop only" (temporary deactivation). **§the-named-asymmetric-default-IS-the-named-safer-shape** — accidental stop doesn't permanently disable; accidental start doesn't have a comparable risk because start IS idempotent.

- **§the-named-empty-array-guard** (first-explicit-observation):

```bash
all_units=("${driver_units[@]}" "${watcher_units[@]}")
if [ "${#all_units[@]}" -eq 0 ]; then
  echo "start: config has no lanes or feeds; nothing to do" >&2
  exit 0
fi
```

**§the-named-zero-IS-a-special-case-in-bash-arrays**: the script explicitly checks for empty array (no lanes + no feeds) and exits 0 with a helpful message. **§the-named-empty-IS-not-an-error-IS-just-nothing-to-do**.

§the-named-`${#all_units[@]}`-IS-named-array-length-syntax: bash's array-length expansion.

§the-named-empty-array-handling-distinct-from-missing-config: missing config = "config.sh not found"; empty config = "config has no lanes or feeds". **§the-named-distinct-empty-states-distinct-messages**.

- **§the-named-`+=` array-append-discipline** (first-explicit-observation):

```bash
driver_units+=("garden-driver@${lane}.service")
```

**§the-named-`+=`-IS-named-array-append-operator**: extends a bash array; same operator works on strings (string concatenation). **§the-named-bash-`+=`-polymorphic-on-type**.

§the-named-two-phase-array-build: first append into per-kind arrays (driver_units + watcher_units); then concatenate via `("${driver_units[@]}" "${watcher_units[@]}")`. **§the-named-build-then-concatenate-shape**.

- **§the-named-`(s)` pluralization-handles-zero-and-many-uniformly** (first-explicit-observation):

```bash
echo "start: enabling ${#all_units[@]} unit(s)"
```

**§the-named-`(s)`-suffix-IS-the-named-poor-mans-plural**: the `(s)` reads correctly for both "1 unit(s)" and "5 unit(s)" — not as elegant as proper pluralization but trivially correct for all counts. **§the-named-pragmatic-i18n**.

- **§the-named-prefix-discipline-on-every-stderr-line** (first-explicit-observation): every `echo ... >&2` line in start.sh starts with `"start:"`; every one in stop.sh starts with `"stop:"`. **§the-named-script-name-prefix-IS-named-message-attribution**: when scripts are piped together or run from systemd, the prefix tells the reader which script emitted the line.

§the-named-prefix-discipline-IS-named-readable-logs: `journalctl --user -u garden-driver@1.service` shows all the lines; the prefix tells you which sub-script produced each.

- **§the-named-`echo "start: done"`-final-success-marker-on-stdout** (first-explicit-observation): the final line of start.sh (and stop.sh) IS `echo "start: done"` (resp. `"stop: done"`) — on stdout, not stderr. **§the-named-success-marker-IS-stdout**: distinct from the named informational-messages on stderr.

§the-named-distinct-stdout-vs-stderr-discipline-extends-from-cycle-298: cycle 298's dispatch-prepare uses stdout for its named-return-value (the dispatch root path); cycle 300's start uses stdout for its named-success-marker. **§two-cycles-with-named-distinct-uses-of-stdout-and-stderr** (298 return-value-on-stdout-errors-on-stderr; 300 success-marker-on-stdout-informational-on-stderr).

- **§the-named-`shellcheck disable=SC2034`-WITH-named-justification** (first-explicit-observation):

```bash
# shellcheck disable=SC2034  # consumed by scripts/daemons/{start,stop,status}.sh after sourcing
GARDEN_DRIVER_LANES=(1 2)
```

**§the-named-shellcheck-suppression-WITH-justification**: SC2034 IS the "variable defined but not used" check; the variable IS used — but in the *parent script* that sources this file, not in this file itself. The comment NAMES the consumer paths. **§the-named-shellcheck-suppression-IS-self-documenting**.

§three-named-rules-for-named-justified-shellcheck-suppression: (1) name the rule code (SC2034); (2) name the reason (consumed by the listed scripts after sourcing); (3) named-narrow-suppression (line-local, not file-wide; suppresses only the next variable assignment).

§the-named-shellcheck-stance-IS-cycle-distinct: **§two-cycles-with-distinct-shellcheck-stances** (298 named-no-shellcheck-suppressions + 300 named-justified-shellcheck-suppressions). The distinction reflects context: cycle 298's scripts have no "false positives" worth suppressing; cycle 300's config legitimately defines variables consumed elsewhere.

- **§the-named-tolerated-failure-via-`|| true`** (first-explicit-observation):

```bash
systemctl --user stop "${all_units[@]}" || true
```

**§the-named-`stop || true`-IS-named-idempotent-stop**: stopping an already-stopped unit returns non-zero; `|| true` tolerates that. **§the-named-stop-IS-idempotent-via-tolerance**.

§two-cycles-with-named-`|| true`-tolerated-failure (298 + 300): cycle 298 uses `|| true` on roll-back-on-failure cleanup; cycle 300 uses it on stop-an-already-stopped-unit. **§the-named-`|| true`-IS-the-named-idempotency-tool**.

- **§the-named-export-`GARDEN_ROOT`-for-downstream-wrappers** (first-explicit-observation):

```bash
GARDEN_ROOT=$(cd "$SCRIPT_DIR/.." && pwd)
export GARDEN_ROOT
```

The comment names the purpose: "GARDEN_ROOT is exported for downstream wrappers that may consult it; the daemons scripts themselves only need SCRIPT_DIR." **§the-named-export-with-named-rationale**.

§the-named-context-propagation-via-environment-variable: child processes inherit GARDEN_ROOT. **§the-named-environment-as-context-channel**.

§the-named-`SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)`-extends-from-cycle-298: cycle 298 used `GARDEN_ROOT="$(cd "$(dirname "$0")/.." && pwd)"`; cycle 300 splits into `SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"` then `GARDEN_ROOT=$(cd "$SCRIPT_DIR/.." && pwd)`. **§two-named-script-location-discovery-shapes**: collapsed (298) vs decomposed (300). **§the-named-decomposition-of-script-location-discovery** lets the script use SCRIPT_DIR for nearby files (like config.sh) and GARDEN_ROOT for cross-tree references.

- **§the-named-config.sh.example-IS-the-named-self-documenting-template** (first-explicit-observation): the .example file IS NOT empty boilerplate; it has comments explaining what each variable IS, how systemd instance units relate, the constraint that "Two drivers on the same host must use different lane numbers", and the constraint that "Each feed slug must match a directory under scripts/watcher/<feed>/". **§the-named-template-IS-the-named-documentation**.

§the-named-comments-name-the-constraints: "Two drivers on the same host must use different lane numbers" — names an invariant the template can't enforce mechanically but the operator must respect. **§the-named-constraint-comment-IS-the-named-invariant-marker**.

§the-named-default-values-in-the-template-IS-named-pedagogical: `GARDEN_DRIVER_LANES=(1 2)` shows two lanes (the common case); `GARDEN_WATCHER_FEEDS=(endo-but-for-bots)` shows one feed (matches the only safe-to-monitor feed as of 2026-05-13, per cycle 299's named-monitoring-safety-constraint). **§the-named-template-defaults-IS-the-named-tutorial**.

- **§the-named-top-of-file-docstring-extends-from-cycle-298** (first-explicit-observation; **two-cycles-with-named-top-of-file-docstring**):

```bash
#!/bin/bash
# start.sh -- enable and start the configured set of driver lanes and
# per-feed watchers via systemd's user manager.
#
# Reads host-local config from scripts/daemons/config.sh (gitignored;
# copy from config.sh.example). Falls back to an empty configuration
# if config.sh is missing; the script then no-ops with a helpful
# message rather than touching systemd.
#
# Usage:
#   scripts/daemons/start.sh [--enable-only|--start-only]
```

**§the-named-docstring-with-named-sections**: purpose + behavior + usage. **§the-named-bash-shebang-line-IS-named-explicit-interpreter** (`#!/bin/bash` vs `#!/usr/bin/env bash` — the script chooses the more direct `#!/bin/bash`).

§the-named-comments-explain-WHY-not-just-WHAT: "Falls back to an empty configuration if config.sh is missing; the script then no-ops with a helpful message rather than touching systemd." — explains the deliberate fallback rather than just describing it.

- **§the-named-Usage-line-format** (first-explicit-observation): `scripts/daemons/start.sh [--enable-only|--start-only]` — square brackets for optional + pipe for alternatives. **§the-named-Usage-line-IS-named-microformat** following Unix conventions.

§two-cycles-with-named-Usage-line (298 dispatch-prepare's `usage: $0 <role> <purpose-slug> [<owner>/<repo> <branch>]` + 300 start's `usage: scripts/daemons/start.sh [--enable-only|--start-only]`).

- **§the-named-cycle-300-IS-the-named-three-hundredth-cycle-milestone** (first-explicit-observation): the librarian work has accumulated 300 cycles of one-source-per-cycle ingest, alternating designs-lane and chat-lane. **§the-named-cadence-IS-the-named-library-shape**: cycle count IS not arbitrary; it directly indexes the library's growth.

§the-named-multi-cycle-pattern-accumulation: the cycle-300 mark unlocks **§five-cycles-with-garden-repo-source-ingest** (281 designs/driver.md + 297 WORKTREES.md + 298 scripts pair + 299 CLAUDE.md + 300 daemons triple), which IS now the largest single-repo cluster in the library.

§the-named-five-named-shapes-of-garden-self-documentation: proposed-design (281) + standing-reference (297) + implementation-source (298) + project-instructions (299) + operational-daemon-control (300). **§the-named-coverage-IS-the-named-five-shape-set**.

## Cross-cycle pattern accumulation

- **§five-cycles-with-garden-repo-source-ingest**: 281 + 297 + 298 + 299 + 300.
- **§five-named-shapes-of-garden-self-documentation**: proposed-design + standing-reference + implementation-source + project-instructions + operational-daemon-control.
- **§two-cycles-with-named-script-pair-shape**: 298 prepare/teardown + 300 start/stop.
- **§two-cycles-with-`exit 64`-for-usage-errors**: 298 + 300.
- **§two-cycles-with-named-top-of-file-docstring**: 298 + 300.
- **§two-cycles-with-named-Usage-line-microformat**: 298 + 300.
- **§two-cycles-with-distinct-shellcheck-stances**: 298 no-suppressions + 300 justified-suppressions.
- **§two-cycles-with-named-`|| true`-tolerated-failure**: 298 + 300.
- **§two-cycles-with-named-distinct-uses-of-stdout-and-stderr**: 298 return-value-on-stdout + 300 success-marker-on-stdout.
- **§two-cycles-with-named-actionable-error-messages**: 298 + 300.
- **§two-named-bash-strictness-shapes-in-the-garden-scripts**: 298 `set -euo pipefail` + 300 `set -uo pipefail`.
- **§the-named-multi-cycle-bridge** (5-cycle): 296 (cluster bridge end) + 297 (WORKTREES.md) + 298 (scripts) + 299 (CLAUDE.md) + 300 (daemons) — design names contract, implementation realizes it, over five cycles.

## Notes

- Cycle 300 IS the **three-hundredth** cycle of the librarian's one-source-per-cycle cadence. The chat-lane / designs-lane alternation continues unbroken (designs cycle 299; chat cycle 300; the next cycle 301 IS designs-lane).
- The five-cycle garden-meta cluster (281+297+298+299+300) IS now the library's largest single-repo cluster.
- Three of the five garden ingests are now source files (298 dispatch-prepare/teardown; 300 daemons start/stop/config); two are designs/standing-reference docs (281 designs/driver.md; 297 WORKTREES.md); one IS project instructions (299 CLAUDE.md). **§the-named-five-into-three-source-and-two-document-and-one-instructions split**.
- The named-deliberate-`set -uo pipefail`-WITHOUT-`-e` choice (cycle 300) IS the second deliberate bash-strictness stance surfaced in the library; cycle 298 named `set -euo pipefail` as the first shape; cycle 300 names `set -uo pipefail` as the deliberate alternative. The two together form **§the-named-bash-strictness-discipline-IS-context-determined-not-universal**.
- The named-host-local-gitignored-config + checked-in-`.example` template-pair IS a pattern that recurs across many projects but IS named explicitly here for the first time in the library.
- The named-shellcheck-suppression-WITH-justification IS a deliberate methodological choice that contrasts with cycle 298's named-no-shellcheck-suppressions; both are valid stances, cycle-context-determined.
