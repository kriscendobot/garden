#!/bin/bash
# comment-claude-fallback-test.sh — the ambiguity-fallback classifier
# (handlers/comment-claude.sh) must route a FEATURE / implementation / design
# directive to 'attention', NEVER to a mechanical verb guessed at random.
#
# Regression for the endojs/endo-but-for-bots #405 misroute
# (issuecomment-4819835663): a maintainer comment that was a feature-refinement
# directive ("hide empty groups; regroup the inventory into Directories / Agents /
# Personas / Values / Capabilities") was classified by the fallback as 'rebase',
# producing a no-op pr405-rebase job and silently dropping the real directive. The
# fallback forces `claude -p` to pick ONE token from
#   rebase | retcon | refresh | shepherd | gauntlet | attention | skip
# and the model, lacking a "change the code" verb, guessed the closest mechanical
# one. The fix is twofold and both halves are asserted here:
#   1. The PROMPT now states the mechanical verbs are ONLY for their literal git/CI
#      operation and that a behavior/UI/code/feature directive is 'attention'.
#   2. The token EXTRACTION prefers the model's LAST non-empty line, so a disobedient
#      model that reasons about a mechanical verb before answering 'attention' is not
#      misread by a whole-output first-match.
#
# Hermetic: a fake `claude` injected via GARDEN_COMMENT_CLAUDE stands in for the
# model (the handler's testability seam, like GARDEN_FOLLOWUP_CLAUDE); no network,
# no real claude, no journal. The fake records the prompt it received so the
# prompt-hardening assertion reads the ACTUAL prompt the handler built.
#
# Usage: comment-claude-fallback-test.sh

# The ok/bad idiom is the intended A && pass || fail (SC2015, safe: ok never fails).
# shellcheck disable=SC2015
set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
HANDLER="$JOBS/handlers/comment-claude.sh"
TR="$(mktemp -d "${TMPDIR:-/tmp}/comment-claude-test.XXXXXX")"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
trap 'rm -rf "$TR"' EXIT

# --- the deterministic `claude` stand-in, injected via GARDEN_COMMENT_CLAUDE ---
# The handler calls: "$GARDEN_COMMENT_CLAUDE" -p --dangerously-skip-permissions
# "<prompt>". We reuse the COMMITTED test/fake-claude.sh helper (FAKE_CLAUDE_BLOCKS
# = canned model output, FAKE_CLAUDE_PROMPT_OUT = capture the built prompt) rather
# than a temp stub: $TMPDIR (/tmp) is mounted noexec on the gardener hosts, so an
# executable created under mktemp cannot be exec'd — the committed helper under
# $HOME is exec-ok. PATH-shadowing `claude` is also unreliable (the sandbox
# resolves the real binary regardless of PATH order); the env seam is the contract.
export GARDEN_COMMENT_CLAUDE="$HERE/fake-claude.sh"

# The PR #405 feature directive, used as the fixture comment body.
BODY="$TR/body-405.md"
cat > "$BODY" <<'EOF'
Looking good! Two refinements before we land this:

- Hide empty groups entirely (don't render a header with no rows).
- Regroup the inventory into Directories / Agents / Personas / Values /
  Capabilities instead of the current flat list.
EOF

run() {  # run <fake-output-file> [prompt-capture-file] -> echoes the resolved token
  local out="$1" cap="${2:-/dev/null}"
  FAKE_CLAUDE_BLOCKS="$out" FAKE_CLAUDE_PROMPT_OUT="$cap" \
    "$HANDLER" endojs/endo-but-for-bots 405 alice \
    https://github.com/endojs/endo-but-for-bots/pull/405#issuecomment-4819835663 \
    "$BODY" 2>/dev/null
}

echo "comment-claude-fallback-test"

# --- A. a compliant single-token 'attention' answer is returned verbatim ------
A="$TR/out-a"; printf 'attention\n' > "$A"
tok="$(run "$A")"
[ "$tok" = attention ] && ok "compliant 'attention' token returned" \
  || bad "compliant 'attention' not returned (got '$tok')"

# --- B. the misroute fixture: a disobedient model that REASONS about a -----
#        mechanical verb before answering 'attention' must still resolve to
#        'attention', not the verb mentioned first in its reasoning. This is the
#        #405 misroute reproduced at the extraction layer.
B="$TR/out-b"
cat > "$B" <<'EOF'
This is a feature-refinement directive, not a request for a git rebase or refresh.
attention
EOF
tok="$(run "$B")"
[ "$tok" = attention ] && ok "disobedient 'not a rebase ... attention' resolves to attention" \
  || bad "misroute: feature directive resolved to '$tok' (expected attention)"

# --- C. the hardened PROMPT actually steers feature directives to attention ----
# Capture the real prompt the handler built and assert the steering language is
# present, so a future edit that drops it fails this test.
CAP="$TR/prompt.txt"; C="$TR/out-c"; printf 'attention\n' > "$C"
run "$C" "$CAP" >/dev/null
if [ -s "$CAP" ]; then
  grep -qiE "literal git/CI operation" "$CAP" \
    && ok "prompt reserves mechanical verbs for their literal operation" \
    || bad "prompt missing 'literal git/CI operation' steering"
  grep -qiE "is NOT a mechanical verb" "$CAP" \
    && ok "prompt states a behavior/UI/code change is NOT a mechanical verb" \
    || bad "prompt missing 'NOT a mechanical verb' steering"
  grep -qiE "feature request is 'attention'" "$CAP" \
    && ok "prompt says a feature request is 'attention', never rebase" \
    || bad "prompt missing 'feature request is attention' steering"
  grep -qiF "$(head -1 "$BODY")" "$CAP" \
    && ok "prompt embeds the (untrusted) comment body" \
    || bad "prompt did not embed the comment body"
else
  bad "prompt capture empty — fake claude did not receive a prompt"
fi

# --- D. a genuine mechanical request still passes through (no over-correction) -
# "please rebase this on master" → the model answers 'rebase'; the handler must
# still return it. The fix must not break the legitimate mechanical path.
D="$TR/out-d"; printf 'rebase\n' > "$D"
tok="$(run "$D")"
[ "$tok" = rebase ] && ok "legitimate mechanical 'rebase' still passes through" \
  || bad "mechanical path broken: got '$tok' (expected rebase)"

# --- E. chatter / unparseable output falls back to skip ----------------------
E="$TR/out-e"; printf 'I am not sure what you mean here.\n' > "$E"
tok="$(run "$E")"
[ "$tok" = skip ] && ok "no recognized token → skip" \
  || bad "unparseable output did not fall back to skip (got '$tok')"

echo
echo "comment-claude-fallback-test: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
