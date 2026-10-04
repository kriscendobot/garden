#!/bin/bash
# main-host-test.sh — leader/follower (multibot) coverage.
#
# Covers issue kriskowal/garden#11: the GARDEN host-identity knob, the
# is-main-host predicate (journal marker read, GARDEN override, TTL cache, fail
# open/closed, the single-flight leader-fetch outage backoff), set-main-host.sh,
# and the systemd gating (every singleton service carries
# ExecCondition=is-main-host.sh; gardeners do NOT). No real systemd or
# network: a throwaway bare journal2 stands in for the shared origin.
#
# Usage: main-host-test.sh
set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
ROOT="$(cd "$JOBS/../.." && pwd)"
SRC="$ROOT/scripts/systemd"
IMH="$JOBS/is-main-host.sh"
SMH="$JOBS/set-main-host.sh"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# Scrub any ambient fleet env so the test's throwaway settings are authoritative.
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN|JOURNAL_)' || true) 2>/dev/null || true

TR=/home/kris/.garden-mainhost-test
rm -rf "$TR"; mkdir -p "$TR"
BARE="$TR/journal.git"; BRANCH=journal2

# --- seed a bare journal2 with the root `leader` marker = leaderhost ---------
git init -q --bare "$BARE"
SEED="$TR/seed"; git init -q "$SEED"; git -C "$SEED" checkout -q -b "$BRANCH"
( cd "$SEED"; printf 'leaderhost\n' > leader; mkdir -p hosts; touch hosts/.gitkeep )
git -C "$SEED" add -A
git -C "$SEED" -c user.name=t -c user.email=t@l commit -q -m seed
git -C "$SEED" remote add origin "$BARE"
git -C "$SEED" push -q -u origin "$BRANCH"

export JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH"

# ============================================================================
hr; echo "STATIC — scripts parse"; hr
for s in "$JOBS/common.sh" "$IMH" "$SMH"; do
  bash -n "$s" && ok "$(basename "$s") parses" || bad "$(basename "$s") syntax error"
done

# ============================================================================
hr; echo "GARDEN KNOB — the single host-identity var; defaults to hostname -s"; hr
gh_of() { env "$@" bash -c "source '$JOBS/common.sh'; printf '%s' \"\$GARDEN\""; }
[ "$(gh_of GARDEN=knobhost)" = knobhost ] \
  && ok "explicit GARDEN=knobhost is honored" \
  || bad "GARDEN not honored (got '$(gh_of GARDEN=knobhost)')"
hn="$(hostname -s 2>/dev/null || echo host)"
[ "$(gh_of)" = "$hn" ] \
  && ok "unset GARDEN falls back to hostname -s ($hn)" \
  || bad "fallback wrong (got '$(gh_of)', want '$hn')"

# ============================================================================
hr; echo "PREDICATE — journal marker read decides leader vs follower"; hr
run_imh() { env JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH" GARDEN_STATE="$1" \
                GARDEN="$2" GARDEN_NO_MAINTAINER_ALERT=1 "$IMH" >/dev/null 2>&1; echo $?; }
[ "$(run_imh "$TR/st-leader" leaderhost)" = 0 ] \
  && ok "is-main-host exits 0 on the journal-named leader (leaderhost)" \
  || bad "leader not recognized"
[ "$(run_imh "$TR/st-follow" otherhost)" = 1 ] \
  && ok "is-main-host exits 1 on a follower (otherhost)" \
  || bad "follower not recognized"
# GARDEN is what the predicate compares against the journal `leader` marker.
garden_imh="$(env JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH" GARDEN_STATE="$TR/st-g" \
                  GARDEN=leaderhost GARDEN_NO_MAINTAINER_ALERT=1 "$IMH" >/dev/null 2>&1; echo $?)"
[ "$garden_imh" = 0 ] && ok "GARDEN=leaderhost matches journal leader → leader" || bad "GARDEN knob not honored by predicate"

