#!/bin/bash
# Regression coverage for the pr-description-reviewer-attention review-miss
# cluster: scripts/jobs/gardening/pr-body-template-check.sh (template conformance)
# and skills/panel-hints/probes/C-pruner-pr-body.sh (concision). Each member is
# re-litigated against its historical artifact in fixtures/:
#   endojs/endo-but-for-bots#1281  body as opened 2026-09-15T23:08:36Z (from
#                                  userContentEdits) vs the base template
#   kriscendobot/agoric-sdk#16     body as reviewed (2026-07-13T16:11:11Z) and
#                                  review-thread reply 3576146608
# plus controls (a filled template, the one-permalink reply) and the panel.sh
# pre-pass binding a nonconforming body to must-fix.

set -uo pipefail

ROOT=$(cd "$(dirname "$0")/../../.." && pwd)
CHECK="$ROOT/scripts/jobs/gardening/pr-body-template-check.sh"
PROBE="$ROOT/skills/panel-hints/probes/C-pruner-pr-body.sh"
FX="$ROOT/scripts/jobs/test/fixtures/pr-description-reviewer-attention"
TMP=$(mktemp -d "${TMPDIR:-/tmp}/pr-body-template-test.XXXXXX")
trap 'rm -rf "$TMP"' EXIT

passes=0
failures=0
ok() { echo "ok - $1"; passes=$((passes + 1)); }
bad() { echo "not ok - $1"; failures=$((failures + 1)); }

# check <name> <want-rc> <body> <template> [grep-pattern]
check() {
  local name="$1" want="$2" body="$3" tpl="$4" pat="${5:-}" out rc
  out=$(bash "$CHECK" --body-file "$body" --template-file "$tpl" 2>&1); rc=$?
  if [ "$rc" -ne "$want" ]; then bad "$name: expected rc=$want, got $rc: $out"; return; fi
  if [ -n "$pat" ] && ! printf '%s\n' "$out" | grep -qE "$pat"; then
    bad "$name: output lacks /$pat/: $out"; return
  fi
  ok "$name (rc=$rc)"
}

# probe <name> fire|skip <kind> <file>
probe() {
  local name="$1" want="$2" kind="$3" file="$4" out
  out=$(bash "$PROBE" --kind "$kind" --body-file "$file" 2>&1)
  case "$out" in
    "$want pruner"*) ok "$name: $out" ;;
    *) bad "$name expected $want pruner, got: $out" ;;
  esac
}

# --- member re-litigation: template ---
check '#1281 as opened fails the template check' 20 \
  "$FX/endo-pr1281-body-opened.md" "$FX/endo-template.md" 'missing: template heading "description"'
check '#1281 as opened names its invented sections' 20 \
  "$FX/endo-pr1281-body-opened.md" "$FX/endo-template.md" 'invented: body heading "what was noisy"'
check '#16 as reviewed also ignored the agoric-sdk template' 20 \
  "$FX/agoric-sdk-pr16-body-reviewed.md" "$FX/agoric-sdk-template.md" 'missing: template heading "security considerations"'

# --- member re-litigation: concision ---
probe '#16 body as reviewed trips the concision probe' fire body "$FX/agoric-sdk-pr16-body-reviewed.md"
probe '#16 reply 3576146608 trips the concision probe' fire reply "$FX/agoric-sdk-pr16-reply-3576146608.md"
probe '#1281 body as opened trips the concision probe' fire body "$FX/endo-pr1281-body-opened.md"

# --- controls ---
probe 'the permalink reply that satisfied the reviewer abstains' skip reply "$FX/agoric-sdk-pr16-reply-3576491047.md"
out=$(bash "$PROBE" 2>&1)
[ "$out" = "skip pruner" ] && ok "no body (plain panel-hints run) abstains" || bad "no-body run: $out"

cat > "$TMP/filled.md" <<'EOF'
Closes: #1280

## Description

Permits the WHATWG `URL` statics so `lockdown()` reports nothing on Node 22 through 26.

### Security Considerations

Each permit is powerless: an empty frozen prototype, or an expressly removed symbol.

### Scaling Considerations

None.

### Documentation Considerations

None.

### Testing Considerations

The ses suite passes; see the CI run.

### Compatibility Considerations

None.

### Upgrade Considerations

None.

<!-- garden-job: ses-node26-lockdown-permits -->
EOF
check 'a filled template conforms' 0 "$TMP/filled.md" "$FX/endo-template.md"
probe 'a filled template abstains from concision' skip body "$TMP/filled.md"

