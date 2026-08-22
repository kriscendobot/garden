#!/bin/bash
# Shared Codex provider primitives for autonomous handlers.  The cleric and the
# foreman deliberately use the same authentication, local-endpoint and reasoning
# configuration so the provider choices do not grow incompatible command paths.

# shellcheck shell=bash

: "${GARDEN_LOCAL_OLLAMA_URL:=http://127.0.0.1:11435/v1}"

# Seconds to poll a just-(re)started local endpoint for readiness before giving up.
: "${GARDEN_OLLAMA_HEAL_TIMEOUT:=30}"

# codex_local_endpoint_responds — one bounded HTTP probe of the local /v1/models
# endpoint. A response alone is not readiness because Ollama returns HTTP 200 with an
# empty model list for an empty store.
codex_local_endpoint_responds() {
  curl -fsS --max-time 5 "$GARDEN_LOCAL_OLLAMA_URL/models" >/dev/null 2>&1
}

# codex_local_model_present <model> -- confirm that the OpenAI-compatible local
# endpoint actually serves the requested model. A reachable Ollama with an empty
# model store still returns HTTP 200 for /v1/models, so endpoint liveness alone is
# not sufficient to dispatch a local Codex run. An unqualified request also accepts
# Ollama's canonical `:latest` spelling applies only to an unqualified model name.
# The local default is already the exact served tag, `qwen3.6`.
codex_local_model_present() {
  local model="${1:?model}" models
  models="$(curl -fsS --max-time 5 "$GARDEN_LOCAL_OLLAMA_URL/models")" || return 1
  command -v jq >/dev/null 2>&1 || return 1
  jq -e --arg model "$model" '
    (.data | type == "array") and
    any(.data[]?; .id == $model or
      (($model | contains(":") | not) and .id == ($model + ":latest")))
  ' <<<"$models" >/dev/null
}

# codex_local_endpoint_ready <model> — readiness for a pinned local worker means its
# requested model is present, not merely that an HTTP listener returned 200.
codex_local_endpoint_ready() {
  codex_local_model_present "${1:?model}"
}

# codex_unit_active <scope-flag|""> <unit> — read-only "is this unit running?".  Bounded
# so a wedged systemd/dbus cannot hang a preflight, and silent about its verdict except
# through the exit status.  It NEVER starts, enables or disables anything.
codex_unit_active() {
  local scope="$1" unit="${2:?unit}"
  command -v systemctl >/dev/null 2>&1 || return 1
  if [ -n "$scope" ]; then
    timeout 5 systemctl "$scope" is-active --quiet "$unit" >/dev/null 2>&1
  else
    timeout 5 systemctl is-active --quiet "$unit" >/dev/null 2>&1
  fi
}