# ============================================================================
hr; echo "OVERRIDE + DEFAULTS — env short-circuit, fail-open, fail-closed"; hr
ov="$(env GARDEN_LEADER=zz GARDEN=zz GARDEN_STATE="$TR/st-ov" "$IMH" >/dev/null 2>&1; echo $?)"
[ "$ov" = 0 ] && ok "GARDEN_LEADER env short-circuits the journal read" || bad "env override not honored ($ov)"
# Undeterminable (dead remote, no cache): default leader = fail open.
fo="$(env JOURNAL_REMOTE="$TR/nope.git" GARDEN_STATE="$TR/st-fo" GARDEN=x \
          GARDEN_NO_MAINTAINER_ALERT=1 "$IMH" >/dev/null 2>&1; echo $?)"
[ "$fo" = 0 ] && ok "undeterminable leader → fail open (default leader)" || bad "fail-open default wrong ($fo)"
fc="$(env JOURNAL_REMOTE="$TR/nope.git" GARDEN_STATE="$TR/st-fc" GARDEN=x \
          GARDEN_LEADER_DEFAULT=follower GARDEN_NO_MAINTAINER_ALERT=1 "$IMH" >/dev/null 2>&1; echo $?)"
[ "$fc" = 1 ] && ok "GARDEN_LEADER_DEFAULT=follower → fail closed" || bad "fail-closed default wrong ($fc)"

# ============================================================================
hr; echo "TTL CACHE — a fresh read survives a later journal outage"; hr
# Prime the cache from the live journal, then point at a DEAD remote: the cached
# leader value must still classify correctly (transient-outage resilience).
CST="$TR/st-cache"
env JOURNAL_REMOTE="$BARE" GARDEN_STATE="$CST" GARDEN=leaderhost GARDEN_NO_MAINTAINER_ALERT=1 "$IMH" >/dev/null 2>&1
[ -f "$CST/leader/cached" ] && ok "first read primes the host-local cache" || bad "cache not written"
# TTL=99999 forces the cache path; dead remote proves no fresh read is needed.
cached="$(env JOURNAL_REMOTE="$TR/dead.git" GARDEN_STATE="$CST" GARDEN=leaderhost \
               GARDEN_LEADER_TTL=99999 GARDEN_NO_MAINTAINER_ALERT=1 "$IMH" >/dev/null 2>&1; echo $?)"
[ "$cached" = 0 ] && ok "cached leader value classifies during a journal outage (no fresh read)" || bad "cache fallback failed ($cached)"

# ============================================================================
hr; echo "OUTAGE BACKOFF — one bounded leader probe per interval, shared by callers"; hr
# A git shim counts journal fetches so the test can prove concurrent callers during
# an open leader-fetch outage reuse the cached leader instead of each probing.
SHIM="$TR/shim"; mkdir -p "$SHIM"; FETCHES="$TR/fetches"; : > "$FETCHES"
# Target the real binary, never the fleet wrapper: the wrapper picks the first
# non-wrapper git on PATH (this shim) as "real", so shim→wrapper would loop.
REALGIT=""
IFS=: read -ra _pd <<< "$PATH"
for d in "${_pd[@]}"; do
  case "$d" in */scripts/jobs/bin) continue ;; esac
  [ -x "$d/git" ] && { REALGIT="$d/git"; break; }
done

