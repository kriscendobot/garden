## Completion report

**Job:** Review directive on endojs/endo-but-for-bots PR #1057 (kriskowal, CHANGES_REQUESTED review `5013312686`; the URL's `3848101130` was the first inline comment id, not the review id).

**Preflight:** `pr-feedback-preflight.sh` → PROCEED (exit 0), no peer resolution. Verified independently by fetching the PR branch state.

**The review carried two inline asks, both on `designs/README.md` — resolved both:**

1. *"Move the historical groom notes ('Layered on') to an `ARCHIVE.md` and adjust the standing instructions accordingly."* — Moved the running `*Layered on …*` / `*Last updated …*` groom notes (former README lines 3–56) into a new **`designs/ARCHIVE.md`** under a **Historical groom notes** section. Replaced the pile in the README header with a short standing note that points readers to `ARCHIVE.md` and instructs future grooming passes to append their note there rather than layer new notes at the top of the index — the "standing instructions" adjustment (there is no external grooming-instruction doc in the repo or garden; the convention lived only in the README header).

2. *"This should be the only block of current totals. Move stale totals blocks to `ARCHIVE.md`."* — README now keeps only the single **Current totals (2026-08-24)** block. The superseded blocks (running `**Totals:**`, `**Current totals (2026-08-16)**`, `**Current totals (2026-07-22)**`) moved to `ARCHIVE.md` under **Superseded totals** (newest-first). All relative `.md` links stay valid (ARCHIVE.md is a sibling in `designs/`).

**Artifacts:**
- Commit `e1b6c9aca` on PR head branch `designs-readme-refresh-20260824` (kriscendobot fork), pushed. Changed files: `designs/ARCHIVE.md` (new), `designs/README.md`.
- Thread replies: reply `3848140410` (comment 3848101130) and reply `3848140527` (comment 3848105085), each naming the resolving commit.
- Re-requested review from kriskowal.

**Follow-ups:** None required. Minor cosmetic residue: the kept current-totals block's phrase "including the running **Totals:** line" now refers to a line that lives in ARCHIVE.md — still accurate (it supersedes it), left untouched to avoid editing content the maintainer didn't ask to change.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1057-review-f6afbf40.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 60 tokens (2482121 cached reads)
- Output: 20639 tokens
- Cost: $2.7985285
- Wall-clock: 339s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
