#!/bin/bash
# complete-job-inbox-rm-force-test.sh — regression guard for the forced `git rm`
# of a completing job's own paths (complete-job.sh, the doin/work/bids/inbox rm).
#
# THE BUG (oros-studio-garden-ce242c49, 2026-10-21): complete-job.sh removed
# inbox/<base> with `git rm -rq` (no -f). On the virtiofs-backed worker clone a
# file the sync_clone hard reset has just rewritten is reported modified for
# about a second, so git refused — "the following files have local
# modifications: inbox/<base>/read/.gitkeep, inbox/<base>/unread/.gitkeep" —
# complete-job exited rc=1 and garden-monk crashed with the job left in doin.
#
# The race is not reproducible on tmpfs, so this test injects it
# deterministically: GARDEN_REAL_GIT points at a shim that, just before any
# `git rm` touching the job's paths, writes bytes into the work-tree copies of
# those files. Without -f, git refuses; with -f the completion must push the
# tada and drop doin/, work/ and inbox/ for the base.
#
# Usage: complete-job-inbox-rm-force-test.sh
set -euo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }

unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true) 2>/dev/null || true

# The real git binary, never a garden bin/git wrapper (this checkout's or the
# deployed root's): those defer to GARDEN_REAL_GIT and would loop into the shim.
REAL_GIT=""
IFS=: read -r -a path_dirs <<< "$PATH"
for d in "${path_dirs[@]}"; do
  [ -x "${d:-.}/git" ] || continue
  case "$(readlink -f "${d:-.}/git")" in */scripts/jobs/bin/git) continue ;; esac
  REAL_GIT="$(readlink -f "${d:-.}/git")"; break
done
[ -n "$REAL_GIT" ] || { echo "no real git on PATH" >&2; exit 1; }
T="$(mktemp -d "${TMPDIR:-/tmp}/garden-cj-rmf.XXXXXX")"; trap 'rm -rf "$T"' EXIT
base=inboxdirty
bare="$T/journal.git" seed="$T/seed"
git_id=(-c user.name=test -c user.email=test@localhost)

git init -q --bare "$bare"
git init -q "$seed"; git -C "$seed" checkout -q -b journal2
( cd "$seed"
  mkdir -p jobs/todo jobs/doin jobs/tada work repos msgs hosts entries schedules cursors
  for d in jobs/todo jobs/doin jobs/tada work repos msgs hosts entries schedules cursors; do touch "$d/.gitkeep"; done
  printf '# %s\n\ndo the work\n' "$base" > "jobs/doin/$base.md"
  printf 'host: okhost\ngardener: 1\n' > "work/$base"
  mkdir -p "inbox/$base/unread" "inbox/$base/read"
  touch "inbox/$base/unread/.gitkeep" "inbox/$base/read/.gitkeep"
  printf 'an already-read message\n' > "inbox/$base/read/20261021T000000Z-aaaaaa.md" )
git -C "$seed" add -A
git -C "$seed" "${git_id[@]}" commit -q -m "seed: claimed job with an inbox"
git -C "$seed" remote add origin "$bare"
git -C "$seed" push -q -u origin journal2

# The shim dirties the work tree of every path a completion `git rm` names, then
# hands off to the real git, reproducing the moment the refusal happened.
shim="$T/git-shim.sh"
cat > "$shim" <<SHIM
#!/bin/bash
dir=""; args=("\$@"); i=0
while [ "\$i" -lt "\${#args[@]}" ]; do
  case "\${args[\$i]}" in -C) dir="\${args[\$((i+1))]}"; i=\$((i+2)); continue ;; esac
  break
done
if [ -n "\$dir" ] && [ "\${args[\$i]:-}" = rm ]; then
  for p in "\${args[@]:\$((i+1))}"; do
    case "\$p" in -*) continue ;; esac
    if [ -d "\$dir/\$p" ]; then
      find "\$dir/\$p" -type f -exec sh -c 'printf "dirty\n" >> "\$1"' _ {} \;
    elif [ -f "\$dir/\$p" ]; then
      printf 'dirty\n' >> "\$dir/\$p"
    fi
  done
fi
exec "$REAL_GIT" "\$@"
SHIM
chmod +x "$shim"

rpt="$T/report.md"; printf 'did the work for %s\n' "$base" > "$rpt"
rc=0
env GARDEN="okhost" GARDEN_STATE="$T/state" JOURNAL_REMOTE="$bare" JOURNAL_BRANCH=journal2 \
    GARDEN_REAL_GIT="$shim" GARDEN_FOREMAN_EDGE_KICK=0 \
    "$JOBS/complete-job.sh" 1 "$base" "$rpt" > "$T/complete.log" 2>&1 || rc=$?

[ "$rc" = 0 ] && ok "complete-job.sh exited 0 with dirty work-tree copies" \
  || bad "complete-job.sh exited $rc: $(tail -5 "$T/complete.log")"
! grep -q "local modifications" "$T/complete.log" \
  && ok "git rm did not refuse on local modifications" \
  || bad "git rm refused: $(grep -A3 'local modifications' "$T/complete.log")"

v="$T/verify"; git clone -q --single-branch --branch journal2 "$bare" "$v" 2>/dev/null
tada="$(find "$v/jobs/tada" -name "$base.md" -type f | head -1)"
[ -n "$tada" ] && ok "the tada report was pushed" || bad "no tada report for $base on origin"
[ ! -e "$v/jobs/doin/$base.md" ] && ok "doin/$base.md removed" || bad "doin/$base.md still on origin"
[ ! -e "$v/work/$base" ] && ok "work/$base removed" || bad "work/$base still on origin"
[ ! -e "$v/inbox/$base" ] && ok "inbox/$base removed" || bad "inbox/$base still on origin"

echo "RESULTS: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
