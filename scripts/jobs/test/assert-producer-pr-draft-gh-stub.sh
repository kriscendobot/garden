#!/bin/bash
# assert-producer-pr-draft-gh-stub.sh — a GARDEN_GH fixture for
# assert-producer-pr-draft-test.sh. Returns a per-PR `pr view` JSON keyed on number
# and LOGS every invocation to $GARDEN_GH_CALL_LOG so the test can prove the gate
# never MUTATED a PR (never called `pr ready` / `--undo`). Committed (not generated
# under $TMPDIR) because /tmp is mounted noexec in CI.
set -euo pipefail
if [ -n "${GARDEN_GH_CALL_LOG:-}" ]; then printf '%s\n' "$*" >>"$GARDEN_GH_CALL_LOG"; fi
if [ "${1:-}" = pr ] && [ "${2:-}" = view ]; then
  url="$3"
  bot='"author":{"login":"kriscendobot"}'
  case "$url" in
    # a DRAFT producer PR — the ordinary parked-draft completion (pass, no mutation).
    */pull/200) printf '{"url":"%s","isDraft":true,"state":"OPEN","title":"feat: x","body":"b",%s}\n' "$url" "$bot" ;;
    # NON-DRAFT, uncovered → BLOCK.
    */pull/201) printf '{"url":"%s","isDraft":false,"state":"OPEN","title":"feat: y","body":"b",%s}\n' "$url" "$bot" ;;
    # NON-DRAFT, covered by a seeded gauntlet record → pass.
    */pull/202) printf '{"url":"%s","isDraft":false,"state":"OPEN","title":"feat: z","body":"b",%s}\n' "$url" "$bot" ;;
    # NON-DRAFT probe → pass (exempt).
    */pull/203) printf '{"url":"%s","isDraft":false,"state":"OPEN","title":"probe (gap-revealing prototype)","body":"gap",%s}\n' "$url" "$bot" ;;
    # NON-DRAFT authored by someone else → pass (citation of another author's PR).
    */pull/204) printf '{"url":"%s","isDraft":false,"state":"OPEN","title":"feat: w","body":"b","author":{"login":"interloper"}}\n' "$url" ;;
    # NON-DRAFT open-questions carve-out → pass.
    */pull/205) printf '{"url":"%s","isDraft":false,"state":"OPEN","title":"design: oq","body":"<!-- garden-design-open-questions -->",%s}\n' "$url" "$bot" ;;
    # inconclusive read (gh error) → the gate fails open.
    */pull/207) echo "boom" >&2; exit 1 ;;
    *) echo "unexpected pr view: $url" >&2; exit 64 ;;
  esac
  exit 0
fi
exit 64
