#!/bin/bash
# container-hardening-maintainer-cred-test.sh — regression guard for check 6 of
# scripts/check-container-hardening.sh (the "no maintainer gh credential" probe).
#
# THE GAP THIS CLOSES: check 6 used to `grep -qi kriskowal` over `gh auth status`
# text AND over ~/.config/gh/hosts.yml. That is a SUBSTRING match, so any incidental
# occurrence of the maintainer's name — a `kriskowal/garden` repo path, a gh-wrapper
# notice, a config comment/key — tripped a FALSE POSITIVE. On the leader
# (endolin-garden-ece02cb4) the probe reported "kriskowal logged into the bot's gh"
# while the only logged-in account was kriscendobot, which would false-alarm the
# twice-daily garden-container-hardening timer forever once deployed.
#
# THE FIX: compare ACCOUNT LOGINS structurally, never substring text. check 6 now
# enumerates logged-in gh accounts (`gh auth status --json hosts`, else a strict
# hosts.yml parse) and resolves GH_TOKEN/GITHUB_TOKEN to their owning login
# (`gh api user`), and fails only when a login EQUALS a maintainer login (default
# kriskowal; overridable via GARDEN_MAINTAINER_LOGIN or the journal allowlist). It
# uses the REAL gh, not the fleet identity wrapper, so the wrapper's bot-identity
# pin cannot mask a leaked maintainer credential.
#
# The check exposes a `--maintainer-cred-selftest` seam that runs ONLY check 6's
# detection (no container guard, no other checks): it prints "REACHABLE <offenders>"
# + exit 1 when a maintainer credential is reachable, else "CLEAN" + exit 0.
#
# Hermetic: a fake gh is placed first on PATH modelling `auth status` (emits a
# fixture login list, or refuses --json to force the hosts.yml fallback) and
# `api user` (maps a fixture token → login). No network, no real ~/.config/gh.
#
# Usage: container-hardening-maintainer-cred-test.sh
set -uo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
CHECK="$JOBS/../check-container-hardening.sh"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# Scrub ambient fleet env so a live gardener running this as a board job does not
# splice its own GARDEN_*/GH_*/GITHUB_* state underneath the fixture.
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|GH_|GITHUB_)' || true) 2>/dev/null || true

# Base the throwaway tree on an EXEC-capable fs ($HOME; ext4) — the fleet /tmp is
# noexec, and a fake gh under a noexec mount would be invisible to the check's
# `type -aP gh` executability walk, silently falling through to the REAL gh.
TMPBASE="${GARDEN_TEST_TMP:-$HOME}"
TR="$(mktemp -d "$TMPBASE/.hardening-cred-test.XXXXXX")"; trap 'rm -rf "$TR"' EXIT
printf '#!/bin/sh\nexit 0\n' > "$TR/.execprobe"; chmod +x "$TR/.execprobe"
"$TR/.execprobe" 2>/dev/null || { echo "FATAL: $TMPBASE is noexec; set GARDEN_TEST_TMP to an exec-capable dir" >&2; exit 2; }

# --- the fake real gh behind the check ---------------------------------------
# `auth status --json …` prints the fixture login list ($FAKE_GH_LOGINS, one per
# line) — modelling gh having applied the requested --jq — unless FAKE_GH_NO_JSON=1,
# in which case it fails so the check exercises its hosts.yml fallback. `api user`
# resolves the CURRENT GH_TOKEN to a login via a fixed map, so the env-token path
# is testable offline.
FAKEBIN="$TR/bin"; mkdir -p "$FAKEBIN"
cat > "$FAKEBIN/gh" <<'EOF'
#!/bin/bash
set -uo pipefail
if [ "${1:-}" = auth ] && [ "${2:-}" = status ]; then
  [ "${FAKE_GH_NO_JSON:-0}" = 1 ] && exit 2
  # shellcheck disable=SC2086
  [ -n "${FAKE_GH_LOGINS:-}" ] && printf '%s\n' $FAKE_GH_LOGINS
  exit 0
fi
if [ "${1:-}" = api ] && [ "${2:-}" = user ]; then
  case "${GH_TOKEN:-}" in
    tok-kriskowal)     echo kriskowal;;
    tok-kriscendobot)  echo kriscendobot;;
    *) exit 1;;
  esac
  exit 0
fi
exit 0
EOF
chmod +x "$FAKEBIN/gh"

# Put the fake gh first; STRIP scripts/jobs/bin so the deployed fleet wrapper is
# never picked as "real gh" (the check's real_gh_bin skips it anyway, but keep the
# fixture clean). GARDEN_MAINTAINER_LOGIN pins the maintainer set hermetically so
# the check never consults the real journal allowlist (except the one case below
# that tests allowlist resolution explicitly).
CLEANPATH="$(printf '%s' "$PATH" | tr ':' '\n' | grep -v '/scripts/jobs/bin$' | paste -sd: -)"
export PATH="$FAKEBIN:$CLEANPATH"

# selftest <expect: CLEAN|REACHABLE> "<label>" <env assignments...> :
# run the check's maintainer-cred seam with the given per-case env and assert the
# verdict. Extra args after the label are `KEY=VALUE` env overrides.
selftest() {
  local want="$1" label="$2"; shift 2
  local out rc
  out="$(env "$@" bash "$CHECK" --maintainer-cred-selftest 2>/dev/null)"; rc=$?
  case "$want" in
    CLEAN)     { [ "$rc" -eq 0 ] && [ "$out" = CLEAN ]; } \
                 && ok "$label → CLEAN" || bad "$label → want CLEAN, got rc=$rc out='$out'";;
    REACHABLE) { [ "$rc" -eq 1 ] && [[ "$out" == REACHABLE* ]]; } \
                 && ok "$label → $out" || bad "$label → want REACHABLE, got rc=$rc out='$out'";;
  esac
}

