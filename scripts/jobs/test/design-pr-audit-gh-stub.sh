#!/bin/bash
# design-pr-audit-gh-stub.sh — a GARDEN_GH fixture for
# design-pr-gauntlet-coverage-audit-test.sh (alert-only backlog + bounded new-PR path).
# Only `pr view <url> --json …` is exercised; return a per-PR JSON keyed on the PR
# number, including headRefOid and createdAt. Committed (not generated
# under $TMPDIR) because /tmp is mounted noexec in CI.
#
# #47's head is read from $GARDEN_TEST_PR47_HEAD (default aaa47) so the test can flip
# it to prove a changed head re-alerts while an unchanged one stays quiet.
set -euo pipefail
if [ "${1:-}" = pr ] && [ "${2:-}" = view ]; then
  url="$3"
  botopen='"state":"OPEN","author":{"login":"kriscendobot"}'
  h47="${GARDEN_TEST_PR47_HEAD:-aaa47}"
  case "$url" in
    # bot, OPEN, non-draft, uncovered → the audit ALERTS (dedup on head).
    *minion.town/pull/47) printf '{"url":"%s","isDraft":false,"title":"design: ocap redesign","body":"security",%s,"headRefOid":"%s","createdAt":"2026-08-16T00:00:00Z"}\n' "$url" "$botopen" "$h47" ;;
    # bot, OPEN, non-draft, covered by an ACTIVE gauntlet record → quiet.
    *minion.town/pull/48) printf '{"url":"%s","isDraft":false,"title":"design: covered","body":"d",%s,"headRefOid":"aaa48","createdAt":"2026-08-16T00:00:00Z"}\n' "$url" "$botopen" ;;
    # bot, OPEN, DRAFT → skipped (draft is the hard boundary; owes nothing).
    *minion.town/pull/49) printf '{"url":"%s","isDraft":true,"title":"feat: draft","body":"c",%s,"headRefOid":"aaa49","createdAt":"2026-08-16T00:00:00Z"}\n' "$url" "$botopen" ;;
    # non-bot author, non-draft → skipped (author gate).
    *minion.town/pull/50) printf '{"url":"%s","isDraft":false,"title":"design: x","body":"d","state":"OPEN","author":{"login":"interloper"},"headRefOid":"aaa50","createdAt":"2026-08-16T00:00:00Z"}\n' "$url" ;;
    # bot, OPEN, non-draft, PROBE (gap-revealing) → skipped.
    *minion.town/pull/51) printf '{"url":"%s","isDraft":false,"title":"probe (gap-revealing prototype)","body":"gap report",%s,"headRefOid":"aaa51","createdAt":"2026-08-16T00:00:00Z"}\n' "$url" "$botopen" ;;
    # stalled metadata read → inconclusive skip.
    *minion.town/pull/54) sleep 600 ;;
    # bot, OPEN, DRAFT → skipped (draft).
    *minion.town/pull/52) printf '{"url":"%s","isDraft":true,"title":"design: draft doc","body":"d",%s,"headRefOid":"aaa52","createdAt":"2026-08-16T00:00:00Z"}\n' "$url" "$botopen" ;;
    # bot, OPEN, non-draft, covered by a COMPLETED gauntlet (tada/) → quiet.
    *minion.town/pull/53) printf '{"url":"%s","isDraft":false,"title":"design: completed-gauntlet","body":"d",%s,"headRefOid":"aaa53","createdAt":"2026-08-16T00:00:00Z"}\n' "$url" "$botopen" ;;
    # Post-arm, bot-authored, uncovered PRs: ready and draft share the stage cap.
    *minion.town/pull/55) printf '{"url":"%s","isDraft":false,"title":"feat: fresh one","body":"d",%s,"headRefOid":"aaa55","createdAt":"2099-01-01T00:00:00Z"}\n' "$url" "$botopen" ;;
    *minion.town/pull/56) printf '{"url":"%s","isDraft":true,"title":"feat: fresh draft with missed handoff","body":"d",%s,"headRefOid":"aaa56","createdAt":"2099-01-01T00:00:01Z"}\n' "$url" "$botopen" ;;
    *minion.town/pull/57) printf '{"url":"%s","isDraft":false,"title":"feat: fresh overflow","body":"d",%s,"headRefOid":"aaa57","createdAt":"2099-01-01T00:00:02Z"}\n' "$url" "$botopen" ;;
    *minion.town/pull/58) printf '{"url":"%s","isDraft":true,"title":"probe (gap-revealing prototype)","body":"gap report",%s,"headRefOid":"aaa58","createdAt":"2099-01-01T00:00:03Z"}\n' "$url" "$botopen" ;;
    # Post-arm, non-draft PRs whose gauntlet already finished (#59-#62) + control #63.
    *minion.town/pull/59|*minion.town/pull/6[0-3]) printf '{"url":"%s","isDraft":false,"title":"feat: finished","body":"d",%s,"headRefOid":"bbb%s","createdAt":"2099-01-02T00:00:00Z"}\n' "$url" "$botopen" "${url##*/}" ;;
    # garden's own repo → excluded before any pr view (defensive fixture).
    *garden/pull/28)      printf '{"url":"%s","isDraft":false,"title":"design: garden own","body":"d",%s,"headRefOid":"aaa28","createdAt":"2026-08-16T00:00:00Z"}\n' "$url" "$botopen" ;;
    *) echo "unexpected pr view: $url" >&2; exit 64 ;;
  esac
  exit 0
fi
exit 64
