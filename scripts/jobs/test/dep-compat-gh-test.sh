#!/bin/bash
# dep-compat-gh-test.sh -- hermetic API/registry test for the compatibility oracle.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HANDLER="$(cd "$HERE/../handlers" && pwd)/dep-compat-gh.sh"
TR="$(mktemp -d /home/kris/.garden-dep-compat-gh-test.XXXXXX)"
trap 'rm -rf "$TR"' EXIT

mkdir -p "$TR/bin"
cat > "$TR/gh-stub" <<'EOF'
#!/bin/bash
case "$*" in
  'api repos/acme/project/pulls/42')
    printf '%s\n' '{"head":{"repo":{"full_name":"bot/project"},"sha":"abcdef0123456789"}}' ;;
  *'repos/acme/project/pulls/42/files?per_page=100'*)
    printf '%s\n' '[{"filename":"package.json"}]' ;;
  *'repos/bot/project/contents/package.json?ref=abcdef0123456789'*)
    content="$(printf '%s' '{"engines":{"node":">=18"},"devDependencies":{"vite":"^6.0.0"}}' | base64 -w0)"
    printf '{"content":"%s"}\n' "$content" ;;
  *) exit 1 ;;
esac
EOF
cat > "$TR/bin/curl" <<'EOF'
#!/bin/bash
url="${*: -1}"
printf '%s\n' "$url" >> "${CURL_LOG:-/dev/null}"
case "$url" in
  */5.0.0) [ -f "${BASELINE_FIXTURE:-}" ] || exit 22; cat "$BASELINE_FIXTURE" ;;
  */6.0.0) cat "${TARGET_FIXTURE:?}" ;;
  *) exit 22 ;;
esac
EOF
chmod +x "$TR/gh-stub" "$TR/bin/curl"

run_handler() {
  PATH="$TR/bin:$PATH" GARDEN_GH="$TR/gh-stub" TARGET_FIXTURE="$TR/target.json" \
    BASELINE_FIXTURE="$TR/baseline.json" CURL_LOG="$TR/curl.log" \
    "$HANDLER" acme/project 42 plugin-react 5.0.0 6.0.0
}

printf '%s' '{"peerDependencies":{"vite":"^6.0.0"}}' > "$TR/baseline.json"
printf '%s' '{"peerDependencies":{"vite":"^7.0.0"}}' > "$TR/target.json"
: > "$TR/curl.log"
out="$(run_handler)"
grep -q '/plugin-react/5.0.0$' "$TR/curl.log" || { echo "FAIL: outgoing manifest was not fetched"; exit 1; }
[ "$out" = $'incompatible\tpeer\tvite\t^6.0.0\t^7.0.0\tpackage.json' ] || {
  echo "FAIL: unexpected peer proof: $out"; exit 1;
}
echo "PASS: handler fetched the PR head and proved an empty peer intersection"

printf '%s' '{"engines":{"node":">=18"},"peerDependencies":{"vite":"^6.0.0"}}' > "$TR/target.json"
if run_handler > "$TR/out"; then
  echo "FAIL: compatible declarations returned a proof"; exit 1
fi
[ ! -s "$TR/out" ] || { echo "FAIL: compatible declarations emitted output"; exit 1; }
echo "PASS: handler falls open when declarations are compatible"

# endojs/endo-but-for-bots#1493: the outgoing version already required the same
# Node, so the bump raises no floor and must not be proven incompatible.
printf '%s' '{"engines":{"node":">=22.19.0"}}' > "$TR/baseline.json"
printf '%s' '{"engines":{"node":">=22.19.0"}}' > "$TR/target.json"
if run_handler > "$TR/out"; then
  echo "FAIL: a Node mismatch the outgoing version already had returned a proof"; exit 1
fi
[ ! -s "$TR/out" ] || { echo "FAIL: pre-existing Node mismatch emitted output"; exit 1; }
echo "PASS: handler ignores a Node mismatch the outgoing version already had"

printf '%s' '{"engines":{"node":">=10"}}' > "$TR/baseline.json"
printf '%s' '{"engines":{"node":">=22.19.0"}}' > "$TR/target.json"
out="$(run_handler)"
[ "$out" = $'incompatible\tnode\t18.0.0\t>=18\t>=22.19.0\tpackage.json' ] || {
  echo "FAIL: unexpected Node proof for a floor-raising bump: $out"; exit 1;
}
echo "PASS: handler proves a bump that itself raises the Node floor"

rm -f "$TR/baseline.json"
if run_handler > "$TR/out"; then
  echo "FAIL: an unreadable outgoing manifest returned a proof"; exit 1
fi
[ ! -s "$TR/out" ] || { echo "FAIL: unreadable outgoing manifest emitted output"; exit 1; }
echo "PASS: handler falls open when the outgoing manifest is unreadable"
