#!/bin/bash
# containment-gateway-record-check.sh — deterministic minion.town gateway record
# containment check, run by the scheduler as the `preflight:` gate of the daily
# schedule `fu-minion-town-containment-gateway-endo-sock-1`.
#
# Usage: containment-gateway-record-check.sh [schedule-name]
#        containment-gateway-record-check.sh [--no-remediate] [--verbose] [--local-root <vhosts-dir>]
#
# What it verifies (schedule retuned 2026-09-02, maintainer muster):
#   - the three de-registered gateway records (f1d754fc…, fe0a8e60…, 09201a31…)
#     are ABSENT from the live active store, by filename AND by whitespace-
#     tolerant content match;
#   - no dckc-owned active record exists outside the accepted baseline set;
#   - every active record parses as JSON.
# The store /var/lib/endo-gateway/store/vhosts/ is scanned RECURSIVELY. A
# root-only glob missed an exposed active record on 2026-08-30/31 and is worse
# than no check. It deliberately does NOT check the systemd containment drop-in:
# the powers plane is authorized OPEN under kriscendobot/minion.town issue #58.
#
# Remediation: a de-registered record found active under its own filename is
# moved back to store/vhosts-revoked-20260812/ (the recorded de-registration),
# and the store is rescanned in the same remote run to prove it came back clean.
# A content-only match, an unexpected dckc record, or an unparseable record is
# reported but never moved. --no-remediate makes the run read-only.
#
# Scheduler contract (skills/schedule § preflight):
#   exit 2  clean — nothing printed, the clock advances, no agent is dispatched;
#   exit 0  a finding (reappearance, remediation, unexpected dckc record) or a
#           scan failure — the report goes to stdout and to
#           $GARDEN_PREFLIGHT_CONTEXT_FILE, so the dispatched agent tick relays
#           it to the maintainer inbox. An inability to scan is a finding, never
#           a quiet pass, so every failure path lands here, not on exit 2.
#
# Bounded: the remote scan runs under `timeout` on the host, and every local AWS
# call and the SSM poll share one deadline (GARDEN_CONTAINMENT_CHECK_DEADLINE,
# default 90s) inside the scheduler's 120s preflight wall.

set -uo pipefail

INSTANCE="${GARDEN_CONTAINMENT_INSTANCE:-i-0380cd68b90020fad}"
REGION="${GARDEN_CONTAINMENT_REGION:-us-west-1}"
DEADLINE_SECS="${GARDEN_CONTAINMENT_CHECK_DEADLINE:-90}"
REMOTE_TIMEOUT="${GARDEN_CONTAINMENT_REMOTE_TIMEOUT:-45}"
STORE="/var/lib/endo-gateway/store"
ACTIVE="$STORE/vhosts"
REVOKED="$STORE/vhosts-revoked-20260812"

local_root=""
remediate=1
verbose=0
while [ $# -gt 0 ]; do
  case "$1" in
    --local-root) local_root="$2"; shift 2 ;;
    --no-remediate) remediate=0; shift ;;
    --verbose) verbose=1; shift ;;   # print the clean-pass summary to stderr
    *) shift ;;   # the scheduler passes the schedule name; unused
  esac
done

