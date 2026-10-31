Panel round 3 for endojs/endo-but-for-bots PR #1596 finished with **must-fix**, and the review is posted on the pinned head.

1. **Pinned the PR.**
   - Base: `9a14ddf660912ed624e2d9047671d43e3a2f0cec`
   - Head: `8526e375eeeb4b32e4b6701fa2ee856cc04d6432`, branch `endojs:build/m3-mvs-resolver-reference`. The PR is still a draft and open.
   - I made an isolated project checkout at `/home/kris/garden/scratch/project-wt-endojs--923771cdda05-7771b9ac`, checked out the head detached, and confirmed `git rev-parse HEAD` matches it.
2. **Read-only probes passed (exit 0).** There was one non-blocking warning: the pruner flagged a 6-line prose comment at `packages/exo-npm/src/mvs-resolver.js:500`.
3. **Ran `panel.sh` in single-round mode; it exited 0 with must-fix.**
   - It noted the same must-fix mechanism had come up again, so it forced the decomplector's "is it needed?" question.
   - The PR-body concision probe also fired, so the pruner reviewed the PR description too.
4. **The review is on the PR.** `panel.sh` posted the "Must-fix before merge" aggregate at 2026-10-31T20:26:46Z against head `8526e375…`. It went up as a comment review (state `COMMENTED`), not a "request changes" review. The first finding is from the changeset-auditor: the diff (`packages/exo-npm/src/mvs-resolver.js` and its test) adds no `.changeset/*.md` file.

I made no code changes and did not un-draft the PR. The fix stage (fix-3) gets the posted review next.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1596-gauntlet-panel-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 16 tokens (409732 cached reads)
- Output: 2590 tokens
- Cost: $0.5078344
- Wall-clock: 204s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
