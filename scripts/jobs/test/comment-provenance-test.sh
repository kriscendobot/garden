#!/bin/bash
# comment-provenance-test.sh — the GitHub-comment provenance footer
# (scripts/jobs/comment-provenance.sh + the gh wrapper hook in scripts/jobs/bin/gh).
#
# WHAT THIS GUARDS (maintainer directive kriskowal 2026-07-28)
# Every PR/issue comment the fleet posts carries a small-text footer naming the
# model, harness, and DEPLOYED garden sha (hyperlinked). Enforced at the single
# PATH chokepoint the fleet's gh wrapper is. This test covers the whole invocation
# surface and the hard constraints:
#   * each body form (--body / --body-file / stdin; -f/-F/--input JSON) gains
#     EXACTLY ONE footer;
#   * JSON bodies stay valid JSON;
#   * a --body-file on disk is NEVER mutated;
#   * an already-footed body is not doubled (idempotent);
#   * reactji and other non-comment calls are untouched (passthrough);
#   * unresolvable provenance degrades — the body is posted WITHOUT the footer
#     rather than failing.
#
# Hermetic: sources the library directly and inspects PROV_NEWARGV for the precise
# cases, and drives the real wrapper (fake gh behind it) for the exec/stdin path.
# No network. A fixture GARDEN_ROOT supplies a deployed-sha marker + git remote.
set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
LIB="$JOBS/comment-provenance.sh"
WRAPPER_DIR="$JOBS/bin"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# Scrub ambient fleet env so a live gardener running this as a board job does not
# splice its own GARDEN_* state under the fixture.
# shellcheck disable=SC2046  # deliberate word-split of the var list to unset.
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|GH_)' || true) 2>/dev/null || true

TMPBASE="${GARDEN_TEST_TMP:-$HOME}"
TR="$(mktemp -d "$TMPBASE/.prov-test.XXXXXX")"; trap 'rm -rf "$TR"' EXIT

# --- fixture GARDEN_ROOT: a deployed-sha marker + a git remote to derive the URL.
FIX="$TR/root"; mkdir -p "$FIX/.garden-state/deploy"
SHA="bb971c9adeadbeef0123456789abcdef01234567"
printf '%s\n' "$SHA" > "$FIX/.garden-state/deploy/deployed-sha"
git -C "$FIX" init -q 2>/dev/null
git -C "$FIX" remote add origin "git@github.com:kriskowal/garden.git" 2>/dev/null
export GARDEN_ROOT="$FIX"
export GARDEN_JOB_MODEL="claude-opus-5"
export GARDEN_WORKER_KIND="gardener"

EXPECT_URL="https://github.com/kriskowal/garden/commit/$SHA"
MARKER="garden-provenance"

# shellcheck source=/dev/null
. "$LIB"

# body_of_bodyfile: last PROV_NEWARGV pair is `--body-file <tmp>`; echo its content.
body_of_bodyfile() {
  local nm="${#PROV_NEWARGV[@]}"
  [ "$nm" -ge 2 ] || { echo "__NO_BODYFILE__"; return; }
  local flag="${PROV_NEWARGV[$((nm-2))]}" f="${PROV_NEWARGV[$((nm-1))]}"
  [ "$flag" = "--body-file" ] || { echo "__NO_BODYFILE__"; return; }
  cat "$f"
}
# field_body: echo the value of the body= field token in PROV_NEWARGV.
field_body() {
  local a
  for a in "${PROV_NEWARGV[@]}"; do
    case "$a" in body=*) printf '%s' "${a#body=}"; return;; *=body=*) printf '%s' "${a#*=body=}"; return;; esac
  done
  echo "__NO_BODY_FIELD__"
}
# input_json: read the --input temp file's JSON from PROV_NEWARGV.
input_json() {
  local nm="${#PROV_NEWARGV[@]}" i
  for ((i=0;i<nm;i++)); do
    case "${PROV_NEWARGV[$i]}" in --input) cat "${PROV_NEWARGV[$((i+1))]}"; return;; --input=*) cat "${PROV_NEWARGV[$i]#--input=}"; return;; esac
  done
  echo "__NO_INPUT__"
}
has_footer() { case "$1" in *"$MARKER"*) return 0;; *) return 1;; esac; }
count_footer() { grep -o "$MARKER" <<<"$1" | wc -l | tr -d ' '; }

