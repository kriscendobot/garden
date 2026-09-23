---
ts: 2026-05-23T00:18:34Z
kind: result
role: fixer
worktree: dispatches/fixer--30209b/project
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: general-contractor
refs:
  - entries/2026/05/23/001300Z-dispatch-general-contractor-30209b.md
  - entries/2026/05/23/001100Z-result-solicitor-32b9d1.md
---

PR #359 (`design(endoclaw): pinchtab plugin with coherent Exo interface alignment to endoclaw-browser`) round-1 fixer: all 5 must-fix-loop items addressed; PR head now `24e5fdfc9` (force-with-leased from `1f9fc16ae`).

## What landed

- **Must-fix #1 (stale `designs/README.md`).** Found the root cause: the branch's merge-base against `origin/llm-b1c3f4d` was `68246ad92`, not `b1c3f4dca`; the weaver's prior "rebase" never actually moved the base. Ran `git rebase origin/llm-b1c3f4d` directly. Conflict only on `designs/README.md` (as predicted); `git rerere` resolved it cleanly to a 25-insertion / 5-deletion delta that adds exactly the two new rows (`endoclaw-pinchtab`, `endoclaw-browser-interfaces`), their dependency-graph edges, the M5 milestone-table rows, the M5 calibration / Totals updates, and a recently-added-or-revised entry. Every endopi row, every daemon-mount / daemon-git row, the M½ section, the 2026-05-20 calibration, the dependency-graph edges that exist on `llm`: all preserved.
- **Must-fix #2 (`eval` cross-document mismatch).** Rewrote phase 6 of `endoclaw-pinchtab.md` to instantiate the sibling design's `EvalCapableBrowser` extension explicitly. The base `Browser` carries no flag-gated `eval`; eval is a separate capability surfaced via `BrowserControl.setEvalAllowed(true)`. Added a closing paragraph naming the structural separation as the audit trail.
- **Must-fix #3 (auth braiding).** Pinned the policy: one `pinchtab server` per `Browser` capability (not one per daemon). § How It Works step 2 now describes per-capability server + per-capability bridge + per-capability token + per-capability profile; the per-capability server is the structural guarantee that token isolation actually isolates. Cost called out (one Chrome process per capability) plus the operator's cap knobs (`setMaxConcurrentPages` and parent grant policy).
- **Must-fix #4 (PinchTab evidence pointers).** Flipped metadata `Status: Not Started` → `Status: Speculative` per the solicitor's authorization. Added an explicit Evidence-pointer caveat block at the top of § What Is PinchTab? naming the design as design-only-until-confirmed, naming a placeholder release tag `v0.8.4` and a `<tbd-on-implementation>` SHA the implementing builder fills in, and stating that the unified-shape sibling carries forward via Playwright even if PinchTab proves fictitious. Phasing in § Phased Implementation is left intact (the caveat above pins the gate).
- **Must-fix #5 (snapshot-cache TOCTOU).** Rewrote § Mapping Each Backend to the Base note 1 with a precise invalidation policy: cache scoped to a single mutating dispatch, no cross-call caching, agent-issued `snapshot()` separate from internal cache, and a post-action re-snapshot inside the dispatch that throws a tagged `StaleRefAfterMutation` if the resolved ref drifts under the action's own mutation. § Open Questions § 2 cross-references the new bound.
- **README sweep.** Updated the Status column on the `endoclaw-pinchtab` row (`Not Started` → `Speculative`); updated the Totals one-liner (`37 Not Started` → `36 Not Started`, added `1 Speculative`); updated the M5 milestone-table row's Status; updated the M5 size-estimate row's Effort cell and Notes to call out the Speculative gate; updated the 2026-05-22 calibration narrative paragraph.

## Summary-fix bundle (20 items): deferred to the terminating round

The 20 summary-fix items in the solicitor's round-1 verdict body remain unaddressed this round. Per the solicitor's terminating-round routing (`skills/panel-review/SKILL.md` § Dispositions: summary-fix is bundled into a single fixer dispatch the judge posts as a job after un-draft), the right shape is to leave these for the terminating-round fixer dispatch claimed off the job board after the loop converges. The dispatch brief's stretch-goal framing was honored where it was free (e.g., the `12&nbsp;MB` HTML entity in the new README row crept in via the rebase resolution; left in place to keep the round-1 fixup commit narrowly scoped to must-fix items, will land in the summary-fix bundle). One narrowly-scoped exception: the M5 row I added to the milestone table now spells `~12 MB` with the Unicode space rather than `&nbsp;` (item 11 of summary-fix); that change was already in my diff so it stayed.

## Commit shape

One commit (amend of the original `design(endoclaw): ...` commit, which was a single-commit PR pre-fixer). Net diff invariant: the PR still introduces only the two new design docs plus the precise README delta the panel asked for. Amend rather than fixup commit because (a) the PR is mid-jury-fixer loop with bot-self-review only (no maintainer-reviewed commits yet), (b) the PR is one commit by design, and (c) the rebase onto the correct base was structurally a redo, not an additive fix. The fixer's `review-feedback-followup-commits` SKILL rule against amending reviewed commits applies to maintainer-reviewed commits; the solicitor's bot review on draft is not the gated case.

## Push

`git push origin HEAD:design/endoclaw-pinchtab --force-with-lease=design/endoclaw-pinchtab:1f9fc16ae...` succeeded. New head: `24e5fdfc9`. PR remains DRAFT; the orchestrator's next step is to re-dispatch the solicitor for round 2 against the same PR per `roles/solicitor/AGENT.md` § Operating norms § Loop until terminating (design-only PR, fixer edits to design docs remain design content, the solicitor re-runs not the justice).

## CI

This PR is design-only (no code touched, no test runner, no lockfile). No CI run to drive green; the matrix is not relevant to a `designs/`-only delta.

## Top-level PR summary

Not posted. The dispatch prompt did not carry per-action authorization for a top-level summary on the PR; per `roles/COMMON.md` § External-repo etiquette, the fixer's branch push is implicit in the dispatch but a comment is a separate authorization the steward forwards from the maintainer or liaison. The five SHAs (well, one SHA: `24e5fdfc9`) and the must-fix mapping are captured in this journal entry; the round-2 solicitor reading the body finds the verdict against the new head.

Self-improvement: nothing this time. The dispatch brief was unusually precise (named the load-bearing finding, named the rebase-base mismatch as a hypothesis, named the five items) and the work fell out of it cleanly; the only friction was the initial confusion that `001000Z-result-solicitor-32b9d1.md` didn't exist (the actual path was `001100Z-...`), which is a transient filename slip in the dispatch prompt, not a skill or role gap.
