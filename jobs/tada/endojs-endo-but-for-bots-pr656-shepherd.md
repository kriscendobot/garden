## Shepherd report — endojs/endo-but-for-bots PR #656

**Result: CI was already green; no repair was needed on the PR. The real blocker was a garden-side merge gate, which I diagnosed, covered with tests, and handed off.**

### PR state (verified)
- `gh api repos/endojs/endo-but-for-bots/commits/76e6800e.../check-runs` → **24/24 check runs `completed`/`success`**, 0 non-success, 0 pending, on head `76e6800ee54cf8108c917b81e7dcdfa7f29e5aaa`.
- OPEN, `mergeable: MERGEABLE`, `mergeStateStatus: CLEAN`, not draft.
- kriskowal `APPROVED` on that exact head at `2026-07-29T00:06:25Z` (the review that minted this job).

No push to the PR, no commit, no comment — the job body carried no comment authorization and there was nothing to fix.

### Why this job existed at all
`comment-watcher.sh` routes a clean trusted approval to the conductor only if `pr-mergeable-gh.sh` says ready; otherwise it dispatches a shepherd. The probe said not-ready — but not because of CI. `pr-maintainer-approval-gh.sh` required GitHub's `reviewDecision` rollup to equal `APPROVED` before it would read the reviews at all, and GitHub leaves that field **empty** on some PRs despite a real approval on the head commit. Empty on #656, #705, #282; `APPROVED` on #669, #707 — same repo, same approver. Polled #656's rollup for 6 minutes after the approval to rule out replication lag: still empty. This is also what stalled `endojs-endo-but-for-bots-pr755-conduct` on 2026-07-28, where it was read as a stale-head problem.

### What I changed (garden `main2`)
A peer landed the same diagnosis concurrently (`c510ec1b4f`, rollup becomes a veto rather than the authority) — I dropped my equivalent handler commit and rebased onto theirs rather than clobbering it. Their fix landed with **no tests**, so I pushed:

- `0520ce88bc` — 7 regression cases pinning the empty-rollup branch, and pinning that letting it through does *not* weaken the individual-review check (absent / stale / non-maintainer approvals still refused; `CHANGES_REQUESTED` and `REVIEW_REQUIRED` still veto). **Verified load-bearing**: reverting `c510ec1b4f`'s condition to the old `!= APPROVED` fails exactly `empty rollup with current maintainer approval allows` and only that one. Unit suite 12/0.
- `59982083f9` — `run-test.sh` ran `shellcheck -x` on the `gh` wrapper without `-P SCRIPTDIR`, so shellcheck 0.9.0 resolved the wrapper's `source=` directive against the caller's cwd: the suite passed from `scripts/jobs/bin` and failed (SC1091) from the repo root. Pre-existing and unrelated to my change; full suite now **367 passed, 0 failed** (was 366/1).

Both pushed to `origin/main2` (rebase-CAS, first attempt).

### Hand-off
The **deployed** root still carries the old gate (`pr-mergeable-gh.sh endojs/endo-but-for-bots 656` → rc=1 deployed, rc=0 with the fix). A conduct job queued now would stall exactly as #755's did, so I parked it instead:

- `jobs/plan/endojs-endo-but-for-bots-pr656-conduct` (gate: `go-ahead`) — promote **after** a deliberate `main2` deploy.
- Maintainer messaged (`20260729T003528Z-fc6c03`) with the diagnosis and the deploy ask.

**next: liaison** — the remaining step is a human-supervised deploy of `main2` (`context/operations/deploy.md`), after which promoting the parked conduct job merges #656 cleanly. Until that deploy, every approved PR in the fleet is unmergeable for the same reason.

### Follow-ups
- The deploy is the unblocking act for more than #656; #705 and #282 also carry approvals with empty rollups (both fail the probe for other reasons today, so they need their own passes once the gate is live).
- Worth knowing why GitHub sets the rollup on some PRs and not others (likely tied to whether a review was *requested*). Not required for correctness — the per-head maintainer check is the authority — but it would close out the `#755` misdiagnosis for good.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr656-shepherd.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 142 tokens (6725401 cached reads)
- Output: 40928 tokens
- Cost: $5.504055500000001
- Wall-clock: 1715s

<!-- garden-usage-end -->
