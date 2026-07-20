#!/bin/bash
# Minimal `codex` stand-in for hermit-ollama-self-heal-test.sh: only needs to satisfy
# `command -v codex` (and a login-status probe, unused on the local path). Never runs.
[ "${1:-}" = login ] && exit 0
exit 0
