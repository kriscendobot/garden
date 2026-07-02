#!/bin/bash
# repo-watcher.sh — reconcile the per-repo watcher units to the watch sets.
#
# Usage: repo-watcher.sh
#
# Two journal-backed watch sets, reconciled to systemd timer units each tick:
#   repos/         → garden-triager@<slug>         (commit watch; laxer bar)
#   comment-repos/ → garden-comment-watcher@<slug> (PR/issue COMMENT watch)
#                  → garden-ci-watcher@<slug>      (CI-STATUS watch; auto-shepherd)
# The CI-status watcher rides the SAME cleared comment-repos/ set: a repo cleared
# for comment surveillance is also cleared for the by-construction-safe CI-status
# watch (it reads only CI status, feeds no external text to an LLM), so it needs no
# third set and never widens the surveillance surface. See ci-watcher.sh header
# § Monitoring safety. A commit that adds a file is a watch, one that removes it an
# unwatch. This
# service's primary input is therefore the JOURNAL, not the repos themselves.
# Each tick it syncs the journal and reconciles the running timer units to
# exactly match the set. Idempotent.
#
# The two sets are SEPARATE on purpose: the comment watcher feeds untrusted
# external comment text into `claude -p`, so it carries the stricter
# monitoring-safety bar (CLAUDE.md § Monitoring safety constraint). A repo may be
# commit-triaged without being comment-watched; comment-repos/ is only widened
# after maintainer authorization is recorded in a journal `message` (see
# comment-watcher.sh header). Keeping comment-repos/ distinct from repos/ means
# the stricter bar cannot be widened by editing the laxer set.
#
# Unit control is indirected through unit_ctl() (common.sh) so the test harness
# can mock systemctl.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
GARDEN_TAG="repo-watcher"

DIR="${GARDEN_WATCHER_CLONE:-$GARDEN_STATE/repo-watcher/journal}"
ensure_clone "$DIR"
sync_clone "$DIR"

# Where install-units.sh renders the systemd --user unit files. repo-watcher
# derives it identically so it can tell whether a template unit for a given
# prefix has actually been rendered into the user manager (see
# ensure_template_installed below).
DEST="${XDG_CONFIG_HOME:-$HOME/.config}/systemd/user"

# The renderer invoked to self-heal a missing template unit. Indirected (like
# unit_ctl) so a test can point it at a no-op stub and drive the "still absent
# after install" skip branch without a real render.
INSTALL_UNITS="${GARDEN_INSTALL_UNITS:-$GARDEN_ROOT/scripts/jobs/install-units.sh}"

# Whether we have already run install-units.sh install THIS tick. reconcile_set
# is called once per prefix (triager / comment-watcher / ci-watcher); if more
# than one prefix is missing its template, a single install renders them all, so
# the install must run at most once per tick — never on the common no-drift path.
_TEMPLATE_INSTALL_DONE=0

# True (0) when the template service unit for <prefix> (e.g. garden-ci-watcher@)
# is present. The on-disk render in $DEST is authoritative — it is exactly the
# artifact install-units.sh produces and this script's arming targets — with a
# user-manager cross-check so we only conclude "missing" when BOTH the render and
# the manager lack it (a template rendered elsewhere is not re-installed).
template_installed() {
  local prefix="$1"
  [ -e "$DEST/$prefix@.service" ] && return 0
  unit_ctl list-unit-files "$prefix@.service" --no-legend 2>/dev/null \
    | grep -qF "$prefix@.service" && return 0
  return 1
}

# Self-heal template drift: arming an instance timer (`enable --now @<slug>.timer`)
# against a template whose unit file was never rendered into the user manager
# fails with "Unit file ... does not exist" on EVERY tick forever — the every-
# minute WARN spam that drowns real warnings in a `journalctl -p warning` tail.
# This is the live state for garden-ci-watcher@* on a host whose install-units
# was never re-run after the templates shipped (commit 1a9448720). Rather than
# leave "re-run install-units" as a human/agent responsibility, render+reload the
# missing templates from within the reconcile: when <prefix>'s template is absent
# AND at least one instance is wanted, run install-units.sh install ONCE per tick,
# then let the caller proceed to arm. Guarded so the heavy install never runs on
# the no-drift path (template already present → cheap file test, no install).
ensure_template_installed() {
  local prefix="$1"
  template_installed "$prefix" && return 0
  if [ "$_TEMPLATE_INSTALL_DONE" -eq 1 ]; then
    # A prior prefix already triggered the once-per-tick install and this
    # template is STILL absent — its source is genuinely missing from
    # scripts/systemd/, an actionable (rare) condition, not the arming race.
    log "WARN: template $prefix@.service still absent after install-units.sh install this tick"
    return 1
  fi
  _TEMPLATE_INSTALL_DONE=1
  log "template $prefix@.service absent from $DEST; running install-units.sh install to self-heal template drift"
  "$INSTALL_UNITS" install >/dev/null 2>&1 \
    || log "WARN: install-units.sh install failed while self-healing missing $prefix@ template"
  template_installed "$prefix" && return 0
  log "WARN: template $prefix@.service still absent after install-units.sh install"
  return 1
}