# ============================================================================
hr; echo "SUBTEST 1 — body-flag surface (pr/issue comment, pr review)"; hr

provenance_rewrite_argv pr comment 5 --body "hello world" && {
  b="$(body_of_bodyfile)"
  { has_footer "$b" && [ "$(count_footer "$b")" = 1 ] && [[ "$b" == "hello world"* ]] && [[ "$b" == *"$EXPECT_URL"* ]] && [[ "$b" == *"claude-opus-5"* ]] && [[ "$b" == *"harness <code>claude</code>"* ]] && [[ "$b" == *"provider <code>anthropic</code>"* ]]; } \
    && ok "pr comment --body → single footer, original body preserved, all four facts (model/harness/provider/garden)" \
    || bad "pr comment --body body wrong: $b"
} || bad "pr comment --body was not rewritten"
provenance_cleanup

provenance_rewrite_argv issue comment 7 -b "hi there" && {
  b="$(body_of_bodyfile)"; { has_footer "$b" && [[ "$b" == "hi there"* ]]; } && ok "issue comment -b → footer" || bad "issue comment -b: $b"
} || bad "issue comment -b not rewritten"
provenance_cleanup

# --body-file: MUST NOT be mutated on disk.
BF="$TR/bodyfile.md"; printf 'file body content' > "$BF"; BF_SUM="$(cksum "$BF")"
provenance_rewrite_argv pr comment 5 --body-file "$BF" && {
  b="$(body_of_bodyfile)"
  { has_footer "$b" && [[ "$b" == "file body content"* ]] && [ "$(cksum "$BF")" = "$BF_SUM" ]; } \
    && ok "pr comment --body-file → footer added, source file NOT mutated on disk" \
    || bad "pr comment --body-file: body=$b  fileChanged=$([ "$(cksum "$BF")" = "$BF_SUM" ] && echo no || echo YES)"
} || bad "pr comment --body-file not rewritten"
provenance_cleanup

# pr review: --approve preserved, summary body footered.
provenance_rewrite_argv pr review 5 --approve --body "looks good" && {
  b="$(body_of_bodyfile)"; keep=0; for a in "${PROV_NEWARGV[@]}"; do [ "$a" = "--approve" ] && keep=1; done
  { has_footer "$b" && [ "$keep" = 1 ] && [[ "$b" == "looks good"* ]]; } && ok "pr review --approve --body → footer, --approve preserved" || bad "pr review: $b keep=$keep"
} || bad "pr review not rewritten"
provenance_cleanup

# ============================================================================
hr; echo "SUBTEST 2 — gh api field-flag surface"; hr

provenance_rewrite_argv api -X POST repos/o/r/issues/5/comments -f body="apibody" && {
  v="$(field_body)"; { [[ "$v" == "apibody"* ]] && has_footer "$v"; } && ok "api issues/N/comments -f body → footer" || bad "api issue comment: $v"
} || bad "api issue comment not rewritten"
provenance_cleanup

provenance_rewrite_argv api -X POST repos/o/r/pulls/5/comments -f body="inline" -f commit_id=abc -f path=x.js && {
  v="$(field_body)"; cid=0; for a in "${PROV_NEWARGV[@]}"; do [ "$a" = "commit_id=abc" ] && cid=1; done
  { has_footer "$v" && [ "$cid" = 1 ]; } && ok "api pulls/N/comments (inline) → footer, sibling fields preserved" || bad "api inline: $v cid=$cid"
} || bad "api inline comment not rewritten"
provenance_cleanup

provenance_rewrite_argv api repos/o/r/pulls/comments/9/replies -f body="areply" && {
  v="$(field_body)"; { has_footer "$v" && [[ "$v" == "areply"* ]]; } && ok "api comments/ID/replies (no -X, defaults POST) → footer" || bad "api reply: $v"
} || bad "api reply not rewritten"
provenance_cleanup

