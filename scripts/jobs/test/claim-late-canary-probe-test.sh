#!/bin/bash
# claim-late-canary-probe-test.sh — a canary probe posted while a claim pass is
# already walking its candidate snapshot is tried at the next candidate boundary,
# not after the whole pass; a late probe pinned to another host is still skipped.
set -euo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
PASS=0; FAIL=0
ok() { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
TR="$(mktemp -d "${TMPDIR:-/var/tmp}/garden-late-probe.XXXXXX")"; trap 'rm -rf "$TR"' EXIT
BRANCH=journal2

seed() { # <name>: a fresh board holding two ordinary jobs
  local bare="$TR/$1.git" s="$TR/$1-seed"
  git init -q --bare "$bare"; git init -q "$s"; git -C "$s" checkout -q -b "$BRANCH"
  for d in jobs/todo jobs/doin jobs/tada work inbox/maintainer/unread inbox/maintainer/read; do mkdir -p "$s/$d"; touch "$s/$d/.gitkeep"; done
  for j in a-plain b-plain; do printf '# ordinary job\n' > "$s/jobs/todo/$j.md"; done
  git -C "$s" add -A; git -C "$s" -c user.name=t -c user.email=t@l commit -qm seed
  git -C "$s" remote add origin "$bare"; git -C "$s" push -q -u origin "$BRANCH"
}

# Mock unit_ctl: the first is-active query (the top of the first candidate attempt,
# after the pass took its snapshot) posts a canary probe for $PROBE_HOST, as the
# leader's rolling-deploy does mid-pass. Always reports the unit active.
MOCK="$TR/unit-ctl"
cat > "$MOCK" <<'M'
#!/bin/bash
if [ "$1" = is-active ] && [ ! -e "$MOCK_DONE" ]; then
  touch "$MOCK_DONE"
  p="$MOCK_TR/poster-$MOCK_NAME"
  git clone -q --branch journal2 "$MOCK_BARE" "$p"
  printf -- '---\nrequires: host=%s\ncanary-probe: true\nhandler-timeout: 120\n---\n# probe\n' "$PROBE_HOST" \
    > "$p/jobs/todo/z-canary-probe-$PROBE_HOST.md"
  git -C "$p" add -A; git -C "$p" -c user.name=t -c user.email=t@l commit -qm "post probe"; git -C "$p" push -q
fi
[ "$1" = is-active ] && echo active
exit 0
M
chmod +x "$MOCK"
claim() { # <board> <probe-host>
  env -u GARDEN_JOB_BASE -u GARDEN_COMPLETION_SENTINEL GARDEN=host-a GARDEN_WORKER_KIND=monk \
    GARDEN_STATE="$TR/state-$1" JOURNAL_REMOTE="$TR/$1.git" JOURNAL_BRANCH="$BRANCH" \
    GARDEN_WORKER_CLONE="$TR/clone-$1" GARDEN_UNIT_CTL="$MOCK" MOCK_DONE="$TR/done-$1" \
    MOCK_TR="$TR" MOCK_NAME="$1" MOCK_BARE="$TR/$1.git" PROBE_HOST="$2" \
    "$JOBS/claim-job.sh" 1
}

seed own
got="$(claim own host-a 2>/dev/null || true)"
if [ "$got" = z-canary-probe-host-a ]; then ok "a probe posted mid-pass is claimed ahead of the snapshot's jobs"; else bad "mid-pass probe: claimed '$got'"; fi
if git -C "$TR/own.git" show "$BRANCH:jobs/todo/a-plain.md" >/dev/null 2>&1 \
   && git -C "$TR/own.git" show "$BRANCH:jobs/todo/b-plain.md" >/dev/null 2>&1; then
  ok "the ordinary jobs stay in todo/"
else bad "an ordinary job left todo/"; fi

seed other
got="$(claim other host-b 2>/dev/null || true)"
case "$got" in
  a-plain|b-plain) ok "a late probe pinned to another host is skipped; an ordinary job is claimed ('$got')" ;;
  *) bad "other-host probe: claimed '$got'" ;;
esac

echo "claim-late-canary-probe-test: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
