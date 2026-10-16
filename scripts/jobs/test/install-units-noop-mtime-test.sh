#!/bin/bash
# install-units-noop-mtime-test.sh — an install that changes no unit must leave
# the unit directory untouched.
#
# Regression: render_unit_file staged its comparison render in $DEST and deleted
# it when unchanged. That bumped the directory mtime on every deploy, and systemd
# >= 255 then flagged all ~290 garden units NeedDaemonReload=yes ("changed on
# disk") even though the daemon-reload was correctly skipped (oros health log,
# 2026-10-15 and 2026-10-16).
#
# Usage: install-units-noop-mtime-test.sh
set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
INSTALL="$JOBS/install-units.sh"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# Scrub ambient fleet env so the fixture is authoritative.
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN|JOURNAL_|XDG_)' || true) 2>/dev/null || true
export GARDEN_TEST=1

# The mock (GARDEN_UNIT_CTL) is exec'd, and `[ -x ]`/execve fail with EACCES on a
# `noexec` mount (this container's /tmp). Probe candidate bases and take the first
# that actually runs a throwaway script — same pattern as run-test.sh.
tr_base=""
for cand in "${TMPDIR:-}" /var/tmp /tmp "$HOME"; do
  { [ -n "$cand" ] && [ -d "$cand" ] && [ -w "$cand" ]; } || continue
  probe="$(mktemp -d "$cand/.iup-probe.XXXXXX" 2>/dev/null)" || continue
  printf '#!/bin/sh\nexit 0\n' > "$probe/x"; chmod +x "$probe/x" 2>/dev/null || true
  if [ -x "$probe/x" ] && "$probe/x" 2>/dev/null; then rm -rf "$probe"; tr_base="$cand"; break; fi
  rm -rf "$probe"
done
[ -n "$tr_base" ] || tr_base="$HOME"
TD="$(mktemp -d "$tr_base/.iup-test.XXXXXX")"
trap 'rm -rf "$TD"' EXIT

# A GARDEN_UNIT_CTL mock recording every call verbatim, one per line. is-enabled
# returns whatever ISENABLED_<sanitized-unit> says (default: disabled, so no
# retired unit looks armed and the prune never forces a reload).
CTL="$TD/ctl.sh"; LOG="$TD/ctl.log"; : > "$LOG"
cat > "$CTL" <<'EOF'
#!/bin/bash
echo "$*" >> "$GARDEN_UNIT_CTL_LOG"
if [ "$1" = "is-enabled" ]; then
  var="ISENABLED_$(printf '%s' "$2" | tr -c 'A-Za-z0-9' _)"
  printf '%s\n' "${!var:-disabled}"
  [ "${!var:-disabled}" = enabled ] && exit 0 || exit 1
fi
exit 0
EOF
chmod +x "$CTL"
export GARDEN_UNIT_CTL="$CTL" GARDEN_UNIT_CTL_LOG="$LOG"
export XDG_CONFIG_HOME="$TD/cfg"; mkdir -p "$XDG_CONFIG_HOME/systemd/user"

# has_call <regex> — true if the ctl log has a line matching the anchored regex.
has_call() { grep -qE "$1" "$LOG"; }
DEST="$XDG_CONFIG_HOME/systemd/user"
mtime() { stat -c %Y "$1" 2>/dev/null || stat -f %m "$1"; }

# ============================================================================
hr; echo "first install renders units and reloads"; hr
: > "$LOG"
bash "$INSTALL" install >/dev/null 2>&1 || true
ls "$DEST"/garden-*.service >/dev/null 2>&1 && ok "units rendered" || bad "no units rendered"
has_call '^daemon-reload$' && ok "first install reloads" || bad "first install did not daemon-reload"

# ============================================================================
hr; echo "unchanged re-install leaves the unit dir untouched"; hr
touch -d '2001-01-01 00:00:00' "$DEST"
before="$(mtime "$DEST")"
: > "$LOG"
bash "$INSTALL" install >/dev/null 2>&1 || true
after="$(mtime "$DEST")"
[ "$before" = "$after" ] && ok "unit dir mtime unchanged" || bad "unit dir mtime changed ($before -> $after)"
has_call '^daemon-reload$' && bad "no-op install ran daemon-reload" || ok "no-op install skipped daemon-reload"
ls -A "$DEST" | grep -q '^\.garden-unit\.' && bad "stray staging file left in unit dir" || ok "no staging file left in unit dir"

# ============================================================================
hr; echo "a changed unit is rewritten and reloads"; hr
victim="$(ls "$DEST"/garden-*.service | head -1)"
echo "# drift" >> "$victim"
: > "$LOG"
bash "$INSTALL" install >/dev/null 2>&1 || true
grep -q '^# drift$' "$victim" && bad "drifted unit not rewritten" || ok "drifted unit rewritten"
has_call '^daemon-reload$' && ok "changed install reloads" || bad "changed install did not daemon-reload"
[ "$(stat -c %a "$victim" 2>/dev/null || stat -f %Lp "$victim")" = 644 ] && ok "rewritten unit is 0644" || bad "rewritten unit mode is not 0644"

# ============================================================================
hr
echo "install-units-noop-mtime: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
