Panel round 3 on endojs/endo-but-for-bots#1379 returned **must-fix**. `panel.sh` exited 0.

**What I did**
- Checked out the PR head `3747b81cdd` from `endojs/endo-but-for-bots` branch `llm-ironhorse-panic-host-call` in an isolated project worktree.
- Ran `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh` against the real merge-base `1706e63247fb` (frozen base `llm-1706e63`). All 33 seats reported with no seat or decider errors.
- Posted the result as review 5360956972 (https://github.com/endojs/endo-but-for-bots/pull/1379). GitHub won't let the bot request changes on its own PR, so it went up as a comment review whose header says to treat it as request-changes. This matches rounds 1 and 2.
- The panel's full aggregate is about 82 KB, which is over GitHub's 65,536-character limit for a review body. The posted review (about 60 K characters) keeps a must-fix summary, the full text of every seat that didn't approve, and only the names of the seats that approved.

**Findings to fix**
- **breaker (must-fix):** in `stage_host_call`, the check against a callback wrongly classed as `Pure` is a `debug_assert!`, which release builds remove. Handle opens and closes can then be silently dropped from the handle log (`host.rs:655-666`).
- **breaker (should-fix):**
  - Document that callers must fetch `host_replay()` again after `clear_barrier`.
  - Consider adding a `UNIQUE(crank_id, call_ordinal)` constraint as a backstop.
- **saboteur:**
  - `CasStore::read_blob` joins an unchecked `hash` into a file path (`cas.rs:158`), so a bad value can read outside the store.
  - The precondition on `recovery_gate` excluding the active crank should be documented.
- **engine-realist:**
  - Host calls staged per crank have no limit in `TranscriptLimits`, unlike outbound events.
  - The NTFS durability comment in `sync_directory` overstates the guarantee.
- **stylist:** four naming fixes:
  - Rename `CasStore`, since "store" is redundant.
  - Spell out `cb` in `host.rs`.
  - Spell out `cb` in `tests/host.rs`, where it appears 18 times.
  - Spell out the SQL aliases `req`/`rep`.
- **scribe:** no top-level summary comment was posted after either earlier fix pass.
- **assessor (comment only):** the barrier's pre-commit write is tagged `Operation::Commit`, which will mislabel that failure in fault reports.

**Follow-ups:** none from this stage. The gauntlet driver takes it from here, and I made no fixes and didn't take the PR out of draft.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-ironhorse-panic-host-call-open-pr-gauntlet-panel-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (781746 cached reads)
- Output: 4883 tokens
- Cost: $0.7484172
- Wall-clock: 658s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
