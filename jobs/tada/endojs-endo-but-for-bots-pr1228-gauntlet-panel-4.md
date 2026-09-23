Panel round 4 complete. Verdict posted.

## Completion report

**Job:** PANEL stage, round 4, of the `endojs-endo-but-for-bots-pr1228-gauntlet` — a single panel round against PR #1228 (`design(claude): finish the bare CLI caplet contract`, docs-only: `designs/endo-claude.md` + `designs/README.md`).

**What I did:**
1. Resolved the PR head (endojs/endo-but-for-bots, branch `design/endo-claude-bare-caplet`, base `llm`) and got an isolated project worktree at the round-3 head `12e24bb5a`.
2. Ran `panel.sh` in `GARDEN_PANEL_SINGLE_ROUND=1` mode against base SHA `51b99651b`. Nine seats fanned; disposition returned as **must-fix**.
3. Assembled the aggregate (round-1.md) with a disposition header and posted it to the PR.

**Verdict — must-fix.** Four seats returned request-changes:
- **critic** — acceptance condition names the DD6 isolation residual but not the tool-result-steering residual the doc calls out twice.
- **skeptic** — "Resolved 2026-09-08" overstates what #1206 landed vs. the still-unbuilt `prune`/`attenuateArgs`/`sessionTag` extensions; `prune` predicate untested against the facet's own catalog.
- **pedant** — ~20 new em-dash violations plus a defined-term ("positive-and-negative" vs "negative-and-positive") word-order inconsistency.
- **novice** — § Status forward-references DD6/one-guest-MCP vocabulary before it's built; DD6 is a ~40-line unbroken paragraph.

Comment-only seats (decomplector, ergonomist, copyeditor, orthographer) added naming/grammar/spelling refinements.

**Note:** `--request-changes` is blocked by GitHub on the bot's own PR, so — matching prior rounds — the review was posted as a COMMENTED review; the must-fix signal is carried in the disposition header line the next-stage heuristic reads. No fix/un-draft performed (single-round stage, as instructed).

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1228-gauntlet-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (707650 cached reads)
- Output: 4814 tokens
- Cost: $0.9542889999999999
- Wall-clock: 383s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
