The PR is now un-drafted (`isDraft: false`) at head `c7307a12a9b0a117332370f7d6c5d8b0d2e2cb13`, MERGEABLE and OPEN.

## Completion report

**Job:** Verify the #389 restack preserved approved content, then un-draft.

**Content comparison — no substantive difference.** I diffed the current head `c7307a12a` against the maintainer-approved head `ea06d79b155377ecabf537f4993b938047b67b0d` (kriskowal, approved 2026-08-16T05:15Z).

- Both ranges are structurally 1:1 — the same two phase-3 commits (`admin daemon` + `separate admin sock with ACL guarantee`), just replayed onto the refreshed #388 head (`af550587f3`) instead of the old one (`590cad28ed`).
- A `git range-diff` of `590cad28ed..ea06d79b1` vs `af550587f3..c7307a12a` shows only **mechanical restack adaptation to the refreshed #388**, which:
  1. renamed UDS→"sock" terminology and moved socket-path helpers into `sock-paths.js` (adds `resolveAdminSocketPath` there);
  2. changed the default-port README text `3469`→`8920`;
  3. consolidated type definitions/imports out of per-module JSDoc/`.js` files into `types.ts`/`types.js`. The `resourceLedger` and `getAdmin` type docs that lived in `index.js` JSDoc on the approved head are relocated **verbatim** into `types.ts` on the new head; the admin-sock-separation doc text is byte-identical, only its home file moved.
- Decisively, the core feature file `packages/gateway/src/admin.js` and its test `packages/gateway/test/admin.test.js` are **identical** between the two heads except for two `@import` JSDoc lines redirected to the renamed `types.js` module (`vhost.js`/`config.js`→`types.js`). Zero logic, behavior, or test changes.

**Conclusion:** the restack preserved the approved content in full; the approval's substance still holds at the new head.

**Un-draft:** `gh pr ready 389` succeeded. Verified: `isDraft: false`, `headRefOid: c7307a12a9b0a117332370f7d6c5d8b0d2e2cb13`, `mergeable: MERGEABLE`, `reviewDecision: APPROVED`, `state: OPEN`.

**Not merged**, per instructions — the conductor bar requires a fresh maintainer approval at the current head `c7307a12a`, which is the maintainer's to give. The prior APPROVED review is against the old sha `ea06d79b1`, so a re-approval at `c7307a12a` is the remaining gate before merge.

**Follow-ups:** none from me. Optional: surface to the maintainer that #389 is un-drafted and awaiting fresh approval at `c7307a12a` (content confirmed equivalent to the previously-approved `ea06d79b1`).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr389-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 4 on 2 host(s) (3 unmetered)
- Input: 25 tokens (571250 cached reads)
- Output: 9017 tokens
- Cost: $0.9417419999999997 (3 engagement(s) unpriced)
- Wall-clock: 278s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
