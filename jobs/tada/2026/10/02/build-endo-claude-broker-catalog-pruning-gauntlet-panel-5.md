Panel round 5 on endojs/endo-but-for-bots#1409 came back **must-fix**.

**What I did**
- Checked out the PR head (`bot/build/claude-broker-catalog-pruning` @ `f417d53307`) in an isolated worktree for this job.
- Ran `panel.sh` in single-round mode against base `llm-d4124e6`. It exited 0 with disposition `must-fix`. All 33 seats ran and none errored: 2 request changes (curator, pruner), 2 comment only (corner-prober, fast-checker), 29 approve.
- The record was written to the journal at `panel-runs/endojs-endo-but-for-bots-1409/3a378d0aff7b.md`.
- Posted the verdict as a review on the PR (`PRR_kwDORRE4FM8AAAABQSwIwA`, 2026-10-02T04:41:39Z). It went up as a COMMENT review carrying the `garden-panel-verdict: must-fix` marker, because GitHub won't accept REQUEST_CHANGES from the PR's own author. Approving seats' text is shortened to a stub, the same as in round 4.
- The REST API refused calls with a rate-limit error after the review went up. A GraphQL query confirmed exactly one round-5 review exists, so there's no duplicate.

**Must-fix items for the next fix round**
- **curator:** `packages/agent-mcp-stdio/README.md:98-99` describes `renderGuestAllowedTools()` / `makeMcpConfig()` right under the new confined allow-list section, but these still default to the full tool catalog. Add a note that they're for the single-tenant setup and the confined broker doesn't use them.
- **pruner:** the PR description is 702 words.
  - Drop the "None." Scaling and Upgrade sections.
  - Cut the "Coordination with #1404" section to one sentence.
  - Summarize the withheld tool names instead of listing all of them.

**Comment-only notes (optional)**
- **corner-prober:** unit-test `selectConfinedTools` with an empty `tools` list and an empty `allowedToolNames`. Add a test showing it passes duplicate names through unchanged.
- **fast-checker:** add property tests for `selectConfinedTools` (keeps order, exact match, gives the same result when run twice). Optionally add a broker-level property that the served `tools/list` equals that selection.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endo-claude-broker-catalog-pruning-gauntlet-panel-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (1035351 cached reads)
- Output: 5550 tokens
- Cost: $0.8521822
- Wall-clock: 999s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
