#!/bin/bash
# gh-wrapper-fail-closed-test.sh — regression guard for the fleet gh wrapper's
# fail-CLOSED-on-writes fallback (scripts/jobs/bin/gh).
#
# THE GAP THIS CLOSES (#521): the wrapper's token-resolution fallback was
# fail-OPEN — when GH_TOKEN was unset and `gh auth token --user kriscendobot`
# could not be resolved, it printed a WARNING and then unconditionally exec'd the
# real gh against the GLOBAL active account, which on the maintainer's host is
# kriskowal. For a read that degradation is tolerable; for a MUTATING call it
# silently performed the action as the maintainer — a PR opened under the human
# instead of @kriscendobot, blocking review and requiring manual remediation.
#
# THE FIX: in the unresolved-token fallback, detect state-changing invocations
# (pr/issue lifecycle verbs, `gh api` with a mutating method or field flags — the
# path reactji/comment POSTs take) and FAIL CLOSED (exit non-zero, loud
# kind:error message, real gh NEVER exec'd). Read-only calls keep the tolerant
# degrade-to-bare-gh behavior so pollers/detectors do not break.
#
# Hermetic: the wrapper (scripts/jobs/bin/gh) is put first on PATH; a throwaway
# "real gh" behind it records its argv to a log and models `auth token` +
# `auth status`. Token resolution is forced to FAIL (fallback branch) or SUCCEED
# (injection branch) per subtest via FAKE_TOKEN_OK. No network, no ~/.config/gh.
#
# Usage: gh-wrapper-fail-closed-test.sh
set -uo pipefail
# Explicit positive test-context sentinel: protects this standalone suite even when
# invoked outside the test-tree entrypoint heuristic.
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
WRAPPER_DIR="$JOBS/bin"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# Scrub ambient fleet env so a live gardener running this as a board job does not
# splice its own GARDEN_*/GH_TOKEN state underneath the fixture.
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|GH_)' || true) 2>/dev/null || true

# CRITICAL: the fake real gh is placed on PATH and must be EXECUTABLE. The default
# fleet TMPDIR (/tmp) is mounted `noexec` here, and a fake gh under a noexec mount
# is silently invisible to the wrapper's `type -aP gh` executability search — the
# wrapper would then fall through to the REAL /usr/bin/gh, whose live bot token
# resolves, and the "write" subtests would fire actual mutations against GitHub
# (this bit once: it closed a real PR and posted comments before this was fixed).
# So base the throwaway tree on an EXEC-capable filesystem: $HOME (the garden root,
# ext4) unless GARDEN_TEST_TMP names another. Fail loudly if it is still noexec.
TMPBASE="${GARDEN_TEST_TMP:-$HOME}"
TR="$(mktemp -d "$TMPBASE/.gh-wrapper-test.XXXXXX")"; trap 'rm -rf "$TR"' EXIT
REALBIN="$TR/realbin"; mkdir -p "$REALBIN"
GHLOG="$TR/real-gh-argv.log"
printf '#!/bin/sh\nexit 0\n' > "$TR/.execprobe"; chmod +x "$TR/.execprobe"
"$TR/.execprobe" 2>/dev/null || { echo "FATAL: $TMPBASE is noexec; set GARDEN_TEST_TMP to an exec-capable dir" >&2; exit 2; }

# SAFETY NET (defense in depth): point gh's config at an EMPTY dir for the whole
# test, so even if the fake real gh were ever bypassed and the REAL gh ran, it
# would find no logged-in account, resolve no token, and thus perform NO
# authenticated mutation — a token-less real gh write fails, it does not land as
# the bot. The fake gh ignores this (it is our own script); it only backstops a
# resolution regression like the noexec one above.
export GH_CONFIG_DIR="$TR/empty-gh-config"; mkdir -p "$GH_CONFIG_DIR"

# The throwaway "real gh" sitting BEHIND the wrapper on PATH. It records every
# invocation the wrapper exec's into it (proof the call was NOT fail-closed), and
# models the two behaviors the wrapper drives: `auth token --user` (resolves iff
# FAKE_TOKEN_OK=1) and `auth status` (a read the wrapper must still let through).
cat > "$REALBIN/gh" <<EOF
#!/bin/bash
set -uo pipefail
if [ "\${1:-}" = "auth" ] && [ "\${2:-}" = "token" ]; then
  if [ "\${FAKE_TOKEN_OK:-0}" = "1" ]; then echo "token-for-kriscendobot"; exit 0; fi
  exit 1
fi
printf '%s\0' "\$@" >> "$GHLOG"
printf '\n' >> "$GHLOG"
echo "real-gh ran: \$*"
exit 0
EOF
chmod +x "$REALBIN/gh"

# Put the wrapper first, the fake real gh right behind it, and STRIP every
# scripts/jobs/bin entry the fleet PATH already carries — the DEPLOYED wrapper
# (/home/kris/garden/scripts/jobs/bin/gh) is on the inherited PATH, and if it
# survives, the wrapper's `type -aP gh` self-skip picks that OTHER copy of itself
# as "real gh" and the two wrappers recurse forever (an infinite-loop hang). With
# the wrapper dirs removed, `type -aP gh` resolves [wrapper (self) → skip, fake →
# real_gh], so the fake backs the wrapper deterministically.
CLEANPATH="$(printf '%s' "$PATH" | tr ':' '\n' | grep -v '/scripts/jobs/bin$' | paste -sd: -)"
export PATH="$WRAPPER_DIR:$REALBIN:$CLEANPATH"