# codex_local_endpoint_unit_hint — name the unit an operator should ACTUALLY inspect on
# THIS host.  The garden unit (garden-ollama.service, port :11435) and the installer's
# system unit (ollama.service, port :11434) serve DIFFERENT ports, so they no longer
# race for the same bind address.  The hint exists for the transition window in which
# either unit may be the one the operator needs to inspect:
#
#   * garden-ollama.service — the garden's supervised `systemctl --user` unit on
#     :11435.  It is hermit-count-gated (install-units.sh reconcile_ollama_unit enables
#     it only where `hermits: N>0`), so on a zero-hermit host it is
#     installed-but-DISABLED.
#   * ollama.service — the Ollama installer's SYSTEM unit on :11434, running as the
#     `ollama` user.  The Dockerfile stopped enabling it (2026-07-28, "make garden
#     Ollama the sole endpoint owner"), but a container built from any earlier image
#     still has it enabled and holding :11434.  Observed live on endolin-garden2
#     (hermits: 0, garden-ollama disabled, system ollama.service active).
#
# The probe is read-only; deciding which unit SHOULD own the port is an operator call,
# not something a preflight may act on.
codex_local_endpoint_unit_hint() {
  local garden=0 system=0
  codex_unit_active --user garden-ollama.service && garden=1
  codex_unit_active '' ollama.service && system=1
  if [ "$garden" = 1 ] && [ "$system" = 1 ]; then
    printf 'Both local-inference units are running: the garden-supervised `systemctl --user status garden-ollama.service` (port :11435) and the installer system unit `systemctl status ollama.service` (port :11434). They serve different ports, so neither is looping on address-in-use; the garden endpoint is at $GARDEN_LOCAL_OLLAMA_URL.'
  elif [ "$system" = 1 ]; then
    printf 'The installer SYSTEM unit is running on :11434: check `systemctl status ollama.service` (runs as the `ollama` user, so root manages it). The garden endpoint `garden-ollama.service` (port :11435) is `--user`-scoped and hermit-count-gated (`hermits: N>0`), so it is disabled here. The hermit handler dispatches to $GARDEN_LOCAL_OLLAMA_URL, not the system unit.'
  elif [ "$garden" = 1 ]; then
    printf 'The live garden endpoint is the garden-supervised unit on :11435: check `systemctl --user status garden-ollama.service` and `journalctl --user -u garden-ollama.service`.'
  else
    printf 'No local-inference unit is running: neither `systemctl --user status garden-ollama.service` (the garden-supervised one on :11435, enabled only where `hermits: N>0`) nor `systemctl status ollama.service` (the installer system unit on :11434, run as the `ollama` user) is active. Bring up the garden unit for hermit workers.'
  fi
}

# codex_local_self_heal <kind> <base> — recover an unreachable local endpoint: start
# the supervised garden-ollama.service (Restart=always covers a crash BETWEEN jobs;
# this covers "the endpoint was already down when a hermit job started", plus a
# first-ever start), then poll /v1/models for the pinned model. Returns 0 as soon as
# the model is present, 1 if it remains unavailable after GARDEN_OLLAMA_HEAL_TIMEOUT.
# Only the garden's `--user` unit is startable from here: the installer's system
# ollama.service needs root, and if THAT unit is the one holding the port this start
# fails on address-in-use — which is why the give-up diagnostic below appends the
# host-accurate unit hint rather than repeating one unit name.
codex_local_self_heal() {
  local kind="${1:?kind}" base="${2:?base}" model="${3:?model}" waited=0
  log "local inference endpoint $GARDEN_LOCAL_OLLAMA_URL does not serve '$model' for $kind '$base'; starting the garden-supervised garden-ollama.service and polling ~${GARDEN_OLLAMA_HEAL_TIMEOUT}s for the pinned model"
  systemctl --user start garden-ollama.service >/dev/null 2>&1 || true
  while [ "$waited" -lt "$GARDEN_OLLAMA_HEAL_TIMEOUT" ]; do
    if codex_local_endpoint_ready "$model"; then
      log "local inference endpoint recovered after ~${waited}s of self-heal with '$model'"
      return 0
    fi
    sleep 1; waited=$((waited + 1))
  done
  return 1
}

