---
ts: 2026-06-13T00:56:10Z
kind: result
role: designer
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: liaison
dispatch_root: /home/kris/dispatches/designer--41ce63
prs:
  - repo: endojs/endo-but-for-bots
    pr: 439
    role: target
refs:
  - entries/2026/06/13/004900Z-dispatch-designer-41ce63.md
  - entries/2026/06/12/153600Z-result-designer-6d2dcd.md
  - https://github.com/endojs/endo-but-for-bots/pull/439
  - https://github.com/endojs/endo-but-for-bots/pull/439#pullrequestreview-4490090195
  - https://github.com/endojs/endo-but-for-bots/pull/439#issuecomment-4696839575
---

# result: designer — single-surface rewrite + compatibility elision on #439

## Summary

Applied kriskowal CHANGES_REQUESTED review `4490090195` (six inline asks) on PR #439.
Rewrote `designs/formula-inspector.md` as a single-surface design (Value modal back face only; dropped the dedicated Inspector panel, the read/edit toggle, and the `revise(petName, patch)` daemon method).
Elided the `## Compatibility Considerations` and `## Upgrade Considerations` sections.
Tightened two Open Questions (added the peruacru/animation.js cue; recorded the renewed Shift+P ack).
Synced `designs/README.md` (Updated date, three rows refreshed, size estimate dropped from M-L 6-8 days to M 4-5 days).
Pushed seven commits to `design/chat-value-modal-formula-view` (HEAD `052a57218`).
Posted 6 inline replies (one per ask) and one top-level summary at-mentioning kriskowal.
Re-requested review.

## Inline asks addressed (6 of 6)

| Comment ID | Line | Ask (kriskowal) | Commit | Reply ID |
|---|---|---|---|---|
| 3406942548 | 25 | "This can be omitted." (Consolidation Note's two-surface trailer) | `c987bb124` | 3406973826 |
| 3406948310 | 109 | "We only need one surface. Please consolidate these. ... While one formula captures state, we do not need these to be user editable at this stage of development." | `4760540b7` | 3406974226 |
| 3406950479 | 417 | "These can be elided as well since we have not yet committed to compatibility." | `708566959` | 3406974322 |
| 3406951046 | 436 | "Omit." (Open Question on revise patch shape) | `b818a739f` | 3406974383 |
| 3406955796 | 438 | peruacru/animation.js cue for non-simple animation | `23fda2e3e` | 3406974524 |
| 3406956437 | 441 | "Shift+P is worth a try." (ack) | `d0eb636e4` | 3406974579 |

Plus the metadata + README sync commit `052a57218`.

Top-level summary at-mentioning kriskowal: <https://github.com/endojs/endo-but-for-bots/pull/439#issuecomment-4696839575>.

Re-review requested via `POST /repos/endojs/endo-but-for-bots/pulls/439/requested_reviewers`; `kriskowal` is in the response's `requested_reviewers` array.

## Substantive design changes

1. **Single Chat surface (modal back face only).** Dropped the dedicated Inspector panel section, the read/edit toggle, the retention-paths embed, and the corresponding `revise(petName, patch)` daemon method. The modal back face is the sole surface. The modal header gear icon flips Value to Formula (per kriskowal's directive); the back face header carries a "Show value" button (plus the `F` key) that flips back. Each inventory row carries a gear icon that opens the modal already flipped to the back face, preserving the maintainer's "Reaching the formula view directly from the inventory" entry point without a separate panel. Editing is deferred; the back face is read-only at this stage. The Options Considered table records the rejected dedicated-panel option with the maintainer's quote as rationale.

2. **Compatibility and Upgrade sections elided.** Both sections promised migration paths, deprecation notes, and forward-compatibility commitments for a pre-1.0 surface that has not yet committed to compatibility guarantees. If a future release commits to a compatibility window, a later revision can re-introduce them with concrete supported-version language.

3. **Open Questions tightened.** Question 1 (revise patch shape) was moot post-edit-mode drop; removed and remaining questions renumbered. Question 1 (now: card-flip animation register) records the simple-animation expectation and links `kriskowal/peruacru/animation.js` as the design-cue escape hatch. Question 2 (Enter-Profile keyboard parity) records both the 2026-06-12 and 2026-06-13 maintainer acks.

4. **README sync.** Summary table row Updated date 2026-06-12 → 2026-06-13. Project status row description rewritten to name the single-surface, read-only scope. M9 size estimate dropped from M-L / 6-8 days to M / 4-5 days reflecting the reduced scope (no dedicated panel, no edit toggle, no `revise` method, no retention-paths embed).

## Style discipline applied

- No em-dashes introduced in any of the new prose (verified with `grep -E '—'`).
- No Latin shorthand introduced (verified with `grep -E 'i.e.|e.g.|etc.|vs.|cf.|viz.'`).
- Quoted maintainer text uses straight ASCII quotes throughout.

## Verification

- `git status` clean on project worktree post-push.
- Push to `endojs/endo-but-for-bots:design/chat-value-modal-formula-view` succeeded; fast-forward from `eccd7e503` to `052a57218`.
- All 6 inline replies posted with non-empty bodies; all reply payloads return `in_reply_to_id` matching the original maintainer comment IDs.
- Top-level summary posted as `issuecomment-4696839575` with `@kriskowal` at-mention at the head.
- `requested_reviewers` API call returned 200 with `kriskowal` in the response array.
- `grep -n 'revise\|wrench' designs/formula-inspector.md` confirms the only surviving `revise` mentions are in the rejected-option row of the Options Considered table and the cited 2026-02 historical prompt blockquote; `wrench` no longer appears.

## Open items for the orchestrator

None. The PR remains DRAFT (designer does not un-draft; un-drafting after maintainer re-review is the maintainer's call or a downstream solicitor / appellate flow).

Self-improvement: nothing this time.
