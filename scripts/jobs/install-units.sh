#!/bin/bash
# install-units.sh — render and install the garden systemd --user units.
#
# Usage:
#   install-units.sh install                  render+install all unit files, daemon-reload
#   install-units.sh scale <N>                run N gardeners (enable @1..@N, disable the rest)
#   install-units.sh reconcile-identity       restart any running gardener whose GARDEN identity drifted
#   install-units.sh enable-services          enable+start every intended garden timer/service
#   install-units.sh enable-services --verify report any intended unit not currently enabled (drift check)
#   install-units.sh status                   show the garden units and timers
#
# Units are rendered from scripts/systemd/*.{service,timer} with @GARDEN_ROOT@
# substituted, into ~/.config/systemd/user/. Requires a working `systemctl
# --user` (see the design doc for the XDG_RUNTIME_DIR / lingering bootstrap).

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
GARDEN_TAG="install"
systemd_user_env

SRC="$GARDEN_ROOT/scripts/systemd"
DEST="${XDG_CONFIG_HOME:-$HOME/.config}/systemd/user"

# --- enable-set policy -------------------------------------------------------
#
# enable_services derives the units to enable FROM THE UNITS ACTUALLY PRESENT in
# $SRC, not from a hand-maintained list. A hand-maintained list drifts: every
# garden-*.timer added after the list was written (foreman, deadmail, follow-up,
# proxy, mirror-closer, …) was silently NEVER enabled, so the services never ran
# until found dormant by hand (2026-06-26). Deriving from the present units means
# a newly-added timer/service is covered automatically.
#
# Two classes of unit are deliberately EXCLUDED from the auto-enable, by policy:
#
#   1. Template units (garden-*@.{service,timer}) — enabled PER-INSTANCE, never
#      globally: garden-gardener@ (by `scale`), garden-comment-watcher@ /
#      garden-ci-watcher@ (per watched repo, by the repo-watcher from the journal's
#      comment-repos/ set) / garden-triager@ (per watched repo, from repos/),
#      garden-watcher@ (per feed). These are
#      excluded structurally by the `@` filter in intended_units, not by name.
#
#   2. Monitoring-gated units that the monitoring-safety constraint (see CLAUDE.md
#      § Monitoring safety constraint) says require EXPLICIT MAINTAINER
#      AUTHORIZATION to arm. garden-mention-watcher watches all of GitHub; arming
#      it must be a deliberate maintainer act, never a side effect of a routine
#      install. It is left for the maintainer to enable by hand. Named below.
EXCLUDED_UNITS=(
  garden-mention-watcher.timer
  garden-mention-watcher.service
)

# Belt-and-suspenders list of unit names that must NEVER come back, even if a
# stray source file reappears under $SRC. This is NOT the primary retirement
# mechanism — prune_retired (below) self-reconciles by removing ANY installed
# garden-* unit whose source no longer exists in $SRC, so deleting a unit from
# scripts/systemd/ is sufficient to retire it; no name needs to be listed here.
# Keep an entry ONLY for a name that should stay dead regardless of $SRC (a unit
# we want pruned even if someone re-adds its source by mistake). The historical
# retirees — the bulletin's old oneshot timer (migrated to a long-running
# Restart= service) and garden-deploy-sync (the continuous fast-forward + restart
# reconciler, replaced by the deliberate drained deploy-garden.sh,
# designs/deliberate-deploy.md) — no longer ship a source, so prune_retired
# already removes them; they need no entry and the list is now empty by default.
RETIRED_UNITS=(
)

is_excluded() {
  local u="$1" e
  for e in "${EXCLUDED_UNITS[@]}"; do [ "$u" = "$e" ] && return 0; done
  return 1
}