# The leader-marker read uses journal_fetch's bounded retry behavior before it
# opens a stale-cache fallback episode. Inject one transient failure followed by
# a real successful fetch and prove that no fallback warning or marker appears.
RETRY_FETCH="$TR/retry-fetch"; RETRY_COUNT="$TR/retry-fetches"; : > "$RETRY_COUNT"
cat > "$RETRY_FETCH" <<SH
#!/bin/bash
n=\$(stat -c %s "$RETRY_COUNT" 2>/dev/null || echo 0)
printf '.' >> "$RETRY_COUNT"
[ "\$n" -eq 0 ] && exit 1
exec "$REALGIT" -C "\$GARDEN_FETCH_DIR" fetch -q origin "\$JOURNAL_BRANCH"
SH
chmod +x "$RETRY_FETCH"
RST="$TR/st-retry"; : > "$TR/retry.err"
rc="$(env JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH" GARDEN_STATE="$RST" \
          GARDEN=leaderhost GARDEN_NO_MAINTAINER_ALERT=1 GARDEN_FETCH_RETRIES=2 \
          GARDEN_FETCH_CMD="$RETRY_FETCH" "$IMH" 2>"$TR/retry.err" >/dev/null; echo $?)"
{ [ "$rc" = 0 ] && [ "$(stat -c %s "$RETRY_COUNT")" = 2 ] \
    && [ -f "$RST/leader/cached" ] && [ ! -e "$RST/leader/retry-at" ] \
    && [ ! -e "$RST/fallback-warn/leader-fetch" ] \
    && ! grep -q 'leader fetch failed' "$TR/retry.err"; } \
  && ok "transient first leader fetch failure retries successfully without warning" \
  || bad "transient leader fetch did not recover cleanly (rc=$rc fetches=$(stat -c %s "$RETRY_COUNT") stderr=$(cat "$TR/retry.err"))"

cat > "$SHIM/git" <<SH
#!/bin/bash
for a in "\$@"; do [ "\$a" = fetch ] && { printf '.' >> "$FETCHES"; break; }; done
exec "$REALGIT" "\$@"
SH
chmod +x "$SHIM/git"
nfetch() { stat -c %s "$FETCHES" 2>/dev/null || echo 0; }
BST="$TR/st-backoff"; MARK="$BST/leader/retry-at"
bimh() {  # bimh <remote> [env...] — is-main-host as leaderhost on the shared state
  local r="$1"; shift
  env PATH="$SHIM:$PATH" JOURNAL_REMOTE="$r" JOURNAL_BRANCH="$BRANCH" GARDEN_STATE="$BST" \
      GARDEN=leaderhost GARDEN_NO_MAINTAINER_ALERT=1 GARDEN_LEADER_RETRY_BACKOFF=600 \
      GARDEN_FETCH_RETRIES=1 "$@" \
      "$IMH" 2>>"$TR/backoff.err" >/dev/null
  echo $?
}
bimh "$BARE" >/dev/null
[ -f "$BST/leader/cached" ] && [ ! -e "$MARK" ] \
  && ok "healthy fetch primes the cache and leaves no retry marker" || bad "healthy prime wrong"
# Break the journal (the clone's origin no longer resolves) and age the cache past TTL.
mv "$BARE" "$BARE.away"; touch -d '1 hour ago' "$BST/leader/cached"
: > "$FETCHES"
rc="$(bimh "$BARE")"
{ [ "$rc" = 0 ] && [ "$(nfetch)" = 1 ] && [ -s "$MARK" ]; } \
  && ok "failed fetch answers from the last-known leader and arms the retry marker" \
  || bad "first outage probe wrong (rc=$rc fetches=$(nfetch) marker=$(cat "$MARK" 2>/dev/null))"
: > "$FETCHES"; : > "$TR/rcs"
for _ in 1 2 3 4 5 6 7 8; do ( bimh "$BARE" >> "$TR/rcs" ) & done; wait
{ [ "$(nfetch)" = 0 ] && [ "$(sort -u "$TR/rcs")" = 0 ] && [ "$(wc -l < "$TR/rcs")" = 8 ]; } \
  && ok "8 concurrent callers before the probe is due: 0 fetches, all reuse the cached leader" \
  || bad "backoff not honored (fetches=$(nfetch) rcs=$(tr '\n' ' ' < "$TR/rcs"))"
