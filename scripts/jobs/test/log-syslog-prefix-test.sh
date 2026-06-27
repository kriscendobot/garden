#!/bin/bash
# log-syslog-prefix-test.sh — regression guard for common.sh's log()/die()
# emitting a systemd syslog-level prefix on the stderr line.
#
# The defect this guards: log()/die() wrote plain stderr with NO `<N>` priority
# prefix, so journald classified every fleet line at the default `info`. A
# `journalctl -p warning` failure-tail capture (the mentor's outage triage) then
# dropped ALL of them — including `die "FATAL: …"` — leaving the captured tail
# with 0 script-level lines and only systemd's generic "exit-code", diagnostically
# blind to the actual cause (the 18:46 fleet outage). The fix prefixes the line
# with `<3>` (err) for FATAL, `<4>` (warning) for a line beginning WARN, and `<6>`
# (info) otherwise, which systemd's SyslogLevelPrefix honors by default — UNLESS
# stderr is a TTY, where the prefix is stripped so interactive runs stay clean.
#
# Usage: log-syslog-prefix-test.sh
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
PASS=0; FAIL=0; SKIP=0
ok()   { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad()  { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
skip() { echo "  SKIP: $*"; SKIP=$((SKIP+1)); }
hr()   { echo "----------------------------------------------------------------"; }

# Scrub fleet env so sourcing common.sh against the live garden is harmless: we
# only call log/die, which touch no journal, but usage-meter.sh is sourced too.
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_)' || true) 2>/dev/null || true

# ============================================================================
hr; echo "NON-TTY — stderr piped: each level carries its <N> prefix"; hr
# Source once and emit the three classes with stderr redirected to a pipe (a file
# here — NOT a TTY), exactly as journald/systemd capture a service's stderr.
out="$(
  GARDEN_TAG=scaler bash -c '
    source "'"$JOBS"'/common.sh"
    log "INFO ordinary line"
    log "WARN something off"
    log "FATAL: hand-rolled fatal"
  ' 2>&1 1>/dev/null
)"
grep -q '^<6>[0-9:]* \[scaler\] INFO ordinary line$'   <<<"$out" && ok "info line prefixed <6>"    || bad "info <6> wrong: $out"
grep -q '^<4>[0-9:]* \[scaler\] WARN something off$'   <<<"$out" && ok "WARN line prefixed <4>"    || bad "warn <4> wrong: $out"
grep -q '^<3>[0-9:]* \[scaler\] FATAL: hand-rolled'    <<<"$out" && ok "FATAL line prefixed <3>"   || bad "fatal <3> wrong: $out"

# die() routes through log("FATAL: …") AND exits 1 — both must hold.
set +e
dout="$(GARDEN_TAG=scaler bash -c 'source "'"$JOBS"'/common.sh"; die "boom"' 2>&1 1>/dev/null)"; drc=$?
set -e
grep -q '^<3>[0-9:]* \[scaler\] FATAL: boom$' <<<"$dout" && ok "die() emits <3> FATAL line" || bad "die line wrong: $dout"
[ "$drc" -eq 1 ] && ok "die() still exits 1" || bad "die() exit code $drc (want 1)"

# ============================================================================
hr; echo "TTY — interactive stderr: the prefix is stripped (clean output)"; hr
if ! command -v script >/dev/null 2>&1; then
  skip "util-linux 'script' not present; cannot allocate a pty to test TTY-strip"
else
  # `script` allocates a pty so `[ -t 2 ]` is true inside; capture what a human sees.
  tout="$(script -qec 'GARDEN_TAG=scaler bash -c '\''source "'"$JOBS"'/common.sh"; log "WARN tty line"; log "FATAL: tty fatal"'\''' /dev/null | tr -d '\r')"
  { grep -q '\[scaler\] WARN tty line' <<<"$tout" && ! grep -q '<4>' <<<"$tout" && ! grep -q '<3>' <<<"$tout"; } \
    && ok "under a TTY no <N> prefix appears (interactive output stays clean)" \
    || bad "TTY output carries a prefix or lost the line: $tout"
fi

hr; echo "RESULT: $PASS passed, $FAIL failed, $SKIP skipped"; hr
[ "$FAIL" -eq 0 ]
