I checked PR #1407 without spending any clean, panel, fix, or CI budget. The verdict is **viability=proceed**: the PR is still open and nothing has replaced it.

**PR facts:** The PR is open and unmerged, still a draft, with head `969337438069f565b8f2d4411d3cabc9d11649e0` on `bot/build/guest-scoped-daemon-bootstrap`. Its base is the frozen branch `llm-d4124e6` (`d4124e6e40`). It has no reviews yet. The build's earlier gauntlet (`build-endo-guest-scoped-daemon-bootstrap-gauntlet`) stopped at its clean stage and asked for maintainer action. CI is red on one check, macOS `test (24.x, macos-15)`. The bot's earlier comment on the PR blames flakes that already exist on the base, not this diff.

Deciding question: Is the confined-turn broker still reaching its guest through the root host's `lookupById`, with no other change already giving it a bootstrap scoped to one guest, so that a reviewer's request for one is still unmet?

Evidence:
- **A reviewer asked for this work.** The PR builds item 4 of #1371's "Named follow-ups", which a reviewer requested in https://github.com/endojs/endo-but-for-bots/pull/1371#pullrequestreview-5375148317. #1371 merged on 2026-10-01 at 08:37Z, and this PR was opened 50 minutes later.
- **The design still treats it as future work.** On `llm` today, `designs/endo-guest-stdio-mcp.md` still describes the server resolving through `E(host).lookupById(formulaId)`. It names a bootstrap scoped to the one guest only as the planned replacement (around lines 27, 131 and 208, and 277–281). So the problem this PR fixes still exists on the base.
- **Nothing newer on the base covers it.** `llm` is 25 commits past the PR's base. All of them are mount-view designs, ironhorse-vm/compile/regexp stack refactors, or stack-lanes test commits. None touch the daemon guest bootstrap, `agent-mcp-stdio`, or `claude` confined-turn.
- **No other PR does the same thing.** I searched all PRs for `guestBootstrapPath`, "guest-scoped" and "guest bootstrap". The only one implementing a guest-scoped daemon bootstrap is #1407. Related open PRs touch other things:
  - #1404 changes guests so they neither produce nor consume identifiers. It might conflict with the broker's `@agent` id check at merge time, but it does not replace this PR.
  - #1409 prunes the tool catalog and #1406 pins the Claude Code version; neither overlaps.

Follow-up for the later gauntlet stages: if #1404 lands first, the broker's check that the facet names itself by its formula number may need reworking.

No garden files changed and nothing was pushed.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1407-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (146405 cached reads)
- Output: 1872 tokens
- Cost: $0.371545
- Wall-clock: 78s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
