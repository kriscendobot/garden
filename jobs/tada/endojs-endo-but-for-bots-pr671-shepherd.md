## Completion report — `endojs-endo-but-for-bots-pr671-shepherd`

**Outcome: endojs/endo-but-for-bots#671 is MERGED** (2026-07-29T02:33:47Z, merge commit `50972e791d292749803efe5d4d47f839f46d7fae`, base `llm`). No shepherd push was needed — CI was already green. The real blocker was a garden-side gate, not the PR.

### CI state (verified, not assumed)

Head `7e2bc0b9e510b2de1f8e7c1d74b4e7d417368cef`, OPEN, not draft, `mergeable: MERGEABLE`, `mergeStateStatus: CLEAN`. All **24/24 check-runs on that head conclude `success`**; `gh pr view --json statusCheckRollup` filtered for non-success returns `[]`. Green run: <https://github.com/endojs/endo-but-for-bots/actions/runs/30415003854>. kriskowal's APPROVED review 4803447943 carries `commit_id` equal to that head, so the approval is current, not stale. Nothing to fix, nothing pushed, no PR comment posted (a green-run comment is for a shepherd's own push, per `roles/shepherd/AGENT.md` § Watch-only is the wrong shape).

### Why this job existed at all

`comment-watcher.sh` gates a trusted APPROVED review on `pr-mergeable-gh.sh`; on non-zero it downgrades `VERB=finalize` to `VERB=shepherd` and slides the cursor. The probe returned 1 — but from the **approval** leg, not CI:

```
$ /home/kris/garden2/scripts/jobs/handlers/pr-mergeable-gh.sh endojs/endo-but-for-bots 671
merge blocked: no maintainer approval (reviewDecision=none)   → rc=1
```

The **deployed** `pr-maintainer-approval-gh.sh` requires GitHub's `reviewDecision` rollup to equal `APPROVED`. The `endojs/endo-but-for-bots` default branch `llm` carries a `pull_request` ruleset with `required_approving_review_count: 0`, so GitHub reports `reviewDecision: ""` for **every** `llm`-based PR — the deployed gate false-negatives on all of them. Confirmed empirically: base `llm` → `""`; bases with no ruleset (`llm-08f5acc`, `feat/mount-grep`) → `APPROVED`. The fix is already on `main2` (`c510ec1b4f`, 00:24:54Z today; rollup became a veto rather than the authority) and is **pending deploy**. Run from `main2` the same probe exits 0, and `scripts/jobs/test/pr-maintainer-approval-gh-test.sh` passes 12/12 with the empty-rollup case pinned. This is deploy lag, not a code defect — I changed no code.

### What I did

- **Minted the conductor the watcher dropped**: `endojs-endo-but-for-bots-pr671-conduct` (identity `endojs/endo-but-for-bots#671:finalize:4803447943`), body carrying the evidence *and* the gate diagnosis. That diagnosis is what let the claiming gardener work around it — it ran `ci-wait-merge.sh` from its own `main2` worktree and merged. The approval's watcher cursor had already slid, so nothing else would have re-minted it.
- **Annotated** the parked `jobs/plan/endojs-endo-but-for-bots-pr656-conduct.md` with the demonstrated work-around (that job was parked at 00:35Z on the premise that the merge spine stalls pre-deploy; it only stalls when invoked from the deployed root). Gate not released — that stays the gate-holder's call.
- **Messaged** the live `endojs-endo-but-for-bots-pr691-shepherd` peer with the same work-around (endojs/endo-but-for-bots#691 also exits 0 on the fixed probe).
- **Messaged the maintainer** (`20260729T023731Z-c3d995`) asking to prioritize the deploy, with the blast radius: endojs/endo-but-for-bots#656, #671, #691 all approved, green, and stranded on the one gate.

### Corrections and loose ends

- I posted the conduct job straight into `todo/` when the endojs/endo-but-for-bots#656 precedent argued for parking it. I sent a correction to that gardener; it had already merged successfully, so the correction dead-lettered (`20260729T023454Z-34a94e`) and `garden-deadmail` will promote it into a job carrying now-stale advice. A gardener claiming it will see endojs/endo-but-for-bots#671 merged and no-op. Small waste, flagged rather than hidden.
- Not verified: I read CI state from GitHub's check-runs API rather than executing the project test suite locally — for a shepherd, CI state is the observable. I ran no project tests and pushed nothing to the PR branch.

**next: none** — the PR is merged; the fixer's follow-up items are recorded in the conductor's report as non-blocking.

Self-improvement: `entries/2026/07/29/023848Z-message-shepherd-ee88b5.md` (message to liaison); proposed that the watcher's approval→shepherd fallback stamp the minted body with its provenance and a "mint the conductor when green" instruction, plus a matching norm in `roles/shepherd/AGENT.md` — without it a shepherd landing on already-green CI reads its own role file correctly, reports `next: none`, and silently loses the approval. Routed rather than landed, since this job is not a garden-infra build on `main2`. Three PRs (#656, #671, #755) have now hit that shape.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr671-shepherd.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 117 tokens (6481740 cached reads)
- Output: 46461 tokens
- Cost: $5.744544999999999
- Wall-clock: 799s

<!-- garden-usage-end -->
