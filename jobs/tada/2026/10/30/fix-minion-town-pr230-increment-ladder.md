I restructured the design PR https://github.com/kriscendobot/minion.town/pull/230 into an ordered ladder of nine small increments, as the maintainer asked. The rewrite of `designs/clip-governor-column.md` is pushed to `design/clip-governor-column` as commit 115a48fc. Both mermaid diagrams pass the parse check, and the PR is still a draft.

**The ladder.**
- **Rungs 1 to 3, in full detail.** Each has its endpoints, unit and Chromium tests, an exit criterion and an attach point for the next rung.
  1. A read-only governor column, drawn by the chrome, with no chain and no actions, plus the title-spoofing marker (`“Name” · suffix`). It adds one endpoint, `GET /account/clips/:hash/powers`. This is smaller than the earlier first slice.
  2. Clone copies the content and powers by reference and can never gain authority.
  3. Clone with designated alternate powers: for each power, keep it, leave it out, or replace it with one from the owner's own inventory, looked up only in the owner's namespace.
- **Rungs 4 to 9, one short paragraph each** (what it adds, the invariant it must hold, the attach point):
  4. Destroy, as a plain unpublish.
  5. One child column, opened through a `children` power that the chrome creates and the clip uses over CapTP. Destroy releases the child: the child is re-linked first, then the governor is unpublished, then its link is removed.
  6. Several children, one visible, switched by the governor or the owner.
  7. The gutter as the base governor, with drill in, return, and eject.
  8. The swipe-deck animation.
  9. Endowment.

**Other changes in the design.**
- All of the maintainer's new decisions are folded in.
  - "Destroy promotes the child" is replaced by "destroy releases all children".
  - The one-child limit is lifted: a governor may have several children, with one visible.
- There is a new transport table scored against the `api-transport-rubric` skill.
- The ownership map has a new row for the boundary between a clip governor and the facet over CapTP.
- The argument that a clip cannot fake the chrome now also covers the child switcher, the drill-in path display (breadcrumb) and the clone plan.
- Clones skip the `children` power, so a clone can never govern its source's children.
- The reconciliation with #228 and the parked `claude-api-p4-agent-factory` job is kept and now points to rung numbers.

**PR and open questions.** I updated the PR title and body, kept the `<!-- garden-design-open-questions -->` marker, and left a summary comment (#issuecomment-6513861352). Four questions remain open:
- **(f)** Reworded in plain language and moved to rung 9 only: if a governor passes its child a power through a wrapper it controls and is then destroyed, does the child's power stop working?
- **(g)** Do released children return, in order, to the destroyed governor's own governor (the gutter at top level)? This is the assumption the job asked me to state.
- **(h)** Rung 3 sends the clone plan over REST as pet names, which the rubric's override 2 says should go over CapTP. I kept REST because the names resolve only in the owner's own namespace, so they grant nothing the owner doesn't already hold; the maintainer should confirm that or wait for CapTP in the shell.
- **(i)** I read "eject to the base of the colonnade" as: the ejected clip becomes the leftmost column after the gutter, and every other column moves one place further out. This needs confirming.

No build job was posted.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-minion-town-pr230-increment-ladder.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 24 tokens (801592 cached reads)
- Output: 24484 tokens
- Cost: $1.3079664
- Wall-clock: 256s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
