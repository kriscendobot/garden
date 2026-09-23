---
kind: review-miss-dismissed
primary_job: kriscendobot-agoric-sdk-pr16-review-d584f885
verdict: not-a-miss
category: new-direction
surface: pr-review-inline
author: mhofman
comment_url: https://github.com/kriscendobot/agoric-sdk/pull/16#pullrequestreview-4691288801
identity: kriscendobot/agoric-sdk#16:review:4691288801:retro
producing_role: gardener
producing_job: kriscendobot-agoric-sdk-pr16-review-d584f885
missed_by: none-request-for-wire-format-rename-after-dismissal-held
severity: minor
---

# Dismissal: PR #16 review — grantee-field rename request at eip712-messages.ts:100

mhofman's COMMENTED review 4691288801 on #16 (empty review body; verbatim
untrusted text at `comment_url`) carries a single inline request at
`packages/portfolio-api/src/evm-wallet/eip712-messages.ts:100`, paraphrased:
he asks that the EIP-712 message field be refactored to use a grantee-oriented
name (rather than `accountHolder`) to make it clearer from the name that it
relates to a delegation grant. The PR was closed unmerged before any action;
no code was changed or pushed.

## Grounds (not a miss)

This is new direction, not a review-process miss, for three converging reasons.

First, **the naming concern on this exact field was already evaluated and dismissed twice** in the same PR by two prior records: `kriscendobot-agoric-sdk-pr16-review-65885306` (mhofman's originating review) and `kriscendobot-agoric-sdk-pr16-review-77ecb195` (the @dckc ping on the same thread). Both dismissed the renaming request as taste on a pre-existing EIP-712 wire convention: the field `accountHolder` is a *pre-existing* name shared with the shipped standalone `Grant` op, and renaming only this op would diverge while renaming both is an out-of-scope type-hash change. mhofman's latest request at `d584f885` re-raises that same concern — it does not present new evidence, a different file, or a changed context. Re-litigating it as a panel gap would triple-count one already-dismissed thread.

Second, **the garden's response to the earlier naming ask was appropriate**. The fixer expanded the `accountHolder` doc to state it is the delegation grantee (not the portfolio owner), explained the rationale for keeping the wire name (parity with shipped Grant op), and offered a follow-up rename PR. This addressed the substance of dckc's and mhofman's naming concern without making an out-of-scope wire-format change. The garden did not ignore the feedback; it balanced clarity against EIP-712 compatibility and documented the trade-off.

Third, **no panel seat or gauntlet stage should mandate a wire-name rename here**. A juror seat that governs code naming (ergonomist, stylist) would need to override a deliberate engineering decision about EIP-712 type-hash stability — a cross-cutting concern no single seat is equipped to evaluate. The standing dismissal grounds hold: building a "always prefer grantee-named wire fields" probe would be an un-mechanizable taste gate, exactly the anti-pattern warned against in the 65885306 and 77ecb195 dismissals.

The calibration across all PR-16 records is consistent:
- The one genuine review miss on #16 (the `pr-description-reviewer-attention` cluster) involved garden-authored maintainer-facing prose bloat — a prevention-without-sensing gap that was correctly identified and recorded in two miss records (`a45a180a`, `416988d1`).
- The remaining reviews (65885306, 77ecb195, 12e4a9aa, 9b74ccd4) are all dismissals where the panel caught the substantive questions and the garden responded correctly.
- This review (`d584f885`) continues that dismissal pattern: a re-raised wire-name preference on an already-resolved thread, not evidence of a panel gap.

Recording a dismissal (not a miss) so this re-raised naming preference is never
recursively counted; it mints no cluster and needs no review-cycle check.
