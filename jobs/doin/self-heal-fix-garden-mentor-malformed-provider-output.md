---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/handlers/mentor-claude.sh
The mentor service fails ~24% of ticks (8 of 33 today, 11:20 through 23:50) at `mentor-claude.sh:162` — "mentor provider 'openai' returned malformed semantic output" — when `validate_mentor_response` (lines 87–105) returns 20 on output from `gpt-5.6-terra`. The intervening ticks succeed, so this is a response-shape mismatch, not credentials, quota, or codex failure.

Two changes, both in this file:

1. **Preserve the evidence.** On a validation rejection the raw provider output is destroyed by the `trap 'rm -f "$raw" "$canonical"' EXIT` at line 152, so eight failures have left no artifact of what was actually malformed. Before the `die` at line 162, copy `$raw` to a durable, bounded location (e.g. `$GARDEN_STATE/mentor/rejected/<utc-timestamp>-<provider>.txt`, pruned to the most recent N) and log a short bounded excerpt (first and last few lines, byte-capped) plus the rejecting condition, so the next occurrence is diagnosable from the journal alone. Keep the excerpt small — this text goes into a supervisor's context.

2. **Stop failing closed on a response that proposes nothing.** The role brief (`roles/mentor/AGENT.md`) and the prompt both instruct the model to "emit nothing when there is no clear opportunity"; models commonly satisfy that with a sentence ("No clear opportunities this tick.") or a markdown fence rather than a literally empty body, and the validator's "nothing outside a block" rule (lines 91, 100, 104) rejects it. Treat a response containing **zero** `JOB` lines as the valid no-opportunity case: log it at normal level, post nothing, exit 0. Only `die` when at least one `JOB` line is present but the block structure is genuinely malformed (unterminated block, nested `JOB`, missing/non-path first body line, prose interleaved between blocks). This preserves both existing invariants exactly — a response proposing no jobs cannot create conflicting improvement jobs, and every actual block stays strictly parsed and canonicalized before posting. Consider also tolerating a surrounding markdown code fence before parsing, since that is a lossless wrapper rather than ambiguous content.

Extend `scripts/jobs/test/mentor-provider-order-test.sh` accordingly: SUBTEST 4 must keep asserting that trailing prose *after a valid JOB block* is rejected and does not solicit a second model, and new subtests should cover (a) prose-only output with no `JOB` line succeeding as a no-op with nothing posted, and (b) a rejection writing the raw capture to the durable path.

`scripts/jobs/handlers/foreman-claude.sh:237` has the identical validator shape and the same `trap`-destroys-evidence gap; apply the same treatment there if it is low-risk to do so in the same change, otherwise note it for a follow-up.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 5
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-01T23:52:40Z
