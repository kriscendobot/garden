#!/bin/bash
# send-host-op.sh — address a host-local system operation to a host's sysop.
#
# Usage: send-host-op.sh <GARDEN> op=<op> [key=value]...
#
# A thin wrapper over `send-msg.sh host/<GARDEN>` that emits the structured op
# frontmatter the sysop parses (designs/sysop.md §3/§4), so an operator or the
# liaison never hand-formats a message body. Each argument after the target is a
# `key=value` pair written verbatim as one `key: value` body line. The op is
# executed by the ADDRESSED HOST's standing garden-sysop daemon — most importantly
# an unattended follower — and acked back to this host's own sysop topic (or to a
# reply_to job doer).
#
# Examples:
#   send-host-op.sh ps23-garden-abcd1234 op=set-workers kind=gardener count=2
#   send-host-op.sh ps23-garden-abcd1234 op=drain state=on reason='weekly quota'
#   send-host-op.sh ps23-garden-abcd1234 op=drain state=off
#   send-host-op.sh ps23-garden-abcd1234 op=reset-failed
#   send-host-op.sh ps23-garden-abcd1234 op=restore
#   send-host-op.sh ps23-garden-abcd1234 op=unit action=restart name=garden-foreman.timer authorized_by=<login>
#   send-host-op.sh ps23-garden-abcd1234 op=deploy authorized_by=<login>
#
# The two destructive ops (deploy, unit) additionally require authorized_by=<login>
# with <login> on the journal maintainers/allowlist (attestation, not auth — see
# designs/sysop.md §6). The sysop's issuer gate additionally confines WHICH hosts
# may originate ops (config/sysop-issuers; default: the leader).

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
GARDEN_TAG="send-host-op"

: "${GARDEN_SYSOP_SEND:=$HERE/send-msg.sh}"

target="${1:?usage: send-host-op.sh <GARDEN> op=<op> [key=value]...}"; shift
[ "$#" -ge 1 ] || die "need at least an op=<op> pair"

# Build the op body from the key=value pairs. Require an op= pair; each pair must be
# key=value with key in [A-Za-z0-9._-] (a closed, well-formed frontmatter key).
have_op=0
body="$(mktemp)"; trap 'rm -f "$body"' EXIT
for pair in "$@"; do
  case "$pair" in
    *=*) : ;;
    *) die "argument '$pair' is not a key=value pair";;
  esac
  key="${pair%%=*}"; val="${pair#*=}"
  case "$key" in
    *[!A-Za-z0-9._-]*|'') die "illegal op key '$key' (one [A-Za-z0-9._-]+ token)";;
  esac
  [ "$key" = op ] && have_op=1
  # Single-line values only (a body line is one field); collapse embedded newlines.
  printf '%s: %s\n' "$key" "$(printf '%s' "$val" | tr '\n' ' ')" >> "$body"
done
[ "$have_op" -eq 1 ] || die "no op=<op> pair given"

# The op body is machine-generated frontmatter (no author-written #N refs), so skip
# the issue-ref check. The sysop is the single reader of host/<target>.
GARDEN_SKIP_REF_CHECK=1 GARDEN_SENDER="${GARDEN_SENDER:-sysop-op@$GARDEN}" \
  "$GARDEN_SYSOP_SEND" "host/$target" "$body"
log "sent host op to $target: $(paste -sd' ' "$body" | tr '\n' ' ')"
