#!/bin/bash
# ollama-serve.sh — run the supervised local-inference endpoint for hermit workers.
#
# This is the ExecStart of garden-ollama.service, a PER-HOST singleton enabled ONLY
# where `hermits: N>0` is declared (install-units.sh scale hermit N gates it). It
# serves the on-box Ollama OpenAI-compatible /v1 endpoint that the hermit (provider:
# local) codex worker dispatches to (context/operations/local-inference-amd.md § 2
# Path A). Two things it MUST get right, per that doc:
#   * OLLAMA_IGPU_ENABLE=1 — MANDATORY, or Ollama drops the integrated GPU and falls
#     back to CPU (§ 1 iGPU gotcha, § 2 Path A serve line).
#   * OLLAMA_HOST must match GARDEN_LOCAL_OLLAMA_URL's host:port (ollama_serve_host),
#     so the served bind address and the hermit handler's client URL cannot drift.
# GPU device-node group access (/dev/kfd, /dev/dri/renderD128) is granted by the
# container entrypoint BEFORE the user manager starts (§ Container GPU access), so by
# the time systemd starts this unit the bot user is already in video+render.
#
# The unit sets Restart=always, so this wrapper deliberately waits after a failed
# precondition or a short-lived child. That keeps systemd from turning a persistent
# host defect into a five-second journal hot loop. The delay belongs here rather
# than solely in the unit, because Ollama can also exit successfully immediately.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
GARDEN_TAG="ollama-serve"
OLLAMA_RESTART_BACKOFF_SECONDS="${GARDEN_OLLAMA_RESTART_BACKOFF_SECONDS:-60}"
child_pid=""

back_off() {
  local reason="$1"
  log "$reason; waiting ${OLLAMA_RESTART_BACKOFF_SECONDS}s before systemd retries"
  sleep "$OLLAMA_RESTART_BACKOFF_SECONDS"
}

shutdown() {
  local signal="$1" status="$2"
  log "received SIG${signal}; stopping Ollama"
  if [ -n "$child_pid" ]; then
    kill "-$signal" "$child_pid" 2>/dev/null || true
    wait "$child_pid" 2>/dev/null || true
  fi
  exit "$status"
}

trap 'shutdown TERM 143' TERM
trap 'shutdown INT 130' INT

export OLLAMA_IGPU_ENABLE=1
OLLAMA_HOST="$(ollama_serve_host)"; export OLLAMA_HOST

# A foreign listener is healthy only when it exposes a non-empty model list. An
# empty Ollama store is the signature of the image-owned system unit: it has won the
# port but cannot run a hermit job. Do not stand down for that listener. Starting
# our supervised owner will fail loudly with address-in-use until an operator removes
# the foreign owner, instead of silently preserving guaranteed 404s.
endpoint_models=""
if endpoint_models="$(curl -fsS --max-time 5 "$GARDEN_LOCAL_OLLAMA_URL/models" 2>/dev/null)" \
  && jq -e '.data | (type == "array" and length > 0)' <<<"$endpoint_models" >/dev/null 2>&1; then
  back_off "Ollama endpoint already answers at $GARDEN_LOCAL_OLLAMA_URL (another process owns $OLLAMA_HOST)"
  exit 0
fi
if [ -n "$endpoint_models" ]; then
  msg="local inference endpoint $GARDEN_LOCAL_OLLAMA_URL answers but serves no models; refusing to stand down for the foreign listener on $OLLAMA_HOST"
  log "$msg"
  alert_maintainer "ollama-model-less-endpoint-${GARDEN}" "$msg"
fi

if ! command -v ollama >/dev/null 2>&1; then
  back_off "ollama is not on PATH; a hermit host must ship it (Dockerfile ARG OLLAMA_VERSION) — see context/operations/local-inference-amd.md § 6"
  exit 1
fi

log "starting supervised Ollama endpoint on $OLLAMA_HOST (serves $GARDEN_LOCAL_OLLAMA_URL)"
ollama serve &
child_pid="$!"

set +e
wait "$child_pid"
serve_status=$?
set -e
child_pid=""

# SIGTERM and SIGINT are handled above so a normal systemd stop remains a clean
# 143/130 result. Every other exit, including a misleading immediate 0, is held
# back before Restart=always starts another attempt.
back_off "ollama serve exited with status $serve_status"
exit "$serve_status"
