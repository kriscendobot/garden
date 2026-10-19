#!/bin/bash
# panel-qualify-bare-refs-test.sh — the single-round panel qualifies bare `#N`
# refs in its aggregate so the gh wrapper's bare-ref guard does not refuse a
# review that also names another repository (endojs/endo-but-for-bots#1500
# panel round 4).
set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PANEL="$(cd "$HERE/../gardening" && pwd)/panel.sh"
TR="$(mktemp -d "${TMPDIR:-/tmp}/panel-qualify.XXXXXX")"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
trap 'rm -rf "$TR"' EXIT

# shellcheck source=/dev/null
source <(sed -n '/^panel_qualify_bare_refs()/,/^}/p' "$PANEL")
# shellcheck source=../comment-body-guard.sh
source "$HERE/../comment-body-guard.sh"

cat > "$TR/agg.md" <<'MD'
Regresses #1336 like nodejs/node#123 (see #1226).
`#99` and [#5](https://example.com/x#7) and https://github.com/a/b/pull/3#issuecomment-1 stay.
```
#42 in a fence
```
<!-- #8 --> foo/bar#9 and &#38; stay; end #1407.
MD
repo=endojs/endo-but-for-bots
comment_body_bare_cross_repo_refs "$(cat "$TR/agg.md")" "$repo" >/dev/null \
  && ok "fixture trips the bare-ref guard before qualification" \
  || bad "fixture does not trip the guard"
panel_qualify_bare_refs "$TR/agg.md" "$repo"
for want in "$repo#1336" "see $repo#1226)" "end $repo#1407." 'nodejs/node#123' '`#99`' \
    '[#5](https://example.com/x#7)' 'pull/3#issuecomment-1' '#42 in a fence' \
    '<!-- #8 -->' 'foo/bar#9' '&#38;'; do
  grep -qF -- "$want" "$TR/agg.md" && ok "keeps/produces: $want" || bad "missing: $want"
done
comment_body_bare_cross_repo_refs "$(cat "$TR/agg.md")" "$repo" >/dev/null \
  && bad "guard still fires after qualification" \
  || ok "guard passes after qualification"

echo "panel-qualify-bare-refs-test: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
