#!/bin/bash
# fake-claude.sh — a deterministic `claude -p` stand-in for the follow-up-handler
# tests. Ignores all CLI args (the handler passes `-p --dangerously-skip-permissions
# <prompt>`); just emits canned action blocks so the handler's parse/dispatch/
# classification path can be exercised without a live model.
#
#   FAKE_CLAUDE_BLOCKS   path to a file whose contents are printed verbatim to
#                        stdout (the emitted action blocks).
#   FAKE_CLAUDE_FAIL     if set to a number, exit with that status after writing
#                        FAKE_CLAUDE_STDERR to stderr — exercises the handler's
#                        inner-agent-failure (claude -p non-zero) path.
#   FAKE_CLAUDE_PROMPT_OUT  optional path; if set, the LAST CLI arg (the prompt the
#                        handler built) is written here, so a test can assert the
#                        prompt's content (e.g. prompt-hardening regressions).
set -euo pipefail
[ -n "${FAKE_CLAUDE_PROMPT_OUT:-}" ] && [ "$#" -gt 0 ] && printf '%s' "${!#}" > "$FAKE_CLAUDE_PROMPT_OUT"
if [ -n "${FAKE_CLAUDE_FAIL:-}" ]; then
  printf '%s\n' "${FAKE_CLAUDE_STDERR:-simulated claude crash}" >&2
  exit "$FAKE_CLAUDE_FAIL"
fi
cat "${FAKE_CLAUDE_BLOCKS:?FAKE_CLAUDE_BLOCKS not set}"