provenance_rewrite_argv api -X POST repos/o/r/pulls/5/reviews -f body="summary" -f event=APPROVE && {
  v="$(field_body)"; { has_footer "$v" && [[ "$v" == "summary"* ]]; } && ok "api pulls/N/reviews (summary body) → footer" || bad "api review: $v"
} || bad "api review not rewritten"
provenance_cleanup

# ============================================================================
hr; echo "SUBTEST 3 — gh api --input JSON stays valid JSON"; hr

if command -v jq >/dev/null 2>&1; then
  JF="$TR/in.json"; printf '{"body":"json body","commit_id":"c"}' > "$JF"; JF_SUM="$(cksum "$JF")"
  provenance_rewrite_argv api -X POST repos/o/r/pulls/5/comments --input "$JF" && {
    j="$(input_json)"
    { printf '%s' "$j" | jq -e . >/dev/null 2>&1 \
      && [ "$(printf '%s' "$j" | jq -r '.body')" != "json body" ] \
      && printf '%s' "$j" | jq -r '.body' | grep -q "$MARKER" \
      && [ "$(printf '%s' "$j" | jq -r '.commit_id')" = "c" ] \
      && [ "$(cksum "$JF")" = "$JF_SUM" ]; } \
      && ok "api --input JSON → valid JSON, .body footered, siblings kept, source file NOT mutated" \
      || bad "api --input JSON: $j  fileChanged=$([ "$(cksum "$JF")" = "$JF_SUM" ] && echo no || echo YES)"
  } || bad "api --input not rewritten"
  provenance_cleanup
else
  ok "(jq absent — skipping --input JSON subtest; wrapper fails open by design)"
fi

# ============================================================================
hr; echo "SUBTEST 4 — idempotent: an already-footed body is not doubled"; hr

FOOTED="already said<sub><!--$MARKER-->model <code>x</code></sub>"
if provenance_rewrite_argv pr comment 5 --body "$FOOTED"; then
  b="$(body_of_bodyfile)"; [ "$(count_footer "$b")" = 1 ] && ok "footed --body → not doubled (rewrite, single footer)" || bad "doubled: $b"
  provenance_cleanup
else
  ok "footed --body → passthrough (no rewrite needed)"
fi

# Hand-written footer (no marker) is recognized by shape and not doubled.
HAND="text<sub>model \`m\` harness \`claude\` garden https://github.com/kriskowal/garden/commit/deadbeef</sub>"
if provenance_body_has_line "$HAND"; then ok "hand-written footer recognized by shape (not doubled)"; else bad "hand footer not recognized"; fi

# ============================================================================
hr; echo "SUBTEST 5 — non-comment calls pass through UNTOUCHED"; hr
for spec in \
  "pr view 5" \
  "pr merge 5" \
  "pr edit 5 --add-label z" \
  "pr edit 5 --body description-not-a-comment" \
  "pr create --title x --body y" \
  "issue edit 7 --add-label z" \
  "issue create --title x --body y" \
  "api repos/o/r/pulls/5" \
  "api -X GET repos/o/r/issues/5/comments" \
  "api -X POST repos/o/r/issues/comments/9/reactions -f content=eyes" \
  "api -X PATCH repos/o/r/pulls/5 -f body=newdesc" \
  "api -X POST repos/o/r/pulls/5/merge" \
; do
  # shellcheck disable=SC2086
  if provenance_rewrite_argv $spec; then bad "passthrough expected but REWRITTEN: gh $spec"; provenance_cleanup
  else ok "passthrough (untouched): gh $spec"; fi
done

