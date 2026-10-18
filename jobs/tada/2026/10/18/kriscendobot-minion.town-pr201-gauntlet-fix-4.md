Pushed the round-4 fix to PR #201, but CI is not fully green. The `test` job passed in 13m37s. Both "Claude harness" jobs (amd64 and arm64) were still queued when I stopped, about an hour after the push.

**What was already done:** A prior claimant of this job had already pushed two commits to the PR head that address the round-4 must-fix items:
- `b7fe5da0` stops a bad import from wedging the power, bounds the mutation queue, reads only own-property `KIND_LABELS` entries, and defines the pet-name grammar once.
- `28aaa90b` corrects the design-doc claims (release behavior, shell frame), points to the power header, and trims repeats.

I confirmed those commits cover the archivist, warden, breaker, engine-realist, pruner and decomplector findings. The PR body already reflects the pruner trims.

**What I added:** `5ccb9ed5`, pushed with `safe-push-pr-head.sh` as a plain advance (`28aaa90b` → `5ccb9ed5`).
- **Error status:** `POST /account/clips/new` now answers unexpected errors with 500 ("Could not make a new clip"). It keeps 503 only for `DaemonUnavailableError`. This is the assessor's should-fix, and I updated `test/new-clip.test.ts` to match.
- **ASCII strings:** The typist's curly quotes, curly apostrophes and ellipses in the New Clip page and the shell's "Making a new clip..." text are now ASCII. I left the shell's existing `’` in "town’s keeper" alone because that line isn't part of this PR.
- **Local check:** `test/new-clip.test.ts` passes, 16 of 16.

I did not take two lower-severity items:
- the `describeKind` own-property check, which was already in `b7fe5da0`, and
- the assessor's comment-only notes.

**Follow-up:** The harness jobs are probably stuck behind runner saturation. If they stay queued, the driver should re-post this stage. Since `ci-wait-merge.sh` was killed at the 10-minute background limit, I polled `gh` directly instead.

<!-- gauntlet-stage-result: fix=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr201-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 118 tokens (4778997 cached reads)
- Output: 25780 tokens
- Cost: $2.3232239000000003
- Wall-clock: 7455s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
