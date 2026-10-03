---
handed-off: design-act-local-ci-screening-split
deliverable-complete: false
---
I split the original designer job into two child jobs that run one after the other, and recorded the orchestration that will drive them. None of the original design work was done in this claim, as the split protocol requires.

**Split decision: the work divides.** The original job overran because it tried to do two separate things in one claim: research whether `act` can run here at all, then write the design. The research comes first, and its results go into a committed file, so the second job can start from that file without the first job still running.

**Child jobs, both parked under `design-act-local-ci-screening-split`:**
1. **`design-act-local-ci-screening-research`** (researcher, `handler-timeout: 3600`). It answers four questions, each with evidence:
   - Whether the gardener's container or the host has Docker or Podman.
   - Whether `act` has a mode that runs without containers, checked against its current documentation.
   - Which workflow jobs in `endojs/endo-but-for-bots`, `kriscendobot/minion.town`, and any other repo the fleet regularly runs gauntlets on can run on Linux.
   - The rough local cost compared with the GitHub Actions minutes saved.

   It commits the answers to `main2` as `designs/act-local-ci-screening-findings.md`.
2. **`design-act-local-ci-screening-doc`** (designer). It writes `designs/act-local-ci-screening.md` from those findings, with `act` positioned as a check that `local-verify`'s hand-maintained list still matches the real workflow files. It must cover the Linux-only scope, where the check hooks into the push pipeline, cost/benefit, and `## Open questions`. If the findings file is missing, it stops and says so rather than redoing the research.

**Orchestration:** `design-act-local-ci-screening-split` runs the two children in order and halts if the first one fails. The record is in the journal at `jobs/orch/`, and the orchestrate watcher will start the research child first.

**Follow-ups:** none from this job. A build job should be posted once the design lands.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-act-local-ci-screening.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s) (1 unmetered)
- Input: 8 tokens (166471 cached reads)
- Output: 4423 tokens
- Cost: $0.48222620000000005 (1 engagement(s) unpriced)
- Wall-clock: 2488s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