# Derive the set of units this host should enable from the units present in $SRC.
# One unit name per line. Rules:
#   * Skip template units (basename contains '@') — enabled per-instance.
#   * Skip explicitly-excluded units (monitoring-gated).
#   * A non-template *.timer carrying `WantedBy=timers.target` → enable the TIMER
#     (its [Timer] drives the paired oneshot service).
#   * A non-template *.service is enabled DIRECTLY only when it has NO sibling
#     *.timer (a timer-paired service is started BY its timer, so we enable the
#     timer, not the service) AND it declares an [Install] WantedBy= — i.e. it is
#     a standalone long-running service (the bulletin, the design-poller).
intended_units() {
  local f b base
  for f in "$SRC"/garden-*.timer "$SRC"/garden-*.service; do
    [ -e "$f" ] || continue
    b="$(basename "$f")"
    case "$b" in *@*) continue;; esac          # template → enabled per-instance
    is_excluded "$b" && continue
    case "$b" in
      *.timer)
        grep -q '^WantedBy=timers\.target' "$f" && printf '%s\n' "$b"
        ;;
      *.service)
        base="${b%.service}"
        [ -e "$SRC/$base.timer" ] && continue   # timer-driven oneshot → its timer is enabled instead
        grep -q '^WantedBy=' "$f" && printf '%s\n' "$b"
        ;;
    esac
  done
}

# Self-reconciling retirement. Enumerate the garden-* unit files actually
# installed in $DEST and stop+disable+rm any whose source no longer exists under
# $SRC, then daemon-reload. This is the deterministic replacement for a
# hand-maintained by-name retired list: DELETING a unit from scripts/systemd/ is
# now sufficient to retire it. A stale-enabled unit on an already-deployed host
# (the garden-deploy-sync crash loop, 2026-06-27) is removed automatically on the
# next install/enable, instead of crash-looping until a human notices and an
# agent appends its name.
#
# Skips, by the SAME rules intended_units uses:
#   * template files/instances (basename contains '@'): a template's source IS
#     the @.service/@.timer file, and an enabled instance (garden-gardener@7) has
#     no own source — neither must be pruned.
#   * EXCLUDED_UNITS (monitoring-gated): these ship a source under $SRC anyway, so
#     the source check already keeps them; the skip is belt-and-suspenders.
# A unit named in RETIRED_UNITS is pruned UNCONDITIONALLY (even if a stray source
# reappears) — the explicit never-come-back list.
prune_retired() {
  local f b pruned=() u
  # Belt-and-suspenders: names that must stay dead regardless of $SRC.
  for u in "${RETIRED_UNITS[@]}"; do
    if [ -e "$DEST/$u" ] || [ "$(unit_ctl is-enabled "$u" 2>/dev/null || true)" = enabled ]; then
      unit_ctl disable --now "$u" 2>/dev/null || true
      rm -f "$DEST/$u"
      pruned+=("$u")
    fi
  done
  # Self-reconcile: any installed garden-* unit with no source in $SRC is retired.
  for f in "$DEST"/garden-*.service "$DEST"/garden-*.timer; do
    [ -e "$f" ] || continue
    b="$(basename "$f")"
    case "$b" in *@*) continue;; esac          # template file/instance → never pruned
    is_excluded "$b" && continue
    [ -e "$SRC/$b" ] && continue                # still has a source → keep
    case " ${pruned[*]} " in *" $b "*) continue;; esac   # already pruned above
    unit_ctl disable --now "$b" 2>/dev/null || true
    rm -f "$DEST/$b"
    pruned+=("$b")
  done
  unit_ctl daemon-reload
  if [ "${#pruned[@]}" -gt 0 ]; then
    log "pruned ${#pruned[@]} retired unit(s) (no source in $SRC): ${pruned[*]}"
  fi
}

render() {
  mkdir -p "$DEST"
  # Globs every garden-*.{service,timer}, including the instance templates
  # (garden-gardener@, garden-triager@, garden-comment-watcher@,
  # garden-watcher@), which are instance-armed elsewhere (see the enable-set
  # policy above) and so are excluded from enable_services.
  for f in "$SRC"/garden-*.service "$SRC"/garden-*.timer; do
    [ -e "$f" ] || continue
    sed "s#@GARDEN_ROOT@#$GARDEN_ROOT#g" "$f" > "$DEST/$(basename "$f")"
  done
  # Retire any installed unit whose source we just stopped shipping, then reload
  # (prune_retired does its own daemon-reload, so the rendered files and the
  # removals both take effect in one reload).
  prune_retired
  log "installed units into $DEST and reloaded"
}

