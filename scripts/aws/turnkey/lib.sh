#!/usr/bin/env bash
# lib.sh — shared configuration and helpers for the turnkey Amazon garden host
# pipeline (designs/turnkey-garden-host.md).
#
# Every script here is a HOST-ADMINISTRATION script run from a shell that already
# holds the garden-fleet AWS credential (skills/aws-administration/SKILL.md), NOT a
# fleet job off the board. It sources this file for a single source of truth for the
# account/region, the pinned base image, resource names, and tags. Nothing here
# writes a secret; the whole point of the design is that no Claude subscription
# credential, GitHub token, or user secret ever enters the AMI, the launch template,
# the repository, or user-data.

set -euo pipefail

# ---- AWS identity / region (defaults match the live endolin setup) -------------
# Overridable, but the defaults are the garden's one account + nearest-SF region.
export GARDEN_AWS_ACCOUNT="${GARDEN_AWS_ACCOUNT:-292378781985}"
export GARDEN_AWS_REGION="${GARDEN_AWS_REGION:-us-west-1}"
export AWS_DEFAULT_REGION="${GARDEN_AWS_REGION}"
export AWS_PAGER=""

# ---- Pinned base image ---------------------------------------------------------
# The design says: "start from the pinned Ubuntu ARM64 base already used for the
# current EC2 host." That is the image behind minion.town i-0380cd68b90020fad:
#   ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-arm64-server-20260626
# Canonical owner 099720109477. We PIN the id (reproducible bakes) but also record
# the SSM public-parameter path that resolves the *current* Canonical arm64 image,
# so a security-base refresh is a one-line re-pin, not an archaeology dig.
export GARDEN_TURNKEY_BASE_AMI="${GARDEN_TURNKEY_BASE_AMI:-ami-0b9023009667261d9}"
export GARDEN_TURNKEY_BASE_SSM_PARAM="/aws/service/canonical/ubuntu/server/24.04/stable/current/arm64/hvm/ebs-gp3/ami-id"
export GARDEN_TURNKEY_ARCH="arm64"

# The garden source the AMI ships. Public repo (no auth to clone); we pin a reviewed
# main2 revision at bake time so the AMI records exactly what it carries.
export GARDEN_TURNKEY_SOURCE_REPO="${GARDEN_TURNKEY_SOURCE_REPO:-https://github.com/kriscendobot/garden.git}"
export GARDEN_TURNKEY_SOURCE_BRANCH="${GARDEN_TURNKEY_SOURCE_BRANCH:-main2}"
# The on-host checkout location (also the bind-mounted container home).
export GARDEN_TURNKEY_CHECKOUT="/home/ubuntu/garden"

# ---- Builder sizing ------------------------------------------------------------
# The container build compiles Go tooling and fetches the Ollama runtime, so a
# builder with real cores keeps the bake short. m7g.xlarge (4 vCPU / 16 GiB,
# Graviton3) balances speed against the ~$0.16/hr on-demand cost; the bake runs
# well under an hour, so the builder is a few tens of cents. Override for a cheaper
# (t4g.large) or faster (c7g.2xlarge) box.
export GARDEN_TURNKEY_BUILDER_TYPE="${GARDEN_TURNKEY_BUILDER_TYPE:-m7g.xlarge}"
export GARDEN_TURNKEY_TEST_TYPE="${GARDEN_TURNKEY_TEST_TYPE:-t4g.medium}"
# Root volume: encrypted gp3, sized for the base OS + Docker + the built container
# image (Go tools + Ollama runtime push the image toward ~15 GiB).
export GARDEN_TURNKEY_VOLUME_GB="${GARDEN_TURNKEY_VOLUME_GB:-50}"

# ---- Resource names ------------------------------------------------------------
export GARDEN_TURNKEY_PREFIX="garden-turnkey"
export GARDEN_TURNKEY_ROLE="${GARDEN_TURNKEY_PREFIX}-ssm"          # IAM role + instance profile
export GARDEN_TURNKEY_SG="${GARDEN_TURNKEY_PREFIX}"                # launch/runtime SG (SSM-only)
export GARDEN_TURNKEY_TEST_SG="${GARDEN_TURNKEY_PREFIX}-test"      # separate smoke-test SG
export GARDEN_TURNKEY_LT="${GARDEN_TURNKEY_PREFIX}"                # launch template
export GARDEN_TURNKEY_SECRET_POLICY="${GARDEN_TURNKEY_PREFIX}-secret-read"  # OPTIONAL PAT path

# The AWS project tag stays distinct from minion-town so the turnkey artifacts are
# independently listable and never entangle with the web host's inventory.
export GARDEN_TURNKEY_PROJECT_TAG="garden-turnkey"

aws() { command aws --region "$GARDEN_AWS_REGION" "$@"; }

# Fail early if the wrong identity is loaded — every one of these scripts mutates
# real AWS state, and we never want them to run against a stranger's account.
turnkey_require_identity() {
  local got
  got="$(aws sts get-caller-identity --query Account --output text 2>/dev/null || true)"
  if [[ "$got" != "$GARDEN_AWS_ACCOUNT" ]]; then
    echo "turnkey: refusing to run — active AWS account '$got' != expected '$GARDEN_AWS_ACCOUNT'." >&2
    echo "turnkey: seed the garden-fleet credential first (skills/aws-administration)." >&2
    return 1
  fi
}

# A default subnet in the region's first AZ (the turnkey host is single-AZ; the
# operator relaunches, they do not run a fleet of these).
turnkey_default_subnet() {
  aws ec2 describe-subnets \
    --filters Name=default-for-az,Values=true \
    --query 'Subnets|sort_by(@,&AvailabilityZone)[0].SubnetId' --output text
}

turnkey_default_vpc() {
  aws ec2 describe-vpcs --filters Name=isDefault,Values=true \
    --query 'Vpcs[0].VpcId' --output text
}

# Common tag-spec fragment builders (project tag on everything we create).
turnkey_tag_json() {   # $1=ResourceType  -> a --tag-specifications element
  cat <<JSON
{"ResourceType":"$1","Tags":[{"Key":"project","Value":"$GARDEN_TURNKEY_PROJECT_TAG"},{"Key":"Name","Value":"$GARDEN_TURNKEY_PREFIX"}]}
JSON
}

log() { printf '\033[36mturnkey:\033[0m %s\n' "$*" >&2; }
die() { printf '\033[31mturnkey: %s\033[0m\n' "$*" >&2; exit 1; }
