Panel round 4 on endojs/endo-but-for-bots#266 is done. The verdict is **must-fix**, and it's posted on the PR.

**What I did**
- **Checkout:** I got an isolated checkout of the PR head (`endojs/endo-but-for-bots` @ `design/endopen`, head `964cc634`) at `scratch/project-wt-endojs--8e4af253e4bf-32a18696`.
- **Panel run:** I ran `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh` against the PR's actual base SHA, `1956e545`, rather than the bare branch name `llm`. It exited 0 with the last line "design-panel single-round — must-fix". All 8 seats returned a status of `ok`, and the results are in `garden-panel-project-wt-endojs--8e4af253e4bf-32a18696-266/round-1.md`.
  - **Seat verdicts:** critic, skeptic, decomplector and ergonomist asked for changes. copyeditor and thesaurus approved. novice and orthographer were comment-only.
  - **Main must-fix findings:**
    - **`endopen-acp-server.md`, `cwd` access:** two different accounts of how a session's `cwd` becomes filesystem access. The prose narrows one persistent parent mount; the wire diagram and lifecycle table create a new guest for each session.
    - **`endopen-acp-server.md`, stdio vs. "multiplexing":** the "multiplexing across clients" claim contradicts the stdio transport, which gives each client its own process.
    - **`endopen-acp-server.md`, session recovery:** the path for recovering a session after an adapter restart is contradictory — an in-memory token map, a Phase 4 on-disk store, and a pet-name lookup are all implied.
    - **`endopen-concurrent-subagents.md`:** the Open Questions section says fan-out is capped with `maxConcurrent`, but the `deliberate()` code sketch still launches every member at once with no limit.
    - **Naming clash:** a new guest `cancel()` means "stop the running request", while the daemon's existing `cancel()` permanently discards the stored entry. They share a name but do opposite things.
- **Posted verdict:** the aggregate went up as review 5328271212 on head `964cc634`, headed "Design panel — round 4 verdict: **must-fix**": https://github.com/endojs/endo-but-for-bots/pull/266#pullrequestreview-5328271212
  - I first tried a request-changes review, but GitHub refused because the bot owns the PR. So it's a COMMENT review with a must-fix header, the same way rounds 1–3 were posted.

**What changed:** nothing in the garden repo or the PR branch; the only change is the new review. As instructed, I didn't fix anything, un-draft, or loop.

**Follow-ups**
- **Next stage:** the gauntlet's fixer stage should take this round-4 verdict.
- **Open maintainer review:** kriskowal's 2026-09-02 CHANGES_REQUESTED review still stands: it says to stop coupling to Lal and interface at the Agent layer instead. The fixer should handle it alongside the panel findings.

<!-- gauntlet-stage-result: panel=must-fix -->

## Manual gauntlet handoff

The completion guard found https://github.com/endojs/endo-but-for-bots/pull/266 ready without gauntlet coverage. A deduplicated maintainer action was recorded; the PR was not re-drafted and no gauntlet was staged.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr266-gauntlet-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 5 on 2 host(s)
- Input: 24 tokens (703891 cached reads)
- Output: 4369 tokens
- Cost: $0.6893022
- Wall-clock: 290s
- Model(s): claude-opus-4-8 ×4, claude-opus-5-5 ×1

<!-- garden-usage-end -->