# Log a per-unit skip. Distinguishes a bounded-timeout kill (124/137 from
# unit_ctl_bounded's `timeout -k`) from any other non-zero rc, so the operator can
# tell a wedged systemctl from a genuine unit failure. Either way the caller
# CONTINUES to the next unit — a later scaler tick retries the skipped one — so no
# single unit operation can stall the whole reconcile past its 900s window.
scale_skip_note() {
  local op="$1" unit="$2" rc="$3"
  if [ "$rc" -eq 124 ] || [ "$rc" -eq 137 ]; then
    log "WARN scale: '$op $unit' exceeded ${GARDEN_UNIT_CTL_TIMEOUT:-5}s and was killed; skipping this unit (a later scaler tick retries it)"
  else
    log "WARN scale: '$op $unit' failed (rc=$rc); skipping this unit (a later scaler tick retries it)"
  fi
}

scale() {
  local n="${1:?usage: install-units.sh scale <N>}"
  # Enable + start each intended gardener, split into the cheap synchronous file op
  # and the slow start job so neither blocks the reconcile loop. `enable` just
  # writes the persistent symlink — it does NOT wait on the unit's start job — so it
  # is unbounded. `start --no-block` enqueues the start job and returns as soon as
  # it is queued rather than blocking until the gardener's `claude -p` drains; over
  # a ~100-unit pool on one busy user manager, blocking `--now` reliably took >5s
  # and every tick SIGKILLed the lot, so the pool never converged. Non-blocking, the
  # call finishes well under the bound; it stays wrapped in unit_ctl_bounded purely
  # as a backstop for a genuinely wedged manager, and on a timeout the unit is
  # skipped and a later tick retries it (the scaler already tolerates a start whose
  # convergence is only observed on a later tick).
  for i in $(seq 1 "$n"); do
    local u="garden-gardener@$i.service" erc=0 rc=0
    unit_ctl enable "$u" || erc=$?
    [ "$erc" -eq 0 ] || scale_skip_note "enable" "$u" "$erc"
    unit_ctl_bounded start --no-block "$u" || rc=$?
    [ "$rc" -eq 0 ] || scale_skip_note "start --no-block" "$u" "$rc"
  done
  # Disable any higher-numbered instances still running. `disable` removes the
  # persistent symlink (cheap, unbounded); `stop --no-block` then enqueues the stop
  # job — a SIGTERM of the worker — and returns at once rather than blocking on it.
  # A SIGTERM of an IDLE extra is fine, but a SIGTERM of a mid-job gardener kills its
  # in-flight `claude -p` handler, which then requeues and burns a full TTL cycle
  # (the observed rc=143 transient-handler outage). So gate on the SAME busy marker
  # deploy-sync.sh gates its restart on (gardener_busy, common.sh): an extra that is
  # mid-job is DEFERRED — left running for now and SKIPPED — and a later scaler tick
  # (the 1-minute garden-gardener-scaler.timer) stops it once it has gone idle, so
  # the worker stops between claims, never mid-call.
  local deferred=0
  while read -r unit _; do
    case "$unit" in
      garden-gardener@*.service)
        idx="${unit#garden-gardener@}"; idx="${idx%.service}"
        [[ "$idx" =~ ^[0-9]+$ ]] || continue
        [ "$idx" -gt "$n" ] || continue
        if gardener_busy "$idx"; then
          log "gardener $idx is mid-job; deferring its stop to a later scaler tick (stops between claims, not mid-job)"
          deferred=$((deferred+1))
        else
          # Cheap disable, then a non-blocking stop bounded only as a wedged-manager
          # backstop; a hung stop is skipped so the loop keeps draining the rest —
          # no single unit stalls the whole pass.
          local drc=0 src=0
          unit_ctl disable "$unit" || drc=$?
          [ "$drc" -eq 0 ] || scale_skip_note "disable" "$unit" "$drc"
          unit_ctl_bounded stop --no-block "$unit" || src=$?
          [ "$src" -eq 0 ] || scale_skip_note "stop --no-block" "$unit" "$src"
        fi
        ;;
    esac
  done < <(unit_ctl_bounded list-units --all 'garden-gardener@*.service' --no-legend 2>/dev/null || true)
  log "scaled gardener pool to $n (deferred $deferred mid-job extra(s) for a later tick)"
}

