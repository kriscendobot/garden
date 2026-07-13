#!/bin/bash
# bot-identity-bootstrap-test.sh — the durable bot git identity, on throwaway
# fixtures, no GitHub. Simulates a garden RESET (local .git/config unset) and
# asserts the identity self-restores.
#
# Asserts:
#   A. fresh repo, config UNSET, no journal → bootstrap restores the tracked
#      canonical default (Kriscendo Bot / the kriscendobot noreply email).
#   B. bootstrap is idempotent (a second run is a no-op, config unchanged).
#   C. bot_name()/bot_email() SELF-HEAL: with the config unset they resolve to the
#      tracked default (never garden-bot).
#   D. a PER-HOST journal override (identity/<host>) WINS over the tracked default.
#   E. an unknown GARDEN_BOT_LOGIN (absent from the table) still yields a plausible
#      bot identity (login as name, login@users.noreply email), never garden-bot.
#   F. the per-job worktree PIN reproduces the restored identity — a checkout
#      configured with bot_name()/bot_email() (exactly what ensure-project-worktree
#      does) carries the same user.name/user.email.

set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
TR=/home/kris/.garden-test-botid
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# Hermetic baseline: scrub any ambient fleet GARDEN_*/JOURNAL_* that a live gardener
# running this as a board job would export (see run-test.sh for the rationale).
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_)' || true) 2>/dev/null || true
export GARDEN_TEST=1

rm -rf "$TR"; mkdir -p "$TR"
git_id=(-c user.name=seed -c user.email=seed@localhost)

# --- a throwaway garden root (GARDEN_ROOT override) with the tracked table -----
ROOT="$TR/root"
mkdir -p "$ROOT/scripts/jobs"
git init -q "$ROOT"
cp "$JOBS/bot-identity-defaults.tsv" "$ROOT/scripts/jobs/bot-identity-defaults.tsv"

CANON_NAME="Kriscendo Bot"
CANON_EMAIL="279080640+kriscendobot@users.noreply.github.com"

# Common env for every invocation: the throwaway root + isolated state. The REAL
# bootstrap/common.sh are used (HERE=real scripts/jobs), but GARDEN_ROOT is the
# override, so the tracked-defaults lookup and the git config writes all land on
# the throwaway repo — never the real garden.
be() { env GARDEN_ROOT="$ROOT" GARDEN_STATE="$TR/state" GARDEN="testhost" "$@"; }

get_name()  { git -C "$ROOT" config --get user.name  2>/dev/null || true; }
get_email() { git -C "$ROOT" config --get user.email 2>/dev/null || true; }

# ============================================================================
hr; echo "A — fresh reset (config unset, no journal) → tracked canonical default"; hr
git -C "$ROOT" config --unset-all user.name  2>/dev/null || true
git -C "$ROOT" config --unset-all user.email 2>/dev/null || true
be GARDEN_BOOTSTRAP_SKIP_JOURNAL=1 "$JOBS/bootstrap-bot-identity.sh" >/dev/null 2>&1
{ [ "$(get_name)" = "$CANON_NAME" ] && [ "$(get_email)" = "$CANON_EMAIL" ]; } \
  && ok "restored '$CANON_NAME' <$CANON_EMAIL>" \
  || bad "restore wrong (name='$(get_name)' email='$(get_email)')"

# ============================================================================
hr; echo "B — idempotent: a second run is a no-op"; hr
out="$(be GARDEN_BOOTSTRAP_SKIP_JOURNAL=1 "$JOBS/bootstrap-bot-identity.sh" 2>&1)"
{ [ "$(get_name)" = "$CANON_NAME" ] && [ "$(get_email)" = "$CANON_EMAIL" ]; } \
  && ok "config unchanged on re-run" || bad "config drifted on re-run"
grep -q 'already correct' <<<"$out" \
  && ok "reported 'already correct' (no write)" || bad "did not report no-op ($out)"