# Bounded in-tick retry for a single `enable --now` arm call. A transient
# systemctl / XDG_RUNTIME_DIR hiccup (the user bus momentarily unreachable, a
# daemon-reload still settling) makes the arm fail once; the pre-fix code
# swallowed the underlying rc+stderr into a bare "could not arm" WARN and did not
# retry until the NEXT full tick — a whole cycle with the ci-watcher / comment
# watcher for that slug disarmed (the "#259 rollup unreadable" follow that never
# fired). arm_timer instead captures the systemctl rc and stderr, and retries a
# few times with a short backoff so a one-off hiccup self-heals within the tick;
# only a failure that persists across every attempt WARNs, and it WARNs with the
# rc+stderr so the cause is on the record rather than opaque. Tunable (and driven
# to 0-delay by the test) via GARDEN_ARM_RETRIES / GARDEN_ARM_RETRY_DELAY.
ARM_RETRIES="${GARDEN_ARM_RETRIES:-3}"
ARM_RETRY_DELAY="${GARDEN_ARM_RETRY_DELAY:-2}"
arm_timer() {
  local prefix="$1" slug="$2"
  local unit="$prefix@$slug.timer"
  local attempt=1 rc err
  while :; do
    # 2>&1 >/dev/null: capture the arm's stderr into $err, discard its stdout.
    # `&& return 0` keeps this off set -e's radar on failure AND leaves $? as the
    # failed systemctl's rc (an `if …; then` would reset $? to the if's own 0).
    err="$(unit_ctl enable --now "$unit" 2>&1 >/dev/null)" && return 0
    rc=$?
    if [ "$attempt" -ge "$ARM_RETRIES" ]; then
      log "WARN: could not arm $prefix@$slug after $attempt attempt(s): systemctl rc=$rc: ${err:-<no stderr>}"
      return 1
    fi
    log "arm $prefix@$slug failed (attempt $attempt/$ARM_RETRIES, systemctl rc=$rc: ${err:-<no stderr>}); retrying in ${ARM_RETRY_DELAY}s"
    [ "$ARM_RETRY_DELAY" != 0 ] && sleep "$ARM_RETRY_DELAY"
    attempt=$((attempt + 1))
  done
}

# reconcile_set <journal-subdir> <unit-prefix>
# Arm a "<unit-prefix>@<slug>.timer" for every file under <journal-subdir>/, and
# disarm any armed instance whose file is gone. Idempotent. Echoes a summary.
reconcile_set() {
  local subdir="$1" prefix="$2" slug path inst
  declare -A want=() have=()
  shopt -s nullglob
  for path in "$DIR/$subdir"/*; do
    slug="${path##*/}"
    [ "$slug" = .gitkeep ] && continue
    want["$slug"]=1
  done
  shopt -u nullglob
  while read -r unit _; do
    case "$unit" in
      "$prefix"@*.timer)
        inst="${unit#"$prefix"@}"; inst="${inst%.timer}"
        [ -n "$inst" ] && have["$inst"]=1;;  # skip the bare template
    esac
  done < <(unit_ctl list-unit-files "$prefix@*.timer" --no-legend 2>/dev/null || true)

  # Before arming any instance, make sure the template unit for $prefix is
  # actually rendered into the user manager; otherwise every `enable --now` below
  # fails identically every tick (the WARN-spam this self-heal exists to stop).
  # Only bother when something is wanted — an empty set needs no template. If the
  # template is STILL absent after the once-per-tick self-heal install (its source
  # is genuinely gone from scripts/systemd/), SKIP the arming loop this tick:
  # ensure_template_installed has already logged a single WARN, and arming against
  # an absent template would only loop a per-slug "could not arm" WARN every tick —
  # exactly the spam this self-heal exists to stop. The disarm loop still runs;
  # tearing down a now-unwanted instance never needs the template.
  local can_arm=1
  if [ "${#want[@]}" -gt 0 ]; then
    ensure_template_installed "$prefix" || can_arm=0
  fi

  if [ "$can_arm" -eq 1 ]; then
    for slug in "${!want[@]}"; do
      if [ -z "${have[$slug]:-}" ]; then
        log "watch: arming $prefix@$slug.timer"
        arm_timer "$prefix" "$slug" || true
      fi
    done
  fi
  for slug in "${!have[@]}"; do
    if [ -z "${want[$slug]:-}" ]; then
      log "unwatch: disarming $prefix@$slug.timer"
      unit_ctl disable --now "$prefix@$slug.timer" || log "WARN: could not disarm $prefix@$slug"
    fi
  done
  if [ "$can_arm" -eq 1 ]; then
    log "reconciled $subdir: ${#want[@]} watched, ${#have[@]} previously armed"
  else
    log "reconciled $subdir: template $prefix@ absent — armed 0 of ${#want[@]} wanted, ${#have[@]} previously armed"
  fi
}

# Reload the user manager before arming so the latest @.timer / @.service template
# bodies are loaded. Arming a template instance (`enable --now @<slug>.timer`)
# against a not-yet-loaded service template leaves the timer active but unable to
# resolve its trigger target — it never fires, and a `.timer` restart alone does
# NOT fix it (only a daemon-reload loads the service template). Reloading here,
# before every reconcile, closes that arming race durably. Cheap and idempotent;
# the test's mock-systemctl treats daemon-reload as a no-op.
unit_ctl daemon-reload 2>/dev/null || log "WARN: daemon-reload failed (continuing to reconcile)"

# repos/ → commit triager (laxer bar); comment-repos/ → comment watcher (stricter
# monitoring-safety bar, widened only after journal-recorded maintainer auth) AND
# the CI-status watcher (auto-shepherd on red; rides the same cleared set).
reconcile_set repos         garden-triager
reconcile_set comment-repos garden-comment-watcher
reconcile_set comment-repos garden-ci-watcher
