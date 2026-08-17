#!/bin/bash
# design-pr-audit-gh-stub.sh — a GARDEN_GH fixture for
# design-pr-gauntlet-coverage-audit-test.sh. Only `pr view <url> --json …` is
# exercised by the audit; return a per-PR JSON keyed on the PR number. Committed
# (not generated under $TMPDIR) because /tmp is mounted noexec in CI.
set -euo pipefail
if [ "${1:-}" = pr ] && [ "${2:-}" = view ]; then
  url="$3"
  design='"files":[{"path":"designs/x.md"}]'
  code='"files":[{"path":"src/foo.js"}]'
  botopen='"state":"OPEN","author":{"login":"kriscendobot"}'
  case "$url" in
    *minion.town/pull/47) printf '{"url":"%s","isDraft":false,"title":"design: ocap redesign","body":"security",%s,%s}\n' "$url" "$botopen" "$design" ;;
    *minion.town/pull/48) printf '{"url":"%s","isDraft":true,"title":"design: covered","body":"d",%s,%s}\n' "$url" "$botopen" "$design" ;;
    *minion.town/pull/49) printf '{"url":"%s","isDraft":false,"title":"fix: bug","body":"c",%s,%s}\n' "$url" "$botopen" "$code" ;;
    *minion.town/pull/50) printf '{"url":"%s","isDraft":false,"title":"design: x","body":"d","state":"OPEN","author":{"login":"interloper"},%s}\n' "$url" "$design" ;;
    *minion.town/pull/51) printf '{"url":"%s","isDraft":true,"title":"design: probe (gap-revealing prototype)","body":"gap report",%s,%s}\n' "$url" "$botopen" "$design" ;;
    *minion.town/pull/52) printf '{"url":"%s","isDraft":true,"title":"design: draft doc","body":"d",%s,%s}\n' "$url" "$botopen" "$design" ;;
    *minion.town/pull/53) printf '{"url":"%s","isDraft":false,"title":"design: completed-gauntlet","body":"d",%s,%s}\n' "$url" "$botopen" "$design" ;;
    *garden/pull/28)      printf '{"url":"%s","isDraft":false,"title":"design: garden own","body":"d",%s,%s}\n' "$url" "$botopen" "$design" ;;
    *) echo "unexpected pr view: $url" >&2; exit 64 ;;
  esac
  exit 0
fi
exit 64
