CI is GREEN (rc 0). The fix stage is complete.

## Completion report

**Job:** endojs/endo-but-for-bots PR #717 gauntlet FIX round 6 (design-only PR: `designs/promise-debug-view.md`, "promise debug view").

**Panel round-6 must-fix items applied** (3 request-changes seats: critic, skeptic, decomplector):

- **critic #1** — Added a "Phase-1 scope caveat" to the *What is the Problem Being Solved?* section so the `forever-pending`/`undeliveredRejection` headline matches the actually-delivered signal at first read (in canonical liveSlots deployment the live-producer case surfaces via `long-pending`, not `forever-pending`, pending Open Question 6).
- **critic #2** — In *First-listener arrival plumbing*, added the retained-entry-evicted-before-delivery case: `fin.delivered` is still set (finalization stays sound), but no `ring` entry is produced, and the loss is non-silent because the earlier eviction already incremented `evicted.retained`.
- **skeptic #1** — Made the dead-`ref` guard on the `long-pending` walk **unconditional** (both the `liveSet` bullet and the inspection-time step), since GC-vs-finalizer-callback ordering is unspecified even when `FinalizationRegistry` is present.
- **skeptic #2** — Added the promise-forwarding-chain test explicitly to Phase 2 (intermediate carrier `b`, re-listen forwarded from `a`'s consumer: one record, no double-recording, `delivered` only on the forwarded listen).
- **skeptic #3** (comment-only) — Marked opportunistic native-promise tracking as design intent deferred pending Open Question 3, not scheduled baseline.
- **decomplector #2** — Added an explicit Phase-4 claim downgrade (composite verifiable only under a lab `gc()` harness pending Open Question 6).
- **decomplector #1** (should-fix) — Added Design Decision 10 documenting the deliberate two-location `delivered` tracking, with drift contained by a single write site (rather than a risky doc-wide restructure that merges `fin` and the entry, which would defeat the `retained` memory bound).

**Style:** kept the doc's typist-friendly convention intact — removed all em-dashes, an ellipsis, and an arrow I had initially introduced, and matched the `see "Section"` reference style (0 non-ASCII except pre-existing usage; mermaid diagram untouched).

**Pushed** as follow-up commit `197340357` to `endojs/design/promise-debug-view` (advanced from `c4f3fc500`). **CI watched to terminal: GREEN** (5/5 checks, 0 failed, rc 0).

**Follow-ups:** none required from this stage. The driver re-posts panel-7. Note: the two `should-fix` decomplector items were addressed by documented decision rather than structural refactor, and several remaining ergonomist/copyeditor/pedant/novice findings were comment-only/approve and out of the must-fix set.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr717-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 96 tokens (4332597 cached reads)
- Output: 23917 tokens
- Cost: $3.789905499999999
- Wall-clock: 842s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
