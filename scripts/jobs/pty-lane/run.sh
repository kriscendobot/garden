#!/bin/bash
# pty-lane/run.sh — the opt-in `lane: pty` replacement for a monk's headless `claude -p`
# call. Sets up everything a driven interactive session needs for Claude Code's statusLine
# to fire (workspace trust, a --settings layer pointing at the noexec-safe statusline
# command, session-persistence env), then hands off to run.py which encloses the session
# in a pty and drives it to the completion marker. See
# designs/pty-context-introspection-lane.md.
#
# Called by handlers/monk-claude.sh (lane branch) as:
#   run.sh <base> <worktree> <session_id> <resuming> <report-out> <prompt-file> <claude-cli> -- <extra claude args...>
# where <extra claude args...> are the session/model flags monk-claude already resolved
# (--resume/--session-id, --model, --dangerously-skip-permissions). This script adds the
# interactive-lane specifics and NEVER passes -p.
#
# Exit code is run.py's: 0 iff the worker emitted the completion marker (a report was
# written to <report-out>); non-zero requeues, exactly like a headless miss. The spine
# (monk-claude.sh) still owns the sentinel/teardown/state-cleanup decision downstream.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../common.sh
source "$HERE/../common.sh"

base="${1:?base}"; worktree="${2:?worktree}"; session_id="${3:?session_id}"
resuming="${4:?resuming}"; report="${5:?report-out}"; prompt_file="${6:?prompt-file}"
claude_cli="${7:?claude-cli}"; shift 7
[ "${1:-}" = "--" ] && shift
extra_args=("$@")

state_root="${GARDEN_STATE:-$GARDEN_ROOT/.garden-state}"
lane_dir="$state_root/pty-context"
mkdir -p "$lane_dir"

log "pty-lane: starting interactive session for '$base' (resuming=$resuming) in $worktree"

# 1) A --settings layer that turns on the statusLine command. Generated per session (not a
#    tracked file) because the command must carry the DEPLOYED absolute path of
#    statusline.sh — and must invoke it via `bash` so a noexec state/tmp mount cannot fail
#    the exec (rc=126). This is the settings-propagation answer (requirement 5): the
#    statusline SCRIPT is tracked in-repo; the settings file that references it is written
#    by code at launch, so no human ever hand-edits the gitignored ~/.claude/settings.json,
#    and the bind mount that masks $HOME is irrelevant.
settings_file="$lane_dir/$base.settings.json"
statusline="$HERE/statusline.sh"
cat > "$settings_file" <<JSON
{ "statusLine": { "type": "command", "command": "bash $statusline", "padding": 0 } }
JSON

# 2) Pre-accept workspace trust for this worktree. The statusLine executor has an EXTRA
#    trust gate beyond hooks: it skips with "workspace trust not accepted" unless
#    projects.<cwd>.hasTrustDialogAccepted is set (interactive sessions do not get the
#    `-p` auto-trust). run.py also answers the trust dialog as a fallback, but pre-persist
#    is the reliable path. Serialize the read-modify-write with flock: ~/.claude.json is
#    shared by every concurrent gardener AND by Claude itself.
config_dir="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
# .claude.json lives beside the config dir historically at $HOME/.claude.json; honor
# CLAUDE_CONFIG_DIR relocation if present.
if [ -n "${CLAUDE_CONFIG_DIR:-}" ] && [ -f "$CLAUDE_CONFIG_DIR/.claude.json" ]; then
  claude_json="$CLAUDE_CONFIG_DIR/.claude.json"
else
  claude_json="$HOME/.claude.json"
fi
lock="$lane_dir/.claude-json.lock"
(
  flock -w 10 9 || { log "pty-lane: could not lock $claude_json to set trust for '$base'; run.py will answer the dialog"; exit 0; }
  python3 - "$claude_json" "$worktree" <<'PY' || true
import json, os, sys
p, wt = sys.argv[1], sys.argv[2]
try:
    d = json.load(open(p)) if os.path.exists(p) else {}
except Exception:
    d = {}
proj = d.setdefault('projects', {})
e = proj.setdefault(wt, {})
e['hasTrustDialogAccepted'] = True
e.setdefault('hasCompletedProjectOnboarding', True)
tmp = p + '.pty-lane.tmp'
json.dump(d, open(tmp, 'w'))
os.replace(tmp, p)
PY
) 9>"$lock"

# 3) Completion signal file + lane protocol. Interactive mode has no `--output-format json`
#    envelope and does not reliably persist a transcript at a predictable path, so the lane
#    detects completion from a file the worker WRITES: append a short protocol to the prompt
#    telling it to write its complete final report (ending with the marker) to $signal via
#    the Write tool. run.py polls that clean whole-file artifact — no ANSI/transcript
#    parsing. The worker already emits the marker as its final act on stdout; this asks for
#    the same text in a file the driver can see.
signal="$lane_dir/$base.report"
rm -f "$signal" 2>/dev/null || true
export GARDEN_PTY_REPORT_FILE="$signal"
{
  printf '\n\n---\n'
  printf 'PTY-LANE COMPLETION PROTOCOL (this session runs in the experimental pty lane): '
  printf 'in addition to printing your final report, you MUST write your COMPLETE final '
  printf 'report — the same text, ending with the line %s as its very last line — to the '  "$GARDEN_COMPLETION_MARKER"
  printf 'file at %s using the Write tool, as your FINAL action. Writing that file is how '  "$signal"
  printf 'this lane records completion; the job is not recorded done until you do.\n'
} >> "$prompt_file"

# Transcript candidate paths — run.py polls these as a FALLBACK. Claude
#    encodes the launch cwd into the project dir with '/'→'-' (and in some versions '.'→'-'
#    too); probe both, mirroring monk-claude.sh's resume detection.
proj_dir="$config_dir/projects/$(printf '%s' "$worktree" | sed 's#/#-#g')"
proj_dir_alt="$config_dir/projects/$(printf '%s' "$worktree" | sed 's#[/.]#-#g')"

# 4) Launch. Clear inherited nested-session markers (only present if a gardener is itself
#    somehow under a claude session — defensive) and force transcript persistence so run.py
#    can read the marker back. Disable nonessential traffic so remote-control cannot hijack
#    the driven TUI.
export GARDEN_JOB_BASE="$base" GARDEN_STATE="$state_root"
cd "$worktree"
set +e
env -u CLAUDE_CODE_CHILD_SESSION -u CLAUDE_CODE_SESSION_ID -u CLAUDE_PID -u CLAUDECODE \
    -u CLAUDE_CODE_ENTRYPOINT -u CLAUDE_CODE_EXECPATH -u CLAUDE_CODE_MESSAGING_SOCKET \
    -u CLAUDE_CODE_MESSAGING_TOKEN \
    CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1 \
    CLAUDE_CODE_FORCE_SESSION_PERSISTENCE=1 \
  python3 "$HERE/run.py" \
    --prompt-file "$prompt_file" \
    --report-out "$report" \
    --marker "$GARDEN_COMPLETION_MARKER" \
    --signal-file "$signal" \
    --transcript "$proj_dir/$session_id.jsonl" \
    --transcript "$proj_dir_alt/$session_id.jsonl" \
    --idle-exit "${GARDEN_PTY_IDLE_EXIT:-8}" \
    --max-seconds "${GARDEN_PTY_MAX_SECONDS:-0}" \
    -- "$claude_cli" "${extra_args[@]}" --settings "$settings_file"
rc=$?
set -e
rm -f "$settings_file" "$signal" 2>/dev/null || true
exit "$rc"
