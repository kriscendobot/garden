---
role: builder
provider: openai
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Revise four-plus-one illuminations on garden-book PR #9 per Fable's thematic review (single bounded pass)

Repository: `kriscendobot/garden-book`. PR: https://github.com/kriscendobot/garden-book/pull/9 (head branch `book-illumination-assets`, base `main-ab5990e`). Reviewed head: `063d0bb24c4ef45a55b9c159ed56cff3dab8ad94`. Review: https://github.com/kriscendobot/garden-book/pull/9#pullrequestreview-5404453977 (Fable, verdict CHANGES REQUESTED). Supervisor: `book-illumination-supervisor-after-revise-20261004`.

Get an isolated checkout with `ensure-project-worktree.sh book-illumination-revise-20261004 kriscendobot/garden-book book-illumination-assets`, fetch the current branch head (a supplementary code gauntlet may have pushed since 063d0bb; rebase onto it, never force over it), and change ONLY what the findings below name. Regenerate through the existing generator (do not hand-edit generated SVGs if the generator owns them). Keep the established 13-color palette, globally unique prefixed IDs, inline-safe SVG (no script/handlers/external refs), the manifest mapping, and alt text consistent.

## Fable's findings (the complete scope)

- **A1 — `illumination-ch9-three-indexes.svg`:** the three index routes are identical green roads from blank shapes; the source/topic/keyword distinction is not legible. Differentiate the three routes and their origins (e.g. stepping-stones for the keyword path, a row of named plots for the topic path, archival markers/chest for the source path) and restyle the terracotta dash-tags so they read as pruning tags, not road signs.
- **A2 — `illumination-ch10-inference-tiers.svg`:** attach one guild emblem to the foot of each ladder (two currently float unattached at bottom-right), and place an increasingly demanding plant on each terrace so tier is carried by the terraces and worker kind by the ladders.
- **B — `illumination-ch8-feedback-loops.svg` (chapter opener):** it duplicates the section figure `illumination-ch8-cybernetic-loop.svg`. Add at least one more loop at a clearly different scale (e.g. a small bed-level drip loop beside the fleet-scale reservoir loop) to the opener only. Leave `illumination-ch8-cybernetic-loop.svg` untouched.
- **C1 — `illumination-ch7-named-paths.svg` and `illumination-ch9-reading-basket.svg`:** replace the oversized beige floating arrow "signposts" with post-mounted signboards; in `ch9-reading-basket`, stand a reader by the basket so the stop-or-descend choice has an agent.
- **C2 — `illumination-ch9-hanging-library.svg`:** pull the detached fifth book spine on the third terrace back inside the terrace edge.

The other 19 images are approved as-is; do not alter them. Motif discipline (tower exactly twice, hanging gardens exactly twice) must be preserved.

## Verification (report all of it)

- `npm test` and `npm run build` pass (report counts).
- Still exactly 25 SVGs/anchors; IDs unique; all refs resolve; no unsafe content; palette unchanged.
- Render each changed SVG to PNG with headless Chromium (see garden skill `skills/svg-visual-review/SKILL.md`) and inspect it visually against the finding; describe what each now shows. Attach or link the renders if practical.
- Push to `book-illumination-assets` (keep PR #9 draft) and post one PR comment summarizing the per-finding changes and the new head SHA.

This is the ONLY revision pass: there is no second thematic review. Report any finding you could not fully satisfy honestly. Then send the new head SHA and verification summary to `book-illumination-supervisor-after-revise-20261004` via `inbox-send.sh`.
