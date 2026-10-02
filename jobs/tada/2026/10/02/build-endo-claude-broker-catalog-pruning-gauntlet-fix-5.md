I made the panel's two must-fix changes to endojs/endo-but-for-bots#1409 in one pushed commit (`707c1591da`) and edited the PR description. CI is green: all 31 checks passed with none failing.

**Must-fix items:**
- **curator:** In `packages/agent-mcp-stdio/README.md`, the sentence about `renderGuestAllowedTools()` / `makeMcpConfig()` now says those helpers are for the single-tenant shape and render the full tool list. It also says the confined broker doesn't use them and serves only the confined allow-list.
- **pruner:** The PR description is down from about 700 to 579 words:
  - I removed the "Scaling Considerations" and "Upgrade Considerations" sections, which only said "None."
  - "Coordination with #1404" is now one sentence.
  - The withheld tools are summarised by group, with a pointer to the README for the full list.
  - I also fixed a wrong claim in the old description: it said `loadContent` was kept, but the code withholds it.

**Optional comment from corner-prober:** I added a unit test in `test/confined.test.js` covering `selectConfinedTools` with an empty tool list, an empty allow-list, and duplicate names (which pass through unchanged). The file's 7 tests pass locally, and eslint and prettier are clean.

**Not done:** fast-checker's optional property-based tests. The panel's next round is posted separately and will review this push.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endo-claude-broker-catalog-pruning-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (797378 cached reads)
- Output: 3900 tokens
- Cost: $0.6835236000000001
- Wall-clock: 861s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