{ cat "$TMP/filled.md"; printf '\n## Phase and evidence ledger\n\nDesign: `designs/x.md`\n'; } > "$TMP/ledger.md"
check 'the garden phase/evidence ledger is not an invented heading' 0 "$TMP/ledger.md" "$FX/endo-template.md"
{ cat "$TMP/filled.md"; printf '\n## Provenance\n\nBased on master.\n'; } > "$TMP/extra.md"
check 'an extra heading alone is attention, not a refusal' 10 "$TMP/extra.md" "$FX/endo-template.md" 'invented: body heading "provenance"'
sed 's/^### Security Considerations$/### Scaling Considerations/; t; s/^### Scaling Considerations$/### Security Considerations/' \
  "$TMP/filled.md" > "$TMP/swapped.md"
check 'out-of-order template headings fail' 20 "$TMP/swapped.md" "$FX/endo-template.md" 'out-of-order'
cp "$FX/endo-template.md" "$TMP/unfilled.md"
check 'the untouched template fails on leftover guidance' 20 "$TMP/unfilled.md" "$FX/endo-template.md" 'guidance: .*#XXXX'
printf '```\n## Description\n```\n' > "$TMP/fenced.md"
check 'a heading inside a code fence does not count' 20 "$TMP/fenced.md" "$FX/endo-template.md" 'missing: template heading "description"'

# --- template resolution from a base ref (panel mode) ---
repo="$TMP/repo"
git init -q "$repo"
git -C "$repo" -c user.name=t -c user.email=t@t commit -q --allow-empty -m none
git -C "$repo" branch -q no-template
mkdir -p "$repo/.github"
cp "$FX/endo-template.md" "$repo/.github/PULL_REQUEST_TEMPLATE.md"
git -C "$repo" add .github
git -C "$repo" -c user.name=t -c user.email=t@t commit -q -m template
out=$(bash "$CHECK" --body-file "$FX/endo-pr1281-body-opened.md" --base-ref HEAD --worktree "$repo" 2>&1); rc=$?
[ "$rc" -eq 20 ] && ok "template resolved from the base ref in the worktree (rc=20)" || bad "base-ref resolution: rc=$rc $out"
out=$(bash "$CHECK" --body-file "$FX/endo-pr1281-body-opened.md" --base-ref no-template --worktree "$repo" 2>&1); rc=$?
[ "$rc" -eq 0 ] && ok "no template on the base ref: nothing to conform to" || bad "no-template base: rc=$rc $out"
out=$(bash "$CHECK" --body-file "$FX/endo-pr1281-body-opened.md" --base-ref nonesuch --worktree "$repo" 2>&1); rc=$?
[ "$rc" -eq 3 ] && ok "an unresolvable base ref is unresolved (3), not 'no template'" || bad "bad base: rc=$rc $out"

# --- panel.sh wiring: the pre-pass forces the seats and binds must-fix ---
PANEL="$ROOT/scripts/jobs/gardening/panel.sh"
grep -q 'run_pr_body_prepass$' "$PANEL" && ok "panel.sh runs the PR-body pre-pass each round" || bad "panel.sh does not call run_pr_body_prepass"
grep -q 'PR_BODY_TEMPLATE_BLOCKED" -eq 1 ]; then' "$PANEL" && ok "a nonconforming body binds the disposition" || bad "panel.sh does not bind PR_BODY_TEMPLATE_BLOCKED"
# Exercise the function body in isolation against the fixture repo.
fn=$(sed -n '/^PR_BODY_TEMPLATE_CHECK=/,/^# --- the panel \/ fixer loop/p' "$PANEL" | sed '$d')
out=$(
  HERE="$ROOT/scripts/jobs/gardening" GARDEN_PANEL_RUNDIR="$TMP/run" wt="$repo" base=HEAD \
  wt_repo="" pr=1281 seats="assessor" GARDEN_PANEL_PR_BODY_FILE="$FX/endo-pr1281-body-opened.md" \
  bash -c "mkdir -p \"\$GARDEN_PANEL_RUNDIR\"; $fn
run_pr_body_prepass 2>/dev/null
echo \"blocked=\$PR_BODY_TEMPLATE_BLOCKED seats=\$seats\"
[ -s \"\${GARDEN_PANEL_PR_BODY_TEMPLATE_EVIDENCE:-/nonexistent}\" ] && echo template-evidence
[ -s \"\${GARDEN_PANEL_PR_BODY_CONCISION_EVIDENCE:-/nonexistent}\" ] && echo concision-evidence"
)
case "$out" in
  *"blocked=1 seats=assessor integrator pruner"*template-evidence*concision-evidence*)
    ok "pre-pass on #1281: blocked, integrator + pruner forced, evidence handed over" ;;
  *) bad "pre-pass on #1281: $out" ;;
esac

echo "# $passes passed, $failures failed"
[ "$failures" -eq 0 ]
