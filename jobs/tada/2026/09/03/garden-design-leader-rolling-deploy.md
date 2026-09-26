PR #73 is still draft, kriskowal is re-requested, and the head is my pushed commit. Inbox is empty. Job complete.

## Completion report

**Job:** Revise design PR #73 per kriskowal's review — reframe the follower-only self-deploy design into a leader-orchestrated rolling deploy with followers as canaries.

**What I did:**
- Rewrote `designs/follower-self-deploy.md` (retitled *"Rolling deploy: the leader orchestrates a fleet upgrade with followers as canaries"*; filename kept for branch/link continuity, with an in-doc note explaining the reframe). It now works out all six required points:
  1. **Leader self-deploy** — the leader advances itself autonomously but **last**, gated on canary validation; reverses the old session-orchestrated asymmetry.
  2. **Rolling order** — followers first, one canary at a time by default; leader last; single-follower and leader-only fleets specified (leader-only has no canary → self-deploys directly = today's solo behavior).
  3. **Orchestration + attestation crux** — **Reconciliation A (recommended):** deploy trigger stays a host-local cryptographic `upgrade-ready` fact (never a bus message), leader orchestrates ordering via a **benign** journal release token + benign `drain` ops, so the sysop `deploy`-op maintainer attestation is untouched. **Reconciliation B** (leader-issued deploy op with a narrowed exemption) recorded as the maintainer-choosable fallback. Design point 4's "never read the bus to decide to deploy" invariant is preserved verbatim.
  4. **Post-deploy validation** — a bounded deterministic canary probe: unit health + a host-pinned round-trip probe job (`claim → run → tada`) + a job-processing regression watch (claim liveness, failure rate), with one pass/fail gate.
  5. **Failure & rollback** — a failed canary halts the roll (leader never advances on a failed canary), pages once-per-window, leaves the canary drained; auto-rollback deferred with rationale. Distinguished a safety-halt from the original nine-day *liveness* stall.
  6. **Relationship to the old trigger** — retained as the release mechanism (primary) + a leaderless-grace headless fallback (degraded).
- Rewrote the `designs/deliberate-deploy.md` § Session-orchestrated-trigger narrowing note so it no longer contradicts (now neither tier is session-gated; canary validation is the safety gate).
- Kept the diff **design-only** (the `roles/liaison/AGENT.md` live-brief edit stays deferred to the build), so the design panel stays armed; updated the description of that deferred note.
- Retained a `## Open questions` section (6 maintainer-facing questions) and added the `<!-- garden-design-open-questions -->` marker to the PR body (it was absent before).
- Validated the mermaid flowchart with `mermaid.parse` (flowchart-v2 OK).

**Changed / pushed:** commit `9fbe151be5` to branch `design/follower-self-deploy`; PR body refreshed; posted a review-thread reply and re-requested review from kriskowal. PR remains **draft**.

**Follow-ups (all deferred to a build, none blocking):** the implementation build (`garden-rolling-deploy.sh` conductor, re-gated `self-deploy.sh`, `fleet/health` publish, canary-probe template + watcher, root-repo-guard invariant D, the deferred liaison brief edit, tests). The maintainer's top decisions are the open questions — chiefly Reconciliation **A vs B** and **canary quorum vs all-followers**.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/garden-design-leader-rolling-deploy.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 60 tokens (2232422 cached reads)
- Output: 38387 tokens
- Cost: $2.994178
- Wall-clock: 556s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
