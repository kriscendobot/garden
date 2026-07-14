#!/usr/bin/env bash
# teardown.sh — remove turnkey resources so a test run leaves nothing costing money.
# By default it terminates any builder/smoke instances and, with --all, also
# deregisters the AMI (+ its snapshot), deletes the launch template, security
# groups, and the instance profile/role. The AMI is the one artifact you usually
# KEEP (it is the product), so deregistration is gated behind --ami / --all.
#
# Usage:
#   teardown.sh                 # terminate tagged builder/smoke instances only
#   teardown.sh --ami <id>      # also deregister that AMI + delete its snapshots
#   teardown.sh --all           # instances + last-bake AMI + LT + SGs + role
set -uo pipefail
here="$(cd "$(dirname "$0")" && pwd)"
source "$here/lib.sh"
turnkey_require_identity

DROP_AMI="" ALL=0
while [[ $# -gt 0 ]]; do
  case "$1" in
    --ami) DROP_AMI="${2:?}"; shift 2 ;;
    --all) ALL=1; shift ;;
    *) die "unknown arg: $1" ;;
  esac
done

# 1. Terminate tagged transient instances (builder + smoke), never anything else.
ids="$(aws ec2 describe-instances \
  --filters "Name=tag:project,Values=$GARDEN_TURNKEY_PROJECT_TAG" \
            "Name=tag:role,Values=builder,smoke-test" \
            "Name=instance-state-name,Values=pending,running,stopping,stopped" \
  --query 'Reservations[].Instances[].InstanceId' --output text)"
if [[ -n "$ids" ]]; then
  log "terminating instances: $ids"
  # shellcheck disable=SC2086  # $ids is a space-separated list, intentional split
  aws ec2 terminate-instances --instance-ids $ids >/dev/null
else
  log "no transient instances to terminate"
fi

if [[ "$ALL" -eq 1 && -z "$DROP_AMI" && -f "$here/.last-bake.env" ]]; then
  DROP_AMI="$(awk -F= '/^ami_id=/{print $2}' "$here/.last-bake.env")"
fi

# 2. Deregister the AMI + delete its backing snapshots.
if [[ -n "$DROP_AMI" ]]; then
  snaps="$(aws ec2 describe-images --image-ids "$DROP_AMI" \
    --query 'Images[0].BlockDeviceMappings[].Ebs.SnapshotId' --output text 2>/dev/null || true)"
  log "deregistering AMI $DROP_AMI"
  aws ec2 deregister-image --image-id "$DROP_AMI" >/dev/null 2>&1 || true
  for s in $snaps; do
    [[ "$s" == "None" || -z "$s" ]] && continue
    log "deleting snapshot $s"
    aws ec2 delete-snapshot --snapshot-id "$s" >/dev/null 2>&1 || true
  done
fi

if [[ "$ALL" -eq 1 ]]; then
  log "deleting launch template $GARDEN_TURNKEY_LT"
  aws ec2 delete-launch-template --launch-template-name "$GARDEN_TURNKEY_LT" >/dev/null 2>&1 || true
  for sg in "$GARDEN_TURNKEY_SG" "$GARDEN_TURNKEY_TEST_SG"; do
    gid="$(aws ec2 describe-security-groups --filters Name=group-name,Values="$sg" \
      --query 'SecurityGroups[0].GroupId' --output text 2>/dev/null || true)"
    [[ "$gid" == "None" || -z "$gid" ]] && continue
    log "deleting security group $sg ($gid)"
    aws ec2 delete-security-group --group-id "$gid" >/dev/null 2>&1 || log "  (in use; skipped)"
  done
  role="$GARDEN_TURNKEY_ROLE"
  log "removing instance profile/role $role"
  aws iam remove-role-from-instance-profile --instance-profile-name "$role" --role-name "$role" >/dev/null 2>&1 || true
  aws iam delete-instance-profile --instance-profile-name "$role" >/dev/null 2>&1 || true
  aws iam detach-role-policy --role-name "$role" --policy-arn arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore >/dev/null 2>&1 || true
  aws iam delete-role-policy --role-name "$role" --policy-name "$GARDEN_TURNKEY_SECRET_POLICY" >/dev/null 2>&1 || true
  aws iam delete-role --role-name "$role" >/dev/null 2>&1 || true
fi

log "teardown done"
