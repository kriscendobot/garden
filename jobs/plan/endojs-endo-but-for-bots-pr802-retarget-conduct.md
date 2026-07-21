---
gate: orchestrated
orchestrated_by: endojs-endo-but-for-bots-npm-stack-landing
priority: normal
posted_by: gardener
posted_at: 2026-07-21T03:14:10Z
---

# Retarget to `llm`, then finalize (curate → merge) endojs/endo-but-for-bots PR #802

Runs AFTER PR #800 has merged into `llm` (serial orchestration child; do not
start early — verify #800 is MERGED first, and if it is not, report failure
rather than merging #802 into its stale base).

PR #802 (`reland/endor-npm-exports-resolution`) is APPROVED by a trusted
maintainer and green (23/23 checks on head `9a87cf1056`), and already
carries the merged PR #803 (Phase 5 offline + .npmrc). Its base
`reland/endor-run-exec-hardening` is a stale stack branch whose content
reaches `llm` via PR #800; merging into that base would strand the work.

Steps:
  1. Verify https://github.com/endojs/endo-but-for-bots/pull/800 is MERGED
     into `llm`.
  2. Retarget PR #802's base to `llm`
     (`gh api -X PATCH repos/endojs/endo-but-for-bots/pulls/802 -f base=llm`).
  3. Conductor curation: re-verify OPEN, mergeable, checks green on the
     current head after the retarget (the base change alone does not
     invalidate the head's green checks, but a conflict with `llm` would
     surface as not-mergeable — if red or conflicted, dispatch the
     shepherd/fixer instead of forcing).
  4. Merge. Do NOT name a merge method — the conductor owns that choice
     (roles/conductor/AGENT.md).

Guards:
  - Bot repo only (endojs/endo-but-for-bots). NEVER merge agoric-sdk or the
    endojs/endo upstream.
  - Idempotent: if already merged/closed, do nothing.
  - No open PR uses `reland/endor-npm-exports-resolution` as a base
    (PR #805 closed; PR #812 bases on `feat/endor-run-top-level-await`), so
    head-branch deletion after merge is safe.

Source: press tick endo-npm-cas-registry-press-20260721-030507
Approval: https://github.com/endojs/endo-but-for-bots/pull/802#pullrequestreview-4740280808
Prior conduct: jobs/tada/endojs-endo-but-for-bots-pr802-conduct.md (stalled awaiting green; green since 9a87cf1056)
