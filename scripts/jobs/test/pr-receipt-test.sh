#!/bin/bash
# pr-receipt-test.sh — hermetic proof of the PR receipt's measurement rollup: no
# human-effort estimate (MRE / human dollars) in the receipt, words (not chars) of
# human feedback split maintainer vs other with bots dropped, the quality-bar class,
# the receipts/rollup.jsonl row, and --backfill-rollup idempotency. gh is stubbed and
# the journal is a throwaway bare repo.
set -euo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
PASS=0; FAIL=0
ok() { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
command -v jq >/dev/null 2>&1 || { echo "SKIP: jq unavailable"; exit 0; }
# shellcheck disable=SC2046 # intentional variable-name expansion for unset
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_)' || true) 2>/dev/null || true
export GARDEN_TEST=1

TR="$(mktemp -d "${TMPDIR:-/tmp}/pr-receipt-test.XXXXXX")"; trap 'rm -rf "$TR"' EXIT
BARE="$TR/journal.git"; SEED="$TR/seed"
git init -q --bare "$BARE"; git init -q "$SEED"; git -C "$SEED" checkout -q -b journal2
mkdir -p "$SEED"/{reputation/events,usage,config,maintainers,panel-runs/endojs-endo-7}
printf 'kriscendobot\n' > "$SEED/config/fork-owners"
printf 'kriskowal\n' > "$SEED/maintainers/allowlist"
printf -- '---\nkind: builder\nprovider: anthropic\n---\n' > "$SEED/reputation/events/build-x.md"
printf -- '---\nkind: fixer\nprovider: anthropic\n---\n' > "$SEED/reputation/events/fix-x.md"
printf '{"source":"result","role":"builder","provider":"anthropic","model":"claude-opus","input_tokens":100,"output_tokens":50,"cache_creation_tokens":0,"cache_read_tokens":0,"total_cost_usd":1.5,"elapsed_s":600,"ts":"2026-11-01T01:00:00Z"}\n' > "$SEED/usage/build-x.jsonl"
printf '{"source":"result","role":"fixer","provider":"anthropic","model":"claude-opus","input_tokens":10,"output_tokens":5,"cache_creation_tokens":0,"cache_read_tokens":0,"total_cost_usd":0.5,"elapsed_s":300,"ts":"2026-11-01T05:00:00Z"}\n' > "$SEED/usage/fix-x.jsonl"
printf -- '---\nkind: panel-run\nrounds: 2\n---\n' > "$SEED/panel-runs/endojs-endo-7/a.md"
git -C "$SEED" add -A
git -C "$SEED" -c user.name=t -c user.email=t@l commit -q -m seed
git -C "$SEED" remote add origin "$BARE"; git -C "$SEED" push -q -u origin journal2
CLONE="$TR/clone"; git clone -q --branch journal2 "$BARE" "$CLONE"
git -C "$CLONE" config user.name t; git -C "$CLONE" config user.email t@l
export JOURNAL_REMOTE="$BARE" GARDEN_STATE="$TR/state" GARDEN_ROOT="$TR/root"
mkdir -p "$GARDEN_STATE" "$GARDEN_ROOT"

# precomputed base map: base pr state ceil calibrated
printf 'build-x\tendojs/endo#7\tmerged\t0\t0.40\nfix-x\tendojs/endo#7\tmerged\t0\t0.10\n' > "$TR/basemap.tsv"
export GARDEN_RECEIPT_BASEMAP="$TR/basemap.tsv"

