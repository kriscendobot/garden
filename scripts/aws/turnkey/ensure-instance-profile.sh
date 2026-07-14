#!/usr/bin/env bash
# ensure-instance-profile.sh — create (idempotently) the least-privilege instance
# profile the turnkey garden host runs under.
#
# The ONLY managed permission the turnkey host needs is SSM
# (AmazonSSMManagedInstanceCore) so the operator can reach an interactive shell
# with no inbound port open — the secret-free entry path the device-auth workflow
# rides on (designs/turnkey-garden-host.md). Nothing here grants the host any way
# to read a Claude or GitHub credential: the operator supplies those interactively
# after launch, never the AMI or the instance role.
#
# OPTIONAL (off by default): --with-secret <secret-arn> attaches a scoped inline
# policy granting read of exactly ONE Secrets Manager secret — the design's
# alternate GitHub-PAT delivery path (item 2). The secret NAME, not its value, is
# configuration; the value is created by the operator out of band. This is the
# GitHub path only; the Claude login stays interactive by deliberate design.

here="$(cd "$(dirname "$0")" && pwd)"
source "$here/lib.sh"
turnkey_require_identity

SECRET_ARN=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --with-secret) SECRET_ARN="${2:?--with-secret needs a secret ARN}"; shift 2 ;;
    *) die "unknown arg: $1" ;;
  esac
done

role="$GARDEN_TURNKEY_ROLE"

# 1. Role with the EC2 trust policy.
if aws iam get-role --role-name "$role" >/dev/null 2>&1; then
  log "role $role exists"
else
  log "creating role $role"
  aws iam create-role --role-name "$role" \
    --assume-role-policy-document '{
      "Version":"2012-10-17",
      "Statement":[{"Effect":"Allow","Principal":{"Service":"ec2.amazonaws.com"},"Action":"sts:AssumeRole"}]
    }' \
    --tags Key=project,Value="$GARDEN_TURNKEY_PROJECT_TAG" \
    --description "Least-privilege SSM role for the turnkey garden host" >/dev/null
fi

# 2. SSM managed policy — the whole permission surface in the default posture.
aws iam attach-role-policy --role-name "$role" \
  --policy-arn arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore >/dev/null
log "attached AmazonSSMManagedInstanceCore"

# 3. OPTIONAL scoped Secrets Manager read (GitHub-PAT path only).
if [[ -n "$SECRET_ARN" ]]; then
  log "attaching scoped read for secret $SECRET_ARN"
  aws iam put-role-policy --role-name "$role" \
    --policy-name "$GARDEN_TURNKEY_SECRET_POLICY" \
    --policy-document "{
      \"Version\":\"2012-10-17\",
      \"Statement\":[{\"Effect\":\"Allow\",\"Action\":[\"secretsmanager:GetSecretValue\"],\"Resource\":\"$SECRET_ARN\"}]
    }" >/dev/null
else
  # Ensure the default posture carries no lingering secret grant from a prior run.
  aws iam delete-role-policy --role-name "$role" \
    --policy-name "$GARDEN_TURNKEY_SECRET_POLICY" >/dev/null 2>&1 || true
fi

# 4. Instance profile wrapping the role.
if aws iam get-instance-profile --instance-profile-name "$role" >/dev/null 2>&1; then
  log "instance profile $role exists"
else
  log "creating instance profile $role"
  aws iam create-instance-profile --instance-profile-name "$role" \
    --tags Key=project,Value="$GARDEN_TURNKEY_PROJECT_TAG" >/dev/null
fi

# 5. Bind role into profile (idempotent — ignore "already has a role").
aws iam add-role-to-instance-profile --instance-profile-name "$role" \
  --role-name "$role" >/dev/null 2>&1 || true

log "instance profile ready: $role"
aws iam get-instance-profile --instance-profile-name "$role" \
  --query 'InstanceProfile.{Profile:InstanceProfileName,Arn:Arn,Roles:Roles[].RoleName}' --output json
