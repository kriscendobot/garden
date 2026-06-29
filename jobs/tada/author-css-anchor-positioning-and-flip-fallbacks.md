Done. Completion report follows.

---

## Completion report: `author-css-anchor-positioning-and-flip-fallbacks`

**What I did.** Authored the deferred third web-designer CSS skill and wired it in. Pushed to `main2` as commit `58a7421b9` via a rebase-CAS loop (clean first attempt).

**What changed.**
- **New:** `skills/css-anchor-positioning-and-flip-fallbacks/SKILL.md` — full skill matching the structure of the existing `css-intrinsic-and-content-sizing` / `supports-feature-query-progressive-enhancement` skills (frontmatter, purpose, grounding paragraph, when-to-use, technique sections, procedure, verification, limitations, output, field notes). Covers:
  - the anchor relationship (`anchor-name` / `position-anchor`, the `absolute`/`fixed` requirement, default anchor);
  - placement via `anchor()` (per-side, with `translate` centering) and `position-area` (the 3×3 region grid, span keywords, the physical/logical no-mix rule, cell-as-inset-modified-containing-block);
  - sizing via `anchor-size()` and its composition with `calc-size()` clamping;
  - `position-try-fallbacks` with the `flip-block`/`flip-inline`/`flip-start` tactics, space-combining, `position-area` and `@position-try` entries;
  - the **normative flip semantics** from the CSSWG draft — tactics are geometric axis-mirrors that swap logical pairs (a `margin-block-end` becoming `margin-block-start` on `flip-block`), with the deliberate spec gap that the affected set is implementation-derived, so the portable subset is insets/margins/`position-area`/self-alignment and everything else must be verified per-engine;
  - `position-try-order` (stable sort, Firefox/Safari gap) and the `position-try` shorthand;
  - the goldilocks picker margin-that-survives-a-flip as the applied exemplar;
  - the mid-2026 per-feature support matrix and the gate it implies (Chrome full; `flip-*` universal; Safari no anchored container queries; `calc-size()` Chrome-only; Firefox no `max-block-size: stretch`).
- **Wired in:** added the skill to `roles/web-designer/AGENT.md` § Additional skills and to the `CLAUDE.md` skills inventory (now "four `css-*`/`supports-*` skills").
- **Cross-refs resolved:** replaced the "a source ingest is pending" note in `css-intrinsic-and-content-sizing/SKILL.md` with a live link, and turned the bare "anchor positioning" mention in `supports-feature-query-progressive-enhancement/SKILL.md` § When to use into a link to the new skill.

**Grounding.** Read all 11 named library sections read-only via `git show origin/journal2:…` (7 MDN, 2 CSSWG, 2 goldilocks). Did not re-ingest sources. Inbox was empty at the checkpoint.

**Follow-ups.** None required. The companion `web-builder` role does not maintain its own Additional-skills list (it defers to `web-designer`), so no edit was needed there. If/when the CSSWG ships the changed default `::picker(select)` `position-try-fallbacks`, the skill's field note already flags that the explicit `flip-*` override may become unnecessary — a future re-confirm-at-authoring-time touch, not a defect.
