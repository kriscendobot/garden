**Retro endojs-endo-but-for-bots-pr1226-review-2fc247cc: review-miss recorded; below the threshold, so no improvement job dispatched**

**Idempotency:** No record existed yet under `review-misses/{misses,dismissed}/` for this primary, so the retro ran.

**What I checked myself** (the PR, the board and the merged design, not the primary's report):
- **The review.** Review 5231787250 by kriskowal was CHANGES_REQUESTED on 2026-09-17. It asked the design to drop the per-guest domain socket or named pipe. Instead, the guest formula id would reach the MCP server through its environment or a stdin handshake, and the server would connect with the ordinary Endo daemon client and look the guest up from the bootstrap root host.
- **Panel history.** Six design-panel rounds ran on 2026-09-08, and every one was must-fix:
  - Round 1: the critic flagged that the channel between broker and adapter was undefined.
  - Rounds 2–6 kept raising must-fix findings on the per-guest Unix-domain-socket mechanism that the fixes added: other processes on the host can list abstract sockets, a mount-slice mismatch, pid reuse defeating `SO_PEERCRED`, Node being unable to read peer credentials, and the cost of one broker process per guest.
  - Each fix added more mechanism. No seat asked whether the existing daemon-client path already present in the repo made the socket unnecessary.
- **The primary's work is real.** The PR merged on 2026-09-24. The design now on `llm` passes the formula id through the MCP config environment and uses the bootstrap-host lookup. The primary job's report is in `jobs/tada/`.

**Verdict: a miss, not new direction.** The maintainer's simplification uses only infrastructure that already existed. The decomplector's standing brief item (f), "minimum viable abstraction", already covers this question and did not catch it in six rounds.
- Category: `process`
- Missed by: decomplector and critic
- Severity: moderate (a design, caught before the builder step and already fixed)

**Recorded** with `review-miss-record.sh record`:
- The record is a paraphrase; none of the comment text was copied into the store.
- No existing cluster matched, so I started a new one, `design-bespoke-mechanism-over-existing-path`, with count=1, status=open, PRs [1226].
- I confirmed both the record and the cluster on `origin/journal2`.

**Threshold: held.** Dispatch needs at least 3 misses across at least 2 PRs; this cluster has 1 miss on 1 PR. The severity bypass needs a major miss, and this one is moderate. I added the reasoning to the cluster file through `cluster-status --rationale-file`, along with a candidate check for a later improvement job: when must-fix findings on the same mechanism come back in two or more rounds, the decomplector or critic asks whether an existing repo path makes that mechanism unnecessary.

**Follow-ups:** There are 3 more retro jobs for #1226 sitting in `plan/` (reviews 5273006881, 5299330782 and 5299606833); they will judge those reviews separately. No garden code changed, so nothing was pushed to `main2`.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1226-review-2fc247cc-retro.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (1051737 cached reads)
- Output: 7035 tokens
- Cost: $0.9267354
- Wall-clock: 120s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
