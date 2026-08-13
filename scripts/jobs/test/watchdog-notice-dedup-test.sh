#!/bin/bash
# watchdog-notice-dedup-test.sh — the watchdog-notice coalescing contract.
#
# Regression for the 2026-07-28 maintainer-inbox flood: 147 of 291 unread
# maintainer messages were `watchdog:*` notices, 94 of them ONE condition (the
# provider's weekly quota refusing every `claude -p`). alert_maintainer throttled
# per key but posted a FRESH message every time the window reopened, so a
# long-running condition accumulated one message per key per hour and buried a
# blocked build, two halted orchestrations, and an access request underneath it.
#
# Asserts, on a throwaway journal with no network and no `claude -p`:
#   A. CONTROL (the pre-fix shape) — 11 posts of the same condition through
#      inbox-send.sh produce 11 unread messages.
#   B. COALESCE — 11 occurrences of the same condition through alert_maintainer
#      produce exactly ONE unread entry whose notice_count is 11, with first_seen
#      and last_seen frontmatter. Occurrences suppressed by the throttle are
#      folded into the next delivery, so the count is the OCCURRENCE count, not
#      the delivery count.
#   C. DISTINCT conditions still get distinct entries (dedup keys the condition,
#      not the sender).
#   D. FLEET-LEVEL QUOTA — a provider quota/usage-limit refusal observed by three
#      DIFFERENT units folds into ONE `provider-quota` entry (count 3), not three
#      per-unit reports, and the entry carries the reset clause.
#   E. RECOVERY — note_provider_ok closes the loop: the entry is amended with
#      `recovered: true`, and there is still exactly one entry. A recovery for a
#      condition that was never raised is a silent no-op.
#
# Usage: watchdog-notice-dedup-test.sh
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
BRANCH=journal2
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# Scrub ambient fleet env so a live gardener running this suite cannot splice the
# real journal/state under the fixture (the run-test.sh isolation rationale).
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_)' || true) 2>/dev/null || true
export GARDEN_TEST=1

# Not /tmp (noexec here) and not inside a git repo: same constraints as
# triager-test.sh, same remedy — a unique dir under the bot's real home.
TR="$(mktemp -d "$(dirname "$HOME")/.garden-watchdog-notice-test.XXXXXX")"
trap 'rm -rf "$TR"' EXIT
git_id=(-c user.name=test -c user.email=test@localhost)

# --- throwaway journal (the maintainer inbox lives here) ---------------------
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

# --- driver: call one common.sh helper in a fixture-scoped subshell ----------
DRIVER="$TR/drive.sh"
cat > "$DRIVER" <<EOF
#!/bin/bash
set -euo pipefail
source "$JOBS/common.sh"
GARDEN_TAG="\${GARDEN_TAG:-testwatch}"
case "\$1" in
  alert) alert_maintainer "\$2" "\$3" ;;
  clear) alert_maintainer_clear "\$2" "\${3:-}" ;;
  quota) note_provider_quota "\$2" "\$3" ;;
  ok)    note_provider_ok "\${2:-}" ;;
  send)  printf '%s\n' "\$3" | GARDEN_SKIP_REF_CHECK=1 GARDEN_SENDER="watchdog:\$2" "$JOBS/inbox-send.sh" maintainer >/dev/null ;;
esac
EOF
chmod +x "$DRIVER"

STATE="$TR/state"
drive() {  # drive [--throttle N] <verb> <args...>
  local throttle=3600
  if [ "$1" = --throttle ]; then throttle="$2"; shift 2; fi
  env GARDEN=testhost GARDEN_STATE="$STATE" \
      JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH" \
      GARDEN_ALERT_THROTTLE_SECS="$throttle" \
      "$DRIVER" "$@" >>"$TR/drive.out" 2>&1
}

# --- journal readers ---------------------------------------------------------
snap() {  # snap -> a fresh clone of the journal tip
  local d; d="$(mktemp -d "$TR/snap.XXXXXX")"
  git clone -q --single-branch --branch "$BRANCH" "$BARE" "$d" 2>/dev/null
  printf '%s' "$d"
}
unread_count() {
  local d n; d="$(snap)"
  n=$(ls -1 "$d/inbox/maintainer/unread" | grep -vxc '.gitkeep' || true); rm -rf "$d"; printf '%s' "$n"
}
field() {  # field <file-basename> <frontmatter-key>
  local d v=""; d="$(snap)"
  [ -f "$d/inbox/maintainer/unread/$1" ] && v="$(sed -n "s/^$2:[[:space:]]*//p" "$d/inbox/maintainer/unread/$1" | head -1)"
  rm -rf "$d"; printf '%s' "$v"
}
body_of() {  # body_of <file-basename>
  local d; d="$(snap)"; cat "$d/inbox/maintainer/unread/$1" 2>/dev/null; rm -rf "$d"
}
names() { local d; d="$(snap)"; ls -1 "$d/inbox/maintainer/unread" | grep -vx '.gitkeep' | sort; rm -rf "$d"; }

MSG='self-heal: garden-comment-watcher@kriscendobot-garden exited rc=1 with no scoped fix.'

# ============================================================================
hr; echo "A — CONTROL: the pre-fix path posts one message per occurrence"; hr
for i in $(seq 1 11); do drive send self-heal-claude "$MSG"; done
before="$(unread_count)"
[ "$before" -eq 11 ] && ok "control: 11 occurrences → $before unread messages (the flood)" \
  || bad "control produced $before unread messages (want 11)"

