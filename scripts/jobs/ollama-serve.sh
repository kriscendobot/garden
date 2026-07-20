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
# The unit sets Restart=always, so a crash self-restarts; this script is a thin,
# durable derivation shim (no config file needed — reset-proof, like the handler's
# inline provider block).
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
GARDEN_TAG="ollama-serve"

command -v ollama >/dev/null 2>&1 \
  || die "ollama is not on PATH; a hermit host must ship it (Dockerfile ARG OLLAMA_VERSION) — see context/operations/local-inference-amd.md § 6"

export OLLAMA_IGPU_ENABLE=1
OLLAMA_HOST="$(ollama_serve_host)"; export OLLAMA_HOST
log "starting supervised Ollama endpoint on $OLLAMA_HOST (serves $GARDEN_LOCAL_OLLAMA_URL)"
exec ollama serve
