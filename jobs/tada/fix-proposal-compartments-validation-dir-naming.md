Pushed cleanly to `main`.

## Completion report

Consolidated the two engine-validation reports in `kriscendobot/proposal-compartments` onto a single directory name.

**What I did:**
- Got an isolated project worktree off `main @ 1f3f237`.
- Checked both report files (`validation/jsc.md`, `validations/endor.md`) and `README.md` for any relative links referencing the `validation`/`validations` paths — **none exist**. The `./dep.mjs` occurrences in both files are inline code examples in tables, not directory links, so no link fixes were needed.
- `git mv validation/jsc.md validations/jsc.md`; the now-empty `validation/` directory was removed automatically by the rename (git doesn't track empty dirs).

**What changed:**
- One commit (`2dfeb02`, `chore: consolidate engine-validation reports under validations/`): a pure 100% rename, no content changes to the report. Pushed directly to `main` via a rebase-CAS loop (`1f3f237..2dfeb02`), consistent with this repo's direct-commit convention.

**Result:** `validations/` now holds both `endor.md` and `jsc.md`; `validation/` is gone.

**Follow-ups:** none.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-proposal-compartments-validation-dir-naming.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 14 tokens (252788 cached reads)
- Output: 1791 tokens
- Cost: $0.49171600000000004
- Wall-clock: 38s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