# ============================================================================
hr; echo "SUBTEST 6 — fail-open: unresolvable provenance degrades, never blocks"; hr
(
  export GARDEN_ROOT="$TR/empty"; mkdir -p "$TR/empty"
  unset GARDEN_JOB_MODEL GARDEN_WORKER_KIND
  export GARDEN_DEPLOYED_SHA_MARKER="$TR/empty/nope"
  # shellcheck source=/dev/null
  . "$LIB"
  line="$(provenance_line)"
  [ -z "$line" ] && echo FAILOPEN_EMPTY || echo "FAILOPEN_NONEMPTY:$line"
  if provenance_rewrite_argv pr comment 5 --body "x"; then echo REWROTE; else echo PASSTHROUGH; fi
) > "$TR/failopen.out" 2>/dev/null
grep -q FAILOPEN_EMPTY "$TR/failopen.out" && ok "no facts resolve → empty footer (no crash)" || bad "fail-open line: $(cat "$TR/failopen.out")"
grep -q PASSTHROUGH "$TR/failopen.out" && ok "no facts resolve → comment posts WITHOUT footer (passthrough)" || bad "fail-open should passthrough: $(cat "$TR/failopen.out")"

# Partial resolution: only the sha (no model/harness) still yields a garden field.
(
  unset GARDEN_JOB_MODEL GARDEN_WORKER_KIND
  # shellcheck source=/dev/null
  . "$LIB"
  provenance_line
) > "$TR/partial.out" 2>/dev/null
{ grep -q "$EXPECT_URL" "$TR/partial.out" && ! grep -q "model <code>" "$TR/partial.out"; } \
  && ok "partial resolve → garden field present, model/harness omitted" \
  || bad "partial resolve: $(cat "$TR/partial.out")"

# ============================================================================
hr; echo "SUBTEST 7 — stdin body via the REAL wrapper (exec path, fake gh behind)"; hr
# Drive the actual wrapper so the `--body-file -` / `--input -` stdin normalization
# and the run-then-cleanup exec path are exercised end to end. Token resolution is
# forced to SUCCEED so we reach the rewrite/exec.
REALBIN="$TR/realbin"; mkdir -p "$REALBIN"; GHLOG="$TR/gh-argv.log"; GHBODY="$TR/gh-body.out"
cat > "$REALBIN/gh" <<EOF
#!/bin/bash
set -uo pipefail
if [ "\${1:-}" = "auth" ] && [ "\${2:-}" = "token" ]; then echo "tok"; exit 0; fi
# Record argv; if a --body-file is present, dump its content for assertions.
printf '%s\n' "\$*" >> "$GHLOG"
prev=""
for a in "\$@"; do [ "\$prev" = "--body-file" ] && cat "\$a" > "$GHBODY"; prev="\$a"; done
exit 0
EOF
chmod +x "$REALBIN/gh"
CLEANPATH="$(printf '%s' "$PATH" | tr ':' '\n' | grep -v '/scripts/jobs/bin$' | paste -sd: -)"
run_wrapper() { PATH="$WRAPPER_DIR:$REALBIN:$CLEANPATH" GARDEN_GH_IDENTITY=kriscendobot gh "$@"; }

: > "$GHBODY"
printf 'stdin body text' | run_wrapper pr comment 5 --body-file - >/dev/null 2>&1
b="$(cat "$GHBODY" 2>/dev/null || true)"
{ has_footer "$b" && [[ "$b" == "stdin body text"* ]]; } && ok "wrapper: --body-file - (stdin) → footer via temp body-file" || bad "wrapper stdin body: $b"

# A reactji through the wrapper must reach gh untouched (no body grows).
: > "$GHLOG"
run_wrapper api -X POST repos/o/r/issues/comments/9/reactions -f content=eyes >/dev/null 2>&1
grep -q "reactions -f content=eyes" "$GHLOG" && ! grep -q "$MARKER" "$GHLOG" \
  && ok "wrapper: reactji passes through untouched (no body injected)" \
  || bad "wrapper reactji: $(cat "$GHLOG")"

# ============================================================================
hr; echo "SUBTEST 8 — provider field follows the worker-kind taxonomy"; hr
# provider is a DISTINCT fact from harness: the codex harness fronts several
# providers by kind. Spot-check the taxonomy (mirrors common.sh worker_kind_field).
check_provider() {  # <worker-kind> → prints the rendered provenance_line
  ( export GARDEN_WORKER_KIND="$1"; . "$LIB"; provenance_line )
}
for row in \
  "monk anthropic claude" \
  "gardener anthropic claude" \
  "cleric openai codex" \
  "fireworker fireworks codex" \
  "openrouter openrouter codex" \
  "mystic moonshot kimi" \
  "friar ollama-cloud claude" \
  "opencode-anthropic anthropic opencode" \
