---
posted_at: 2026-10-30T02:54:53Z
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Restructure the design PR https://github.com/kriscendobot/minion.town/pull/230 (`designs/clip-governor-column.md`, branch `design/clip-governor-column`) from one large step into an **ordered ladder of small increments**, per the maintainer (kriskowal, 2026-10-30, relayed by the liaison): "restart from simple and evaluate each complication in order." Read the PR's comments first, including the maintainer-answer comments. This supersedes the destroy-promotes and single-child decisions of the earlier revision.

New maintainer decisions to fold in:
- A governor may have **more than one child column, but only one is visible**; the governor switches among them. **Any clip can serve as a governor.** **The gutter is itself the base governor.**
- The gutter can swallow a stack of governors, showing only the children of the selected governor, with a way to return to the parent governor, **ejecting that governor's clip to the base of the colonnade and pushing everything after it down**.
- Transitions between a governor's child clips animate as a vertical swipe, like a deck of stacked clips.
- **When a governor is destroyed it releases all its children** (replaces "destroy promotes the child"). Assumption to state and list as an open question: released children return to the destroyed governor's own governor (the gutter at top level), in order.
- Clone copies content **and** powers by default, and a second mode clones the content with designated alternate powers (each at most the owner's own authority, never more).

Restructure into this ladder, each rung independently buildable, deployable, and evaluable, with its own endpoints, tests, and exit criterion. Rung 1 must be as small as the current design's smallest useful slice:
1. Governor column beside one selected clip: read-only powers view, chrome-drawn, no chain. (Include the title-spoofing mitigation.)
2. Clone: copies content and powers.
3. Clone with designated alternate powers.
4. Destroy a clip (plain unpublish; no children yet).
5. One child column: New Clip opens a child and governs it; destroy releases it.
6. Several children, one visible, the governor switches among them.
7. Gutter as base governor; drill into a governor, return to parent, eject to the base.
8. Swipe-deck animation between children.
9. Endowment: the governor endows a child's powers (the interposition question, below).

Keep full detail only for rungs 1 to 3; give each later rung a short paragraph with what it adds, the invariant it must hold, and the attach point left by the previous rung. Revise the ownership map, the chrome-unforgeability argument and the REST-vs-CapTP choices to follow the skills/api-transport-rubric/SKILL.md rubric (now on main2; if your garden checkout lacks it, read it at https://github.com/kriscendobot/garden/blob/main2/skills/api-transport-rubric/SKILL.md), including a rubric table. Re-run the mermaid parse check on every diagram you touch.

Open question (f) was not understood by the maintainer; reword it plainly or drop it into rung 9: "If a governor passes its child a power through a wrapper that the governor controls (so it can watch or block calls), and the governor is then destroyed, does the child's power stop working, or does the wrapper vanish and leave the child holding the real power?" Rung 9 only; it is not needed before it.

Keep the PR a draft and keep the `<!-- garden-design-open-questions -->` marker if an open question remains. Update the PR body and leave a summary comment. Do not post any build job.