# Make the probe due: exactly one of a concurrent herd may claim it.
printf '%s\n' "$(( $(date +%s) - 1 ))" > "$MARK"
: > "$FETCHES"; : > "$TR/rcs"
for _ in 1 2 3 4 5 6 7 8; do ( bimh "$BARE" >> "$TR/rcs" ) & done; wait
{ [ "$(nfetch)" = 1 ] && [ "$(sort -u "$TR/rcs")" = 0 ]; } \
  && ok "8 concurrent callers once the probe is due: exactly 1 bounded fetch" \
  || bad "due probe not single-flight (fetches=$(nfetch) rcs=$(tr '\n' ' ' < "$TR/rcs"))"
due="$(head -1 "$MARK" 2>/dev/null)"
[ "${due:-0}" -gt "$(date +%s)" ] \
  && ok "the failed due probe re-arms the marker one backoff out" || bad "marker not re-armed ($due)"
# A garbage/far-future due time (clock step) must not wedge probing off.
printf '%s\n' "$(( $(date +%s) + 999999 ))" > "$MARK"; : > "$FETCHES"
bimh "$BARE" >/dev/null
[ "$(nfetch)" = 1 ] && ok "a due time beyond one backoff counts as due (no wedge)" \
  || bad "far-future marker wedged probing (fetches=$(nfetch))"
# Persistent-failure escalation is retained: an episode older than the bound
# escalates to ERROR on the next due probe.
printf '%s\n' "$(( $(date +%s) - 1 ))" > "$MARK"
printf '%s\n' "$(( $(date +%s) - 120 ))" > "$BST/fallback-warn/leader-fetch/first"
: > "$TR/backoff.err"
bimh "$BARE" GARDEN_FALLBACK_ESCALATE_AFTER=60 >/dev/null
grep -q 'ERROR: leader fetch failed.*fallback persistent' "$TR/backoff.err" \
  && ok "persistent outage still escalates once to ERROR" \
  || bad "escalation lost ($(cat "$TR/backoff.err"))"
# Recovery: journal back, probe due → fetch succeeds, marker and episode cleared.
mv "$BARE.away" "$BARE"
printf '%s\n' "$(( $(date +%s) - 1 ))" > "$MARK"; : > "$FETCHES"; : > "$TR/backoff.err"
rc="$(bimh "$BARE")"
{ [ "$rc" = 0 ] && [ "$(nfetch)" = 1 ] && [ ! -e "$MARK" ] && [ ! -e "$BST/fallback-warn/leader-fetch" ]; } \
  && ok "recovery: successful fetch clears the retry marker and closes the episode" \
  || bad "recovery wrong (rc=$rc fetches=$(nfetch) marker=$([ -e "$MARK" ] && echo yes))"
grep -q 'recovered: leader-fetch' "$TR/backoff.err" \
  && ok "recovery logs one recovered line" || bad "no recovery line"
touch -d '1 hour ago' "$BST/leader/cached"; : > "$FETCHES"
bimh "$BARE" >/dev/null
[ "$(nfetch)" = 1 ] && ok "after recovery a stale cache fetches normally again" \
  || bad "post-recovery fetch suppressed (fetches=$(nfetch))"

# ============================================================================
hr; echo "SET-MAIN-HOST — CAS-writes the journal \`leader\` marker; predicate flips"; hr
SST="$TR/st-set"
env JOURNAL_REMOTE="$BARE" GARDEN_STATE="$SST" GARDEN=newleader GARDEN_NO_MAINTAINER_ALERT=1 \
    "$SMH" newleader >/dev/null 2>&1 && ok "set-main-host.sh ran" || bad "set-main-host.sh failed"
V="$TR/verify"; git clone -q --single-branch --branch "$BRANCH" "$BARE" "$V"
[ "$(head -1 "$V/leader" | tr -d '[:space:]')" = newleader ] \
  && ok "journal leader marker now names newleader" || bad "marker not updated ($(cat "$V/leader" 2>/dev/null))"