# ============================================================================
hr; echo "C — bot_name()/bot_email() self-heal to the tracked default"; hr
git -C "$ROOT" config --unset-all user.name  2>/dev/null || true
git -C "$ROOT" config --unset-all user.email 2>/dev/null || true
hn="$(be bash -c 'source "'"$JOBS"'/common.sh"; bot_name')"
he="$(be bash -c 'source "'"$JOBS"'/common.sh"; bot_email')"
{ [ "$hn" = "$CANON_NAME" ] && [ "$he" = "$CANON_EMAIL" ]; } \
  && ok "unset config self-heals to '$hn' <$he> (not garden-bot)" \
  || bad "self-heal wrong (name='$hn' email='$he')"

# ============================================================================
hr; echo "D — per-host journal override WINS over the tracked default"; hr
# Seed a throwaway bare journal carrying identity/testhost, point the producer
# clone at it, and run WITHOUT skip-journal. ensure_clone/sync_clone read it.
BARE="$TR/journal.git"; git init -q --bare "$BARE"
SEED="$TR/seed"; git init -q "$SEED"; git -C "$SEED" checkout -q -b journal2
mkdir -p "$SEED/identity"
OVR_NAME="Override Bot"; OVR_EMAIL="override@users.noreply.github.com"
printf 'bot_name: %s\nbot_email: %s\n' "$OVR_NAME" "$OVR_EMAIL" > "$SEED/identity/testhost"
git -C "$SEED" add -A; git -C "$SEED" "${git_id[@]}" commit -q -m "seed identity override"
git -C "$SEED" remote add origin "$BARE"; git -C "$SEED" push -q -u origin journal2
git -C "$ROOT" config --unset-all user.name  2>/dev/null || true
git -C "$ROOT" config --unset-all user.email 2>/dev/null || true
be JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH=journal2 \
   GARDEN_PRODUCER_CLONE="$TR/pclone" \
   "$JOBS/bootstrap-bot-identity.sh" >/dev/null 2>&1
{ [ "$(get_name)" = "$OVR_NAME" ] && [ "$(get_email)" = "$OVR_EMAIL" ]; } \
  && ok "override '$OVR_NAME' <$OVR_EMAIL> applied ahead of the canonical default" \
  || bad "override not applied (name='$(get_name)' email='$(get_email)')"

# ============================================================================
hr; echo "E — unknown login → plausible identity, never garden-bot"; hr
git -C "$ROOT" config --unset-all user.name  2>/dev/null || true
git -C "$ROOT" config --unset-all user.email 2>/dev/null || true
be GARDEN_BOT_LOGIN=someotherbot GARDEN_BOOTSTRAP_SKIP_JOURNAL=1 \
   "$JOBS/bootstrap-bot-identity.sh" >/dev/null 2>&1
{ [ "$(get_name)" = "someotherbot" ] && [ "$(get_email)" = "someotherbot@users.noreply.github.com" ]; } \
  && ok "unknown login → 'someotherbot' <someotherbot@users.noreply.github.com>" \
  || bad "unknown-login fallback wrong (name='$(get_name)' email='$(get_email)')"
[ "$(get_name)" = "garden-bot" ] && bad "fell back to garden-bot" || ok "never garden-bot"

# ============================================================================
hr; echo "F — per-job worktree pin reproduces the restored identity"; hr
# Re-restore the canonical identity, then reproduce the pin ensure-project-worktree
# performs: git config user.name/email "$(bot_name)"/"$(bot_email)" on a checkout.
git -C "$ROOT" config user.name  "$CANON_NAME"
git -C "$ROOT" config user.email "$CANON_EMAIL"
WT="$TR/wt"; git init -q "$WT"
be bash -c '
  source "'"$JOBS"'/common.sh"
  git -C "'"$WT"'" config user.name  "$(bot_name)"
  git -C "'"$WT"'" config user.email "$(bot_email)"
'
{ [ "$(git -C "$WT" config --get user.name)" = "$CANON_NAME" ] \
  && [ "$(git -C "$WT" config --get user.email)" = "$CANON_EMAIL" ]; } \
  && ok "worktree pinned '$CANON_NAME' <$CANON_EMAIL> (matches the garden repo)" \
  || bad "worktree pin drifted (name='$(git -C "$WT" config --get user.name)')"

# ============================================================================
hr
echo "bot-identity-bootstrap: $PASS passed, $FAIL failed"
rm -rf "$TR"
[ "$FAIL" -eq 0 ]
