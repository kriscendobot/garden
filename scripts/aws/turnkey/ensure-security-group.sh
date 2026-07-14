#!/usr/bin/env bash
# ensure-security-group.sh — create (idempotently) the turnkey host's security
# group(s).
#
# DEFAULT POSTURE: no inbound rules at all. The operator reaches the host over SSM
# (Session Manager, or `ssh` tunnelled through AWS-StartSSHSession), which needs no
# open port — so "SSH stays closed" in the design's original sense (no world-open
# port 22) remains literally true, while the operator still gets the ssh/shell CLI
# the device-auth workflow needs. Egress is the SG default (all outbound), which
# the device-login flow and the container build require.
#
# The bake and the smoke test use SEPARATE groups (design: "an explicit test launch
# in a separate security group"), so a test instance can never share the builder's
# blast radius.
#
# OPTIONAL: --open-ssh <cidr> adds a single inbound 22/tcp rule scoped to the
# operator's own CIDR — for an operator who wants a *direct* `ssh` (their own key
# via a launch-template KeyName or EC2 Instance Connect) instead of SSH-over-SSM.
# A public key is not a secret; it is never baked into the AMI. Default: omit it and
# stay fully closed.

here="$(cd "$(dirname "$0")" && pwd)"
source "$here/lib.sh"
turnkey_require_identity

NAME="$GARDEN_TURNKEY_SG"
OPEN_SSH_CIDR=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --test) NAME="$GARDEN_TURNKEY_TEST_SG"; shift ;;
    --open-ssh) OPEN_SSH_CIDR="${2:?--open-ssh needs a CIDR}"; shift 2 ;;
    *) die "unknown arg: $1" ;;
  esac
done

vpc="$(turnkey_default_vpc)"
[[ "$vpc" != "None" && -n "$vpc" ]] || die "no default VPC in $GARDEN_AWS_REGION"

sg_id="$(aws ec2 describe-security-groups \
  --filters Name=group-name,Values="$NAME" Name=vpc-id,Values="$vpc" \
  --query 'SecurityGroups[0].GroupId' --output text 2>/dev/null || true)"

if [[ "$sg_id" == "None" || -z "$sg_id" ]]; then
  log "creating security group $NAME in $vpc"
  sg_id="$(aws ec2 create-security-group \
    --group-name "$NAME" --vpc-id "$vpc" \
    --description "Turnkey garden host — SSM-only, no inbound by default" \
    --tag-specifications "$(turnkey_tag_json security-group)" \
    --query GroupId --output text)"
  # A fresh SG has all-egress already; no inbound rules — exactly the default we want.
else
  log "security group $NAME exists: $sg_id"
fi

if [[ -n "$OPEN_SSH_CIDR" ]]; then
  log "authorizing inbound 22/tcp from $OPEN_SSH_CIDR (operator direct-ssh opt-in)"
  aws ec2 authorize-security-group-ingress --group-id "$sg_id" \
    --ip-permissions "IpProtocol=tcp,FromPort=22,ToPort=22,IpRanges=[{CidrIp=$OPEN_SSH_CIDR,Description=operator-direct-ssh}]" \
    >/dev/null 2>&1 || log "(ingress rule already present)"
fi

echo "$sg_id"
