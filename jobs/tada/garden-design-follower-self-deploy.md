Inbox empty. The job is complete. Let me write the report.

The design is delivered as draft PR **kriskowal/garden#73**, design-only diff so the design-panel gauntlet auto-stages.

---

## Completion report

**Job:** `garden-design-follower-self-deploy` (role: designer) — design follower self-deploy so an unattended non-leader host advances its own deployed version on the local upgrade signal, without a human.

**What I did**
- Studied the existing rails: `upgrade-monitor.sh` (the `upgrade-ready` signal), `deploy-garden.sh` (candidate gate / drain / defer / dirty-tree abort / atomic swap), `sysop.sh` (the attested bus `deploy` op), `root-repo-guard.sh` (lossless HEAD/origin/object-store self-heal), the leader/follower singleton model, the foreman brake, and the maintainer-alert path.
- Wrote **`designs/follower-self-deploy.md`** (~415 lines, 1 validated mermaid flowchart — `mermaid.parse` → `OK flowchart-v2`). It designs **only the trigger** and works out all six required points:
  1. **Trigger** — a `! is_main_host`-gated no-LLM `garden-self-deploy` daemon reading only the local `upgrade-ready` file; **per-sha settle window** (10 min floor, argued from a premature/reverted tip); **rejected** a minimum-drift threshold (it recreates the stall); quiet-period subsumed by the existing long-job defer.
  2. **Leader vs follower** — keep the asymmetry (leader stays session-orchestrated: a session is present there and it is the canary; a follower is unattended by definition).
  3. **Dirty-tree case** — a **lossless preserve-and-clean self-heal** (proposed as root-repo-guard invariant D) instead of another blocking inbox notice, since any tracked edit in the root is an escape by the no-dev-in-root invariant.
  4. **Attestation boundary** — self-deploy triggers on a **host-local signal + git ancestry, never a bus message**, with a two-path table and the hard invariant that it reads no `msgs/` path; the sysop `deploy` op keeps its maintainer attestation, and self-deploy is not a back door around it.
  5. **Drain / foreman brake** — respects an operator drain (skips), ignores the orthogonal foreman brake.
  6. **Failure/observability** — a **leader-canary** gate (a follower never gets ahead of the leader's published deployed sha, making the attended leader the fleet's integration test), plus once-per-window self-clearing alerts, a retry back-off, and the existing stalled-deploy watch as backstop.
- **Supersession (narrowed, leader-only):** added a "Narrowed by" note to `designs/deliberate-deploy.md` § Session-orchestrated trigger. For `roles/liaison/AGENT.md` § Deploy-on-upgrade Monitor I recorded the narrowing in the design's § What this supersedes and **deferred the actual live-brief edit to the implementation build** — a role brief must not claim a behavior before its daemon exists, and this keeps the PR diff design-only.

**What changed**
- New: `designs/follower-self-deploy.md`. Modified: `designs/deliberate-deploy.md` (15-line narrowing note).
- Draft PR **kriskowal/garden#73** (head `design/follower-self-deploy`, base `main2`), diff verified design-only (`design_only_paths: YES`), so the completion machinery auto-stages the 7-seat design panel. Left draft per designer norm; no `run the gauntlet` hand-posted.

**Follow-ups (named in the design, deliberately not implemented — design record first)**
- A contained build: `self-deploy.sh` + `garden-self-deploy.{service,timer}`; publish `deploy/leader-sha` on a leader deploy; root-repo-guard invariant D; `GARDEN_SELF_DEPLOY_SETTLE`/`GARDEN_SELF_DEPLOY_RETRY_BACKOFF`; `self-deploy-test.sh`; and the deferred liaison-brief note.
- Three open questions surfaced for the maintainer: a possible headless leader fallback, confirmation that preserve-and-revert is always correct for in-root edits, and `deploy/leader-sha` vs a full per-host fleet deploy-state view.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/garden-design-follower-self-deploy.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 1101 tokens (3713572 cached reads)
- Output: 32890 tokens
- Cost: $3.9881800000000003
- Wall-clock: 516s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
