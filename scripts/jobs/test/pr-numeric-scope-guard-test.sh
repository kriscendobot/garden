#!/bin/bash
# pr-numeric-scope-guard-test.sh — regression guard for the ambiguous
# bare-numeric `gh pr` selector guard (scripts/jobs/pr-numeric-scope-guard.sh +
# its wiring in bin/gh).
#
# THE GAP THIS CLOSES (a completed deadline-retirement job requeued): a bare
# `gh pr … 51` with no explicit repository or PR URL, run OUTSIDE a project
# worktree, resolved `#51` against the garden's own repo — where issues and PRs
# share one number space — so `gh pr` reported a "nonexistent PullRequest" and
# turned finished work into a handler failure. The guard refuses such a call and
# names the remedy (`-R <owner>/<repo>` or a full PR URL).
#
# Two layers under test:
#   1. the pure argv guard — a bare-numeric selector with no -R/URL, outside a
#      project worktree, BLOCKS; an -R-scoped, URL, branch-name, or non-selector
#      call passes; inside a project worktree a bare number passes;
#   2. the wrapper wiring — bin/gh first on PATH refuses the ambiguous call
#      (real gh NEVER runs) and passes an -R-scoped one through.
#
# Hermetic: no network. Project-worktree detection is exercised against real
# throwaway git repos (a fake "garden root" repo + a linked worktree that shares
# it = a garden worktree, and a separate bare clone + worktree = a project
# worktree), so the git-common-dir comparison is tested for real.
set -uo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
LIB="$JOBS/pr-numeric-scope-guard.sh"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# shellcheck disable=SC2046  # deliberate word-split: unset each matched var name.
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|GH_|GIT_)' || true) 2>/dev/null || true
export GARDEN_TEST=1

# --- an exec-capable temp root (mirrors comment-body-guard-test.sh) -----------
TMPBASE="${GARDEN_TEST_TMP:-$HOME}"
TR="$(mktemp -d "$TMPBASE/.prnsg-test.XXXXXX")"; trap 'rm -rf "$TR"' EXIT
printf '#!/bin/sh\nexit 0\n' > "$TR/.execprobe"; chmod +x "$TR/.execprobe"
"$TR/.execprobe" 2>/dev/null || { echo "FATAL: $TMPBASE is noexec; set GARDEN_TEST_TMP" >&2; exit 2; }
# Cap git's upward search so it never escapes into the REAL garden repo that
# (here) encloses $TR — mirroring the fleet, where common.sh pins
# GIT_CEILING_DIRECTORIES=$GARDEN_ROOT. The ceiling stops git BEFORE the listed
# dir, so name $TR's parent: a "no git repo" cwd under $TR then fails to resolve
# any repo instead of finding the real garden's .git above and skewing detection.
# The fixture worktrees under $TR are unaffected — each has its own .git found
# without any upward search.
_tr_parent="$(dirname "$TR")"; export GIT_CEILING_DIRECTORIES="$_tr_parent"

git_quiet() { git -c init.defaultBranch=main -c user.email=t@t -c user.name=t "$@"; }

# --- build a fake garden root repo + a garden dev worktree --------------------
GROOT="$TR/garden"; mkdir -p "$GROOT"
git_quiet init -q "$GROOT"
( cd "$GROOT" && echo hi > f && git_quiet add f && git_quiet commit -qm init )
GWT="$TR/garden-dev-wt"
( cd "$GROOT" && git_quiet worktree add -q --detach "$GWT" HEAD ) >/dev/null 2>&1

# --- build a fake project bare clone + a project worktree ---------------------
PBARE="$TR/proj.git"
git_quiet clone -q --bare "$GROOT" "$PBARE" >/dev/null 2>&1
PWT="$TR/proj-wt"
git_quiet --git-dir="$PBARE" worktree add -q --detach "$PWT" HEAD >/dev/null 2>&1

export GARDEN_ROOT="$GROOT"
# shellcheck source=../pr-numeric-scope-guard.sh
. "$LIB"

hr; echo "argv guard: ambiguous bare number OUTSIDE a project worktree must BLOCK"
# Run each check from the garden dev worktree (a garden worktree, not a project).
run_in() { ( cd "$1" && shift && "$@" ); }

for sub in view diff checks checkout close comment edit merge ready reopen; do
  if run_in "$GWT" pr_numeric_scope_guard_argv pr "$sub" 51 2>/dev/null; then
    ok "pr $sub 51 blocked in garden worktree"
  else
    bad "pr $sub 51 NOT blocked in garden worktree"
  fi
done
# #-prefixed form
run_in "$GWT" pr_numeric_scope_guard_argv pr view '#51' 2>/dev/null \
  && ok "pr view #51 blocked" || bad "pr view #51 NOT blocked"
# number after other flags (flag values must not hide the selector)
run_in "$GWT" pr_numeric_scope_guard_argv pr view 51 --json state 2>/dev/null \
  && ok "pr view 51 --json state blocked" || bad "pr view 51 --json state NOT blocked"
run_in "$GWT" pr_numeric_scope_guard_argv pr comment 51 --body 'hello' 2>/dev/null \
  && ok "pr comment 51 --body hello blocked" || bad "pr comment 51 --body hello NOT blocked"
