#!/usr/bin/env bash
# build-ami.sh — the bake pipeline. Launches a Graviton builder from the pinned
# Ubuntu ARM64 base, provisions it (Docker + reviewed garden checkout + prebuilt
# container) over SSM, scrubs every credential/identity artifact, then CreateImage
# into a PRIVATE AMI tagged immutably with its source commit, base AMI, arch, and
# build timestamp. Terminates the builder. No secret ever enters the AMI.
#
# Long-running (a full container build). Emits progress to stderr AND to a log file
# so it can run in the background while the operator does other work. On success the
# LAST stdout line is the AMI id (machine-readable). All created/leftover resource
# ids are also written to a manifest file passed as $GARDEN_TURNKEY_MANIFEST (or a
# default under the checkout).
#
# Usage: build-ami.sh [--commit <sha>] [--keep-builder]
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"
source "$here/lib.sh"
turnkey_require_identity

COMMIT="${GARDEN_TURNKEY_SOURCE_COMMIT:-}"
KEEP_BUILDER=0
while [[ $# -gt 0 ]]; do
  case "$1" in
    --commit) COMMIT="${2:?}"; shift 2 ;;
    --keep-builder) KEEP_BUILDER=1; shift ;;
    *) die "unknown arg: $1" ;;
  esac
done

MANIFEST="${GARDEN_TURNKEY_MANIFEST:-$here/.last-bake.env}"
: > "$MANIFEST"
manifest() { printf '%s=%s\n' "$1" "$2" >>"$MANIFEST"; }

# Resolve the reviewed revision: explicit --commit, else current tip of the branch.
if [[ -z "$COMMIT" ]]; then
  COMMIT="$(git ls-remote "$GARDEN_TURNKEY_SOURCE_REPO" "$GARDEN_TURNKEY_SOURCE_BRANCH" | awk '{print $1}')"
fi
[[ -n "$COMMIT" ]] || die "could not resolve source commit"
export GARDEN_TURNKEY_SOURCE_COMMIT="$COMMIT"
log "source commit: $COMMIT"
manifest source_commit "$COMMIT"
manifest base_ami "$GARDEN_TURNKEY_BASE_AMI"

# Timestamp (shell date — reproducibility comes from the pinned commit + base AMI,
# the timestamp is provenance only).
BUILD_TS="$(date -u +%Y%m%dT%H%M%SZ)"
manifest build_timestamp "$BUILD_TS"

# --- Prereqs: instance profile + SG ------------------------------------------
"$here/ensure-instance-profile.sh" >/dev/null
SG_ID="$("$here/ensure-security-group.sh")"
log "security group: $SG_ID"
manifest sg_id "$SG_ID"
SUBNET="$(turnkey_default_subnet)"
manifest subnet "$SUBNET"

# Root device name of the base AMI (Canonical: /dev/sda1) — query it, don't assume.
ROOT_DEV="$(aws ec2 describe-images --image-ids "$GARDEN_TURNKEY_BASE_AMI" \
  --query 'Images[0].RootDeviceName' --output text)"

