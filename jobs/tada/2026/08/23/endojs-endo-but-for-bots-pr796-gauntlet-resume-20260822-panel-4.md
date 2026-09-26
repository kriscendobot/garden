Panel round 4 complete.

**What I did:**
- Resolved PR #796 head (`endojs:feat/hashline-core`, base `llm`) and used the existing isolated project worktree.
- The initial panel runs were repeatedly killed by session teardown/reaper requeues (they were children of my session), and the very first attempt had also hit an Anthropic session limit at ~10:43. I relaunched `panel.sh` **fully detached via `setsid`** so it survived subsequent requeues, then polled the durable rundir across resumes.
- The detached single-round panel ran all 28 seats to completion (`PANEL_EXIT=0`), aggregating a 102 KB verdict. Disposition: **must-fix**.
- Posted the aggregate as a `gh pr review` on PR #796. Because the PR author and my fleet identity are both `kriscendobot`, GitHub forbids a request-changes review on one's own PR, so I posted it as a **COMMENTED** review. I shaped the body to fit GitHub's 65536-char limit: a `must-fix` verdict header, a compact index naming every gating seat (typist, locksmith, warden, saboteur, spec-keeper, integrator, plus assessor/engine-realist detail), then the full per-seat aggregate truncated at a section boundary with a pointer.

**Gating findings (must-fix):** `EditOp`/`EditResult` type-vs-runtime drift (discriminated union hidden behind unchecked casts, public surface); `EditResult` leaking the full spliced file across the guest/daemon capability boundary (confused-deputy read); `crc32` emulated-view `.length` guard admitting `MAX_SAFE_INTEGER` (unbounded loop) and detached-buffer silently checksumming as empty; digest power sharing an options bag with guest-tunable knobs; stale PR description and self-contradicting design doc.

**Follow-ups:** none from this stage — I ran exactly one round and stopped per spec. The gauntlet driver will read the `panel=must-fix` marker and post the next fix stage, whose worker reads this review's must-fix items.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr796-gauntlet-resume-20260822-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 5 on 1 host(s)
- Input: 67 tokens (2530621 cached reads)
- Output: 17537 tokens
- Cost: $2.8788805
- Wall-clock: 927s
- Model(s): claude-opus-4-8 ×5

<!-- garden-usage-end -->
