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
    # NON-DRAFT PR consumed by the explicitly attested #99 undraft job.
    */pull/99) printf '{"url":"%s","isDraft":false,"state":"OPEN","title":"feat: harness","body":"b",%s}\n' "$url" "$bot" ;;
    # a DRAFT producer PR — the ordinary parked-draft completion (pass, no mutation).
    */pull/200) printf '{"url":"%s","isDraft":true,"state":"OPEN","title":"feat: x","body":"b",%s,"files":[{"path":"src/x.js"}]}\n' "$url" "$bot" ;;
    # NON-DRAFT, uncovered → BLOCK.
    */pull/201) printf '{"url":"%s","isDraft":false,"state":"OPEN","title":"feat: y","body":"b",%s}\n' "$url" "$bot" ;;
    # NON-DRAFT, covered by a seeded gauntlet record → pass.
    */pull/202) printf '{"url":"%s","isDraft":false,"state":"OPEN","title":"feat: z","body":"b",%s}\n' "$url" "$bot" ;;
    # NON-DRAFT, covered by archived/completed gauntlet history → pass.
    */pull/206|*/pull/218) printf '{"url":"%s","isDraft":false,"state":"OPEN","title":"feat: previously reviewed","body":"b",%s}\n' "$url" "$bot" ;;
    # NON-DRAFT probe → pass (exempt).
    */pull/203) printf '{"url":"%s","isDraft":true,"state":"OPEN","title":"probe (gap-revealing prototype)","body":"gap",%s,"files":[{"path":"src/probe.js"}]}\n' "$url" "$bot" ;;
    # NON-DRAFT authored by someone else → pass (citation of another author's PR).
    */pull/204) printf '{"url":"%s","isDraft":false,"state":"OPEN","title":"feat: w","body":"b","author":{"login":"interloper"}}\n' "$url" ;;
    # NON-DRAFT open-questions carve-out → pass.
    */pull/205) printf '{"url":"%s","isDraft":false,"state":"OPEN","title":"design: oq","body":"<!-- garden-design-open-questions -->",%s}\n' "$url" "$bot" ;;
    # inconclusive read (gh error) → the gate fails open.
    */pull/207) echo "boom" >&2; exit 1 ;;
    # DRAFT design-only producer PR → automatic design gauntlet.
    */pull/208) printf '{"url":"%s","isDraft":true,"state":"OPEN","title":"design: x","body":"b",%s,"files":[{"path":"designs/x.md"}]}\n' "$url" "$bot" ;;
    # DRAFT non-design PR from a non-builder → automatic gauntlet.
    */pull/209) printf '{"url":"%s","isDraft":true,"state":"OPEN","title":"fix: x","body":"b",%s,"files":[{"path":"src/x.js"}]}\n' "$url" "$bot" ;;
    # OPEN, non-draft builder artifact → auto-handoff does not mutate or stage.
    */pull/210) printf '{"url":"%s","isDraft":false,"state":"OPEN","title":"feat: ready","body":"b",%s,"files":[{"path":"src/x.js"}]}\n' "$url" "$bot" ;;
    # DRAFT builder PR whose FIRST view hits a transient TLS handshake timeout
    # (counted from the call log, which already holds this call) → a retry wins.
    */pull/211)
      if [ "$(grep -c "pull/211 " "${GARDEN_GH_CALL_LOG:?}")" -le 1 ]; then
        echo 'Post "https://api.github.com/graphql": net/http: TLS handshake timeout' >&2; exit 1
      fi
      printf '{"url":"%s","isDraft":true,"state":"OPEN","title":"feat: flaky","body":"b",%s,"files":[{"path":"src/x.js"}]}\n' "$url" "$bot" ;;
    # every view times out → the retry budget is exhausted and the caller fails.
    */pull/212) echo 'Post "https://api.github.com/graphql": net/http: TLS handshake timeout' >&2; exit 1 ;;
    # a number that is an issue, not a PR → a definitive, non-retried answer.
    */pull/213) echo 'GraphQL: Could not resolve to a PullRequest with the number of 213. (repository.pullRequest)' >&2; exit 1 ;;
    # DRAFT open-questions answer surface → no automatic gauntlet.
    */pull/214) printf '{"url":"%s","isDraft":true,"state":"OPEN","title":"design: oq","body":"<!-- garden-design-open-questions -->",%s,"files":[{"path":"designs/oq.md"}]}\n' "$url" "$bot" ;;
    # DRAFT PR authored by someone else → citation, not a producer artifact.
    */pull/215) printf '{"url":"%s","isDraft":true,"state":"OPEN","title":"feat: cited","body":"b","author":{"login":"interloper"},"files":[{"path":"src/x.js"}]}\n' "$url" ;;
    # DRAFT build PRs with plain titles: the probe classification rides on the job file.
    */pull/216|*/pull/217) printf '{"url":"%s","isDraft":true,"state":"OPEN","title":"fix: plain","body":"b",%s,"files":[{"path":"src/x.js"}]}\n' "$url" "$bot" ;;
    # DRAFT build PRs whose phase/evidence ledger says the PR is not the
    # deliverable (#219 replays kriscendobot/minion.town#148) or now is (#220).
    */pull/219|*/pull/220|*/pull/221)
      case "$url" in
        */pull/219|*/pull/221) disposition="${GARDEN_STUB_LEDGER_DISPOSITION:-non-deliverable-probe}" ;;
        *) disposition=deliverable ;;
      esac
      body="$(printf 'Feature.\n\n<!-- garden-phase-evidence-ledger:v1 -->\n## Phase and evidence ledger\n\nDisposition: %s\nSuccessor: canary-child\nPhase 1: partial | wired\nPhase 3: not-started | canary child\nAcceptance: not-started | canary child\n<!-- /garden-phase-evidence-ledger -->\n' "$disposition")"
      jq -cn --arg url "$url" --arg body "$body" \
        '{url: $url, isDraft: true, state: "OPEN", title: "feat: slice", body: $body,
          author: {login: "kriscendobot"}, files: [{path: "src/x.js"}]}' ;;
    *) echo "unexpected pr view: $url" >&2; exit 64 ;;
  esac
  exit 0
fi
exit 64