# ============================================================================
hr; echo "B — COALESCE: the same 11 occurrences produce ONE counted entry"; hr
seed_journal; rm -rf "$STATE"
# Occurrence 1 delivers (no marker yet); occurrences 2..10 are inside the 1h
# throttle window and are COUNTED locally, not delivered; occurrence 11 runs with
# the window elapsed (throttle 0) and folds the 9 suppressed ones plus itself.
drive alert self-heal-garden-comment-watcher "$MSG"
after1="$(unread_count)"
[ "$after1" -eq 1 ] && ok "first occurrence posts exactly one entry" || bad "first occurrence produced $after1 entries (want 1)"
for i in $(seq 2 10); do drive alert self-heal-garden-comment-watcher "$MSG"; done
[ "$(unread_count)" -eq 1 ] && ok "9 throttled occurrences add NO new entries" || bad "throttled occurrences added entries ($(unread_count) total)"
drive --throttle 0 alert self-heal-garden-comment-watcher "$MSG"
after="$(unread_count)"
FILE=watchdog-self-heal-garden-comment-watcher.md
[ "$after" -eq 1 ] && ok "after: 11 occurrences → $after unread entry (was $before)" || bad "coalesced path produced $after entries (want 1)"
[ "$(field "$FILE" notice_count)" = "11" ] && ok "notice_count is the OCCURRENCE count (11), not the delivery count (2)" \
  || bad "notice_count = $(field "$FILE" notice_count) (want 11)"
[ -n "$(field "$FILE" first_seen)" ] && ok "carries first_seen" || bad "no first_seen frontmatter"
[ -n "$(field "$FILE" last_seen)" ]  && ok "carries last_seen"  || bad "no last_seen frontmatter"
[ "$(field "$FILE" first_seen)" != "$(field "$FILE" last_seen)" ] || true   # same-second runs may tie; not asserted
grep -qi 'occurrence #11' <<<"$(body_of "$FILE")" && ok "body states the occurrence count in prose" || bad "body does not state the occurrence count"
grep -q "$MSG" <<<"$(body_of "$FILE")" && ok "body carries the LATEST detail" || bad "body lost the latest detail"

# ============================================================================
hr; echo "C — DISTINCT conditions keep distinct entries"; hr
drive --throttle 0 alert triager-fetch-failed-kriscendobot-endo "triager: fetch for kriscendobot-endo failed (rc=128)."
[ "$(unread_count)" -eq 2 ] && ok "a different condition gets its own entry (2 total)" || bad "distinct condition did not get its own entry ($(unread_count) total)"
names | grep -qx watchdog-triager-fetch-failed-kriscendobot-endo.md \
  && ok "the second entry is keyed by its own condition" || bad "second entry not keyed by condition: $(names | tr '\n' ' ')"

# ============================================================================
hr; echo "D — FLEET-LEVEL: a provider quota refusal folds ACROSS units"; hr
seed_journal; rm -rf "$STATE"
QUOTA="You've hit your weekly limit · resets 4:10pm (UTC)"
# Three DIFFERENT units trip the same account limit. Pre-fix these were three
# per-unit reports; the classifier re-keys them to one fleet condition.
drive --throttle 0 alert self-heal-garden-issue-inbox   "self-heal: garden-issue-inbox exited rc=1 with no scoped fix. Diagnosis: $QUOTA"
drive --throttle 0 alert self-heal-garden-comment-watcher "self-heal: garden-comment-watcher exited rc=1 with no scoped fix. Diagnosis: $QUOTA"
drive --throttle 0 quota garden-foreman "$QUOTA"
QFILE=watchdog-provider-quota.md
[ "$(unread_count)" -eq 1 ] && ok "three units, ONE fleet-level entry" || bad "quota produced $(unread_count) entries (want 1): $(names | tr '\n' ' ')"
names | grep -qx "$QFILE" && ok "the entry is keyed 'provider-quota', not per-unit" || bad "entry not keyed provider-quota: $(names | tr '\n' ' ')"
[ "$(field "$QFILE" notice_count)" = "3" ] && ok "notice_count counts all three observations" || bad "notice_count = $(field "$QFILE" notice_count) (want 3)"
qbody="$(body_of "$QFILE")"
grep -qi 'resets 4:10pm' <<<"$qbody" && ok "the notice names the reset time" || bad "notice omits the reset clause"
grep -q 'limit_type: weekly' <<<"$qbody" && ok "the notice carries the extracted weekly limit type" || bad "notice omits the weekly limit type"
grep -qi 'ACCOUNT LIMIT' <<<"$qbody" && ok "the notice says this is an account limit, not a garden defect" || bad "notice does not classify the condition"
grep -qi 'restore' <<<"$qbody" && ok "the notice points at the restore skill" || bad "notice omits the operational response"

# ============================================================================
hr; echo "E — RECOVERY closes the loop"; hr
drive --throttle 0 ok garden-comment-watcher
[ "$(unread_count)" -eq 1 ] && ok "recovery amends the open entry (still 1)" || bad "recovery added an entry ($(unread_count) total)"
[ "$(field "$QFILE" recovered)" = "true" ] && ok "the entry is marked recovered" || bad "entry not marked recovered"
grep -qi 'RECOVERED' <<<"$(body_of "$QFILE")" && ok "the body states the condition cleared" || bad "body does not state the recovery"
grep -qi 'observed 3 time' <<<"$(body_of "$QFILE")" && ok "the recovery reports how many occurrences it covered" || bad "recovery omits the occurrence total"
# A second recovery, and a recovery for a condition never raised, are silent.
drive --throttle 0 ok garden-comment-watcher
drive --throttle 0 clear never-raised-condition
[ "$(unread_count)" -eq 1 ] && ok "a repeat/never-raised recovery is a silent no-op" || bad "spurious recovery notice posted ($(unread_count) total)"

hr
echo "watchdog-notice-dedup: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
