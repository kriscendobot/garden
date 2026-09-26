The review is posted. Panel round 1 complete with disposition **must-fix**.

## Report

Ran exactly one panel round for the gauntlet's PANEL stage against endojs/endo-but-for-bots PR #891 ("design(zone): back-port portable @endo/zone", a design-only diff on `designs/endo-zone.md`).

- **Isolated checkout:** `ensure-project-worktree.sh` for the PR head `kriscendobot/endo-but-for-bots@design/endo-zone` (HEAD `8ad854cb9`).
- **Panel:** `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh <wt> 891 b377b0ed05…` (real merge-base SHA of the upstream `llm` base, per the origin-only-normalization gotcha). Design panel fanned 7 seats — critic, skeptic, decomplector, ergonomist, copyeditor, pedant, novice. Disposition: **must-fix**.
- **Verdict posted:** Aggregate (`round-1.md`) posted as a `gh pr review` on #891. Note: request-changes is disallowed on your own PR (bot authored it), so it was posted as a **COMMENTED** review with the header explicitly stating "round 1 verdict: **must-fix**" so the next-stage fixer heuristic reads the block correctly.

**Key must-fix themes** (four request-changes seats agree): Phase 2 asserts a breaking change to `@agoric/zone`, a package in `agoric-sdk` outside this repo's governance, as a controlled deliverable with no cross-org coordination dependency / fallback / open question; the Design Regrets table characterizes `@agoric/zone` internals with no file/commit citation; the `detached()` "must not persist" invariant is prose-only, not type-enforced; the sibling host-adapter constructor and `isStorable`/host-predicate relationship are unnamed. Copyeditor/novice/pedant added should-fix nits (word choice, title/Zone-capitalization consistency, unglossed jargon).

**Follow-up:** next gauntlet stage is the fix loop (owns the must-fix items). I stopped here — no fix, no un-draft, per single-round contract.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr891-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (796333 cached reads)
- Output: 5214 tokens
- Cost: $1.0249045
- Wall-clock: 440s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