# Predicate now flips: newleader is leader, the OLD leaderhost is a follower.
nl="$(env JOURNAL_REMOTE="$BARE" GARDEN_STATE="$TR/st-nl" GARDEN=newleader GARDEN_NO_MAINTAINER_ALERT=1 "$IMH" >/dev/null 2>&1; echo $?)"
ol="$(env JOURNAL_REMOTE="$BARE" GARDEN_STATE="$TR/st-ol" GARDEN=leaderhost GARDEN_NO_MAINTAINER_ALERT=1 "$IMH" >/dev/null 2>&1; echo $?)"
{ [ "$nl" = 0 ] && [ "$ol" = 1 ]; } \
  && ok "after re-designation: newleader=leader, leaderhost=follower (manual leadership)" \
  || bad "predicate did not flip (newleader=$nl leaderhost=$ol)"

# ============================================================================
hr; echo "UNIT GATING — every singleton service carries the ExecCondition"; hr
SINGLETONS=(garden-foreman garden-scheduler garden-bulletin garden-deadmail garden-reaper
            garden-deadline-nudge garden-follow-up garden-proxy garden-mentor garden-mirror-closer
            garden-comment-watcher@ garden-mention-watcher garden-triager@
            garden-issue-inbox garden-library-source-drift-scan)
# The bulletin is a CONTINUOUS singleton gated IN-PROCESS, not via ExecCondition:
# assert its in-loop gate instead.
for u in "${SINGLETONS[@]}"; do
  f="$SRC/$u.service"; [ -e "$f" ] || { bad "$u.service missing"; continue; }
  if [ "$u" = garden-bulletin ]; then
    grep -q 'is_main_host' "$JOBS/bulletin.sh" \
      && ok "garden-bulletin gated in-process (is_main_host in bulletin.sh loop)" \
      || bad "garden-bulletin has no in-process leader gate"
    continue
  fi
  cond="$(grep -n '^ExecCondition=/bin/bash .*is-main-host.sh' "$f" | head -1 | cut -d: -f1)"
  exec="$(grep -n '^ExecStart=' "$f" | head -1 | cut -d: -f1)"
  if [ -n "$cond" ] && [ -n "$exec" ] && [ "$cond" -lt "$exec" ]; then
    ok "$u.service: ExecCondition=is-main-host.sh precedes ExecStart"
  else
    bad "$u.service: missing/misordered ExecCondition (cond=$cond exec=$exec)"
  fi
done
# The watchman broadcast is leader-gated in-process (ff/maintenance stays every-host).
grep -q 'is_main_host' "$JOBS/watchman.sh" \
  && ok "watchman broadcast gated in-process (ff/maintenance stays every-host)" \
  || bad "watchman has no in-process broadcast gate"

# ============================================================================
hr; echo "EVERY-HOST — gardeners and local-infra are NOT gated"; hr
for u in garden-monk@ garden-gardener-scaler garden-upgrade-monitor \
         garden-clone-keeper garden-journal-worktree-keeper garden-state-clone-keeper \
         garden-worktree-sweeper garden-sysop garden-repo-watcher garden-unblock; do
  f="$SRC/$u.service"; [ -e "$f" ] || { ok "$u.service absent (nothing to gate)"; continue; }
  # Match an EXECUTABLE ExecCondition directive, not a mere comment mention: the
  # worktree-sweeper and sysop units both explain in a comment WHY they omit the
  # leader gate, and that prose must not read as the gate itself.
  grep -qE '^ExecCondition=/bin/bash .*is-main-host.sh' "$f" \
    && bad "$u.service is leader-gated (should run on every host)" \
    || ok "$u.service NOT gated (every-host)"
done

hr; echo "RESULT: $PASS passed, $FAIL failed"; hr
rm -rf "$TR"
[ "$FAIL" -eq 0 ]
