Panel round 6 on endojs/endo-but-for-bots#1408 came back **must-fix**, and the verdict is posted on the PR.

**What I did**
- Checked out the PR head (`bot/build/claude-sandbox-bwrap-slice` @ `d266f8a841`) in an isolated project worktree.
- Ran `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh` against base SHA `d4124e6e40` (`llm-d4124e6`). It exited 0 with disposition `must-fix`. Record: `panel-runs/endojs-endo-but-for-bots-1408/302766c9ba39.md`.
- Seat results across 33 seats:
  - **Request changes (4):** saboteur, wire-watcher, integrator, pruner.
  - **Comment only (6).**
  - **Approve (19).**
  - **No verdict line (4):** packager, migrator, releaser, breaker. Breaker's output contained no actual review.
- Posted the verdict as a COMMENT review, because GitHub refuses REQUEST_CHANGES from the PR author. It carries the `<!-- garden-panel-verdict: must-fix -->` and round-6 markers, a summary of what must be fixed, and the per-seat detail for the request-changes and comment-only seats. The full 33-seat report was too long for one review, so the approving seats are only in the durable record.

**What must be fixed (for the next fix stage)**
1. **wire-watcher:** the bwrap slice is opt-in. Without `--bwrap` or `sandbox`, a turn silently runs without the sandbox, but `designs/endo-claude.md` (lines 175 and 1350) says the slice is "required". Either require an explicit opt-out or change the design doc to match what the code does.
2. **integrator:** two rows in the dependency table of `designs/endo-claude.md` (`endo-posix-sandbox` and `@endo/claude-sandbox`) contradict the new Implementation note. Update both.
3. **saboteur (should-fix):** the exported `assembleBwrapArgv`/`makeBwrapSpawn` never check that the read-only and writable path sets don't overlap. A writable path that equals or contains a read-only one silently makes it writable. Add a check that throws.
4. **pruner:**
   - Remove the explanation of why `@endo/claude` shares a CI job from the comment in `ci.yml`.
   - Remove the paragraph in the `README` explaining why the slice doesn't reuse the `@endo/sandbox` driver.
   - Shorten the `SYSTEM_ETC_ENTRIES` comment.

I didn't fix anything or un-draft the PR; this job covers one panel round only.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endo-claude-sandbox-bwrap-slice-gauntlet-panel-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (861476 cached reads)
- Output: 5573 tokens
- Cost: $0.8060992
- Wall-clock: 742s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
