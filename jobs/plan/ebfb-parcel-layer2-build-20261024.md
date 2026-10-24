---
gate: blocked
blocked_on: https://github.com/endojs/endo-but-for-bots/pull/774
priority: normal
posted_by: builder
posted_at: 2026-10-24T03:19:28Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---

---
role: builder
arc: endo-ocapn-background
dispatch: automatic
tier: mentor
fallback-tier: minion
---
# Build: Parcel layer 2 (SES `%InitialParcel%` / `%SharedParcel%`), endojs/endo-but-for-bots#1391

Repo: https://github.com/endojs/endo-but-for-bots. Design: `designs/parcel.md` on `llm`
(accepted in https://github.com/endojs/endo-but-for-bots/pull/1460), § The Layer Map After the Rename, row 2.
Authorized by kriskowal's APPROVED review on layer 1
(https://github.com/endojs/endo-but-for-bots/pull/774#pullrequestreview-5609838628:
"conduct and post a plan to build for the foreman to pick up on the parcel budget").
Budget: the `endo-ocapn-background` arc (the Parcel/SturdyRef budget). Parked deferred so the
foreman promotes it from that arc's headroom.

## Precondition

Layer 1, PR #774, is being merged by the conductor job `endojs-endo-but-for-bots-pr774-conduct`.
Before any edit, confirm #774 is MERGED. If it is not yet merged, stop without changes and
re-park this job (`post-plan.sh --blocked --blocked-on https://github.com/endojs/endo-but-for-bots/pull/774`).

## Task

Advance the next layer of the Parcel stack onto the merged layer 1:

1. Adopt the existing draft #1391 (`build/sturdyref-ses-accommodation`), currently based on a
   frozen snapshot of #774's head. Do NOT open a duplicate PR. Pin the merge base: snapshot the
   current `llm` tip as a new frozen `llm-<short-sha>`, rebase #1391 onto it (dropping commits that
   #774 already landed), resolve conflicts, force-push, and retarget #1391's base
   (skills/frozen-base-branch, skills/verify-upstream-state-before-pinning).
2. Reconcile #1391 with the layer-2 row of `designs/parcel.md`: replace the single SES
   accommodation with `%InitialParcel%` and `%SharedParcel%`, derived like `%SharedURL%`;
   withhold `locate` from child compartments; harden both constructors at lockdown. Fix any gap.
3. Verify locally (SES and parcel tests, lint, types) and update the PR description.
4. Completion stages the standard gauntlet (clean, panel, fix-loop, un-draft) for #1391.

Scope: layer 2 only. Layers 3 to 9 (#1392 to #1399) stay as drafts stacked on #1391; restack
only the immediate child's base if the force-push requires it, and leave further layers to later
plans. Do not add new channels or reopen questions settled in `designs/parcel.md`.

## Re-park note (2026-10-24)

Successor of `ebfb-parcel-layer2-build-20261022`, which found #774 still unmerged at claim time.
The conductor `endojs-endo-but-for-bots-pr774-conduct-endolin` (tada 2026-10-22) un-drafted #774,
rebased it onto `llm` (head ef1ae4f9d76), and stopped on red CI. The failures came from the runner image
moving to `ubuntu-latest` = 26.04: Playwright chromium is unsupported, `tred`/graphviz is missing, and
sandbox-drivers fails. #774 needs that fixed and a re-conduct before this layer can proceed.
This plan is blocked on #774 and promotes when it merges. Re-check the precondition then.