# codex_provider_preflight <provider> <kind> <base> <state-namespace> [self_heal] [model]
#
# A backend outage must read as a HOST defect, not a job defect. For a paid provider
# this stays a once-per-boot auth check (a codex login probe is comparatively
# expensive and its result is stable for the boot). For the LOCAL provider it is
# instead a PER-JOB liveness check: the once-per-boot marker is NOT used, because a
# mid-life Ollama crash must re-trigger recovery on the very next hermit job rather
# than being masked by a stale "auth-ok" marker for the rest of the boot (the per-boot
# gap this change closes).
#
# self_heal (5th arg, "1" to enable) controls what happens when the local endpoint is
# down. A HERMIT worker (cleric-codex.sh) sets it: the tick is PINNED local with no
# fallback, so the preflight (re)starts garden-ollama.service and polls before dying —
# the host-defect diagnostic only after recovery fails, and the hourly press cadence
# retries next tick (no paid fallback: a model: qwen3.6 job stays local). The FOREMAN
# leaves it off: it probes local only to decide provider order and has other providers
# to fall through to, so an unreachable endpoint must advance immediately, not block
# on a 30s heal it does not need.
codex_provider_preflight() {
  local provider="${1:?provider}" kind="${2:?kind}" base="${3:?base}" state_ns="${4:?state namespace}" self_heal="${5:-0}" model="${6:-}"
  command -v codex >/dev/null 2>&1 || {
    printf 'codex not on PATH; cannot run %s handler for %q\n' "$kind" "$base" >&2
    return 1
  }

  if [ "$provider" = local ]; then
    # PER-JOB liveness (NOT the per-boot marker): probe now; self-heal only if the
    # caller requested it (a pinned hermit tick), else fail through for the caller
    # (the foreman) to try the next provider.
    if codex_local_endpoint_ready "$model"; then return 0; fi
    if [ "$self_heal" = 1 ] && codex_local_self_heal "$kind" "$base" "$model"; then return 0; fi
    if codex_local_endpoint_responds; then
      # The store that matters is the one owned by the daemon holding the port — a model
      # sitting in another user's ~/.ollama is invisible to the endpoint (the bot's store
      # held qwen3.6 while the `ollama`-user system unit served an empty list, 2026-07-28).
      # `ollama pull` is a CLIENT call against $OLLAMA_HOST, so pulling against the LIVE
      # endpoint lands the model in the right store whichever unit owns it.
      local msg
      msg="local inference endpoint $GARDEN_LOCAL_OLLAMA_URL serves no $model; $kind cannot run '$base'. Run \`ollama pull $model\` against this endpoint (a client call, so it lands in the serving daemon's own store — a copy in another user's store is invisible here). $(codex_local_endpoint_unit_hint)"
      alert_maintainer "ollama-model-less-endpoint-${GARDEN}" "$msg"
      printf '%s\n' "$msg" >&2
      return 1
    fi
    printf 'local inference endpoint %s not reachable%s; %s cannot run %q. %s Also confirm ollama is on PATH and the serving user has GPU group access — context/operations/local-inference-amd.md.\n' \
      "$GARDEN_LOCAL_OLLAMA_URL" \
      "$([ "$self_heal" = 1 ] && printf ' and self-heal (start garden-ollama.service + %ss poll) failed' "$GARDEN_OLLAMA_HEAL_TIMEOUT")" \
      "$kind" "$base" "$(codex_local_endpoint_unit_hint)" >&2
    return 1
  fi

  if [ "$provider" = fireworks ]; then
    fireworks_provider_preflight "$kind" "$base"
    return
  fi

  if [ "$provider" = openrouter ]; then
    openrouter_provider_preflight "$kind" "$base"
    return
  fi

  # GARDEN_PROBE_LIVE=1 (the scaler's backend probe) needs the OPPOSITE of the hot
  # job path: a LIVE re-check every tick so it can ramp DOWN on a mid-boot logout.
  # It skips both reading and writing the per-boot auth-ok marker (the marker stays
  # for the hot path). See designs/gnome-backend-verified-autotune.md § 1.
  local live="${GARDEN_PROBE_LIVE:-0}"
  local auth_boot auth_marker
  auth_boot="$(tr -dc 'a-f0-9' < /proc/sys/kernel/random/boot_id 2>/dev/null || true)"
  auth_marker="$GARDEN_STATE/$state_ns/auth-ok-${auth_boot:-noboot}"
  [ "$live" != 1 ] && [ -e "$auth_marker" ] && return 0

  if ! codex login status >/dev/null 2>&1; then
    printf 'codex is not authenticated on this host; %s cannot run %q. Run codex login as the bot user.\n' \
      "$kind" "$base" >&2
    return 1
  fi

  if [ "$live" != 1 ]; then
    mkdir -p "$(dirname "$auth_marker")" 2>/dev/null || true
    : > "$auth_marker" 2>/dev/null || true
  fi
}

