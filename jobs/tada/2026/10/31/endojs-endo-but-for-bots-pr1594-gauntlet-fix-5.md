---
orchestration-failed: true
---
Fix round 5 for PR #1594 is pushed, but CI came back red (`ci-wait-merge.sh` exit 3), so the stage is not marked done. The one failing test is a sandbox test that looks like a known runner problem, not this change.

**What I fixed:** The style pre-pass flagged the re-export of `WorkerFacetForManagerInterface` from `./worker-facet-interface.js` at `packages/daemon/src/interfaces.js:1025` because it had no `@deprecated` JSDoc. Earlier commits on this PR first removed that re-export and then restored it, since the changeset still advertises it there. So I kept it and marked it deprecated instead of removing it again:
- I kept the existing explanatory line comment and added `/** @deprecated Import from \`./worker-facet-interface.js\` instead. */` directly above the export.
- Every in-tree importer already imports from `./worker-facet-interface.js`. The identity test that checks both paths give the same object is unchanged.
- I pushed it as follow-up commit `9b0619a17` with `safe-push-pr-head.sh --mode advance`, moving the branch from `10a1297e1` to `9b0619a17`.

**Checks:**
- `pre-push-gates.sh --probes-only` against `llm-9a14ddf`: all 9 stages pass, with no warnings. An earlier, longer JSDoc version drew a comment-length warning, so I shortened it.
- I couldn't reproduce the original failure locally: the probes also pass on the pre-fix commit. Running the probe's parser directly on the new file does show the export as deprecated, which is what the probe checks for.
- Prettier is clean.

**CI result:** 35 of 36 checks passed. The one failure is `test (24.x, ubuntu-latest)`, run 41250046102: `bwrap › bwrap timeout and repeated cancellation reap process groups`. This matches the breakage on every endo-but-for-bots PR since `ubuntu-latest` moved to 26.04 on 2026-10-22. My change only adds a JSDoc comment and doesn't touch the sandbox code. It still needs the runner fix or a re-run; another push to this PR won't clear it.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1594-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 62 tokens (1791169 cached reads)
- Output: 8855 tokens
- Cost: $1.0024458000000003
- Wall-clock: 4150s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
