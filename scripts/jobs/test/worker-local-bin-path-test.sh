#!/bin/bash
# worker-local-bin-path-test.sh — regression guard that a worker's agent
# subprocess can REACH a tool installed in `$HOME/.local/bin` (the AWS CLI v2
# lands `aws` there — scripts/aws/install-aws-cli.sh), through the exact launch
# path the claude handler uses.
#
# THE DEFECT THIS LOCKS DOWN. A `systemd --user` unit carries no declared PATH,
# so a worker starts on the bare user-manager PATH (`/usr/local/sbin:…:/snap/bin`
# — no `$HOME/.local/bin`). If nothing re-adds the dir, an `aws` invoked by the
# agent fails `command not found` — NOT an auth error, which sends whoever reads
# the report hunting the wrong problem. common.sh § "declare the fleet's PATH
# tail" is the fix: it APPENDS `$HOME/.local/bin` (and the image's other tool
# dirs) when missing and EXPORTS the result, so the `claude -p` child the handler
# spawns — and its non-login Bash tool calls — inherit it. This test proves that
# mechanism actually delivers a RUNNABLE binary to the agent, not merely a PATH
# string that mentions the directory.
#
# WHY common.sh AND NOT a resolver / a per-handler tweak. `aws` is not launched by
# the spine (the way `claude_bin()` resolves the CLI the spine itself execs); it
# is run BY the agent inside its own `claude -p` session as an ordinary shell
# command, so it rides on whatever PATH the gardener process exported. The fix
# therefore has to be PATH propagation to the subprocess, done once for every
# worker kind — which is exactly what the common.sh append is (every worker/timer
# sources common.sh). Pinning `Environment=PATH=` in the systemd unit was
# rejected deliberately: an absolute unit pin NARROWS the PATH on any host whose
# session legitimately carries something else (nvm, ~/.cargo/bin, /snap/bin) and
# breaks the very builds the fleet runs (common.sh comment).
#
# The handler's launch idiom (handlers/gardener-claude.sh) is reproduced verbatim
# in spirit: `( cd "$worktree" && env -u GARDEN_USAGE_FILE -u GARDEN_ENGAGEMENT_USAGE
# "$cli" … )`. A non-login `bash -c 'aws'` stands in for the agent resolving the
# tool by PATH — non-login on purpose, because the agent's Bash tool is non-login
# and inherits the exported PATH rather than re-deriving it from /etc/profile.
#
# Usage: worker-local-bin-path-test.sh
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# Scrub ambient fleet env (a live gardener running this test as a board job would
# otherwise splice its own GARDEN_*/JOURNAL_* state — clone, remote, offline rc —
# underneath the fixture; see run-test.sh § hermetic baseline).
# shellcheck disable=SC2046  # deliberate word-split: unset each matched var name
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true) 2>/dev/null || true

# The stub is probed with `[ -x ]` and then EXECUTED, both of which honor a
# mount's noexec flag — and the sandbox mounts /tmp noexec, so a fixture there
# would read as "present but not runnable" and silently invert the assertions.
# Probe for an exec-allowed base exactly as claude-bin-resolver-test.sh does, and
# SKIP honestly (not fail) when the sandbox forbids exec everywhere writable.
# Never $HOME: it is the garden repo root.
pick_exec_base() {
  local c probe rc
  for c in "${TMPDIR:-}" /tmp /var/tmp "${GARDEN_ROOT:+$GARDEN_ROOT/scratch}"; do
    [ -n "$c" ] || continue
    mkdir -p "$c" 2>/dev/null || true
    [ -d "$c" ] && [ -w "$c" ] || continue
    probe="$(mktemp -d "$c/wlbp-probe.XXXXXX" 2>/dev/null)" || continue
    printf '#!/bin/sh\nexit 7\n' > "$probe/x"; chmod +x "$probe/x" 2>/dev/null
    "$probe/x" >/dev/null 2>&1; rc=$?
    rm -rf "$probe"
    [ "$rc" -eq 7 ] && { printf '%s\n' "$c"; return 0; }
  done
  return 1
}
EXEC_BASE="$(pick_exec_base)" || { echo "  SKIP: no exec-allowed temp base (needed to run the fake aws)"; exit 0; }
TR="$(mktemp -d "$EXEC_BASE/garden-wlbp.XXXXXX")"; trap 'rm -rf "$TR"' EXIT

# A throwaway $HOME whose ~/.local/bin holds a fake `aws` that prints a marker when
# it actually RUNS. Reachability = this marker comes back through the launch path.
FAKE_HOME="$TR/home"
mkdir -p "$FAKE_HOME/.local/bin"
STUB="$FAKE_HOME/.local/bin/aws"
printf '#!/bin/bash\nprintf %%s\\\\n "STUB-AWS-REACHED"\n' > "$STUB"
chmod +x "$STUB"

