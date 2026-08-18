#!/bin/bash
# comment-body-guard-test.sh — regression guard for the backtick-strip comment
# body guard (scripts/jobs/comment-body-guard.sh + its wiring in bin/gh).
#
# THE GAP THIS CLOSES (endojs/endo-but-for-bots #475): the fleet posted review
# replies whose `inlineCode` spans were eaten by shell backtick command
# substitution, collapsing to empty gaps ("…provides  / . A new  package … with ,
# , and …"). The guard refuses to post a body bearing that unmistakable signature
# and names the remedy (write to a file, post via --body-file).
#
# Two layers under test:
#   1. the pure detector — corrupt bodies match, a battery of legit bodies do not
#      (the 0-false-positive property proven on the fleet's 3822-comment history);
#   2. the argv guard + wrapper wiring — a corrupt body on a real comment argv is
#      BLOCKED (rc 0 / exit 1, real gh NEVER runs), a clean one passes, and the
#      GARDEN_ALLOW_BACKTICK_STRIP=1 override bypasses.
#
# Hermetic: no network. The detector tests source the library directly; the
# wrapper e2e puts scripts/jobs/bin/gh first on PATH behind a fake "real gh" that
# only logs its argv, and forces token resolution to succeed via a fake gh.
set -uo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
LIB="$JOBS/comment-body-guard.sh"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|GH_)' || true) 2>/dev/null || true
export GARDEN_TEST=1

# shellcheck source=../comment-body-guard.sh
. "$LIB"

# The two ACTUAL corrupt bodies from #475 (3456102245) and #486 (3456304718),
# verbatim (backticks already eaten — this is what the wrapper would see).
BAD_475=$'Acknowledged. The new direction is landed in 66b56be27.\n\n no longer provides  / . A new  package now owns UTF-8 transcoding with , , and , mirroring the shape of  and .\n\n gains three parallel sub-path exports (, , ) that are byteArray-passable-aware:  produces a passable byteArray; the two decode variants accept byteArray passables or any  and handle the immutable-backed buffer copy internally.'
BAD_486=$'Addressed in 1ca1147c4. Replaced the  usage in  with , adding a typed  guard with explicit method patterns for , , and . Also updated the JSDoc comment from "Far interface name" to "Exo interface name".'

hr; echo "detector: known-bad bodies must match"
comment_body_looks_backtick_stripped "$BAD_475" && ok "#475 body detected" || bad "#475 body NOT detected"
comment_body_looks_backtick_stripped "$BAD_486" && ok "#486 body detected" || bad "#486 body NOT detected"

hr; echo "detector: legit bodies must NOT match (no false positives)"
# A body that still carries backticks is never a full strip, even with commas/parens.
LEGIT=(
  'Addressed in `4f5192232`. `compareBytes` reads via `array[i]`, `array.set(...)`.'
  'Rejected shapes: the emulated wrapper, any other typed array (`Int8Array`), and non-array values (`null`, a number, a plain object).'
  'Done. Method patterns for `next`, `return`, and `throw` are now guarded.'
  'Please disregard. We have pivoted to using `isView` and `thawedBytes`.'
  'This is enough to convince me that reuse is impossible; we need parallel routines.'
  'Fixed. It now throws (TypeError), not returns a wrong answer.'
  'Tuple (a, b, c) and list one, two, and three read fine without any code.'   # commas but no ", ," slot, no parens-comma
  'See tsconfig.composite.json; run yarn build:types:gen to regenerate.'
  ''                                                                            # empty body
  'A short prose acknowledgement with no code identifiers at all.'
)
i=0
for L in "${LEGIT[@]}"; do
  i=$((i+1))
  if comment_body_looks_backtick_stripped "$L"; then bad "legit #$i falsely flagged: $L"
  else ok "legit #$i clean"; fi
done

hr; echo "argv guard: corrupt bodies on real comment forms must BLOCK (rc 0)"
# inline review comment via gh api reply, -f body=
comment_body_guard_argv api repos/o/r/pulls/comments/123/replies -X POST -f "body=$BAD_475" 2>/dev/null \
  && ok "api reply -f body=<#475> blocked" || bad "api reply -f body=<#475> NOT blocked"
