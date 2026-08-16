#!/bin/bash
# set-workers.sh — declare a host's concurrent count for one worker KIND.
#
# Usage: set-workers.sh <kind> <N> [host]   (the optional host must be this host)
#
# Per-host worker concurrency is garden state, so it lives on the bus: writes the
# journal hosts/<host> file's `<count_key>: N` line for the given kind (gardeners: /
# clerics:). The gardener-scaler service on that host watches for the change and
# reconciles its local pool for THAT kind. Only the host that owns a record may
# write it. A human changing another host's capacity runs this command on that
# host, preventing one host's local action from changing another host's pool.
#
# A host's hosts/<host> file holds an INDEPENDENT count line per kind. This writer
# updates ONLY the named kind's line and PRESERVES every other kind's line — so
# `set-workers.sh cleric 4` never disturbs an existing `gardeners: N`, and a sibling
# kind that was never declared stays undeclared (a no-op for the scaler) rather than
# being written as an explicit 0 (which would scale it to zero).

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
GARDEN_TAG="set-workers"

kind="${1:?usage: set-workers.sh <kind> <N> [host]}"
n="${2:?usage: set-workers.sh <kind> <N> [host]}"
host="${3:-$GARDEN}"
count_key="$(worker_kind_field "$kind" count_key)" || die "unknown worker kind '$kind' (known: $(worker_kinds | paste -sd'|' -))"
# The Anthropic kinds (monk canonical, gardener legacy alias) share the same
# exemptions below — they may be declared before the Claude device-login completes,
# and reaching zero is the same fail-closed-floor concern for both spellings.
kind_provider="$(worker_kind_field "$kind" provider)"
[[ "$n" =~ ^[0-9]+$ ]] || die "count must be a non-negative integer"
[ "$host" = "$GARDEN" ] || die "refusing to write hosts/$host from $GARDEN; a host may set only its own worker counts"

# The fleet generally permits an explicit zero for any kind. The temporary
# endolin Claude-quota route makes one exception safety-sensitive: gardeners may
# reach zero only while this host is routed around the auction and another
# configured, probe-qualified non-Claude class can still claim work.

# Provisioning gate: a fresh gnome may declare a NON-gardener kind's count > 0 only
# once that kind's backend probe passes on this host — so a Claude-only gnome (ps23)
# simply cannot declare clerics/hermits/mystics, instead of standing up pools that
# fail every claim. Gardener is EXEMPT because it may be declared before the Claude
# device-login completes; the runtime effective cap keeps it at 0 until the probe
# passes. Like every other kind, gardener may also be explicitly declared as 0.
# GARDEN_FORCE_DECLARE=1 stages a positive non-gardener declaration ahead of a
# credential; the runtime cap still holds it at effective 0, so the override is safe.
# See designs/gnome-backend-verified-autotune.md § 3.
if [ "$kind_provider" != anthropic ] && [ "$n" -gt 0 ] && [ "${GARDEN_FORCE_DECLARE:-0}" != 1 ]; then
  worker_backend_probe "$kind" \
    || die "refusing to declare $count_key=$n: this host's $kind backend probe failed (missing credentials or software). Provision the backend first, or override with GARDEN_FORCE_DECLARE=1 if you are staging ahead of a credential."
fi

DIR="${GARDEN_PRODUCER_CLONE:-$GARDEN_STATE/producer/journal}"
ensure_clone "$DIR"

for attempt in $(seq 1 50); do
  sync_clone "$DIR"
  mkdir -p "$DIR/hosts"
  f="$DIR/hosts/$host"
  if [ "$kind_provider" = anthropic ] && [ "$n" -eq 0 ]; then
    [ "$(quota_routing_mode)" = race ] \
      || die "refusing $count_key: 0 outside the temporary quota route; retain one Anthropic worker or use drain-fleet.sh to pause work"
    host_has_qualified_non_claude_worker "$f" \
      || die "refusing $count_key: 0; retain at least one configured, probe-qualified non-Claude worker class (or use drain-fleet.sh to pause work)"
  fi
  # Gather each kind's CURRENT declared count from the existing file, override the
  # target kind with N, and rewrite — so a sibling kind's count is preserved and an
  # undeclared sibling stays undeclared (never forced to 0).
  {
    for k in $(worker_kinds); do
      ck="$(worker_kind_field "$k" count_key)"
      if [ "$k" = "$kind" ]; then
        printf '%s: %s\n' "$ck" "$n"
      else
        cur=""
        if [ -f "$f" ]; then
          cur="$(sed -n "s/^$ck:[[:space:]]*//p" "$f" | head -1)"
        fi
        if [[ "$cur" =~ ^[0-9]+$ ]]; then
          printf '%s: %s\n' "$ck" "$cur"
        fi
      fi
    done
    printf 'updated_at: %s\n' "$(date -u +%FT%TZ)"
    printf 'updated_by: %s\n' "$GARDEN"
  } > "$f.tmp"
  mv "$f.tmp" "$f"
  git -C "$DIR" add "hosts/$host"
  # Capture with `|| rc=$?` (a false `if` with no `else` is exit 0 and would
  # swallow commit_and_push's rc=2 "nothing to commit" on an idempotent re-run).
  rc=0; commit_and_push "$DIR" "hosts($host) $count_key=$n" || rc=$?
  [ "$rc" -eq 0 ] && { log "declared $host $count_key=$n"; exit 0; }
  [ "$rc" -eq 2 ] && { log "$host already at $count_key=$n"; exit 0; }
  log "set-workers lost a push race (attempt $attempt); retrying"
  backoff "$attempt"
done
die "could not declare $count_key for $host after retries"