# openai_compat_provider_preflight <provider-label> <key-var> <base-url> <kind> <base>
# The provider-generic reachability + auth check shared by every separately
# credentialed OpenAI-compatible custom provider (Fireworks, OpenRouter).  Probe only
# `/models`, discard its body, and print status-free diagnostics so neither the bearer
# key nor provider response text can reach a journal/report/log.  A 429 is an
# adaptive-capacity/quota result (retryable); a 503 is load shedding (retryable);
# auth/configuration statuses are not retried.  The `<key-var>: absent` wording is
# preserved exactly (tests assert it), with the variable name substituted per provider.
openai_compat_provider_preflight() { # <label> <key-var> <base-url> <kind> <base>
  local label="${1:?label}" key_var="${2:?key var}" base_url="${3:?base url}" kind="${4:?kind}" base="${5:?base}" status rc key
  command -v codex >/dev/null 2>&1 || { printf 'codex not on PATH; cannot run %s handler for %q\n' "$kind" "$base" >&2; return 1; }
  key="${!key_var:-}"
  [ -n "$key" ] || { printf '%s: absent; %s cannot run %q. Recreate the container with the key in its creation environment.\n' "$key_var" "$kind" "$base" >&2; return 1; }
  set +e
  status="$(curl -sS -o /dev/null -w '%{http_code}' --connect-timeout 5 --max-time 15 \
    -H "Authorization: Bearer $key" "$base_url/models" 2>/dev/null)"
  rc=$?
  set -e
  if [ "$rc" -ne 0 ]; then
    printf '%s availability check failed for %s %q (network/endpoint unavailable); retry later.\n' "$label" "$kind" "$base" >&2
    return 1
  fi
  case "$status" in
    2*) return 0 ;;
    401|403) printf '%s authentication/authorization rejected %s %q; check credential access without printing it.\n' "$label" "$kind" "$base" >&2 ;;
    429) printf '%s adaptive capacity/quota limited %s %q (HTTP 429); retry with exponential backoff.\n' "$label" "$kind" "$base" >&2 ;;
    503) printf '%s load shed %s %q (HTTP 503); retry with exponential backoff.\n' "$label" "$kind" "$base" >&2 ;;
    *) printf '%s availability check returned HTTP %s for %s %q; retry only after endpoint/configuration diagnosis.\n' "$label" "${status:-000}" "$kind" "$base" >&2 ;;
  esac
  return 1
}

# Fireworks is a separately credentialed OpenAI-compatible service.
fireworks_provider_preflight() { # <kind> <base>
  openai_compat_provider_preflight Fireworks FIREWORKS_API_KEY "$GARDEN_FIREWORKS_BASE_URL" "${1:?kind}" "${2:?base}"
}

# OpenRouter is an OpenAI-compatible model-aggregator, credentialed independently of
# Fireworks; it rides the identical reachability/auth shape.
openrouter_provider_preflight() { # <kind> <base>
  openai_compat_provider_preflight OpenRouter OPENROUTER_API_KEY "$GARDEN_OPENROUTER_BASE_URL" "${1:?kind}" "${2:?base}"
}

# openai_compat_retryable_failure <capture> -- diagnostics-only classifier for the
# custom OpenAI-compatible providers.  Codex hides the upstream status in some
# releases, so retain both status and familiar provider wording.  It never prints the
# capture; callers log only this class.
openai_compat_retryable_failure() {
  local capture="${1:?capture}"
  grep -Eqi '(^|[^0-9])(429|503)([^0-9]|$)|rate.?limit|too many requests|load.?shed|service unavailable|temporar(il)?y unavailable' "$capture" 2>/dev/null
}
# Backward-compatible name kept for the fireworker path and its harness test.
fireworks_retryable_failure() { openai_compat_retryable_failure "$@"; }