# pr comment inline --body
comment_body_guard_argv pr comment 5 --body "$BAD_486" 2>/dev/null \
  && ok "pr comment --body <#486> blocked" || bad "pr comment --body <#486> NOT blocked"
# issue comment via --body=
comment_body_guard_argv issue comment 7 "--body=$BAD_475" 2>/dev/null \
  && ok "issue comment --body=<#475> blocked" || bad "issue comment --body=<#475> NOT blocked"
# body via a file (--body-file)
BF="$(mktemp)"; printf '%s' "$BAD_475" > "$BF"
comment_body_guard_argv pr comment 5 --body-file "$BF" 2>/dev/null \
  && ok "pr comment --body-file <#475> blocked" || bad "pr comment --body-file <#475> NOT blocked"
# body via -F body=@file on a comment endpoint
comment_body_guard_argv api "repos/o/r/issues/9/comments" -F "body=@$BF" 2>/dev/null \
  && ok "api -F body=@file <#475> blocked" || bad "api -F body=@file <#475> NOT blocked"
rm -f "$BF"

hr; echo "argv guard: must PASS THROUGH (rc 1) on clean / non-comment / doubt"
comment_body_guard_argv pr comment 5 --body 'Clean: `compareBytes` fixed in `abc123`.' 2>/dev/null \
  && bad "clean pr comment wrongly blocked" || ok "clean pr comment passthrough"
comment_body_guard_argv api repos/o/r/pulls/5/reviews -X GET 2>/dev/null \
  && bad "GET wrongly blocked" || ok "non-POST/read passthrough"
comment_body_guard_argv pr view 5 2>/dev/null \
  && bad "pr view wrongly blocked" || ok "non-comment verb passthrough"
comment_body_guard_argv api "repos/o/r/issues/9/reactions" -f "content=+1" 2>/dev/null \
  && bad "reaction wrongly blocked" || ok "non-comment endpoint passthrough"
# override bypasses even a corrupt body
GARDEN_ALLOW_BACKTICK_STRIP=1 comment_body_guard_argv pr comment 5 --body "$BAD_475" 2>/dev/null \
  && bad "override failed to bypass" || ok "override bypasses block"

hr; echo "wrapper e2e: bin/gh must refuse a corrupt comment (real gh NEVER runs)"
TMPBASE="${GARDEN_TEST_TMP:-$HOME}"
TR="$(mktemp -d "$TMPBASE/.cbg-test.XXXXXX")"; trap 'rm -rf "$TR"' EXIT
printf '#!/bin/sh\nexit 0\n' > "$TR/.execprobe"; chmod +x "$TR/.execprobe"
"$TR/.execprobe" 2>/dev/null || { echo "FATAL: $TMPBASE is noexec; set GARDEN_TEST_TMP" >&2; exit 2; }
REALBIN="$TR/realbin"; mkdir -p "$REALBIN"; GHLOG="$TR/real-gh.log"
cat > "$REALBIN/gh" <<EOF
#!/bin/bash
# fake real gh: model auth token/status, log everything else.
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
# corrupt reply → must exit non-zero and NOT reach the fake real gh comment POST
if gh api repos/o/r/pulls/comments/123/replies -X POST -f "body=$BAD_475" >/dev/null 2>"$TR/err"; then
  bad "wrapper posted a corrupt comment (exit 0)"
else
  grep -q 'REFUSING to post a comment' "$TR/err" && ok "wrapper refused corrupt comment with remedy message" \
    || bad "wrapper exited non-zero but without the guard message"
fi
if grep -qa 'replies' "$GHLOG"; then bad "real gh received the corrupt POST"; else ok "real gh never ran for the corrupt POST"; fi
# clean comment → must reach the fake real gh
: > "$GHLOG"
gh api repos/o/r/pulls/comments/123/replies -X POST -f 'body=Clean `fix`.' >/dev/null 2>&1 || true
grep -qa 'replies' "$GHLOG" && ok "clean comment reached real gh" || bad "clean comment was blocked"

hr
echo "comment-body-guard: PASS=$PASS FAIL=$FAIL"
[ "$FAIL" -eq 0 ]
