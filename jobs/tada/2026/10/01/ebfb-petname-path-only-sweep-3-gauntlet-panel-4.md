Panel round 4 on endojs/endo-but-for-bots PR #1390 came back **must-fix**. I posted the verdict as review https://github.com/endojs/endo-but-for-bots/pull/1390#pullrequestreview-5374560621. It went up as a comment because GitHub won't let the bot request changes on its own PR.

**What I ran:** the panel in single-round mode, in an isolated checkout of the PR head `784decdc7a` (branch `build/pet-name-path-only`). I gave it the real merge-base SHA `8e53cc0f89` (the PR's base branch is `llm-8e53cc0`). `panel.sh` exited 0 with disposition must-fix. All 33 seats finished without errors: 6 request changes, 5 comment-only, the rest approve.

**Automated pre-check:** the phase/evidence check blocked the PR, which forces must-fix. It linked the PR to `designs/fs-interface-consolidation.md` and found no phase ledger. The integrator seat thinks that link is a mismatch, because the PR only updates that design's divergence table. A one-line note saying the PR is not a phase of that design, or a valid ledger, would clear it.

**Must-fix findings:**
1. **typist:** `packages/floot/src/container-mounts.js:305` still passes a bare string to `storeValue`, which now throws at runtime. The test fakes accept either form, which hides the bug.
2. **locksmith:** `packages/spaces-util/src/command-executor.js` splits user-supplied names on `/`. A name that would have been rejected becomes a multi-level address, which widens what the user can reach. It should wrap the name as a single item (`[String(x)]`), as the PR already does elsewhere.
3. **surfacer:** parameter names in `packages/daemon/src/types.d.ts` don't match the renamed `*NamePath` names in the help text.
4. **stylist:** `petNames` was never renamed to `petNamePaths` in `@endo/lal`, and some help-text headings still use the old names.
5. **integrator:** the PR body doesn't explain the order of landing and rebasing against #1343, which edits the same daemon files.

**Should-fix:** the `lookup`/`maybeLookup` guards in `interfaces.js` aren't consistent with their neighbors, and the `evaluate` tool in `@endo/agent-tools` still names its argument `resultName`.

The full per-seat output (about 88 KB) is too large for a GitHub review, so the review has a summary plus the first 50 KB in a collapsed section. The cut may land mid-section.

No fixing or un-drafting was done, as this stage requires.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-petname-path-only-sweep-3-gauntlet-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (838878 cached reads)
- Output: 5845 tokens
- Cost: $0.7824116
- Wall-clock: 857s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
