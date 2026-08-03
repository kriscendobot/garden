#!/bin/bash
# review-rounds-fake-gh.sh — a committed `gh` stub for review-rounds-test.sh. Lives in
# the repo tree (an exec-capable location — a stub written into a /tmp mktemp dir is
# NOT executable under the sandboxed test runner) and is symlinked in as `gh` on PATH,
# the same shape mentor-provider-order-test.sh uses for its fake claude/codex/curl.
# It ignores all args and prints the fixed `gh pr list` fixture the test asserts on.
#
# Four merged bot PRs (author "botlogin") + one non-bot PR that --author must drop:
#   #1: 2 human (kriskowal, erights) + 1 bot review -> 2 human rounds, multi-reviewer
#   #2: 1 human (kriskowal)                          -> 1 human round
#   #3: only a bot review                            -> 0 human rounds
#   #4: no reviews                                   -> 0 human rounds
#   #9: author someone-else                          -> excluded by --author botlogin
cat <<'JSON'
[
 {"number":1,"author":{"login":"botlogin"},"mergedAt":"2026-08-01T00:00:00Z",
  "reviews":[{"author":{"login":"kriskowal"},"state":"COMMENTED"},
             {"author":{"login":"erights"},"state":"APPROVED"},
             {"author":{"login":"panelbot"},"state":"COMMENTED"}]},
 {"number":2,"author":{"login":"botlogin"},"mergedAt":"2026-08-01T00:00:00Z",
  "reviews":[{"author":{"login":"kriskowal"},"state":"APPROVED"}]},
 {"number":3,"author":{"login":"botlogin"},"mergedAt":"2026-08-01T00:00:00Z",
  "reviews":[{"author":{"login":"copilot-pull-request-reviewer[bot]"},"state":"COMMENTED"}]},
 {"number":4,"author":{"login":"botlogin"},"mergedAt":"2026-08-01T00:00:00Z","reviews":[]},
 {"number":9,"author":{"login":"someone-else"},"mergedAt":"2026-08-01T00:00:00Z",
  "reviews":[{"author":{"login":"kriskowal"},"state":"APPROVED"}]}
]
JSON
