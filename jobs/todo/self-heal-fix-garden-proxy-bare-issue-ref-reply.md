---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
`scripts/jobs/handlers/proxy-claude.sh`'s ANSWER prompt template (the `prompt="$(cat <<EOF ... EOF)"` block in `flush()`) never tells the inner `claude -p` agent that its tentative reply is delivered through `maintainer-reply.sh`, which rejects any bare `#N` issue/PR reference via `check-issue-refs.sh` (only `owner/repo#N` or a full `https://github.com/...` URL passes). The inner agent produced a reply citing bare `#626`/`#627`, `check-issue-refs.sh` correctly REJECTED it, `maintainer-reply.sh` died, and because `answer_question`/`flush` run under `set -euo pipefail` with no per-question isolation, that single rejection propagated up and killed the whole handler for every question in the digest — which `proxy.sh` then treated as a full handler failure (exit 1, service restart). Because the digest is never marked `SEEN` on failure, the identical digest re-triggers next tick, risking a repeat crash-restart loop rather than a one-off.

Fix in `scripts/jobs/handlers/proxy-claude.sh`:
1. Add an explicit line to the ANSWER instructions in the prompt heredoc: any issue/PR reference in the tentative reply must be fully-qualified as `owner/repo#N` or a full `https://github.com/owner/repo/issues|pull/N` URL — never a bare `#N` — because the reply is delivered via the message bus's `check-issue-refs.sh` gate, which rejects partial references.
2. Isolate per-question delivery failure so one bad `answer_question` (e.g. a repeat `check-issue-refs.sh` rejection) doesn't `set -e`-crash the whole digest: catch the failure, fall back to `defer_question` (or an equivalent "awaiting maintainer" note) for that one message, log it, and continue processing the remaining QUESTION blocks — so a single malformed answer degrades gracefully instead of taking the service down and looping.
