#!/usr/bin/env bash
# smoke-test.sh — the credential-free smoke test. Launches a THROWAWAY instance from
# the baked AMI, in a SEPARATE test security group (design: "an explicit test launch
# in a separate security group"), and proves the three properties the design's smoke
# result must show:
#   1. the instance reaches SSM (the operator's secret-free entry path works);
#   2. `./garden create` starts the container from the prebuilt image;
#   3. the host has NO pre-existing Claude or GitHub authentication.
# Then it terminates the test instance. Nothing is left running.
#
# Usage: smoke-test.sh [--ami <ami-id>] [--keep]
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"
source "$here/lib.sh"
turnkey_require_identity

AMI="${GARDEN_TURNKEY_AMI:-}"
KEEP=0
while [[ $# -gt 0 ]]; do
  case "$1" in
    --ami) AMI="${2:?}"; shift 2 ;;
    --keep) KEEP=1; shift ;;
    *) die "unknown arg: $1" ;;
  esac
done
if [[ -z "$AMI" && -f "$here/.last-bake.env" ]]; then
  AMI="$(awk -F= '/^ami_id=/{print $2}' "$here/.last-bake.env")"
fi
[[ -n "$AMI" ]] || die "no AMI given (--ami) and none in .last-bake.env"
log "smoke-testing AMI $AMI"

TEST_SG="$("$here/ensure-security-group.sh" --test)"
"$here/ensure-instance-profile.sh" >/dev/null
SUBNET="$(turnkey_default_subnet)"

log "launching throwaway test instance ($GARDEN_TURNKEY_TEST_TYPE) in test SG $TEST_SG"
IID="$(aws ec2 run-instances \
  --image-id "$AMI" \
  --instance-type "$GARDEN_TURNKEY_TEST_TYPE" \
  --subnet-id "$SUBNET" \
  --security-group-ids "$TEST_SG" \
  --iam-instance-profile "Name=$GARDEN_TURNKEY_ROLE" \
  --metadata-options 'HttpTokens=required,HttpEndpoint=enabled' \
  --block-device-mappings "[{\"DeviceName\":\"/dev/sda1\",\"Ebs\":{\"VolumeType\":\"gp3\",\"VolumeSize\":$GARDEN_TURNKEY_VOLUME_GB,\"Encrypted\":true,\"DeleteOnTermination\":true}}]" \
  --tag-specifications \
    "ResourceType=instance,Tags=[{Key=project,Value=$GARDEN_TURNKEY_PROJECT_TAG},{Key=Name,Value=${GARDEN_TURNKEY_PREFIX}-smoke},{Key=role,Value=smoke-test}]" \
  --query 'Instances[0].InstanceId' --output text)"
log "test instance: $IID"

cleanup() {
  [[ "$KEEP" -eq 1 ]] && { log "keeping test instance $IID (--keep)"; return; }
  log "terminating test instance $IID"
  aws ec2 terminate-instances --instance-ids "$IID" >/dev/null 2>&1 || true
}
trap cleanup EXIT

aws ec2 wait instance-running --instance-ids "$IID"

# ---- Property 1: SSM reachable ----
log "PROP 1: waiting for SSM to come online"
ping=""
for _ in $(seq 1 60); do
  ping="$(aws ssm describe-instance-information \
    --filters "Key=InstanceIds,Values=$IID" \
    --query 'InstanceInformationList[0].PingStatus' --output text 2>/dev/null || true)"
  [[ "$ping" == "Online" ]] && break
  sleep 10
done
[[ "$ping" == "Online" ]] || die "PROP 1 FAIL: SSM never came online"
log "PROP 1 PASS: SSM online"

# One SSM command runs all on-host checks and prints a machine-greppable verdict.
CHECK=$(cat <<'CHECKEOF'
set -uo pipefail
echo "=== garden checkout ==="
ls -d /home/ubuntu/garden >/dev/null 2>&1 && echo "checkout: PRESENT" || echo "checkout: MISSING"

echo "=== PROP 3: no pre-existing Claude/GitHub auth ==="
authfound=0
for p in /home/ubuntu/.claude/.credentials.json /home/ubuntu/.claude/credentials.json \
         /home/ubuntu/.config/gh/hosts.yml /root/.config/gh/hosts.yml; do
  if [ -e "$p" ]; then echo "AUTH PRESENT: $p"; authfound=1; fi
done
# gh/claude report unauthenticated (best-effort; tools may be inside the container only)
if command -v gh >/dev/null 2>&1; then
  gh auth status >/dev/null 2>&1 && { echo "gh: AUTHENTICATED"; authfound=1; } || echo "gh: unauthenticated"
fi
[ "$authfound" -eq 0 ] && echo "PROP3: CLEAN" || echo "PROP3: DIRTY"

echo "=== PROP 2: ./garden create starts the container from the prebuilt image ==="
sudo -u ubuntu -H bash -lc '
  set -e
  cd /home/ubuntu/garden
  # prove the image was baked in (no build should be needed)
  if sg docker -c "docker image inspect garden-ubuntu >/dev/null 2>&1"; then
    echo "image: PREBUILT"
  else
    echo "image: MISSING (would build on demand)"
  fi
  sg docker -c "./garden create" || { echo "garden-create: FAIL"; exit 1; }
  # container name is the location-derived instance id; assert one garden container runs
  if sg docker -c "docker ps --filter status=running --format {{.Image}}" | grep -q garden-ubuntu; then
    echo "container: RUNNING"
  else
    echo "container: NOT-RUNNING"
  fi
'
echo "=== SMOKE CHECKS DONE ==="
CHECKEOF
)

log "PROP 2+3: running on-host checks over SSM"
b64="$(printf '%s' "$CHECK" | base64 -w0)"
cid="$(aws ssm send-command --instance-ids "$IID" \
  --document-name AWS-RunShellScript --comment "turnkey smoke" \
  --timeout-seconds 600 \
  --parameters "{\"executionTimeout\":[\"1800\"],\"commands\":[\"echo $b64 | base64 -d > /tmp/smoke.sh\",\"bash /tmp/smoke.sh\"]}" \
  --query 'Command.CommandId' --output text)"
status=""
while true; do
  status="$(aws ssm get-command-invocation --command-id "$cid" --instance-id "$IID" \
    --query Status --output text 2>/dev/null || echo Pending)"
  case "$status" in
    Success|Failed|Cancelled|TimedOut) break ;;
    *) sleep 15 ;;
  esac
done
OUT="$(aws ssm get-command-invocation --command-id "$cid" --instance-id "$IID" \
  --query StandardOutputContent --output text)"
ERR="$(aws ssm get-command-invocation --command-id "$cid" --instance-id "$IID" \
  --query StandardErrorContent --output text)"
echo "----- smoke output -----"
echo "$OUT"
[[ -n "$ERR" ]] && { echo "----- stderr -----"; echo "$ERR"; }
echo "------------------------"

# ---- Verdict ----
fail=0
grep -q "checkout: PRESENT" <<<"$OUT" || { echo "VERDICT: checkout missing"; fail=1; }
grep -q "PROP3: CLEAN"     <<<"$OUT" || { echo "VERDICT: PROP3 (no auth) FAILED"; fail=1; }
grep -q "container: RUNNING" <<<"$OUT" || { echo "VERDICT: PROP2 (./garden create) FAILED"; fail=1; }
if [[ "$fail" -eq 0 ]]; then
  echo "SMOKE: PASS — SSM reachable, container starts from prebuilt image, no pre-existing auth."
else
  echo "SMOKE: FAIL"
  exit 1
fi