mkdir -p "$TR/bin"
cat > "$TR/bin/gh" <<'EOF'
#!/bin/bash
# stub: gh api [--paginate] <path>
p=""; for a in "$@"; do case "$a" in repos/*) p="$a";; esac; done
case "$p" in
  repos/endojs/endo/pulls/7) echo '{"merged_at":"2026-11-02T01:00:00Z","closed_at":"2026-11-02T01:00:00Z","state":"closed","title":"t"}' ;;
  repos/endojs/endo/pulls/7/reviews) echo '[
    {"user":{"login":"kriskowal"},"submitted_at":"2026-11-01T02:00:00Z","state":"CHANGES_REQUESTED","body":"please   rename this\nthing"},
    {"user":{"login":"erights"},"submitted_at":"2026-11-01T03:00:00Z","state":"COMMENTED","body":"looks fine to me"},
    {"user":{"login":"kriskowal"},"submitted_at":"2026-11-01T06:00:00Z","state":"APPROVED","body":""},
    {"user":{"login":"kriscendobot"},"submitted_at":"2026-11-01T04:00:00Z","state":"COMMENTED","body":"bot words here ignored"}]' ;;
  repos/endojs/endo/pulls/7/comments) echo '[
    {"user":{"login":"KrisKowal"},"created_at":"2026-11-01T02:01:00Z","in_reply_to_id":null,"body":"one two"},
    {"user":{"login":"erights"},"created_at":"2026-11-01T02:02:00Z","in_reply_to_id":5,"body":"agreed"}]' ;;
  repos/endojs/endo/issues/7/comments) echo '[
    {"user":{"login":"github-actions[bot]"},"created_at":"2026-11-01T02:03:00Z","body":"ci ci ci"},
    {"user":{"login":"Copilot"},"created_at":"2026-11-01T02:03:00Z","body":"copilot says words"}]' ;;
  *) echo '[]' ;;
esac
EOF
chmod +x "$TR/bin/gh"; export PATH="$TR/bin:$PATH"

echo "== generate a receipt (--no-post) =="
out="$("$JOBS/pr-receipt.sh" endojs/endo 7 --no-post --dir "$CLONE" 2>"$TR/err")" || { cat "$TR/err"; bad "pr-receipt.sh failed"; }
arc="$CLONE/receipts/endojs-endo/2026/11/pr7.md"
[ "$out" = "$arc" ] && [ -f "$arc" ] && ok "archive written" || bad "archive missing ($out)"
if grep -qiE 'MRE|maintainer review|maintainer_review|hourly|total_usd|≈ *[0-9]+×|\$[0-9.]+ *\(MRE' "$arc"; then
  bad "receipt asserts a human-effort figure"; grep -niE 'MRE|maintainer review|hourly|total_usd' "$arc"
else ok "no MRE / human-dollar text in the receipt"; fi
# words: kriskowal 4 (review) + 2 (inline) = 6; erights 4 + 1 = 5; bots/Copilot dropped
grep -q '^human_words: 11$' "$arc" && ok "human words = 11" || bad "human words wrong: $(grep human_words: "$arc")"
grep -q '^human_words_maintainer: 6$' "$arc" && grep -q '^human_words_other: 5$' "$arc" \
  && ok "maintainer/other word split" || bad "word split wrong"
grep -q '^quality_bar_class: highest$' "$arc" && grep -q '^quality_bar_rank: 1$' "$arc" \
  && ok "quality bar endojs/endo = highest/1" || bad "quality bar wrong"
row="$(git -C "$BARE" show journal2:receipts/rollup.jsonl 2>/dev/null | tail -1)"
[ -n "$row" ] && ok "rollup row pushed" || bad "no rollup row pushed"
jq -e '.schema==1 and .human_words==11 and .human_words_by_author.kriskowal.words==6
       and .verdicts.changes_requested==1 and .verdicts.approved==1
       and .verdict_sequence=="CHANGES_REQUESTED>APPROVED" and .human_inline_threads==1
       and .job_duration_s==900 and .wall_clock_s==((24*3600)+600) and .jobs==2
       and .fix_rounds==1 and .panel_rounds==2 and .tokens_by_model["claude-opus"]==165
       and .calibrated_usd==0.5 and .quality_bar_class=="highest"
       and ([paths|map(tostring)|join(".")|test("mre|hourly|_usd_human|maintainer_review";"i")]|any|not)' \
  <<<"$row" >/dev/null && ok "rollup row fields" || { bad "rollup row fields"; echo "$row"; }

echo "== backfill is idempotent and never rewrites the archive =="
before="$(sha1sum "$arc")"
git -C "$CLONE" pull -q origin journal2 2>/dev/null || true
"$JOBS/pr-receipt.sh" endojs/endo 7 --backfill-rollup --dir "$CLONE" >/dev/null 2>"$TR/err2" || { cat "$TR/err2"; bad "backfill failed"; }
n="$(git -C "$BARE" show journal2:receipts/rollup.jsonl | grep -c .)"
[ "$n" = 1 ] && ok "backfill skipped an existing row" || bad "backfill duplicated ($n rows)"
[ "$(sha1sum "$arc")" = "$before" ] && ok "archive untouched" || bad "archive rewritten"

echo "== journal config/quality-bar outranks the tracked seed =="
printf 'endojs/endo\t5\tcustom\n' > "$CLONE/config/quality-bar"
git -C "$CLONE" add config/quality-bar; git -C "$CLONE" commit -q -m qb; git -C "$CLONE" push -q origin HEAD:journal2
"$JOBS/pr-receipt.sh" endojs/endo 7 --no-post --force --dir "$CLONE" >/dev/null 2>"$TR/err3" || { cat "$TR/err3"; bad "force regen failed"; }
grep -q '^quality_bar_class: custom$' "$arc" && ok "journal config/quality-bar outranks the seed" || bad "journal override ignored"

echo "pr-receipt-test: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
