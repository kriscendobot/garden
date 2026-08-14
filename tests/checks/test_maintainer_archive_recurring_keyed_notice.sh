#!/bin/bash
# test_maintainer_archive_recurring_keyed_notice.sh — maintainer-archive.sh must
# be able to archive a RECURRING, dedup-keyed maintainer notice.
#
# Regression for the 2026-08-14 wedge: watchdog/reaper notices use STABLE,
# dedup-keyed filenames (one keyed message per open condition — see
# designs/watchdog-notice-dedup.md). The old archive did a bare `git mv
# unread/<key>.md read/<key>.md`, which refuses forever once the condition
# re-opens after a prior archive: read/<key>.md already exists, so `git mv`
# fatals and no retry in the 50-attempt loop can ever succeed. Seven keyed names
# were stuck in BOTH unread/ and read/ the day this was found.
#
# Asserts, on a throwaway journal with no network:
#   A. FIRST archive of a keyed notice lands read/<key>.md (unchanged behavior).
#   B. RE-OPEN + re-archive of the SAME key SUCCEEDS (the wedge is gone) and
#      PRESERVES the earlier archived copy (recurrence is history worth keeping):
#      read/ now holds two files, both derived from the key.
#   C. A THIRD occurrence still archives — no cap, no collision.
#
# Usage: test_maintainer_archive_recurring_keyed_notice.sh
set -uo pipefail

HARNESS_DIR=$(cd "$(dirname "$0")" && pwd)
PROJECT_ROOT=$(cd "$HARNESS_DIR/../.." && pwd)
JOBS="$PROJECT_ROOT/scripts/jobs"
ARCHIVE="$JOBS/maintainer-archive.sh"
BRANCH=journal2

PASS=0; FAIL=0
ok()  { PASS=$((PASS+1)); echo "  PASS: $1"; }
ko()  { FAIL=$((FAIL+1)); echo "  FAIL: $1"; }

echo "=== test_maintainer_archive_recurring_keyed_notice ==="
[ -f "$ARCHIVE" ] || { echo "missing $ARCHIVE"; exit 2; }

# Scrub ambient fleet env so a live gardener running this suite cannot splice the
# real journal/state under the fixture (the run-test.sh isolation rationale).
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_)' || true) 2>/dev/null || true
export GARDEN_TEST=1

# Not /tmp (may be noexec here) and not inside a git repo: a unique dir under the
# bot's real home, mirroring watchdog-notice-dedup-test.sh.
TR="$(mktemp -d "$(dirname "$HOME")/.garden-maint-archive-test.XXXXXX")"
trap 'rm -rf "$TR"' EXIT
git_id=(-c user.name=test -c user.email=test@localhost)

BARE="$TR/journal.git"
seed_journal() {
  rm -rf "$BARE"
  git init -q --bare "$BARE"
  local seed; seed="$(mktemp -d "$TR/seed.XXXXXX")"
  git init -q "$seed"; git -C "$seed" checkout -q -b "$BRANCH"
  ( cd "$seed"
    mkdir -p inbox/maintainer/unread inbox/maintainer/read
    touch inbox/maintainer/unread/.gitkeep inbox/maintainer/read/.gitkeep )
  git -C "$seed" add -A; git -C "$seed" "${git_id[@]}" commit -q -m seed
  git -C "$seed" remote add origin "$BARE"; git -C "$seed" push -q -u origin "$BRANCH"
  rm -rf "$seed"
}
seed_journal

STATE="$TR/state"

# Push a keyed notice into unread/<key>.md with a given last_seen timestamp
# (the recurrence marker maintainer-archive.sh uses to disambiguate archives).
KEY="watchdog-triager-upstream-gone-kriscendobot-list.md"
post_notice() {  # post_notice <last_seen>
  local d; d="$(mktemp -d "$TR/post.XXXXXX")"
  git clone -q --single-branch --branch "$BRANCH" "$BARE" "$d"
  {
    printf -- '---\n'
    printf 'from: watchdog:triager/kriscendobot-list\n'
    printf 'notice_count: 1\n'
    printf 'first_seen: %s\n' "$1"
    printf 'last_seen: %s\n---\n' "$1"
    printf 'triager: upstream for kriscendobot/list is gone.\n'
  } > "$d/inbox/maintainer/unread/$KEY"
  git -C "$d" add -A; git -C "$d" "${git_id[@]}" commit -q -m "post $1"
  git -C "$d" push -q origin "$BRANCH"
  rm -rf "$d"
}

