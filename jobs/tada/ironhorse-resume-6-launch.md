---
handed-off: ironhorse-resume-6-launch-postdeploy
deliverable-complete: false
---
Done. The precondition failed and I preserved the launch intent via a durable successor plus a maintainer notification.

## Report

**Job:** Launch Ironhorse test262 campaign resume-6 (17 children, js-12..js-28).

**Outcome: did NOT launch — precondition (meter fix DEPLOYED) is not met.** Handed off to a durable successor.

**What I verified:**
- **Deploy gap confirmed.** The deployed root `scripts/jobs/campaign-spend.sh` **still fatals** at line 79 (`die "usage/$child.jsonl line $line_number is an unmetered or invalid campaign row"`). The forbidden string is present in the deployed script.
- **Fix is landed on `main2` but not deployed.** In a fresh `main2` worktree the fix is present: unmetered rows (`source: "none"` / all-null token fields) contribute 0 spend and are counted, while malformed rows (bad JSON, missing/invalid `ts`, invalid token/cost) are still strictly rejected (lines 62–76). So this is a pure **deploy gap**, not an unlanded fix.
- **All 17 children still parked** in `jobs/plan/` (js-12 through js-28 present).

Per the precondition I did **not** launch and did **not** self-authorize a deploy — launching first would relaunch straight into the same fatal on the first cleric child (how resume-5 died) and would keep the fleet busy, blocking the drained deploy.

**What changed on the board:**
- Posted a durable go-ahead successor `ironhorse-resume-6-launch-postdeploy` (gate=go-ahead → never auto-selected; only the maintainer/liaison promotes it, eliminating any double-launch risk). It carries the full precondition + the exact `post-orchestration.sh` launch line (`--serial --on-child-failure continue --budget-tokens 10000000`, base `ironhorse-test262-implementation-completion-resume-6`, children js-12..js-28) and re-verifies the deploy before firing. Confirmed landed/propagated on `journal2`.
- Messaged the maintainer (via the liaison) with the gap and next steps: (1) let the deploy-on-upgrade Monitor drive the deploy of `main2` → root (or authorize a sysop deploy op); (2) after deploy, promote `ironhorse-resume-6-launch-postdeploy`.

**Follow-ups (owned by the successor):**
1. Deploy the meter fix to the root.
2. Promote `ironhorse-resume-6-launch-postdeploy` — it re-checks the deployed script, then launches the campaign.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-resume-6-launch.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 20 tokens (526301 cached reads)
- Output: 16810 tokens
- Cost: $1.1629115
- Wall-clock: 350s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
