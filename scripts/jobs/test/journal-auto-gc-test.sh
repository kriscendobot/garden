#!/bin/bash
# journal-auto-gc-test.sh — regression guard for the post-fetch pack compaction
# (journal_auto_gc in common.sh).
#
# Incident (oros-studio-garden-ce242c49, 2026-10-12): the producer journal clone
# sat at 57 packs, over the 50-pack limit, so every successful fetch ran
# `gc --auto`, whose over-limit path is an all-in-one cruft repack of the whole
# journal. Under host load that never finished inside bin/git's 120s bound
# (rc=124), so every fetch, including each CAS retry of a land, paid 120s under
# the producer clone lock and the pack count never fell. Covered here:
#   * at or below the pack limit nothing runs (no git invocation at all);
#   * above it, a geometric repack runs (never `gc`), the small packs and loose
#     objects are folded, and every object stays reachable;
#   * a failed compaction is advisory: rc 0, a WARN, the clone untouched;
#   * journal_fetch calls it after a successful real fetch.
#
# Usage: journal-auto-gc-test.sh
set -euo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

TR="$(mktemp -d "$HOME/.garden-auto-gc-test.XXXXXX")"  # $HOME, not /tmp: the shim must be executable
trap '[ -n "${KEEP:-}" ] || rm -rf "$TR"' EXIT
export GARDEN_STATE="$TR/state" GARDEN_CONTENTION_DIR="$TR/state/journal-contention"

# shellcheck source=../common.sh
source "$JOBS/common.sh"
export GARDEN_FETCH_RETRIES=1
unset GARDEN_FETCH_CMD
# The real binary, not the fleet wrapper: the wrapper resolves "real git" from
# PATH, where it would find this shim again.
REAL_GIT="$(type -aP git | grep -v '/scripts/jobs/bin/git$' | head -1)"

# A git shim that records each subcommand and can be told to fail repack.
mkdir -p "$TR/shim"
cat > "$TR/shim/git" <<SHIM
#!/bin/bash
args=("\$@")
i=0
while [ "\$i" -lt "\${#args[@]}" ]; do
  case "\${args[\$i]}" in
    -C|-c) i=\$((i+2)) ;;
    *) printf '%s\n' "\${args[*]:\$i}" >> "$TR/calls"; break ;;
  esac
done
if [ -e "$TR/fail-repack" ] && [ "\${args[\$i]:-}" = repack ]; then exit 124; fi
exec "$REAL_GIT" "\$@"
SHIM
chmod +x "$TR/shim/git"

# A remote with <n> commits; a clone that fetches each one as its own pack.
RB="$TR/journal.git"; W="$TR/writer"; C="$TR/clone"
git init -q --bare "$RB"
git init -q "$W"
git -C "$W" checkout -q -b journal2
git -C "$W" remote add origin "$RB"
commit_n() {  # <n>
  local i
  for i in $(seq "$1"); do
    printf '%s\n' "$RANDOM-$i" > "$W/f-$i-$(date +%s%N)"
    git -C "$W" add -A
    git -C "$W" -c user.name=t -c user.email=t@localhost commit -q -m "c$i"
  done
  git -C "$W" push -q origin HEAD:journal2
}
commit_n 1
git clone -q -b journal2 "$RB" "$C"
packs() { find "$C/.git/objects/pack" -maxdepth 1 -name '*.pack' | wc -l; }
grow_packs() {  # <n> — n more fetches, each kept as its own pack
  local i
  for i in $(seq "$1"); do
    commit_n 1
    git -C "$C" -c fetch.unpackLimit=1 fetch -q origin journal2
  done
}
grow_packs 6

hr; echo "CASE — at or below the limit, nothing runs"; hr
: > "$TR/calls"
before="$(packs)"
rc=0
( export PATH="$TR/shim:$PATH" GARDEN_JOURNAL_AUTO_GC_PACK_LIMIT="$before"
  journal_auto_gc "$C" ) >/dev/null 2>"$TR/below.err" || rc=$?
if [ "$rc" -eq 0 ] && [ ! -s "$TR/calls" ] && [ "$(packs)" -eq "$before" ]; then
  ok "$before packs at limit $before: no git invoked"
else
  bad "below: rc=$rc packs=$(packs) calls=$(tr '\n' ';' < "$TR/calls")"
fi

hr; echo "CASE — a failed compaction is advisory"; hr
: > "$TR/calls"; : > "$TR/fail-repack"
before="$(packs)"
rc=0
( export PATH="$TR/shim:$PATH" GARDEN_JOURNAL_AUTO_GC_PACK_LIMIT=2
  journal_auto_gc "$C" ) >/dev/null 2>"$TR/fail.err" || rc=$?
rm -f "$TR/fail-repack"
if [ "$rc" -eq 0 ] && [ "$(packs)" -eq "$before" ] \
   && grep -q 'journal auto-gc check failed.*rc=124' "$TR/fail.err"; then
  ok "repack rc=124 -> journal_auto_gc rc 0 with a WARN, clone untouched"
else
  bad "fail: rc=$rc packs=$(packs) stderr=$(tr '\n' ' ' < "$TR/fail.err")"
fi

hr; echo "CASE — over the limit, a geometric repack (never gc) folds the packs"; hr
printf 'loose\n' > "$C/loose"
git -C "$C" add loose   # one loose blob, as a small unpacked fetch leaves
: > "$TR/calls"
before="$(packs)"
rc=0
( export PATH="$TR/shim:$PATH" GARDEN_JOURNAL_AUTO_GC_PACK_LIMIT=2
  journal_auto_gc "$C" ) >/dev/null 2>"$TR/over.err" || rc=$?
loose="$(git -C "$C" count-objects -v | awk '$1=="count:"{print $2}')"
if [ "$rc" -eq 0 ] && grep -q -- '^repack .*--geometric' "$TR/calls" \
   && ! grep -q '^gc' "$TR/calls" && [ "$(packs)" -lt "$before" ] && [ "$loose" -eq 0 ] \
   && git -C "$C" fsck --no-progress >/dev/null 2>&1 \
   && [ "$(git -C "$C" rev-parse origin/journal2)" = "$(git -C "$RB" rev-parse journal2)" ]; then
  ok "$before -> $(packs) packs, loose folded, fsck clean"
else
  bad "over: rc=$rc packs=$before->$(packs) loose=$loose calls=$(tr '\n' ';' < "$TR/calls") stderr=$(tr '\n' ' ' < "$TR/over.err")"
fi

hr; echo "CASE — journal_fetch compacts after a successful fetch"; hr
grow_packs 4
: > "$TR/calls"
before="$(packs)"
rc=0
( export PATH="$TR/shim:$PATH" GARDEN_JOURNAL_AUTO_GC_PACK_LIMIT=2
  commit_n 1
  journal_fetch "$C" 0 ) >/dev/null 2>"$TR/fetch.err" || rc=$?
if [ "$rc" -eq 0 ] && grep -q -- '^repack .*--geometric' "$TR/calls" && [ "$(packs)" -lt "$before" ]; then
  ok "journal_fetch -> geometric repack ($before -> $(packs) packs)"
else
  bad "fetch: rc=$rc packs=$before->$(packs) calls=$(tr '\n' ';' < "$TR/calls") stderr=$(tr '\n' ' ' < "$TR/fetch.err")"
fi

hr; echo "RESULT: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
