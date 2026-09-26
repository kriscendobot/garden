The work is complete and pushed to `main2`. Here is my completion report.

---

**Job: improve-dependabotany-idle-preflight** — done.

## What I did

Added a deterministic, no-LLM scheduler preflight that quiets the per-project daily `dependabotany-recheck-<project>` backstop on idle days, and wired the botanist role to attach it.

## What changed (commit `39f509d00d` on `main2`)

- **`scripts/jobs/dependabotany-preflight.sh`** (new). Invoked by the scheduler as `<script> <schedule-name>`. Derives the project slug from the schedule stem, then:
  - **exit 2 (skip)** iff BOTH: (A) the watched repo has zero open `dependabot[bot]` PRs, AND (B) the project's dependabotany ledger has no due row.
  - **exit 0 (dispatch)** otherwise — a due matured ledger row, or any open dependabot PR.
  - **fails open (exit 0)** on any error: unreachable journal, open-PR source failure, or undeterminable repo. It only ever quiets a *provably* idle day.
  - Reuses `common.sh` (`ensure_clone`/`sync_clone`), the shared `ci-pr-source-gh.sh` open-PR handler, and the exact `project:` + `# dependabotany` ledger-recovery grep from the botanist role. Repo is derived from the ledger's `repo:` line (overridable). All external I/O is behind `GARDEN_DEPB_*` seams for testing.
- **`scripts/jobs/test/dependabotany-preflight-test.sh`** (new). Hermetic (throwaway bare journal + stubbed PR source, pinned `today`). 14 assertions, all green: both skip paths (drained ledger / not-yet-due embargo with no PRs), both dispatch triggers (due ledger row for a reconcile case; open dependabot PR), the author gate, and all three fail-open branches. `scholar-preflight-test.sh` still green (10/10).
- **`roles/botanist/AGENT.md`** leg 2: the daily-heartbeat `set-schedule.sh` call now carries `GARDEN_SCHEDULE_PREFLIGHT=dependabotany-preflight.sh`, with prose explaining the gate and its fail-open contract, so every future ensure of the schedule wires it.

## Design note (soundness)

Check (A) is the load-bearing guarantee: an *active* embargo is by construction an open Dependabot PR, so real recheck work always makes (A) false → dispatch, regardless of how the ledger prose parses. Check (B) is a best-effort, fail-open backstop that only ever *adds* a dispatch trigger (reconciling a row left behind for an externally-closed PR), so ledger-parse imprecision can never cause an unsafe skip of live work.

## Follow-up (post-deploy)

A live daily schedule already exists on the journal (`dependabotany-recheck-endo-but-for-bots.md`) without the `preflight:` field. It can only be wired **after this deploys** (`set-schedule.sh`'s `validate_preflight` requires the script present in the deployed root; wiring it earlier would trip a one-time deploy-lag escalation). Once deployed, from the deployed garden root:

```
GARDEN_SCHEDULE_PREFLIGHT=dependabotany-preflight.sh \
  scripts/jobs/set-schedule.sh dependabotany-recheck-endo-but-for-bots daily
```

Otherwise the next botanist embargo verdict re-ensures it with the gate automatically.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-dependabotany-idle-preflight.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 83 tokens (4731063 cached reads)
- Output: 58207 tokens
- Cost: $5.177801500000001
- Wall-clock: 837s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
