The panel verdict is posted. The job is complete: one panel round ran (exit 0, disposition **must-fix**), and the aggregate was posted as a review on PR #1304.

## Completion report

**Job:** PANEL round 1 for endojs/endo-but-for-bots PR #1304 (`feat(daemon): read-only directory attenuation (1/3 of #1125)`), single stage of the `endojs-endo-but-for-bots-pr1304-gauntlet`.

**What I did:**
- Resolved the PR head (`endojs:bot/build/1125-readonly-directory-attenuation`) and got an isolated project worktree at the head commit `672ed33`.
- Ran `panel.sh` in `GARDEN_PANEL_SINGLE_ROUND=1` mode against base `387ea66` (the PR's `baseRefOid`, the direct parent of the head — so the panel reviewed exactly the PR diff, not a stale divergence).
- Survived two reaper requeues mid-run; the second detached run completed cleanly: **panel.sh exit 0, disposition `must-fix`**, with a durable panel-run record emitted.
- Posted the aggregate as a `gh pr review` on #1304. Because the PR author and our reviewer identity are the same (`kriscendobot`), GitHub forbids a request-changes review on your own PR, so it posted as a **COMMENTED** review whose header states the `must-fix` verdict explicitly (the own-PR convention).
- The full 31-seat aggregate (86 KB) exceeds GitHub's 65,536-char review-body limit, so the posted body (62.9 KB) carries: the must-fix header + verdict rollup (24 request-changes · 7 comment-only… as tallied), the 7 approve seats collapsed to one line, and full blocks for 21 actionable seats truncated at a clean block boundary. The blocking finding is first and intact; 3 low-priority seats that didn't fit (fast-checker/releaser comment-only, orthographer summary-fix "behavioural"→"behavioral") are named and retained in the run record.

**Blocking finding (must-fix):** assessor — `EndoDirectory.readOnly()` in `directory.js` formulates an eval formula via `formulateEval` but neither names it (no `storeIdentifier` task) nor pins it (`pinTransient`/`unpinTransient(id)`), unlike every other `formulateEval` caller (`host.js`, `guest.js`); the fresh formula sits at ref-count 0 and can be collected before the untrusted caller references it. Plus several should-fix items (the `readOnly?()` optional-vs-guarded-mandatory type/interface mismatch flagged by assessor/typist/packager, `maybeLookup` missing `Promise<>` in `types.d.ts`, changeset audience/accuracy notes).

**Verdict:** must-fix. Stopping here per the single-round contract — no fix, no un-draft, no loop.

**Follow-ups:** none from me; the gauntlet driver owns the next (fix-loop) stage.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1304-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 4 on 2 host(s)
- Input: 188 tokens (6493772 cached reads)
- Output: 54116 tokens
- Cost: $6.468496000000002
- Wall-clock: 3222s
- Model(s): claude-opus-4-8 ×3

<!-- garden-usage-end -->