; do
  set -- $row; kind="$1"; eprov="$2"; eharn="$3"
  line="$(check_provider "$kind")"
  { [[ "$line" == *"provider <code>$eprov</code>"* ]] && [[ "$line" == *"harness <code>$eharn</code>"* ]]; } \
    && ok "kind $kind → provider $eprov, harness $eharn" \
    || bad "kind $kind: got [$line], expected provider $eprov / harness $eharn"
done

# ============================================================================
hr; echo "SUBTEST 9 — GARDEN_NO_LLM marks a deterministic post 'automatic'"; hr
(
  export GARDEN_NO_LLM=1
  # shellcheck source=/dev/null
  . "$LIB"
  provenance_line
) > "$TR/automatic.out" 2>/dev/null
{ grep -q "model <code>automatic</code>" "$TR/automatic.out" \
  && ! grep -q "harness <code>" "$TR/automatic.out" \
  && ! grep -q "provider <code>" "$TR/automatic.out" \
  && grep -q "$EXPECT_URL" "$TR/automatic.out"; } \
  && ok "GARDEN_NO_LLM=1 → model automatic, harness/provider omitted, garden sha kept" \
  || bad "automatic marker: $(cat "$TR/automatic.out")"

# GARDEN_NO_LLM wins even when a model var is (spuriously) inherited by a
# deterministic handler job: the explicit no-LLM mark beats a stray GARDEN_JOB_MODEL.
(
  export GARDEN_NO_LLM=1 GARDEN_JOB_MODEL="claude-opus-5" GARDEN_WORKER_KIND="gardener"
  # shellcheck source=/dev/null
  . "$LIB"
  provenance_line
) > "$TR/automatic2.out" 2>/dev/null
{ grep -q "model <code>automatic</code>" "$TR/automatic2.out" && ! grep -q "claude-opus-5" "$TR/automatic2.out"; } \
  && ok "GARDEN_NO_LLM=1 overrides an inherited GARDEN_JOB_MODEL (→ automatic)" \
  || bad "automatic override: $(cat "$TR/automatic2.out")"

# The automatic marker suppresses the instrumentation-gap alert (no LLM ⇒ no gap).
(
  export GARDEN_NO_LLM=1
  export GARDEN_ALERT_CMD="$TR/alert-sink9.sh"; printf '#!/bin/bash\nprintf "%%s\\n" "$1" >> "%s"\n' "$TR/gap9.log" > "$GARDEN_ALERT_CMD"; chmod +x "$GARDEN_ALERT_CMD"
  : > "$TR/gap9.log"
  # shellcheck source=/dev/null
  . "$LIB"
  provenance_rewrite_argv pr comment 5 --body "auto body" >/dev/null 2>&1
)
[ ! -s "$TR/gap9.log" ] && ok "automatic post raises NO gap alert" || bad "automatic wrongly alerted: $(cat "$TR/gap9.log")"

# ============================================================================
hr; echo "SUBTEST 10 — instrumentation gap (LLM post, no facts) is surfaced, still posts"; hr
(
  unset GARDEN_JOB_MODEL GARDEN_WORKER_KIND
  export GARDEN_ALERT_CMD="$TR/alert-sink10.sh"; printf '#!/bin/bash\nprintf "%%s|%%s\\n" "$1" "$3" >> "%s"\n' "$TR/gap10.log" > "$GARDEN_ALERT_CMD"; chmod +x "$GARDEN_ALERT_CMD"
  : > "$TR/gap10.log"
  # shellcheck source=/dev/null
  . "$LIB"
  # A comment with a resolvable garden sha but NO model/harness/provider: footer is
  # appended (garden-only) AND the gap is surfaced (the PR #1125 shape).
  if provenance_rewrite_argv pr comment 5 --body "gap body"; then echo REWROTE; else echo PASSTHROUGH; fi
  provenance_cleanup
) > "$TR/gap10.out" 2>/dev/null
{ grep -q "comment-provenance-gap" "$TR/gap10.log" && grep -q "|1" "$TR/gap10.log"; } \
  && ok "gap → maintainer alert raised (keyed comment-provenance-gap-<host>, count folded)" \
  || bad "gap alert not raised: $(cat "$TR/gap10.log")"