# NOT in any git repo at all → still ambiguous → block
run_in "$TR" pr_numeric_scope_guard_argv pr view 51 2>/dev/null \
  && ok "pr view 51 blocked outside any git repo" || bad "pr view 51 NOT blocked outside any git repo"

hr; echo "argv guard: explicit scope must PASS THROUGH (rc 1)"
run_in "$GWT" pr_numeric_scope_guard_argv pr view 51 -R endojs/endo-but-for-bots 2>/dev/null \
  && bad "-R-scoped call wrongly blocked" || ok "-R <owner>/<repo> passthrough"
run_in "$GWT" pr_numeric_scope_guard_argv pr view 51 --repo=endojs/endo-but-for-bots 2>/dev/null \
  && bad "--repo=… call wrongly blocked" || ok "--repo=<owner>/<repo> passthrough"
run_in "$GWT" pr_numeric_scope_guard_argv pr view https://github.com/endojs/endo-but-for-bots/pull/51 2>/dev/null \
  && bad "URL call wrongly blocked" || ok "full PR URL passthrough"
run_in "$GWT" pr_numeric_scope_guard_argv pr checkout my-feature-branch 2>/dev/null \
  && bad "branch-name call wrongly blocked" || ok "branch-name selector passthrough"
run_in "$GWT" pr_numeric_scope_guard_argv pr checkout 51-my-feature 2>/dev/null \
  && bad "51-my-feature branch wrongly blocked" || ok "numeric-prefixed branch name passthrough"
run_in "$GWT" pr_numeric_scope_guard_argv pr list --limit 51 2>/dev/null \
  && bad "pr list wrongly blocked" || ok "non-selector subcommand (list) passthrough"
run_in "$GWT" pr_numeric_scope_guard_argv pr status 2>/dev/null \
  && bad "pr status wrongly blocked" || ok "non-selector subcommand (status) passthrough"
run_in "$GWT" pr_numeric_scope_guard_argv issue view 51 2>/dev/null \
  && bad "issue view wrongly blocked" || ok "non-pr command (issue) passthrough"
# override bypasses even the ambiguous case
GARDEN_ALLOW_BARE_PR_NUMBER=1 run_in "$GWT" bash -c '. "'"$LIB"'"; pr_numeric_scope_guard_argv pr view 51' 2>/dev/null \
  && bad "override failed to bypass" || ok "GARDEN_ALLOW_BARE_PR_NUMBER=1 bypasses block"

hr; echo "argv guard: bare number INSIDE a project worktree must PASS THROUGH"
run_in "$PWT" pr_numeric_scope_guard_argv pr view 51 2>/dev/null \
  && bad "bare number wrongly blocked inside project worktree" \
  || ok "bare number passthrough inside project worktree"
run_in "$PWT" pr_numeric_scope_guard_argv pr checkout 51 2>/dev/null \
  && bad "pr checkout 51 wrongly blocked inside project worktree" \
  || ok "pr checkout 51 passthrough inside project worktree"

hr; echo "wrapper e2e: bin/gh must refuse the ambiguous call (real gh NEVER runs)"
REALBIN="$TR/realbin"; mkdir -p "$REALBIN"; GHLOG="$TR/real-gh.log"
cat > "$REALBIN/gh" <<EOF
#!/bin/bash
case "\$1 \$2" in
  "auth token") echo "faketoken"; exit 0 ;;
  "auth status") echo "logged in"; exit 0 ;;
esac
printf '%s\0' "\$@" >> "$GHLOG"
echo >> "$GHLOG"
exit 0
EOF
chmod +x "$REALBIN/gh"
export PATH="$JOBS/bin:$REALBIN:$PATH"
export GH_CONFIG_DIR="$TR/ghcfg"; mkdir -p "$GH_CONFIG_DIR"

: > "$GHLOG"
if ( cd "$GWT" && gh pr view 51 ) >/dev/null 2>"$TR/err"; then
  bad "wrapper allowed the ambiguous bare-numeric pr call (exit 0)"
else
  grep -q 'REFUSING a bare-numeric' "$TR/err" && ok "wrapper refused ambiguous call with remedy message" \
    || { bad "wrapper exited non-zero but without the guard message"; cat "$TR/err"; }
fi
if grep -qa 'view' "$GHLOG"; then bad "real gh received the ambiguous pr call"; else ok "real gh never ran for the ambiguous call"; fi

# -R-scoped call must reach the fake real gh
: > "$GHLOG"
( cd "$GWT" && gh pr view 51 -R endojs/endo-but-for-bots ) >/dev/null 2>&1 || true
grep -qa 'view' "$GHLOG" && ok "-R-scoped call reached real gh" || bad "-R-scoped call was blocked"

# bare number inside a project worktree must reach the fake real gh
: > "$GHLOG"
( cd "$PWT" && gh pr view 51 ) >/dev/null 2>&1 || true
grep -qa 'view' "$GHLOG" && ok "project-worktree bare number reached real gh" || bad "project-worktree bare number was blocked"

hr
echo "pr-numeric-scope-guard: PASS=$PASS FAIL=$FAIL"
[ "$FAIL" -eq 0 ]
