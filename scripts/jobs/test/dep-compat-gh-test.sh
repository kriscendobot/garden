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
cat "${TARGET_FIXTURE:?}"
EOF
chmod +x "$TR/gh-stub" "$TR/bin/curl"

printf '%s' '{"peerDependencies":{"vite":"^7.0.0"}}' > "$TR/target.json"
out="$(PATH="$TR/bin:$PATH" GARDEN_GH="$TR/gh-stub" TARGET_FIXTURE="$TR/target.json" \
  "$HANDLER" acme/project 42 plugin-react 6.0.0)"
[ "$out" = $'incompatible\tpeer\tvite\t^6.0.0\t^7.0.0\tpackage.json' ] || {
  echo "FAIL: unexpected peer proof: $out"; exit 1;
}
echo "PASS: handler fetched the PR head and proved an empty peer intersection"

printf '%s' '{"engines":{"node":">=18"},"peerDependencies":{"vite":"^6.0.0"}}' > "$TR/target.json"
if PATH="$TR/bin:$PATH" GARDEN_GH="$TR/gh-stub" TARGET_FIXTURE="$TR/target.json" \
  "$HANDLER" acme/project 42 plugin-react 6.0.0 > "$TR/out"; then
  echo "FAIL: compatible declarations returned a proof"; exit 1
fi
[ ! -s "$TR/out" ] || { echo "FAIL: compatible declarations emitted output"; exit 1; }
echo "PASS: handler falls open when declarations are compatible"
