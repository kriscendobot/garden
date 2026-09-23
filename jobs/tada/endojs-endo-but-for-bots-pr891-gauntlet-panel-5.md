The round-5 panel verdict is posted. Job complete.

Panel round 5 for endojs/endo-but-for-bots PR #891 (`design(zone): back-port portable @endo/zone`) ran to completion.

**What I did:**
- Resolved the PR head (`kriscendobot/endo-but-for-bots`, branch `design/endo-zone`) and got an isolated project worktree at head `f549960d1`.
- Ran `panel.sh` in single-round mode (`GARDEN_PANEL_SINGLE_ROUND=1`) against the worktree, base ref `origin/llm`. The 29 design-panel jury seats fanned out and all completed (29/29 ok).
- Panel disposition: **must-fix** (`panel #891: code-panel single-round — must-fix`).
- Posted the full 29-seat aggregate as a `gh pr review --comment` on PR #891 with a round-5 must-fix disposition header. (Posted as COMMENTED, not request-changes, because the PR is bot-authored and GitHub forbids requesting changes on your own PR — matching how rounds 1–4 were posted.)

**Key must-fix themes surfaced by the panel** (design-doc PR, `designs/endo-zone.md` + `designs/README.md`): the `makeOnce` step order makes duplicate/collision detection unreachable on the revival path; `makeAdapterZone` has no way to construct a `detached()` store on durable adapters; the `makeAdapterZone` return shape (sync `Zone` vs async `Promise<Zone>`) is specified two incompatible ways; portable label grammar/length bound is unspecified while the daemon host imposes a hard pet-name grammar; and several should-fix type/rollback/at-most-once gaps.

**Note on base:** the panel worktree's `origin/llm` was stale relative to `upstream/llm` (`e84a4c83c`); multiple seats scoped their review to the true merge-base (the 5 `design(zone)` commits), and I reflected the true base in the posted header.

**Follow-ups:** none from this stage — per the staged-gauntlet contract this stage runs exactly one round and stops; the next fix-loop stage owns the must-fix items.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr891-gauntlet-panel-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 302 tokens (10532005 cached reads)
- Output: 34344 tokens
- Cost: $7.011376499999999
- Wall-clock: 625s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