grep -q REWROTE "$TR/gap10.out" \
  && ok "gap → comment STILL posts (garden-only footer appended, fail-open preserved)" \
  || bad "gap should still post: $(cat "$TR/gap10.out")"

# The gap alert is THROTTLED per host: a burst folds into ONE delivery.
(
  unset GARDEN_JOB_MODEL GARDEN_WORKER_KIND
  export GARDEN_ALERT_CMD="$TR/alert-sink10b.sh"; printf '#!/bin/bash\nprintf "x\\n" >> "%s"\n' "$TR/gap10b.log" > "$GARDEN_ALERT_CMD"; chmod +x "$GARDEN_ALERT_CMD"
  export GARDEN_STATE="$TR/gap10b-state"
  : > "$TR/gap10b.log"
  # shellcheck source=/dev/null
  . "$LIB"
  for i in 1 2 3 4 5; do provenance_rewrite_argv pr comment 5 --body "gap $i" >/dev/null 2>&1; provenance_cleanup; done
)
[ "$(wc -l < "$TR/gap10b.log" | tr -d ' ')" = 1 ] \
  && ok "gap alert throttled: a burst of 5 folds into ONE delivery" \
  || bad "throttle failed, deliveries=$(cat "$TR/gap10b.log" | wc -l)"

# A no-facts post that is NOT a comment (a reactji) raises NO gap alert.
(
  unset GARDEN_JOB_MODEL GARDEN_WORKER_KIND
  export GARDEN_ALERT_CMD="$TR/alert-sink10c.sh"; printf '#!/bin/bash\nprintf "x\\n" >> "%s"\n' "$TR/gap10c.log" > "$GARDEN_ALERT_CMD"; chmod +x "$GARDEN_ALERT_CMD"
  export GARDEN_STATE="$TR/gap10c-state"
  : > "$TR/gap10c.log"
  # shellcheck source=/dev/null
  . "$LIB"
  provenance_rewrite_argv api -X POST repos/o/r/issues/comments/9/reactions -f content=eyes >/dev/null 2>&1
)
[ ! -s "$TR/gap10c.log" ] && ok "non-comment (reactji) with no facts raises NO gap alert" || bad "reactji wrongly alerted"

# ============================================================================
hr; echo "SUBTEST 11 — per-section footnotes for an AGGREGATED multi-section body"; hr
# A whole-body footer misattributes every section but one when a body is stitched
# from multiple agents at DIFFERENT model/harness/provider (a panel's per-seat
# blocks, a completion summary's per-contributor sections). provenance_footnote
# renders one footnote per section from that section's OWN explicit facts.
SECTION_MARKER="garden-provenance-section"

# Two sections, two different (model, harness, provider) → two DISTINCT footnotes.
fn1="$(provenance_footnote "claude-opus-5" "claude" "anthropic")"
fn2="$(provenance_footnote "gpt-5" "codex" "openai")"
{ [ -n "$fn1" ] && [ -n "$fn2" ] && [ "$fn1" != "$fn2" ] \
  && [[ "$fn1" == *"claude-opus-5"* ]] && [[ "$fn1" == *"harness <code>claude</code>"* ]] && [[ "$fn1" == *"provider <code>anthropic</code>"* ]] \
  && [[ "$fn2" == *"gpt-5"* ]] && [[ "$fn2" == *"harness <code>codex</code>"* ]] && [[ "$fn2" == *"provider <code>openai</code>"* ]]; } \
  && ok "two sections at different model/harness/provider → two distinct footnotes" \
  || bad "per-section footnotes not distinct: fn1=[$fn1] fn2=[$fn2]"

