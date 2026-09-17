Done. Work committed and pushed to `main2` as `611da016e4`.

## Completion report

**Job:** `dedup-jury-seat-headings` — remove the redundant doubled seat heading from aggregated jury panel reports.

**Precondition confirmed:** the blocking sibling `collapse-jury-and-fixer-report-verbosity` had already landed (commit `3c5b535c19`, the `<details>` disclosure wrapping). I built on that aggregate loop rather than reverting it.

**Root-cause finding (universal, not seat-specific):** The doubled heading has a single shared source. Every seat brief (`roles/jurors/<seat>/AGENT.md`) references the per-juror block shape in `skills/panel-review/SKILL.md`, whose template opened with `### <perspective name>` — an artifact seats copied literally, substituting their own name (sometimes with "Now I have the block shape…" meta-narration first). Since `panel.sh`'s aggregate loop already emits the seat name as the block's `<summary>` heading, that produced the doubled `### assessor` seen in endo#1281 round 6. No juror brief inlines its own copy, and `panel/SKILL.md` carries no duplicate template — so the fix is one shared fragment plus defense in depth.

**Changes:**
1. **Root cause (`skills/panel-review/SKILL.md`):** removed the `### <perspective name>` line from the block-shape template and added an explicit "do not re-title; the aggregator supplies the heading; start at the Verdict" instruction — a corrected example, not just a prohibition.
2. **Seat prompt (`scripts/jobs/gardening/panel.sh`):** the `run_seat` `claude -p` prompt now tells each seat its name is already printed as the block heading and forbids a `### $seat` heading or "now I'll produce the block" preamble.
3. **Defense in depth (`panel.sh`):** new `strip_seat_self_heading` helper, called in the aggregate loop before wrapping each block. It strips a seat-authored leading heading whose name (normalized to alphanumerics, case-insensitive) matches the seat — plus any throwaway preamble before it — but only within the region *before* the first real block marker (Verdict/Findings/Notes), and only for actual heading lines (`#…` atx or bold-only `**…**`). Narrow by construction (a real finding is never a bare heading of the seat's own name) and fail-open (emits the block unchanged if no such heading is found or if stripping would empty it).

**Tests:** new `panel-seat-self-heading-dedup-test.sh` + committed `panel-self-heading-stub.sh` (noexec-mount convention) — 9/9 pass. Existing `panel-details-disclosure-test` (9/9), `panel-per-section-provenance` (8/8), `panel-single-round` (14/14), `panel-parallel-fanout` (16/16), `panel-empty-diff` (14/14) all still green. `bash -n` and shellcheck clean.

**Scope honored:** going-forward-only; no retroactive editing of already-posted comments.

**Follow-ups:** none.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/dedup-jury-seat-headings.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 78 tokens (2936662 cached reads)
- Output: 27040 tokens
- Cost: $3.0259179999999994
- Wall-clock: 426s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
