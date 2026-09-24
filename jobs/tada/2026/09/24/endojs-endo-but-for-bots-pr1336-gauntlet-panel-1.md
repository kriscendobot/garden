**PR #1336 panel, round 1: must-fix**

- **Checkout:** isolated project worktree of `endojs/endo-but-for-bots` branch `build/endo-guest-stdio-mcp` at head `64ca00f9fb`, in `scratch/project-wt-endojs--6401e66a2811-3dd4a324`.
- **Base:** I used the PR's `baseRefOid`, `6726b0fb` (branch `llm-6726b0f`), rather than a possibly stale `origin/<baseRef>`. `git diff --name-only <base>...HEAD` lists 29 files, the same count GitHub reports for the PR.
- **Run:** `GARDEN_PANEL_SINGLE_ROUND=1 scripts/jobs/gardening/panel.sh <wt> 1336 6726b0fb…`, run detached and polled in the foreground. `record-meta` shows `exit_code=0`, `panel_kind=code`, `disposition=must-fix`, and no appellate pass. All 33 seats finished with status ok, and the decider had no error.
- **Seat verdicts:**
  - **Request-changes (13):** wire-watcher, typist, spec-keeper, saboteur, purist, pruner, prover, orthographer, integrator, engine-realist, corner-prober, breaker.
  - **Comment-only or approve:** the rest.
  - **Two of the findings:**
    - `mcp.js` `handleMessage` sends an error reply to a malformed notification, which JSON-RPC 2.0 forbids.
    - Exported multi-field typedefs in `adapters/mcp.js` and `server.js` should move into a `types.ts` / `.d.ts` module.
- **Verdict posted:** GitHub refuses a request-changes review on the bot's own PR, so the aggregate went up as COMMENTED reviews. At 94KB it was over the 65,536-character review body limit, so it is split into two parts:
  - Part 1 carries the `disposition: must-fix` header: https://github.com/endojs/endo-but-for-bots/pull/1336#pullrequestreview-5310656032
  - Part 2: https://github.com/endojs/endo-but-for-bots/pull/1336#pullrequestreview-5310656373
- **Unchanged:** no garden commits; I did not fix or un-draft the PR.
- **Follow-up:** kriskowal also has an open CHANGES_REQUESTED review from 20:38Z today, and the fix stage should address it together with the panel findings.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1336-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (793806 cached reads)
- Output: 5415 tokens
- Cost: $0.6819092000000001
- Wall-clock: 405s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
