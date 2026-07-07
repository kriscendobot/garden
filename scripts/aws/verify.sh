#!/bin/bash
# verify.sh — assert the garden AWS identity from the host and every checkout home.
#
# Usage: verify.sh [checkout-root ...]
#
# Runs `aws sts get-caller-identity` once for the host home and once with
# HOME=<checkout> for each discovered checkout root, so it exercises the actual
# hard-linked credential file each home resolves. For every home it asserts:
#   - the caller is IAM user/garden-fleet (never the account :root), and
#   - the account is 292378781985, and
#   - the configured region is us-west-1.
# Any mismatch, or any home whose credential does not resolve, fails the whole
# run (non-zero exit) after reporting every home, so one bad link is visible even
# when the others pass.
set -euo pipefail

export PATH="$HOME/.local/bin:$PATH"

IAM_USER="${GARDEN_AWS_IAM_USER:-garden-fleet}"
EXPECT_ACCOUNT="${GARDEN_AWS_ACCOUNT:-292378781985}"
EXPECT_REGION="${GARDEN_AWS_REGION:-us-west-1}"

command -v aws >/dev/null 2>&1 || { echo "verify: aws not on PATH (install-aws-cli.sh)" >&2; exit 1; }

is_garden_checkout() {
  [ -f "$1/CLAUDE.md" ] && [ -d "$1/roles" ] && [ -d "$1/skills" ]
}

# The homes to check: the current host home first, then each discovered checkout
# root (deduped, and never repeating the host home).
homes=("$HOME")
add_home() {
  is_garden_checkout "$1" || return 0
  local abs; abs="$(cd "$1" && pwd)"
  local h; for h in "${homes[@]}"; do [ "$h" = "$abs" ] && return 0; done
  homes+=("$abs")
}

if [ "$#" -gt 0 ]; then
  for arg in "$@"; do
    is_garden_checkout "$arg" || { echo "verify: $arg is not a garden checkout" >&2; exit 1; }
    add_home "$arg"
  done
else
  add_home "$HOME"
  for d in "$HOME"/*/; do add_home "${d%/}"; done
fi

status=0
for home in "${homes[@]}"; do
  label="$home"
  read -r account arn < <(HOME="$home" aws sts get-caller-identity \
    --query '[Account,Arn]' --output text 2>/dev/null || echo "ERR ERR")
  region="$(HOME="$home" aws configure get region 2>/dev/null || true)"

  if [ "$arn" = "ERR" ]; then
    echo "verify: FAIL $label — sts get-caller-identity failed"; status=1; continue
  fi
  problems=""
  case "$arn" in
    *":user/$IAM_USER") : ;;
    *) problems="$problems identity=$arn(want user/$IAM_USER)" ;;
  esac
  case "$arn" in
    *":root") problems="$problems is-root!" ;;
  esac
  [ "$account" = "$EXPECT_ACCOUNT" ] || problems="$problems account=$account(want $EXPECT_ACCOUNT)"
  [ "$region" = "$EXPECT_REGION" ]   || problems="$problems region=${region:-unset}(want $EXPECT_REGION)"

  if [ -n "$problems" ]; then
    echo "verify: FAIL $label —$problems"; status=1
  else
    echo "verify: ok   $label — $arn @ $region"
  fi
done

[ "$status" -eq 0 ] && echo "verify: all ${#homes[@]} home(s) confirmed as user/$IAM_USER"
exit "$status"