# The remote checker. Prints FINDING/REMEDIATED lines, then one SCAN-COMPLETE
# line; a missing SCAN-COMPLETE means the scan did not finish.
checker_py() {
  cat <<'PY'
import json, os, sys, time
active, revoked, remediate = sys.argv[1], sys.argv[2], sys.argv[3] == "1"
DEREGISTERED = [
    "f1d754fc1efcf4483edfe1c0aac57070cf39eaece43bc8990b1ed7020c56cdd3",
    "fe0a8e602d181ffb6e87e4f2dba4701fd790e897165dbcc452a41707cb1748a0",
    "09201a316203e9d99e3c906b12c9466d8f0ae8dc8baf8db484c918d6698f657f",
]
DCKC_SUB = "8929a9ae-b001-709d-02ea-e94df6225c0a"
# Accepted dckc-owned active records (confirmed 2026-09-28/29/30). A record the
# maintainer accepts later is added here; anything else dckc-owned is a finding.
DCKC_BASELINE = {
    "0d579e87b2b64a90e38fac587f1ecd9a0977f89b717ba90f9f44462cd03b00c0",
    "0eef1d5e44c939eb2e73eaf333aabe13f23fbe57c68bd0aa9c05d5f830905401",
    "18f537bd96894519468b8351f7236ba709e13e8d3c31874287ef6dc602377801",
    "1ef7b5464c71002e3a03ddc564c15792ce2f937488b5b2f59bbd2c2f807a1300",
    "2d0c17f0f4c851bb896eb80dfd69f95fdff6b2dd13cd376a3ff1594f097c09af",
    "2d6d564991b0a918e7523632511faa0d4468681c43ee9a1b8c97e001b7c87eb0",
    "32e492ff448c3086a46191cfdc57edb3749ffe75fba99e20b562a64412b51c9c",
    "4e0644198593e2c0b0a210132b1e0c440890bc0853dd8e81c8a4b52f3f75c280",
    "7736f637ad7d3704392b80374f6b2f960d9ca68b5b246eb73d7e0c4c80b31b6f",
    "806fc2eae36981df79664c85fc58629e0e790ffe9ed9276ff5d586dd912b5a9f",
    "98a1ff7d4dcf183dcf90fba432445d2f639ceda1318c211627b7346a27c53293",
    "a64dae8b566c301713a05ca20a6e35b56fe5f0e155ffaf805e7cbc131b2dce97",
    "b34347e448965aab3942b3061e8b12599f33c5aacc6c9f80ac72a741063235d4",
    "b800cf583fcb67e0f41f0e57142b4467a01406a81a3bd6c568603aeee11badee",
    "c016601eef5aa9bd1f46c981e2819f4a86a4f002d4b9228e42be9704c74c6b2e",
    "cd9cf344b6453b328d57864e1ac631e67d9aca16ece4bba7a9fb23c5835ee852",
    "d15c56a82e36643de24d9e4ccbd6742f49f66eae60432917dbdc1fef5e47554b",
    "eddab2e6aae627002e171c1841f2491cc3e854b86534bb6a2072fc7a7cf26d7e",
    "f5cdf187954ddad8dd752a622b8d65d2aafebcf792098380e045fdd5703b8f0e",
    "fc2e7aeed75515dcf914e404250d4b047c46ccdf9f71b759d4fd7a3c6caafe19",
}

def scan():
    """Walk the active store recursively; return (count, hits, findings)."""
    if not os.path.isdir(active):
        raise SystemExit("FINDING scan-failure: active store %s is missing" % active)
    count, hits, findings = 0, [], []
    def onerror(e):
        findings.append("scan-failure: cannot walk %s: %s" % (e.filename, e))
    for d, dirs, files in os.walk(active, onerror=onerror):
        dirs[:] = [x for x in dirs if not x.startswith("vhosts-revoked")]
        for f in sorted(files):
            p = os.path.join(d, f)
            rel = os.path.relpath(p, active)
            count += 1
            try:
                raw = open(p, encoding="utf-8").read()
            except Exception as e:
                findings.append("scan-failure: unreadable record %s: %s" % (rel, e))
                continue
            flat = "".join(raw.split())
            for h in DEREGISTERED:
                if f == h + ".json":
                    hits.append((h, p))
                elif h in f or h in flat:
                    findings.append("de-registered %s… referenced by active record %s (not moved: not its own record file)" % (h[:12], rel))
            try:
                rec = json.loads(raw)
            except Exception as e:
                findings.append("scan-failure: unparseable record %s: %s" % (rel, e))
                continue
            rid = f[:-5] if f.endswith(".json") else f
            if DCKC_SUB in flat and rid not in DCKC_BASELINE and rid not in DEREGISTERED:
                powers = rec.get("powers") if isinstance(rec, dict) else None
                findings.append("unexpected active dckc-owned record %s (powers=%r)" % (rel, powers))
    return count, hits, findings

count, hits, findings = scan()
for h, p in hits:
    if not remediate:
        findings.append("de-registered record %s… is ACTIVE again at %s (read-only run: not moved)" % (h[:12], p))
        continue
    dest = os.path.join(revoked, h + ".json")
    if os.path.exists(dest):
        dest += ".reappeared-" + time.strftime("%Y%m%dT%H%M%SZ", time.gmtime())
    try:
        os.makedirs(revoked, exist_ok=True)
        os.rename(p, dest)
        print("REMEDIATED de-registered record %s… was ACTIVE again at %s; moved to %s" % (h[:12], p, dest))
    except Exception as e:
        findings.append("de-registered record %s… is ACTIVE again at %s and the move to %s FAILED: %s" % (h[:12], p, dest, e))
if hits and remediate:
    count, rehits, refindings = scan()
    for h, p in rehits:
        findings.append("post-remediation rescan still finds %s… active at %s" % (h[:12], p))
    findings += [x for x in refindings if x not in findings]
for x in findings:
    print("FINDING " + x)
print("SCAN-COMPLETE records=%d" % count)
PY
}

