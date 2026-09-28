## Gauntlet fix round 1: endojs/endo-but-for-bots PR #1097

I applied both of the panel's must-fix items and one of its comment-only suggestions, pushed the change, and CI finished green: 33 checks, 0 failed, `ci-wait-merge.sh` rc 0.

**Must-fix items.** Both were wording in the PR body, so I edited it with `gh pr edit --body-file`:
1. **Wrong method name (integrator seat).** The "Documentation Considerations" section named `range(start, end?)`, which doesn't exist. It now says `byteRange(start, end)`, which is what `help-text-data.js` and the changeset use.
2. **Performance claim with no measurement (benchmarker seat).** "Scaling Considerations" said the change "avoids redundant encoding work". I reworded it: removing the base64 chunk iterator just deletes a duplicate encoding path. The shared `PassableBytesReader` adapter already does the single base64 encoding that `streamBase64` needs. The body now states that this is a simplification rather than a performance claim, and that we did not benchmark it.

**Comment-only suggestion (several seats).** In `packages/platform/test/cached-fs.test.js` I added an assertion that the miss transcript contains exactly one watcher `events` call. I also added a comment saying the reorder only moves the first `streamBase64` return. If someone later extends the test, it will fail loudly instead of being reordered wrong without anyone noticing.
- Commit `517fb54105` (`test(platform): assert the single watcher call the transcript reorder assumes`), pushed with `safe-push-pr-head.sh` in advance mode (4003abd2a1 → 517fb54105).
- Run locally before pushing: `cached-fs.test.js` passed 7/7, prettier passed, and eslint reported no errors. Its one warning (an unused disable directive at line 2) was already in the file.

**Follow-ups:**
- The driver should re-post panel round 2.
- My memory note from 2026-09-22 says the whole #1097 delta may already be on `origin/llm`, and I told the maintainer then that it might be better to close the PR as superseded than to rebase it. The base has since been pinned to `llm-db664fa` and this gauntlet was started, but that close-or-keep question still needs the maintainer's answer.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1097-gauntlet-20260928-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (955890 cached reads)
- Output: 5316 tokens
- Cost: $0.7415300000000001
- Wall-clock: 1853s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
