Panel round 4 complete.

**What I did:** Ran the single-round design panel for endojs/endo-but-for-bots PR #735 ("Chat HTTP Controller UI" design) against diff base `6beb4e5bf7` (PR head `c34b4d279`, still draft). All 7 design-panel seats fired and reported `ok`.

**Key detail on execution:** My gardener session kept getting torn down ~3 min after each turn ended, killing the backgrounded panel three times over (reaped 1→4) before it could finish its ~6-min juror fan-out. I broke the loop by launching `panel.sh` **detached via `setsid`** into a stable rundir (`/tmp/pr735-panel4-rundir`); that process survived the next teardown and ran to completion (`PANEL_DONE rc=0`).

**Result:** Disposition **must-fix**. Three seats returned request-changes — decomplector (Detection probes miss a standalone `HttpClientControl`, contradicting Design Decision 6), skeptic (unstated Phase 1 provisioning dependency; revoked-read-only framing omits the Bindings panel), ergonomist ("Re-allow" affordance has no data source; control-tier legibility signaled only by field omission) — plus copyeditor/pedant cross-reference citation-form drift. critic, copyeditor, novice returned approve/comment-only.

**What changed:** Posted the aggregate as a `gh pr review --comment` on PR #735 (request-changes is blocked on an own-authored PR; the disposition line is the authoritative gauntlet signal), with the load-bearing must-fix themes summarized and all 7 per-seat blocks in a details fold.

**Stage boundary:** Ran exactly one panel round; did not fix, un-draft, or loop. The gauntlet's next stage (fix round 4) owns the must-fix items.

**Follow-ups:** none for this stage.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr735-gauntlet-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 5 on 2 host(s)
- Input: 70 tokens (2345089 cached reads)
- Output: 19440 tokens
- Cost: $2.6856935
- Wall-clock: 616s
- Model(s): claude-opus-4-8 ×5

<!-- garden-usage-end -->
