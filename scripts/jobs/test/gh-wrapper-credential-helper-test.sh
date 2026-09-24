#!/bin/bash
# gh-wrapper-credential-helper-test.sh — regression guard for the fleet gh
# wrapper's ambient-credential-helper suppression (scripts/jobs/bin/gh).
#
# THE GAP THIS CLOSES: a git credential helper named by an ambient gitconfig could
# be consulted (and, for credential-cache, daemonized) underneath a fleet `gh`
# call; the detached daemon outlived the caller's process-group reap and showed up
# as "Found left-over process … (git)" in garden-ci-watcher@ (2026-09-24).
#
# Hermetic: HOME points at a throwaway dir whose global gitconfig names a plain
# and a URL-scoped helper that each log to a file when run. A fake "real gh"
# behind the wrapper runs `git credential fill` the way gh's internals would.
# GH_TOKEN is pre-set so the wrapper never resolves a token. No network.
set -uo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WRAPPER_DIR="$(cd "$HERE/.." && pwd)/bin"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }

# shellcheck disable=SC2046
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|GH_|GIT_CONFIG_)' || true) 2>/dev/null || true
export GARDEN_TEST=1

# /tmp is noexec here, and a fake gh on a noexec mount is invisible to the
# wrapper's `type -aP gh` walk (it would fall through to the REAL gh).
TMPBASE="${GARDEN_TEST_TMP:-$HOME}"
TR="$(mktemp -d "$TMPBASE/.gh-wrapper-cred-test.XXXXXX")"; trap 'rm -rf "$TR"' EXIT
printf '#!/bin/sh\nexit 0\n' > "$TR/.execprobe"; chmod +x "$TR/.execprobe"
"$TR/.execprobe" 2>/dev/null || { echo "FATAL: $TMPBASE is noexec; set GARDEN_TEST_TMP to an exec-capable dir" >&2; exit 2; }

REALBIN="$TR/realbin"; mkdir -p "$REALBIN" "$TR/home"
HELPLOG="$TR/helper.log"
export HOME="$TR/home" GIT_CONFIG_NOSYSTEM=1 GH_CONFIG_DIR="$TR/empty-gh-config" GH_TOKEN=fake
mkdir -p "$GH_CONFIG_DIR"
git config --global credential.helper "!f(){ echo plain >> '$HELPLOG'; }; f"
git config --global 'credential.https://example.com.helper' "!f(){ echo scoped >> '$HELPLOG'; }; f"

# Fake real gh: `cred` models gh's internals consulting ambient git config;
# `cred-own` models gh's own authenticated git call (explicit -c helper);
# `env` dumps the injected git env.
cat > "$REALBIN/gh" <<FAKE
#!/bin/bash
case "\$1" in
  cred)     printf 'protocol=https\nhost=example.com\n\n' | git credential fill >/dev/null 2>&1; exit 0;;
  cred-own) printf 'protocol=https\nhost=example.com\n\n' | git -c credential.helper= \
              -c "credential.https://example.com.helper=!f(){ echo own >> '$HELPLOG'; echo username=u; echo password=p; }; f" \
              credential fill >/dev/null 2>&1; exit 0;;
  env)      env | grep -E '^GIT_(CONFIG_(COUNT|KEY_|VALUE_)|TERMINAL_PROMPT)' | sort; exit 0;;
esac
FAKE
chmod +x "$REALBIN/gh"
export PATH="$WRAPPER_DIR:$REALBIN:/usr/bin:/bin"

echo "== baseline: the fixture helpers really fire without the wrapper"
: > "$HELPLOG"; "$REALBIN/gh" cred
grep -qx plain "$HELPLOG" && grep -qx scoped "$HELPLOG" && ok "ambient helpers fire bare" || bad "fixture helpers did not fire: $(cat "$HELPLOG")"

echo "== wrapper suppresses plain and URL-scoped ambient helpers"
: > "$HELPLOG"; gh cred
[ ! -s "$HELPLOG" ] && ok "no ambient helper consulted" || bad "helper ran under wrapper: $(cat "$HELPLOG")"

echo "== gh's own explicit -c helper still works"
: > "$HELPLOG"; gh cred-own
[ "$(cat "$HELPLOG")" = own ] && ok "gh's own helper consulted, ambient not" || bad "helper log: $(cat "$HELPLOG")"

echo "== caller-set GIT_CONFIG_* entries are preserved (append, not clobber)"
out="$(GIT_CONFIG_COUNT=1 GIT_CONFIG_KEY_0=core.pager GIT_CONFIG_VALUE_0=cat gh env)"
printf '%s\n' "$out" | grep -qx 'GIT_CONFIG_KEY_0=core.pager' \
  && printf '%s\n' "$out" | grep -qx 'GIT_CONFIG_KEY_1=credential.helper' \
  && printf '%s\n' "$out" | grep -qx 'GIT_CONFIG_COUNT=2' \
  && printf '%s\n' "$out" | grep -qx 'GIT_TERMINAL_PROMPT=0' \
  && ok "appended at index 1, COUNT=2, prompts off" || bad "env was: $out"

echo "== opt-out leaves ambient helpers alone"
: > "$HELPLOG"; GARDEN_GH_KEEP_CREDENTIAL_HELPER=1 gh cred
grep -qx plain "$HELPLOG" && ok "opt-out honored" || bad "opt-out ignored: $(cat "$HELPLOG")"

echo "passed=$PASS failed=$FAIL"
[ "$FAIL" -eq 0 ]
