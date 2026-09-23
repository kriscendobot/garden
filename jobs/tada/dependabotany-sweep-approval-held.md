The precondition gate correctly halted this job. Here is my report.

---

## Botanist sweep — HALTED at precondition (deploy is the blocker)

**Outcome: `orchestration-failed: true`** — this is the correct disposition per the job's own precondition, not a failure of the work.

### What I checked

The job's PRECONDITION requires verifying that the **deployed** `scripts/jobs/gardening/ci-wait-merge.sh` actually carries the dependabot auto-conduct path — read from the file, not inferred from `main2`'s git log.

- **Deployed garden root** (`/home/kris/garden2`, HEAD `c7d730c36`): its `ci-wait-merge.sh` has **no** `--dependabot-auto-merge` mode and **no** `dependabot`/`auto-conduct`/`author` references anywhere. It still calls `pr-maintainer-approval-gh.sh` unconditionally at the merge point (line 293). Under this deployed code, every one of the seven PRs would block on the retired maintainer-approval gate — the exact backlog this job exists to clear.
- **origin/main2** (my worktree, HEAD `225e364eb0` "feat(botany): auto-conduct Dependabot MERGE-NOW"): **does** carry the path — `--dependabot-auto-merge` mode that skips only the approval requirement, after a live author-read proves `dependabot[bot]` and the repo is in bot-owned merge scope.

The policy change is committed on `main2` but **`deploy-garden.sh` has not advanced the deployed root past it.** Per the precondition: "Do NOT review or merge anything under the old rules."

### What I did

- Did **not** touch, review, or merge any of the seven PRs (#912–#916, #867, #868). Merging any of them now would either block at the stale approval gate or, worse, land under the old rules.
- Did **not** run git in the deployed root (one read-only `rev-parse` slipped in; harmless, no mutation — noted and avoided thereafter).
- Messaged the liaison/maintainer (`message-user.sh`, delivered `20260812T053228Z-6aa19b`) naming the deploy as the blocker, with the two HEADs and the specific missing flag.

### Follow-up

Run `deploy-garden.sh` to advance the deployed root past `225e364eb0`, then **re-promote** this sweep. The seven-PR set and its per-PR re-verification (sibling/base-ref supersession census, CI green at current head, maturity floor, advisory sweep — all a day old and to be re-run at current heads, not executed on trust) remain exactly as the job body specifies; nothing about them changed, and #868 remains CONFLICTING/DIRTY needing resolution-or-weaver-escalation once the sweep can actually run.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/dependabotany-sweep-approval-held.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 11 tokens (328215 cached reads)
- Output: 4753 tokens
- Cost: $0.8413735
- Wall-clock: 80s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
