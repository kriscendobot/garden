Panel round 4 on PR #181 ended in **must-fix**. `panel.sh` exited 0, so this is a real verdict and not a panel error.

- **Setup:** I checked out the PR head `kriscendobot/minion.town@git-remote-served-clip` in an isolated worktree. I ran the panel in single-round mode against the pinned base `c7bdf2018897930f413a2caf21191f2b26b4b514`.
- **Extra probes:** The new-mechanism probe seated the decomplector. The PR-body concision probe forced the pruner. The repeated-must-fix probe forced the decomplector's is-it-needed question.
- **Posting:** GitHub rejected a request-changes review because the PR is my own, so I posted the aggregate as a `--comment` review. It was cut to the first 60,000 of its 89,819 characters, and the full text is in the panel's `round-1.md` in the run directory.
- **Findings:** I read only the assessor's and typist's sections (the first part of `round-1.md`). Both flagged should-fix issues:
  - **Stuck push marker (assessor):** the receive-pack handler can leave an in-flight entry if `runHttpBackend` throws before it returns, so the marker is never cleared.
  - **Corrupt vhost record (assessor):** a vhost record file that can't be parsed can never be repaired or removed.
  - **Failed-projection retry (assessor):** a failed projection with no markers waits for the hourly sweep. The documented backoff doesn't apply.
  - **Unvalidated state cast (typist):** `parseServedState` casts a shallowly validated value to `ServedState`.
- **Not read:** I did not read the other seats' sections.
- **Changes:** I made no code changes, un-drafted nothing, and did not loop.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr181-gauntlet-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 22 tokens (569811 cached reads)
- Output: 2408 tokens
- Cost: $0.3344862
- Wall-clock: 287s

<!-- garden-usage-end -->
