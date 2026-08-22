#!/bin/bash
# related-design-gh-stub.sh — a GARDEN_GH fixture for related-design-sensing-test.sh,
# reproducing the kriscendobot/minion.town PR 47/48 relationship at the real
# timestamps of the stale-related-design-direction review-miss. Committed (not
# generated under $TMPDIR) because /tmp is mounted noexec in CI, so an executable
# GARDEN_GH override must live on the repo filesystem.
#
# Serves two shapes of `gh pr view`:
#   * metadata:  pr view <n> -R <repo> --json number,title,isDraft,state,reviewDecision,latestReviews,headRefOid,updatedAt
#   * body:      pr view <n> -R <repo> --json body --jq .body   (the self-PR marker probe)
set -euo pipefail

if [ "${1:-}" = pr ] && [ "${2:-}" = view ]; then
  n="$3"
  jqmode=0
  for a in "$@"; do [ "$a" = "--jq" ] && jqmode=1; done

  if [ "$jqmode" = 1 ]; then
    # Body probe: what does the implementation PR declare as its related design set?
    case "$n" in
      48) printf '%s\n' 'Serving slice.

<!-- garden-related-design: 47 -->' ;;                      # PR 48 declares related PR 47
      60) printf '%s\n' 'An unrelated implementation with no related-design marker.' ;;
      61) printf '%s\n' 'Implementation beside a settled design.

<!-- garden-related-design: 50 -->' ;;                      # declares only the satisfied PR 50
      *)  printf '\n' ;;
    esac
    exit 0
  fi

  # Metadata probe: the live review state.
  case "$n" in
    # PR 47: the related design PR whose maintainer changes-requested review
    # (2026-08-17T23:22:53Z) replaced the seam PR 48 built on — and PREDATES PR 48's
    # first commit (2026-08-18T00:38:55Z), the case a "newer-than-impl" test misses.
    47) echo '{"number":47,"title":"design: guest-held @sites registry","isDraft":false,"state":"OPEN","reviewDecision":"CHANGES_REQUESTED","latestReviews":[{"author":{"login":"kriskowal"},"state":"CHANGES_REQUESTED","submittedAt":"2026-08-17T23:22:53Z"}],"headRefOid":"a47","updatedAt":"2026-08-17T23:22:53Z"}' ;;
    # PR 50: a SATISFIED related design (its changes-requested was later approved) —
    # the negative control that must NOT block.
    50) echo '{"number":50,"title":"design: settled projection","isDraft":false,"state":"OPEN","reviewDecision":"APPROVED","latestReviews":[{"author":{"login":"kriskowal"},"state":"APPROVED","submittedAt":"2026-08-19T00:00:00Z"}],"headRefOid":"a50","updatedAt":"2026-08-19T00:00:00Z"}' ;;
    # PR 99: an UNRELATED design PR that also carries changes-requested — never
    # declared by any implementation here, so it is never fetched and never blocks.
    99) echo '{"number":99,"title":"design: unrelated telemetry","isDraft":false,"state":"OPEN","reviewDecision":"CHANGES_REQUESTED","latestReviews":[{"author":{"login":"kriskowal"},"state":"CHANGES_REQUESTED","submittedAt":"2026-08-10T00:00:00Z"}],"headRefOid":"a99","updatedAt":"2026-08-10T00:00:00Z"}' ;;
    *) echo "unexpected pr view: $n" >&2; exit 64 ;;
  esac
  exit 0
fi
exit 64