# --- Launch the builder -------------------------------------------------------
# IMDSv2 required; encrypted gp3 root; SSM-only SG; instance profile for SSM.
log "launching builder ($GARDEN_TURNKEY_BUILDER_TYPE) from $GARDEN_TURNKEY_BASE_AMI"
INSTANCE_ID="$(aws ec2 run-instances \
  --image-id "$GARDEN_TURNKEY_BASE_AMI" \
  --instance-type "$GARDEN_TURNKEY_BUILDER_TYPE" \
  --subnet-id "$SUBNET" \
  --security-group-ids "$SG_ID" \
  --iam-instance-profile "Name=$GARDEN_TURNKEY_ROLE" \
  --metadata-options 'HttpTokens=required,HttpEndpoint=enabled' \
  --block-device-mappings "[{\"DeviceName\":\"$ROOT_DEV\",\"Ebs\":{\"VolumeType\":\"gp3\",\"VolumeSize\":$GARDEN_TURNKEY_VOLUME_GB,\"Encrypted\":true,\"DeleteOnTermination\":true}}]" \
  --tag-specifications \
    "ResourceType=instance,Tags=[{Key=project,Value=$GARDEN_TURNKEY_PROJECT_TAG},{Key=Name,Value=${GARDEN_TURNKEY_PREFIX}-builder},{Key=role,Value=builder}]" \
  --query 'Instances[0].InstanceId' --output text)"
log "builder: $INSTANCE_ID"
manifest builder_instance "$INSTANCE_ID"

cleanup_builder() {
  [[ "$KEEP_BUILDER" -eq 1 ]] && { log "keeping builder $INSTANCE_ID (--keep-builder)"; return; }
  log "terminating builder $INSTANCE_ID"
  aws ec2 terminate-instances --instance-ids "$INSTANCE_ID" >/dev/null 2>&1 || true
}
trap cleanup_builder EXIT

log "waiting for builder to run"
aws ec2 wait instance-running --instance-ids "$INSTANCE_ID"

# --- Wait for SSM to come online ---------------------------------------------
log "waiting for SSM agent to register (proves the SSM entry path works)"
for _ in $(seq 1 60); do
  ping="$(aws ssm describe-instance-information \
    --filters "Key=InstanceIds,Values=$INSTANCE_ID" \
    --query 'InstanceInformationList[0].PingStatus' --output text 2>/dev/null || true)"
  [[ "$ping" == "Online" ]] && break
  sleep 10
done
[[ "$ping" == "Online" ]] || die "SSM never came online for $INSTANCE_ID"
log "SSM online"

# --- SSM runner ---------------------------------------------------------------
# Ship a local script to the builder base64-encoded (no quoting hell), run it under
# a supplied env prefix, and poll to completion. Returns the command's exit status.
ssm_run() {  # $1=label  $2=local-script  $3=env-prefix
  local label="$1" script="$2" envp="$3" b64 cmd_id status
  b64="$(base64 -w0 "$script")"
  local remote="/tmp/turnkey-${label}.sh"
  cmd_id="$(aws ssm send-command \
    --instance-ids "$INSTANCE_ID" \
    --document-name AWS-RunShellScript \
    --comment "turnkey $label" \
    --timeout-seconds 600 \
    --parameters "{\"executionTimeout\":[\"7200\"],\"commands\":[\"set -e\",\"echo $b64 | base64 -d > $remote\",\"chmod +x $remote\",\"$envp bash $remote\"]}" \
    --query 'Command.CommandId' --output text)"
  log "  [$label] SSM command $cmd_id running..."
  while true; do
    status="$(aws ssm get-command-invocation --command-id "$cmd_id" \
      --instance-id "$INSTANCE_ID" --query Status --output text 2>/dev/null || echo Pending)"
    case "$status" in
      Success) log "  [$label] Success"; break ;;
      Failed|Cancelled|TimedOut)
        log "  [$label] $status — tail of output:"
        aws ssm get-command-invocation --command-id "$cmd_id" --instance-id "$INSTANCE_ID" \
          --query '{out:StandardOutputContent,err:StandardErrorContent}' --output text | tail -40 >&2
        return 1 ;;
      *) sleep 15 ;;
    esac
  done
  aws ssm get-command-invocation --command-id "$cmd_id" --instance-id "$INSTANCE_ID" \
    --query StandardOutputContent --output text | tail -6 >&2
}

ENVP="GARDEN_TURNKEY_SOURCE_REPO=$GARDEN_TURNKEY_SOURCE_REPO \
GARDEN_TURNKEY_SOURCE_BRANCH=$GARDEN_TURNKEY_SOURCE_BRANCH \
GARDEN_TURNKEY_SOURCE_COMMIT=$COMMIT \
GARDEN_TURNKEY_CHECKOUT=$GARDEN_TURNKEY_CHECKOUT"

log "provisioning builder (Docker + garden checkout + container build) — this is the long step"
ssm_run provision "$here/provision.sh" "$ENVP" || die "provision failed"

log "scrubbing credentials/identity before imaging"
ssm_run scrub "$here/scrub.sh" "" || die "scrub failed"

# --- Stop + image -------------------------------------------------------------
log "stopping builder for a consistent image"
aws ec2 stop-instances --instance-ids "$INSTANCE_ID" >/dev/null
aws ec2 wait instance-stopped --instance-ids "$INSTANCE_ID"

AMI_NAME="${GARDEN_TURNKEY_PREFIX}-${COMMIT:0:12}-${BUILD_TS}"
log "creating image $AMI_NAME"
AMI_ID="$(aws ec2 create-image \
  --instance-id "$INSTANCE_ID" \
  --name "$AMI_NAME" \
  --description "Turnkey garden host - garden@${COMMIT:0:12}, base $GARDEN_TURNKEY_BASE_AMI, $GARDEN_TURNKEY_ARCH" \
  --no-reboot \
  --tag-specifications \
    "ResourceType=image,Tags=[{Key=project,Value=$GARDEN_TURNKEY_PROJECT_TAG},{Key=Name,Value=$AMI_NAME},{Key=garden:source-commit,Value=$COMMIT},{Key=garden:base-ami,Value=$GARDEN_TURNKEY_BASE_AMI},{Key=garden:architecture,Value=$GARDEN_TURNKEY_ARCH},{Key=garden:build-timestamp,Value=$BUILD_TS}]" \
    "ResourceType=snapshot,Tags=[{Key=project,Value=$GARDEN_TURNKEY_PROJECT_TAG},{Key=Name,Value=$AMI_NAME}]" \
  --query ImageId --output text)"
log "AMI: $AMI_ID — waiting until available"
manifest ami_id "$AMI_ID"
manifest ami_name "$AMI_NAME"
aws ec2 wait image-available --image-ids "$AMI_ID"
log "AMI available: $AMI_ID"

# Keep the AMI PRIVATE — never modify launch permissions here (no public share).
echo "$AMI_ID"
