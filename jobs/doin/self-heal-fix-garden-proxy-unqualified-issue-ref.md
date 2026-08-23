---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
In scripts/jobs/handlers/proxy-claude.sh, `answer_question()` calls
`maintainer-reply.sh` unconditionally (line ~54) under the script's
`set -euo pipefail`. When the inner `claude -p`'s tentative ANSWER text
contains a bare (partially-qualified) issue/PR reference like `#627`,
`check-issue-refs.sh` (invoked from inside maintainer-reply.sh) rejects it,
maintainer-reply.sh exits 1, and that failure propagates via `set -e` and
kills the ENTIRE proxy-claude.sh handler mid-digest — not just the one
malformed question — which makes proxy.sh die ("proxy handler failed;
leaving markers so the next tick retries") and the whole garden-proxy
service tick FATAL (exit 1, matching this crash).

Fix: in answer_question(), validate/sanitize the reply text before calling
maintainer-reply.sh — e.g. pipe `$reply` through
`check-issue-refs.sh` first; on rejection, either fully-qualify obvious bare
refs from context or fall back to defer_question() for that single question
(logging why) instead of letting the whole handler crash. One malformed
LLM-authored answer must not take down the entire proxy tick or force a
full-digest retry loop.

Failure signature to match in tests: check-issue-refs.sh stderr containing
"message REJECTED — apparently partially-qualified issue/PR reference(s)"
followed by maintainer-reply.sh's "reply not delivered" die and proxy.sh's
"proxy handler failed; leaving markers so the next tick retries".

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-23T04:06:30Z