# codex_effort_for_model <model> <unified effort>
# Normalize Garden's common effort scale to Codex's model-specific ladder.
codex_effort_for_model() {
  local m="${1:?}" level="${2:-medium}" ladder
  case "$m" in
    gpt-5.6-terra) ladder="low medium high xhigh max ultra" ;;
    gpt-5.6-luna)  ladder="low medium high xhigh max" ;;
    gpt-5.5|gpt-5.4-mini) ladder="low medium high xhigh" ;;
    *)             ladder="low medium high xhigh" ;;
  esac
  case "$level" in minimal) level="low" ;; esac
  local axis="low medium high xhigh max ultra" want_rank=0 r=0 tok best=""
  for tok in $axis; do r=$((r + 1)); [ "$tok" = "$level" ] && want_rank=$r; done
  [ "$want_rank" -eq 0 ] && want_rank=2
  for tok in $ladder; do
    local ar=0 a
    for a in $axis; do ar=$((ar + 1)); [ "$a" = "$tok" ] && break; done
    [ "$ar" -le "$want_rank" ] && best="$tok"
  done
  printf '%s\n' "${best:-medium}"
}

# codex_provider_extra_args <provider>
# Set CODEX_PROVIDER_EXTRA_ARGS to the inline provider settings required by the
# local route. Keeping these settings here makes a foreman attempt identical to
# its corresponding worker kind.
codex_provider_extra_args() {
  local provider="${1:?provider}"
  # shellcheck disable=SC2034 # caller appends this shared array after invoking us
  CODEX_PROVIDER_EXTRA_ARGS=()
  case "$provider" in
    local)
      export OLLAMA_API_KEY="${OLLAMA_API_KEY:-ollama}"
      # shellcheck disable=SC2034 # caller appends this shared array after invoking us
      CODEX_PROVIDER_EXTRA_ARGS=(
        -c "model_provider=local"
        -c "model_providers.local.name=\"local-ollama\""
        -c "model_providers.local.base_url=\"$GARDEN_LOCAL_OLLAMA_URL\""
        -c "model_providers.local.env_key=\"OLLAMA_API_KEY\""
      ) ;;
    fireworks)
      # Codex's OpenAI-compatible custom-provider configuration.  The exact
      # Fireworks model/deployment/Fast-router id comes from the explicit job
      # header, never from this adapter.  Priority is intentionally not asserted
      # here: it is a JSON request field and Codex currently exposes no verified
      # provider-level way to inject it.
      CODEX_PROVIDER_EXTRA_ARGS=(
        -c "model_provider=fireworks"
        -c "model_providers.fireworks.name=\"fireworks\""
        -c "model_providers.fireworks.base_url=\"$GARDEN_FIREWORKS_BASE_URL\""
        -c "model_providers.fireworks.env_key=\"FIREWORKS_API_KEY\""
      ) ;;
    openrouter)
      # OpenRouter's OpenAI-compatible custom-provider configuration.  The exact
      # aggregator model id (including any `:free` suffix) comes from the explicit
      # job header, never from this adapter.  The optional OpenRouter attribution
      # headers (HTTP-Referer / X-Title, used only for its public leaderboard) are
      # deliberately omitted: they are not required for serving and Codex exposes no
      # verified per-request header-injection surface.
      # shellcheck disable=SC2034 # caller appends this shared array after invoking us
      CODEX_PROVIDER_EXTRA_ARGS=(
        -c "model_provider=openrouter"
        -c "model_providers.openrouter.name=\"openrouter\""
        -c "model_providers.openrouter.base_url=\"$GARDEN_OPENROUTER_BASE_URL\""
        -c "model_providers.openrouter.env_key=\"OPENROUTER_API_KEY\""
      ) ;;
  esac
}
