Panel round 6 on endojs/endo-but-for-bots PR #1393 (gauntlet `ebfb-sturdyref-layer4-marshal-20260930-gauntlet`, iteration 6) returned **must-fix**.

**What I did**
- Checked out the PR head `build/sturdyref-marshal-representation` @ `4445fbf937` (endojs-owned branch) in an isolated worktree: `scratch/project-wt-ebfb-st-6b824a180e2b-99165b05`.
- Ran `GARDEN_PANEL_SINGLE_ROUND=1 scripts/jobs/gardening/panel.sh <wt> 1393 fa2edee302…`, using the PR's pinned base commit rather than the branch name. I launched it detached so a worker reap would not kill it. It exited 0 with disposition **must-fix**, and all 31 seats completed.
- Verdicts:
  - **Request changes (3):** archivist, purist, pruner.
  - **Comment-only (7):** saboteur, breaker, engine-realist, integrator, scribe, corner-prober, fast-checker.
  - **Approve (21):** every other seat.
- Posted the aggregate as a review on #1393 against head `4445fbf937`. GitHub refused `--request-changes` because the bot cannot request changes on its own PR, so it went up as a COMMENTED review, as rounds 3–5 did. The full aggregate is 86 KB, which is over GitHub's review-body limit. The posted body is about 33 KB: a header saying must-fix, the seat lists, the full request-changes and comment-only blocks, and approving seats named only.

**Blocking findings for the fix stage**
- **archivist:** the comment at `packages/marshal/src/encodeToCapData.js:~366` says `@endo/sturdyref` is a devDependency only. But `packages/marshal/package.json` adds it to `dependencies`. One of the two needs to change so they agree.
- **purist:**
  - In `pass-style/src/types.d.ts:96`, `SturdyRef` is a bare member of `Passable`. Because of that, `Key` and `Pattern` remove it only at the top level, and `CopyArray<SturdyRef>` still type-checks as a `Key`. The fix is to add an `SR` type parameter, the same way errors (`E`) are handled.
  - The canonical-index check in `marshal.js` covers only the `'` slot prefix. The `$` and `&` decoders still use a plain `Number(...)`, so `"$0x0"` decodes as slot 0. Either apply the check to all three or add a comment saying why `'` is stricter.
- **pruner:** delete the filler "Scaling Considerations" and "Documentation Considerations" sections from the PR body.

**Follow-ups:** none from this stage; the driver picks up the fix loop. The panel rundir is `scratch/tmpexec/garden-panel-project-wt-ebfb-st-6b824a180e2b-99165b05-1393/`.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-sturdyref-layer4-marshal-20260930-gauntlet-panel-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (903650 cached reads)
- Output: 4837 tokens
- Cost: $0.76359
- Wall-clock: 549s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