# write_hosts_yml <dir> <body> : materialize a fixture gh config dir with hosts.yml.
write_hosts_yml() { mkdir -p "$1"; printf '%s\n' "$2" > "$1/hosts.yml"; }

# ============================================================================
hr; echo "SUBTEST 1 — JSON path: only the bot logged in → CLEAN"; hr
selftest CLEAN "only kriscendobot logged in" \
  GARDEN_MAINTAINER_LOGIN=kriskowal FAKE_GH_LOGINS="kriscendobot"

# ============================================================================
hr; echo "SUBTEST 2 — JSON path: a maintainer account logged in → REACHABLE"; hr
selftest REACHABLE "kriskowal among logged-in accounts" \
  GARDEN_MAINTAINER_LOGIN=kriskowal FAKE_GH_LOGINS="kriscendobot kriskowal"
# case-insensitive login match (GitHub logins are case-insensitive)
selftest REACHABLE "KrisKowal (mixed case) still matches" \
  GARDEN_MAINTAINER_LOGIN=kriskowal FAKE_GH_LOGINS="kriscendobot KrisKowal"

# ============================================================================
hr; echo "SUBTEST 3 — hosts.yml FALLBACK (no --json): kriskowal/garden in a"; \
    echo "            NON-user field → CLEAN (the substring false positive fixed)"; hr
GHCFG="$TR/ghcfg-nonuser"
write_hosts_yml "$GHCFG" 'github.com:
    users:
        kriscendobot:
            oauth_token: gho_REDACTED
    git_protocol: https
    user: kriscendobot
    oauth_token: gho_REDACTED
    # note: forked from kriskowal/garden (transferred) — must NOT trip check 6'
selftest CLEAN "kriskowal/garden repo path in a comment does not false-alarm" \
  GARDEN_MAINTAINER_LOGIN=kriskowal FAKE_GH_NO_JSON=1 GH_CONFIG_DIR="$GHCFG"

# ============================================================================
hr; echo "SUBTEST 4 — hosts.yml FALLBACK: a real users:{kriskowal:} entry → REACHABLE"; hr
GHCFG2="$TR/ghcfg-realuser"
write_hosts_yml "$GHCFG2" 'github.com:
    users:
        kriscendobot:
            oauth_token: gho_REDACTED
        kriskowal:
            oauth_token: gho_REDACTED
    git_protocol: https
    user: kriscendobot
    oauth_token: gho_REDACTED'
selftest REACHABLE "kriskowal as a real logged-in users: key is caught" \
  GARDEN_MAINTAINER_LOGIN=kriskowal FAKE_GH_NO_JSON=1 GH_CONFIG_DIR="$GHCFG2"
# and when kriskowal is the ACTIVE `user:` field
GHCFG3="$TR/ghcfg-activeuser"
write_hosts_yml "$GHCFG3" 'github.com:
    users:
        kriskowal:
            oauth_token: gho_REDACTED
    git_protocol: https
    user: kriskowal
    oauth_token: gho_REDACTED'
selftest REACHABLE "kriskowal as the active user: field is caught" \
  GARDEN_MAINTAINER_LOGIN=kriskowal FAKE_GH_NO_JSON=1 GH_CONFIG_DIR="$GHCFG3"

# ============================================================================
hr; echo "SUBTEST 5 — env token resolving to a maintainer → REACHABLE; bot token → CLEAN"; hr
selftest REACHABLE "GH_TOKEN resolves to kriskowal" \
  GARDEN_MAINTAINER_LOGIN=kriskowal FAKE_GH_LOGINS="kriscendobot" GH_TOKEN=tok-kriskowal
selftest REACHABLE "GITHUB_TOKEN resolves to kriskowal" \
  GARDEN_MAINTAINER_LOGIN=kriskowal FAKE_GH_LOGINS="kriscendobot" GITHUB_TOKEN=tok-kriskowal
selftest CLEAN "GH_TOKEN resolves to the bot (kriscendobot) → fine" \
  GARDEN_MAINTAINER_LOGIN=kriskowal FAKE_GH_LOGINS="kriscendobot" GH_TOKEN=tok-kriscendobot

# ============================================================================
hr; echo "SUBTEST 6 — maintainer set comes from config, not a hardcode"; hr
# A different maintainer login (someone-else) is honored; kriskowal is then just
# another account and does NOT trip the check.
selftest REACHABLE "GARDEN_MAINTAINER_LOGIN=someone-else catches that login" \
  GARDEN_MAINTAINER_LOGIN=someone-else FAKE_GH_LOGINS="kriscendobot someone-else"
selftest CLEAN "with maintainer=someone-else, a logged-in kriskowal is not flagged" \
  GARDEN_MAINTAINER_LOGIN=someone-else FAKE_GH_LOGINS="kriscendobot kriskowal"
# allowlist-file resolution (no GARDEN_MAINTAINER_LOGIN set): a login on the
# allowlist is caught.
ALLOW="$TR/allowlist"; printf '# maintainers\nkriskowal\nerights\n' > "$ALLOW"
selftest REACHABLE "journal allowlist supplies the maintainer set" \
  GARDEN_MAINTAINERS_ALLOWLIST="$ALLOW" FAKE_GH_LOGINS="kriscendobot erights"
selftest CLEAN "allowlist set: only the bot logged in → CLEAN" \
  GARDEN_MAINTAINERS_ALLOWLIST="$ALLOW" FAKE_GH_LOGINS="kriscendobot"

# ============================================================================
hr
echo "SUMMARY: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