# gh_ran — did the real gh execute during the LAST call? (log grows only when the
# wrapper exec'd it; auth-token probes exit before the log write.)
reset_log() { : > "$GHLOG"; }
gh_ran() { [ -s "$GHLOG" ]; }

# run_wrapped <expect-rc> "<label>" -- <gh args...> : run the wrapper with token
# resolution FAILING (fallback branch), assert the exit code.
run_wrapped() {
  local want="$1" label="$2"; shift 2; [ "${1:-}" = "--" ] && shift
  reset_log
  FAKE_TOKEN_OK=0 GARDEN_GH_IDENTITY=kriscendobot gh "$@" >/dev/null 2>"$TR/err"
  local rc=$?
  if [ "$rc" -eq "$want" ]; then ok "$label → rc=$rc"; else
    bad "$label → rc=$rc, expected $want (stderr: $(tr -d '\0' <"$TR/err" | head -1))"; fi
}

# ============================================================================
hr; echo "SUBTEST 1 — unresolved token + WRITE call → FAIL CLOSED (rc!=0, real gh NOT run)"; hr
# Each of these is a genuine mutation; the wrapper must refuse rather than act as
# the global active account.
for spec in \
  "pr create --title x --body y" \
  "pr comment 5 --body hi" \
  "pr review 5 --approve" \
  "pr merge 5" \
  "pr edit 5 --add-label z" \
  "pr close 5" \
  "issue create --title x" \
  "issue comment 7 --body hi" \
  "issue edit 7 --add-label z" \
  "issue close 7" \
  "api -X POST repos/o/r/issues/1/comments -f body=hi" \
  "api --method PATCH repos/o/r/pulls/1 -f title=x" \
  "api repos/o/r/issues/comments/9/reactions -f content=eyes" \
  "api repos/o/r/x -X DELETE" \
; do
  # shellcheck disable=SC2086
  run_wrapped 1 "WRITE: gh $spec" -- $spec
  gh_ran && bad "  real gh WAS exec'd for a blocked write: gh $spec" || ok "  real gh not exec'd (write blocked): gh $spec"
done
# The loud message must name the unresolved identity and be kind:error-greppable.
reset_log
FAKE_TOKEN_OK=0 GARDEN_GH_IDENTITY=kriscendobot gh pr create --title x --body y >/dev/null 2>"$TR/err" || true
grep -q "kind:error" "$TR/err" && grep -q "kriscendobot" "$TR/err" \
  && ok "fail-closed message is kind:error-style and names the identity" \
  || bad "fail-closed message missing kind:error/identity: $(head -1 "$TR/err")"

# ============================================================================
hr; echo "SUBTEST 2 — unresolved token + READ call → tolerant degrade (rc=0, real gh RUNS)"; hr
for spec in \
  "pr view 5" \
  "pr list" \
  "issue view 7" \
  "issue list" \
  "auth status" \
  "api repos/o/r/pulls/1" \
  "api -X GET repos/o/r/pulls/1" \
  "api repos/o/r/pulls -X GET -f state=open" \
  "api graphql -f query=x" \
; do
  # `api graphql -f query=` is technically a POST to /graphql but is a READ in
  # practice; it is NOT in the mutating set, so it degrades. Guarded here so a
  # future over-broadening of the field-flag rule that catches graphql reads is
  # caught. (An explicit -X GET with -f keeps fields as query params → read.)
  # shellcheck disable=SC2086
  run_wrapped 0 "READ: gh $spec" -- $spec
  gh_ran && ok "  real gh exec'd (read degraded): gh $spec" || bad "  real gh NOT exec'd for a read: gh $spec"
done

# ============================================================================
hr; echo "SUBTEST 3 — token RESOLVES → write is injected and exec'd (fallback not entered)"; hr
reset_log
FAKE_TOKEN_OK=1 GARDEN_GH_IDENTITY=kriscendobot gh pr create --title x --body y >/dev/null 2>"$TR/err"
rc=$?
{ [ "$rc" -eq 0 ] && gh_ran; } \
  && ok "resolvable identity → write exec'd (rc=0, real gh ran)" \
  || bad "resolvable-identity write should exec (rc=$rc, ran=$(gh_ran && echo y || echo n))"

# ============================================================================
hr; echo "SUBTEST 4 — caller pre-set GH_TOKEN (boatman path) → write exec'd untouched"; hr
# A pre-set GH_TOKEN never enters the resolution fallback at all, so even a write
# with an unresolvable GARDEN_GH_IDENTITY must pass straight through.
reset_log
FAKE_TOKEN_OK=0 GH_TOKEN=token-for-kriskowal GARDEN_GH_IDENTITY=kriskowal gh pr create --title x --body y >/dev/null 2>"$TR/err"
rc=$?
{ [ "$rc" -eq 0 ] && gh_ran; } \
  && ok "pre-set GH_TOKEN → write exec'd untouched (authorized-ferry surface preserved)" \
  || bad "pre-set GH_TOKEN write should exec (rc=$rc, ran=$(gh_ran && echo y || echo n))"

# ============================================================================
hr
echo "SUMMARY: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