deadline=$(( $(date +%s) + DEADLINE_SECS ))
left() { local l=$(( deadline - $(date +%s) )); [ "$l" -gt 1 ] && echo "$l" || echo 1; }

out=""; failure=""
if [ -n "$local_root" ]; then
  out="$(timeout "$(left)" python3 -c "$(checker_py)" "$local_root" "$(dirname "$local_root")/vhosts-revoked-20260812" "$remediate" 2>&1)" \
    || failure="local checker exited rc=$?"
else
  b64="$(checker_py | base64 -w0)"
  cmd="echo $b64 | base64 -d > /tmp/containment-gateway-record-check.py && timeout $REMOTE_TIMEOUT python3 /tmp/containment-gateway-record-check.py $ACTIVE $REVOKED $remediate; rc=\$?; rm -f /tmp/containment-gateway-record-check.py; exit \$rc"
  params="$(python3 -c 'import json,sys; print(json.dumps({"commands": [sys.argv[1]], "executionTimeout": [sys.argv[2]]}))' "$cmd" "$((REMOTE_TIMEOUT + 15))")"
  cid="$(timeout "$(left)" aws ssm send-command --region "$REGION" --instance-ids "$INSTANCE" \
          --document-name AWS-RunShellScript --comment "garden containment-gateway-record-check" \
          --parameters "$params" --query Command.CommandId --output text 2>&1)" \
    || { failure="SSM send-command failed: $(printf '%s' "$cid" | tr -s '\n' ' ')"; cid=""; }
  if [ -z "$failure" ]; then
    status=Pending
    while [ "$(date +%s)" -lt "$deadline" ]; do
      sleep 3
      status="$(timeout "$(left)" aws ssm get-command-invocation --region "$REGION" --command-id "$cid" \
                 --instance-id "$INSTANCE" --query Status --output text 2>/dev/null || echo Pending)"
      case "$status" in Pending|InProgress|Delayed) ;; *) break ;; esac
    done
    out="$(timeout "$(left)" aws ssm get-command-invocation --region "$REGION" --command-id "$cid" \
            --instance-id "$INSTANCE" --query '[StandardOutputContent,StandardErrorContent]' --output text 2>&1)" \
      || failure="SSM get-command-invocation failed for $cid: $out"
    case "$status" in
      Success) ;;
      Pending|InProgress|Delayed) failure="SSM command $cid did not finish within ${DEADLINE_SECS}s (status $status)" ;;
      *) [ -n "$failure" ] || failure="SSM command $cid ended with status $status" ;;
    esac
  fi
fi

findings="$(printf '%s\n' "$out" | grep -E '^(FINDING|REMEDIATED) ' || true)"
if [ -z "$failure" ] && ! printf '%s\n' "$out" | grep -q '^SCAN-COMPLETE '; then
  failure="recursive scan did not report completion"
fi

if [ -z "$failure" ] && [ -z "$findings" ]; then
  [ "$verbose" = 1 ] && printf '%s\n' "$out" | grep '^SCAN-COMPLETE ' >&2
  exit 2
fi

report="$(
  echo "## Deterministic containment-gateway-record-check result ($(date -u +%Y-%m-%dT%H:%M:%SZ))"
  echo
  echo "Target: $INSTANCE ($REGION), recursive scan of $ACTIVE${cid:+, SSM command $cid}."
  echo
  if [ -n "$failure" ]; then
    echo "**SCAN FAILURE: $failure.** An inability to complete the recursive scan is itself a finding."
    [ -n "$out" ] && { echo; echo '```'; printf '%s\n' "$out" | tail -40; echo '```'; }
  fi
  if [ -n "$findings" ]; then
    printf '%s\n' "$findings" | sed 's/^/- /'
  fi
  printf '%s\n' "$out" | grep '^SCAN-COMPLETE ' || true
)"
printf '%s\n' "$report"
[ -n "${GARDEN_PREFLIGHT_CONTEXT_FILE:-}" ] && printf '%s\n\n' "$report" > "$GARDEN_PREFLIGHT_CONTEXT_FILE"
exit 0