# The footnote carries the SECTION marker, not the whole-body marker, and OMITS the
# garden sha (a whole-body fact) — so it never trips the whole-body idempotency guard.
{ [[ "$fn1" == *"<!--$SECTION_MARKER-->"* ]] && [[ "$fn1" != *"$EXPECT_URL"* ]] && [[ "$fn1" != *"garden <code>"* ]]; } \
  && ok "footnote uses PROV_SECTION_MARKER and omits the garden sha" \
  || bad "footnote marker/sha wrong: $fn1"

# A section produced deterministically (no LLM) → `automatic`, harness/provider omitted.
fna="$(provenance_footnote "" "" "" 1)"
{ [[ "$fna" == *"model <code>automatic</code>"* ]] && [[ "$fna" != *"harness <code>"* ]] && [[ "$fna" != *"provider <code>"* ]] && [[ "$fna" == *"<!--$SECTION_MARKER-->"* ]]; } \
  && ok "no_llm section → model automatic footnote (harness/provider omitted)" \
  || bad "automatic footnote wrong: $fna"

# Fail-open: a section with no resolvable fact yields an EMPTY footnote (no output).
fne="$(provenance_footnote "" "" "")"
[ -z "$fne" ] && ok "no fact resolves → empty footnote (fail-open, no footnote appended)" || bad "expected empty footnote, got: $fne"

# provenance_footnote_for_kind resolves harness/provider from the worker kind.
fnk_cleric="$(provenance_footnote_for_kind "gpt-5" "cleric")"
fnk_monk="$(provenance_footnote_for_kind "claude-opus-5" "monk")"
{ [[ "$fnk_cleric" == *"harness <code>codex</code>"* ]] && [[ "$fnk_cleric" == *"provider <code>openai</code>"* ]] \
  && [[ "$fnk_monk" == *"harness <code>claude</code>"* ]] && [[ "$fnk_monk" == *"provider <code>anthropic</code>"* ]] \
  && [ "$fnk_cleric" != "$fnk_monk" ]; } \
  && ok "provenance_footnote_for_kind resolves the kind → distinct footnotes per kind" \
  || bad "for_kind footnotes wrong: cleric=[$fnk_cleric] monk=[$fnk_monk]"

# End to end: an aggregated body of 2 sections, each footnoted with its own facts,
# then posted through the wrapper. The body carries 2 DISTINCT section footnotes AND
# still gains the single closing whole-body footer (the section marker did not trip
# the whole-body idempotency guard).
AGG="## seat-a"$'\n'"verdict a"$'\n'"$fn1"$'\n\n'"## seat-b"$'\n'"verdict b"$'\n'"$fn2"
nsec="$(grep -o "$SECTION_MARKER" <<<"$AGG" | wc -l | tr -d ' ')"
[ "$nsec" = 2 ] && ok "aggregated body carries 2 per-section footnotes (one per section)" || bad "expected 2 section footnotes, got $nsec"
provenance_rewrite_argv pr comment 5 --body "$AGG" && {
  b="$(body_of_bodyfile)"
  nsec_b="$(grep -o "$SECTION_MARKER" <<<"$b" | wc -l | tr -d ' ')"
  # count the WHOLE-BODY marker only: the section marker contains it as a substring,
  # so subtract the section occurrences from the raw marker count.
  nall="$(grep -o "$MARKER" <<<"$b" | wc -l | tr -d ' ')"
  nbody=$((nall - nsec_b))
  { [ "$nsec_b" = 2 ] && [ "$nbody" = 1 ] && [[ "$b" == *"$EXPECT_URL"* ]]; } \
    && ok "posted body keeps 2 section footnotes + gains exactly 1 closing whole-body footer" \
    || bad "post assembly wrong: section=$nsec_b body=$nbody (raw=$nall); body=$b"
} || bad "aggregated multi-section body was not rewritten (whole-body footer skipped?)"
provenance_cleanup

# ============================================================================
hr
echo "SUMMARY: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
