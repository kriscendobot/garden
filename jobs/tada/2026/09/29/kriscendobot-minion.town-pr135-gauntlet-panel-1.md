I ran round 1 of the review panel on kriscendobot/minion.town PR #135 ("deploy(npm-registry): dark provisioning code for npm.minion.town"). The verdict is **must-fix**, and it is posted on the PR. `panel.sh` exited 0, all 33 seats ran without error, and I did not fix anything or un-draft the PR.

**How it ran**
- Isolated checkout of the PR head (`kriscendobot/minion.town`, branch `build/npm-minion-town-registry`, commit `e155214`).
- Base was the PR's own base commit `c6788df` (branch `main-c6788df`).
- The panel ran detached with `GARDEN_YARN=npm` and single-round mode on, and took about 4 minutes. Its final line was `panel #135: code-panel single-round — must-fix`.
- The journal record is `panel-runs/kriscendobot-minion.town-135/3c91d3e2bf60.md`.

**The posted review**
- The bot account authored the PR and GitHub refuses a "request changes" review on your own PR, so it went up as a comment review (2026-09-29T01:25:39Z). Its header says **must-fix**, which is what the next-stage check reads.
- It includes the full text from the 8 request-changes and 10 comment-only seats. The 15 approving seats are listed by name only, with their text left out to fit GitHub's size limit.
- The gh wrapper first refused to post because three issue links pointed at the wrong repo. I fixed them before posting:
  - `endo-but-for-bots #1362` became `endojs/endo-but-for-bots#1362`.
  - `#134` became `kriscendobot/minion.town#134`.
  - A "finding #2" mention is now in backticks so it doesn't link.

**Seat verdicts**
- **Request-changes (8):** assessor, stylist, prover, locksmith, saboteur, breaker, purist, wire-watcher.
- **Comment-only (10):** typist, archivist, spec-keeper, engine-realist, integrator, pruner, corner-prober, fast-checker, transplanter, coverage-auditor.

**Main findings, for the fixer**
- **Restore can leave the service down:** the restore path in `npm-registry-backup.sh` stops the registry but has no trap to restart it. If a step fails partway, the service stays stopped, and the state directory can be missing. The backup path already has that trap.
- **Publish token exposure in `deploy-npm-registry-secret.sh`:**
  - the plaintext copy in S3 is only deleted if delivery succeeds;
  - the token appears on curl's command line, where any local user can read it;
  - it is written to a world-readable file in `/tmp` (no `umask 077`).
- **Links to a missing design file:** several links point at `designs/npm-minion-town-registry.md`, which only exists in the open draft kriscendobot/minion.town#134. This PR should stay draft behind #134.

**Follow-ups**
- The fix-loop stage comes next.
- `panel.sh` can't always tell which bucket a seat belongs in: the locksmith section had no verdict in its heading, so I sorted seats using each one's own output. Also, oversized aggregates still have to be trimmed by hand to fit GitHub's size limit.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr135-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (880414 cached reads)
- Output: 6197 tokens
- Cost: $0.7639188000000002
- Wall-clock: 342s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