# reconcile_identity — restart any RUNNING gardener whose in-process GARDEN host
# identity has drifted from this host's authoritative identity ($GARDEN — the
# single canonical per-host knob, which in the stock container is the kernel-fixed
# `hostname -s`). The scaler reconciles pool SIZE by instance index but is blind to
# this: a long-lived garden-gardener@N inherits GARDEN once at spawn, so after a
# host-identity correction (e.g. removing a stale `GARDEN=endolinbot2` override)
# the already-running worker keeps the STALE value, keeps keying phantom
# hosts/<stale> worker-count state, writes journal-index entries under a host that
# should not exist, and evaluates is-main-host against the wrong name — until a
# manual mass `restart garden-gardener@*`. This makes the correction propagate
# deterministically on the next 1-minute scaler tick instead.
#
# The restart is gated on the SAME busy marker the scale-down defers on
# (gardener_busy, common.sh): a mid-job worker is DEFERRED — left running and
# skipped — so a later tick restarts it once idle. Like the scale path, the worker
# thus adopts the corrected identity BETWEEN claims, never mid-`claude -p` (a
# `restart` of a mid-job gardener SIGTERMs the in-flight handler, which requeues
# and burns a TTL cycle — the rc=143 transient-handler outage). The restart is
# issued `--no-block` so it enqueues the restart job and returns at once rather
# than blocking on it — the same >5s-per-call blocking that SIGKILLed the scaler's
# `--now` calls. A worker whose live
# identity cannot be read (not running, or no GARDEN in its environ — i.e. it
# resolved the kernel-fixed hostname default, which cannot drift) is left alone.
reconcile_identity() {
  local want="$GARDEN" idx actual restarted=0 deferred=0
  while read -r unit _; do
    case "$unit" in
      garden-gardener@*.service)
        idx="${unit#garden-gardener@}"; idx="${idx%.service}"
        [[ "$idx" =~ ^[0-9]+$ ]] || continue
        actual="$(gardener_instance_garden "$unit")" || continue  # unreadable/unset → not drifted
        [ "$actual" != "$want" ] || continue                       # identity matches → nothing to do
        if gardener_busy "$idx"; then
          log "gardener $idx identity '$actual' != host '$want' but mid-job; deferring its restart to a later tick (restarts between claims, not mid-job)"
          deferred=$((deferred+1))
        else
          log "gardener $idx identity '$actual' != host '$want'; restarting to adopt the corrected host identity"
          # Non-blocking: `restart --no-block` enqueues the restart job and returns
          # at once rather than blocking until it drains, so it finishes well under
          # the bound. Still wrapped in unit_ctl_bounded as a wedged-manager backstop
          # — a hung enqueue is skipped and the loop continues past this unit.
          local rrc=0
          unit_ctl_bounded restart --no-block "$unit" || rrc=$?
          if [ "$rrc" -eq 0 ]; then
            restarted=$((restarted+1))
          else
            scale_skip_note "restart --no-block" "$unit" "$rrc"
          fi
        fi
        ;;
    esac
  done < <(unit_ctl_bounded list-units --all 'garden-gardener@*.service' --no-legend 2>/dev/null || true)
  log "identity reconcile: restarted $restarted drifted gardener(s), deferred $deferred mid-job for a later tick"
}

