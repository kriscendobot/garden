CI is green, the fix is pushed and is the current head, and the summary comment is posted. The job is complete.

**Completion report**

I resumed this FIX round-2 gauntlet stage for endojs/endo-but-for-bots PR #996 (the design-only `worker-constraint-model` PR, head branch `design-worker-constraint-model` on the `kriscendobot` fork). The round-2 panel returned 52 must-fix findings across 13 seats. I applied them in one revision, pushed, and drove CI to green.

**What changed** (commit `cad85efe8`, 3 files):
- `designs/worker-constraint-model.md` — substantial revision:
  - **Migration rule** rewritten to derive the persisted form from the caller's *explicit input* (the predicate `manager.js:5250` already uses), not value-equality on a resolved default — removing the round-1 rule-1/rule-2 contradiction and the host-dependent-persisted-bytes defect. Invariants restated as non-contradicting.
  - Dropped the false **"content-addressed"** premise; restated safety on persisted record shape (random formula numbers), citing the in-tree `manager.js:4562` comment.
  - Corrected the **backend inventory**: four `makeWorker` powers, two acting on `kind`, three `defaultWorkerKind:'locked'` bring-ups, named the `:2172`/`:5665` read sites and `interfaces.js`.
  - **Types**: `(string & {})`, `ResolvedWorkerVersion = { exact }`, `durability` (not `class`), `architecture` (not `arch`), `substrate` (not `journal`).
  - Renamed the OS/arch axis `platform`→**`target`** to resolve the `daemon-endor-architecture.md` `WorkerPlatform` collision, with a reconciliation section and #989 direction.
  - Added a **Passability and rejection** section (hardened copy-record, allowlist/null-proto rejection, fail-closed before formulation, `WorkerConstraintsShape`, read-only meter facet).
  - Named `encodeWorkerConstraints`/`decodeWorkerConstraints` (fixed inbound/outbound inversion), added `Resolved*` axis types and property tests; moved durable×version/target coupling to Open Question 5. Replaced typist-hostile glyphs; mermaid re-validated.
- `designs/README.md` / `designs/ARCHIVE.md` — index fixes: corrected `ARCHIVE.md` link target, added the **M11 constituent-table row**, re-dated the groom note newest-first, added the `Updated` header row + summary-table cell, added the totals delta line, dropped the thrice-repeated `worker-rust-xs.md` flag from the index.

**CI**: all five check-runs (`build`, `test`, `lint`, `browser-tests`, `zizmor`) `completed success`; `mergeable_state: clean`. (The combined-status "pending" is a false signal — this repo has no legacy commit statuses.)

**Also**: posted a per-seat completion summary comment (`#issuecomment-5537741493`), addressing the scribe seat's round-1 silent-push finding.

**Follow-ups (deferred, noted in-doc):** `worker-rust-xs.md`'s stale status to be filed as its own issue; absolute design-count totals reconciliation left to the maintainer's grooming pass (the counts had already drifted before this change). Panel `[proposed-rule]` findings were surfaced in the summary comment for later encoding.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr996-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 4 on 1 host(s)
- Input: 140 tokens (9443621 cached reads)
- Output: 58788 tokens
- Cost: $10.790911000000001
- Wall-clock: 1000s
- Model(s): claude-opus-4-8 ×4

<!-- garden-usage-end -->
