Follow-up posted. This job resolves to a verified no-op — both blockers were already fixed by peer commits, and I've confirmed and reported that.

---

## Completion report

**Directive:** kumavis's review comment on endojs/endo-but-for-bots#1059 (against `dbd7d21`) raised two P1 blockers. My job was to route it to the right work.

**Disposition: verified no-op — both blockers were already resolved by peer commits on the PR head (`0f6ffb0`), corroborated per-ask before completing.**

**P1-1 — Restore Intl-bound callables before retained bound functions.** Resolved by commit **`c2c433138`**. The patch moves `restore_intl` + `restore_intl_bound_functions` to *before* `restore_function_state` in `rust/engine/ironhorse-snapshot/src/machine.rs`, so an `IBFN`-carried target (e.g. `Intl.Collator().compare.bind(null)`) is present when the bound `FUNC` row validates — I confirmed the reordering directly in the diff. Regression locks added in `intl_carry.rs` (+72) cover container, eager-store, and lazy-store resume paths, red pre-fix with exactly the reported `Corrupt("side-table restore: malformed retained function state")`.

**P1-2 — Validate generator PCs against instruction boundaries and the owning body.** Resolved by commit **`0f6ffb0ba`** (the current head). `image.rs` now derives the instruction starts of `cur_func`'s own `[body_start, body_start + body_len)` range via `instruction_len` (memoized) and requires both the resume cursor and every saved handler target to be members — rejecting the segment end, an operand byte, and a valid start in a sibling body. Also bounds the handler `id_map` by the handler's own `locals_len`. Crafted locks added in `generator_carry.rs` (+134) and the store mirror `crafted_row_refusals.rs` (+42) cover exactly the requested cases.

**Verification:** both commits are on the current head `0f6ffb0ba`; commit messages, diffs, and added tests each match the corresponding ask. CI on the head: 16 passed, 8 in-progress, 3 queued, **0 failures** at report time.

**Action taken:** posted the follow-up kriscendobot promised on the thread — issue-comment [#5473484823](https://github.com/endojs/endo-but-for-bots/pull/1059#issuecomment-5473484823) — confirming both P1 blockers resolved with the fixing commit SHAs and how each satisfies the ask.

**Follow-ups:** none for these two findings. A separate job (`endojs-endo-but-for-bots-pr1059-c4d75838`) owns kumavis's later "please review the PR" request; that is out of this job's scope. The round-2 findings ledger (`designs/ironhorse-snapshot-store-seam.md`, commit `e2abd9a63`) notes six total open findings from the two review passes — the remaining (non-P1) items are tracked there, not part of this directive.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1059-beaff99f.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 16 tokens (335810 cached reads)
- Output: 8823 tokens
- Cost: $0.847088
- Wall-clock: 137s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
