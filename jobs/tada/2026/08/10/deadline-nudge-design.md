Landed `designs/deadline-nudge.md` on `main2` at `750ca2b24a`.

The design specifies a leader-only, no-LLM timer; proportional lead time capped at 15 minutes; one conditional inbox message per claim attempt; fail-open delivery; marker isolation; and fleet-wide scope. It plainly limits current delivery to the agent’s next inbox poll and leaves Claude/Codex live-session steering as open questions.

Checks: all five pre-dispatch grep gates clean; `git diff --check` clean; remote `origin/main2` matches the landed commit.

Follow-up: implement the timer and separately spike backend-specific immediate delivery.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/deadline-nudge-design.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 550s

<!-- garden-usage-end -->
