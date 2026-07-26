#!/bin/bash
# auto-gauntlet-handoff.sh: turn a completed feature build's draft PR into the
# next, separately claimable gauntlet job.  This is deliberately in the worker
# completion path, rather than left as an instruction for the builder: producers
# may park/promote a build and a successful builder has no further board edge.
#
# Usage: auto-gauntlet-handoff.sh <build-base> <job-file> <completion-report>
#
# A failed post is a failed handoff.  The caller leaves the build in doin so the
# reaper retries it; completing the build without its gauntlet would recreate the
# silent draft-PR stall this hook exists to prevent.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"

base="${1:?build basename}"; jobfile="${2:?job file}"; report="${3:?completion report}"

if [ "$(plan_role "$jobfile")" != builder ]; then
  exit 0
fi

# A builder that did not open a PR is legitimate for garden-infrastructure work.
# It has no PR lifecycle to hand off, but say so explicitly in the worker log so a
# missing PR is visible rather than indistinguishable from a skipped handoff.
pr_url="$(grep -hEo 'https://github\.com/[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+/pull/[0-9]+' "$report" "$jobfile" 2>/dev/null | head -1 || true)"
if [ -z "$pr_url" ]; then
  log "auto-gauntlet: build '$base' completed without a recognizable GitHub PR URL; no PR handoff required"
  exit 0
fi

gh_bin="${GARDEN_GH:-gh}"
case "$gh_bin" in
  */*) [ -x "$gh_bin" ] || die "auto-gauntlet: gh is required to inspect $pr_url" ;;
  *)   command -v "$gh_bin" >/dev/null 2>&1 || die "auto-gauntlet: gh is required to inspect $pr_url" ;;
esac
pr_json="$("$gh_bin" pr view "$pr_url" --json url,isDraft,state,title,body)"
state="$(printf '%s' "$pr_json" | jq -r '.state // empty')"
draft="$(printf '%s' "$pr_json" | jq -r '.isDraft // false')"

if [ "$state" != OPEN ] || [ "$draft" != true ]; then
  log "auto-gauntlet: build '$base' PR $pr_url is state=$state draft=$draft; no handoff needed"
  exit 0
fi

# Probe builds intentionally remain draft.  Prefer the PR's durable annotation,
# and retain the job-body check for older probe reports that lack it.
if printf '%s\n' "$pr_json" | jq -r '[.title, .body] | join("\\n")' | grep -qi 'gap-revealing prototype' \
   || grep -qiE '(^|[^[:alnum:]])probe([^[:alnum:]]|$)|gap-revealing' "$jobfile"; then
  log "auto-gauntlet: build '$base' PR $pr_url is a probe; leaving its draft PR parked by design"
  exit 0
fi

gauntlet_base="$base-gauntlet"
body="$(mktemp "${TMPDIR:-/tmp}/garden-auto-gauntlet.XXXXXX")"
trap 'rm -f "$body"' EXIT
cat >"$body" <<EOF
---
role: gardener
handler-timeout: $GARDEN_SHEPHERD_HANDLER_TIMEOUT
auto_gauntlet: true
build_job: $base
pr: $pr_url
---

Automatic gauntlet handoff for completed feature build $base.

The build opened $pr_url and it remains an OPEN draft PR. Run the full gardening
state machine now: clean, panel, fixer loop as needed, CI, then un-draft only when
the panel terminates cleanly. This handoff was posted by the build completion edge,
not inferred by a watcher.
EOF

"$HERE/post-job.sh" "$gauntlet_base" "$body"
log "auto-gauntlet: build '$base' posted '$gauntlet_base' for draft PR $pr_url"