# A per-job worktree stand-in — the handler `cd`s into one before launching the
# agent, so the test proves the PATH survives that cd (it is exported, not cwd-
# relative).
WT="$TR/worktree"; mkdir -p "$WT"

# The bare user-manager PATH a `systemd --user` worker actually starts on (the
# value the job read from /proc/<MainPID>/environ). `$HOME/.local/bin` is absent —
# common.sh's append is the ONLY thing that can add it.
SYSTEMD_PATH='/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin'

# Reproduce the agent's reach for `aws`: source common.sh on the bare PATH (as a
# worker does), then run the handler's launch idiom and let a non-login shell
# resolve `aws` off the inherited/exported PATH. Prints the stub's marker on
# success, nothing on failure. Runs entirely in a subshell so common.sh's exports
# never leak into the test process. GARDEN_ROOT is left unset so common.sh derives
# the real repo root from its own path.
reach_aws() {  # reach_aws <starting-PATH>
  (
    set +e
    export HOME="$FAKE_HOME"
    export PATH="$1"
    export GARDEN_TEST=1
    # shellcheck source=../common.sh
    source "$JOBS/common.sh" >/dev/null 2>&1
    cd "$WT" 2>/dev/null || true
    env -u GARDEN_USAGE_FILE -u GARDEN_ENGAGEMENT_USAGE \
      bash -c 'command -v aws >/dev/null 2>&1 && exec aws' 2>/dev/null
    exit 0
  )
}

# Same, but report the PATH common.sh produced (for the membership + idempotency
# assertions).
path_after_source() {  # path_after_source <starting-PATH>
  (
    set +e
    export HOME="$FAKE_HOME"
    export PATH="$1"
    export GARDEN_TEST=1
    # shellcheck source=../common.sh
    source "$JOBS/common.sh" >/dev/null 2>&1
    printf '%s' "$PATH"
    exit 0
  )
}

hr
echo "SUBTEST 1: control — on the bare systemd PATH, aws is unreachable (non-vacuity)"
# Prove the fixture actually reproduces the gap: without common.sh's append the
# agent cannot find aws. If this passed, every later assertion would be vacuous.
ctrl="$(HOME="$FAKE_HOME" PATH="$SYSTEMD_PATH" bash -c 'command -v aws >/dev/null 2>&1 && aws' 2>/dev/null || true)"
if [ -z "$ctrl" ]; then
  ok "aws is NOT reachable on the bare systemd PATH (the reported gap reproduces)"
else
  bad "aws unexpectedly reachable without the append (got '$ctrl') — fixture is vacuous"
fi

hr
echo "SUBTEST 2: common.sh appends \$HOME/.local/bin to PATH"
np="$(path_after_source "$SYSTEMD_PATH")"
case ":$np:" in
  *":$FAKE_HOME/.local/bin:"*) ok "\$HOME/.local/bin present in PATH after sourcing common.sh" ;;
  *) bad "\$HOME/.local/bin missing from PATH after sourcing common.sh: $np" ;;
esac

hr
echo "SUBTEST 3: aws RUNS through the handler's launch idiom (the only test that matters)"
got="$(reach_aws "$SYSTEMD_PATH")"
if [ "$got" = "STUB-AWS-REACHED" ]; then
  ok "the fake aws resolved AND executed inside the cd+env-u launch subshell"
else
  bad "aws not reachable through the launch path (expected marker, got '$got')"
fi

hr
echo "SUBTEST 4: idempotent — sourcing twice does not duplicate the entry"
# A worker's process tree can source common.sh more than once; the append is
# guarded so a repeat must not stack the dir.
dbl="$(
  set +e
  export HOME="$FAKE_HOME" PATH="$SYSTEMD_PATH" GARDEN_TEST=1
  # shellcheck source=../common.sh
  source "$JOBS/common.sh" >/dev/null 2>&1
  # shellcheck source=../common.sh
  source "$JOBS/common.sh" >/dev/null 2>&1
  printf '%s' "$PATH"
  exit 0
)"
n="$(awk -v d="$FAKE_HOME/.local/bin" 'BEGIN{c=0; nf=split(ARGV[1],a,":"); for(i=1;i<=nf;i++) if(a[i]==d) c++; print c}' "$dbl")"
if [ "$n" = "1" ]; then
  ok "\$HOME/.local/bin appears exactly once after a double source"
else
  bad "\$HOME/.local/bin appears $n times after a double source (expected 1)"
fi

hr
echo "worker-local-bin-path-test: PASS=$PASS FAIL=$FAIL"
[ "$FAIL" -eq 0 ]