archive() {  # run the tool under test against the fixture journal
  env GARDEN=testhost GARDEN_STATE="$STATE" \
      JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH" \
      bash "$ARCHIVE" "$KEY" >>"$TR/archive.out" 2>&1
}

# journal readers (fresh clone of tip each time)
snap() { local d; d="$(mktemp -d "$TR/snap.XXXXXX")"; git clone -q --single-branch --branch "$BRANCH" "$BARE" "$d" 2>/dev/null; printf '%s' "$d"; }
unread_present() { local d; d="$(snap)"; [ -e "$d/inbox/maintainer/unread/$KEY" ] && { rm -rf "$d"; return 0; }; rm -rf "$d"; return 1; }
read_count() { local d n; d="$(snap)"; n=$(ls -1 "$d/inbox/maintainer/read" | grep -vxc '.gitkeep' || true); rm -rf "$d"; printf '%s' "$n"; }
read_names() { local d; d="$(snap)"; ls -1 "$d/inbox/maintainer/read" | grep -vx '.gitkeep' | sort; rm -rf "$d"; }

# --- A. first archive: unchanged behavior, lands read/<key>.md ---------------
post_notice 2026-08-14T05:00:00Z
if archive; then ok "first archive of a keyed notice succeeds"; else ko "first archive failed (see $TR/archive.out)"; fi
unread_present && ko "unread copy still present after archive" || ok "unread copy removed"
[ "$(read_count)" -eq 1 ] && ok "read/ holds exactly one archived copy" || ko "read/ holds $(read_count) copies (want 1)"
read_names | grep -qx "$KEY" && ok "first copy is read/<key>.md (unchanged path)" || ko "first copy not at read/<key>.md: $(read_names | tr '\n' ' ')"

# --- B. condition RE-OPENS: same key, must archive AND preserve prior copy ---
post_notice 2026-08-14T09:30:00Z
unread_present || ko "precondition: recurrence did not re-create the unread notice"
if archive; then ok "re-archiving the RECURRING keyed notice succeeds (wedge is gone)"; else ko "re-archive FAILED — the bare-git-mv collision (see $TR/archive.out)"; fi
unread_present && ko "unread copy still present after re-archive" || ok "second unread copy removed"
[ "$(read_count)" -eq 2 ] && ok "both archived copies preserved (recurrence is history)" || ko "read/ holds $(read_count) copies (want 2): $(read_names | tr '\n' ' ')"
read_names | grep -qx "$KEY" && ok "the original read/<key>.md is untouched" || ko "original archived copy was clobbered: $(read_names | tr '\n' ' ')"
# the second copy is disambiguated by the recurrence timestamp, still under the key stem
read_names | grep -q '^watchdog-triager-upstream-gone-kriscendobot-list\..*\.md$' \
  && ok "second copy is disambiguated (read/<stem>.<ts>.md)" \
  || ko "no disambiguated second copy: $(read_names | tr '\n' ' ')"

# --- C. a THIRD occurrence still archives cleanly ----------------------------
post_notice 2026-08-14T14:15:00Z
if archive; then ok "a third recurrence archives cleanly"; else ko "third archive failed (see $TR/archive.out)"; fi
[ "$(read_count)" -eq 3 ] && ok "read/ holds three distinct archived copies" || ko "read/ holds $(read_count) copies (want 3): $(read_names | tr '\n' ' ')"

echo "=== test_maintainer_archive_recurring_keyed_notice: $PASS passed, $FAIL failed ==="
[ "$FAIL" -gt 0 ] && exit 1
exit 0
