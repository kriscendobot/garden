Panel round 3 complete.

## Completion report

**Stage:** Gauntlet PANEL round 3 — endojs/endo-but-for-bots PR #997 (`design(daemon): reassess worker retention, revocation, and the batch-flush retention root`), a docs-only PR (`designs/worker-retention-and-revocation.md` new + `designs/README.md` sync).

**What I did:**
- Resolved the PR head (`kriscendobot:design/worker-retention-and-revocation`) and created an isolated project worktree.
- Ran `panel.sh` in `GARDEN_PANEL_SINGLE_ROUND=1` mode against base `origin/llm`. It fanned 28 code-panel seats, aggregated, and printed disposition **must-fix** (exit 0).
- Vetted the aggregate before posting. Six seats returned request-changes (archivist, breaker, corner-prober, saboteur, scribe, spec-keeper); I confirmed **all six re-based against `upstream/llm` and reviewed the real 2-file diff**, so their findings are legitimate. Seats that got the stale-base garbage diff all returned approve — noise did not drive the verdict. The must-fix disposition is sound.
- Composed a faithful aggregate review capturing the six real must-fix/summary-fix findings (README milestone contradiction M3-vs-M4; "partition-shaped" claim contradicting live `captp.js` behavior — a silent hang; two unstated race interleavings; the "bounded against adversarial peers" claim falsified by a post-resolution cross-peer non-drop; a nonexistent `questions` Map citation that should be `settlers`; and the missing completion-summary comment), plus the non-blocking glyph-sweep note.
- Posted it to PR #997. Because the bot authors the PR, GitHub refuses a request-changes review on it (as in rounds 1–2); posted as a **COMMENTED** review instead, carrying the must-fix content.

**Dispatch caveats surfaced in the review (structural, not PR defects):** (a) panel-kind sensing routed a docs-only PR to the 28-seat *code* panel — should be the design panel; (b) the fork's `origin/llm` is ~499 commits stale, so base normalization (commit `3e7ffb1e13`, which only handles a bare local branch) should also reconcile a stale *fork* remote-tracking ref against the upstream tip / `gh pr view` `baseRefName`. These are worth a follow-up to the panel tooling but are outside this single-round stage.

**Verdict:** must-fix. Stopped here per stage scope — no fix, no un-draft, no loop.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr997-gauntlet-panel-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 23 tokens (883446 cached reads)
- Output: 11177 tokens
- Cost: $1.7623849999999996
- Wall-clock: 843s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
