#!/usr/bin/env bash
# create-launch-template.sh — publish (or add a new version to) the turnkey launch
# template. The template supplies everything the design's "one-click launch"
# needs and NOTHING secret: the AMI, the least-privilege SSM instance profile, the
# SSM-only security group, an encrypted gp3 root, the IMDSv2 requirement, and tags.
# It carries no credentials and no user-data (user-data is a credential-injection
# surface the design deliberately refuses).
#
# Idempotent: creates the template if absent, else adds a new default version
# pointing at the given AMI. Immutable AMIs mean "new build" == "new template
# version", never an in-place mutation.
#
# Usage: create-launch-template.sh [--ami <ami-id>] [--type <instance-type>]
here="$(cd "$(dirname "$0")" && pwd)"
source "$here/lib.sh"
turnkey_require_identity

AMI="${GARDEN_TURNKEY_AMI:-}"
TYPE="${GARDEN_TURNKEY_TEST_TYPE}"
while [[ $# -gt 0 ]]; do
  case "$1" in
    --ami) AMI="${2:?}"; shift 2 ;;
    --type) TYPE="${2:?}"; shift 2 ;;
    *) die "unknown arg: $1" ;;
  esac
done
# Fall back to the last bake's AMI if not given.
if [[ -z "$AMI" && -f "$here/.last-bake.env" ]]; then
  AMI="$(awk -F= '/^ami_id=/{print $2}' "$here/.last-bake.env")"
fi
[[ -n "$AMI" ]] || die "no AMI given (--ami) and none in .last-bake.env"

SG_ID="$("$here/ensure-security-group.sh")"
"$here/ensure-instance-profile.sh" >/dev/null

# Encrypted gp3 root, IMDSv2 required, instance profile, SG, project tags on both
# the instance and its volumes at launch. No user-data. No key pair (SSM entry).
LT_DATA="$(cat <<JSON
{
  "ImageId": "$AMI",
  "InstanceType": "$TYPE",
  "IamInstanceProfile": {"Name": "$GARDEN_TURNKEY_ROLE"},
  "SecurityGroupIds": ["$SG_ID"],
  "MetadataOptions": {"HttpTokens": "required", "HttpEndpoint": "enabled"},
  "BlockDeviceMappings": [
    {"DeviceName": "/dev/sda1",
     "Ebs": {"VolumeType": "gp3", "VolumeSize": $GARDEN_TURNKEY_VOLUME_GB,
             "Encrypted": true, "DeleteOnTermination": true}}
  ],
  "TagSpecifications": [
    {"ResourceType": "instance", "Tags": [
      {"Key": "project", "Value": "$GARDEN_TURNKEY_PROJECT_TAG"},
      {"Key": "Name", "Value": "$GARDEN_TURNKEY_PREFIX"}]},
    {"ResourceType": "volume", "Tags": [
      {"Key": "project", "Value": "$GARDEN_TURNKEY_PROJECT_TAG"},
      {"Key": "Name", "Value": "$GARDEN_TURNKEY_PREFIX"}]}
  ]
}
JSON
)"

if aws ec2 describe-launch-templates --launch-template-names "$GARDEN_TURNKEY_LT" >/dev/null 2>&1; then
  log "adding a new default version to launch template $GARDEN_TURNKEY_LT (AMI $AMI)"
  ver="$(aws ec2 create-launch-template-version \
    --launch-template-name "$GARDEN_TURNKEY_LT" \
    --launch-template-data "$LT_DATA" \
    --query 'LaunchTemplateVersion.VersionNumber' --output text)"
  aws ec2 modify-launch-template \
    --launch-template-name "$GARDEN_TURNKEY_LT" \
    --default-version "$ver" >/dev/null
  log "launch template $GARDEN_TURNKEY_LT default version -> $ver"
else
  log "creating launch template $GARDEN_TURNKEY_LT (AMI $AMI)"
  aws ec2 create-launch-template \
    --launch-template-name "$GARDEN_TURNKEY_LT" \
    --launch-template-data "$LT_DATA" \
    --tag-specifications "$(turnkey_tag_json launch-template)" >/dev/null
fi

aws ec2 describe-launch-templates --launch-template-names "$GARDEN_TURNKEY_LT" \
  --query 'LaunchTemplates[0].{Name:LaunchTemplateName,Id:LaunchTemplateId,Default:DefaultVersionNumber,Latest:LatestVersionNumber}' \
  --output json