enable_services() {
  local u
  # Self-reconciling retirement: stop+disable+rm any installed garden-* unit whose
  # source no longer ships under $SRC (plus the explicit RETIRED_UNITS list), then
  # daemon-reload so systemd forgets it entirely. This is what keeps a stale-enabled
  # retiree from being re-triggered (a stale garden-deploy-sync.timer kept firing
  # its missing deploy-sync.sh into an rc-127 crash loop, 2026-06-27) — and it needs
  # no by-name list: deleting a unit from scripts/systemd/ is sufficient to retire it.
  prune_retired
  # Enable + start every intended (derived) unit, split into the cheap file op and
  # the slow start job so neither blocks (as the scaler does): `enable` writes the
  # persistent symlink without waiting on the start job, and `start --no-block`
  # enqueues the start and returns at once rather than blocking until it drains. The
  # start stays bounded as a backstop: this runs inside deploy-garden's DRAINED
  # window, where a blocking `--now` against a wedged user-manager/dbus used to hang
  # the whole deploy with the fleet stopped (the reason unit_ctl_bounded exists for
  # the scaler). One failure never aborts the loop — a single failing enable under
  # set -e silently skipped every alphabetically-later unit. Enablement is the
  # persistent state drift-verify keys on, so failure keys on the `enable`; a hung
  # `start` only WARNs (the unit stays enabled and a later tick retries its start).
  # Failures are collected and WARN'd; a later reconcile retries them.
  local enabled=() failed_units=()
  while read -r u; do
    [ -n "$u" ] || continue
    if unit_ctl enable "$u"; then
      unit_ctl_bounded start --no-block "$u" \
        || log "WARN: 'start --no-block $u' timed out/failed (rc=$?); its start is enqueued-or-retried, unit stays enabled"
      enabled+=("$u")
    else
      failed_units+=("$u")
    fi
  done < <(intended_units)
  log "enabled (${#enabled[@]}): ${enabled[*]}"
  [ "${#failed_units[@]}" -gt 0 ] && log "WARN: failed/timed out enabling ${#failed_units[@]} unit(s): ${failed_units[*]} (a later enable-services retries them)"
  log "excluded by policy: templates (garden-*@), ${EXCLUDED_UNITS[*]}"
}

# Drift check: report any intended unit that is NOT currently enabled (e.g. a unit
# added since the last enable-services run, or one manually disabled). Echoes the
# deliberately-excluded set for visibility. Exits non-zero when drift is found so a
# watchman/bulletin check can surface it. Idempotent and read-only.
enable_services_verify() {
  local u state drift=0
  while read -r u; do
    [ -n "$u" ] || continue
    state="$(unit_ctl is-enabled "$u" 2>/dev/null || true)"
    if [ "$state" = "enabled" ]; then
      log "ok: $u enabled"
    else
      log "DRIFT: $u is '${state:-unknown}' (expected enabled — run enable-services)"
      drift=1
    fi
  done < <(intended_units)
  log "excluded by policy (NOT expected enabled): templates (garden-*@), ${EXCLUDED_UNITS[*]}"
  if [ "$drift" -ne 0 ]; then
    log "enable-services drift detected"
    return 1
  fi
  log "no drift: every intended garden unit is enabled"
}

status() {
  unit_ctl list-units 'garden-*' --all --no-pager || true
  unit_ctl list-timers 'garden-*' --all --no-pager || true
}

case "${1:-install}" in
  install)         render;;
  scale)           shift; scale "$@";;
  reconcile-identity) reconcile_identity;;
  enable-services)
    shift || true
    case "${1:-}" in
      ""|--now)        enable_services;;
      --verify|verify) enable_services_verify;;
      *) die "usage: install-units.sh enable-services [--verify]";;
    esac;;
  status)          status;;
  *) die "usage: install-units.sh {install|scale <N>|reconcile-identity|enable-services [--verify]|status}";;
esac
