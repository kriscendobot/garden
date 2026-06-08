---
ts: 2026-06-08T02:12:00Z
kind: result
role: designer
host: endolinbot
project: endo-but-for-bots
prs:
  - https://github.com/endojs/endo-but-for-bots/pull/89
refs:
  - entries/2026/06/08/013700Z-dispatch-researcher-41281f.md
  - entries/2026/06/08/014800Z-result-researcher-41281f.md
  - https://github.com/endojs/endo-but-for-bots/pull/89#pullrequestreview-4342320898
---

# result: designer applied kriskowal CHANGES_REQUESTED on PR #89

Applied kriskowal's CHANGES_REQUESTED review `pullrequestreview-4342320898`
on `endojs/endo-but-for-bots#89` (design-only PR
`docs(designs): propose genie-integration`). All five inline asks
addressed, rebased onto a fresh frozen base, new sibling design
authored, README updated, replies posted on each inline thread plus a
top-level summary comment.

## Deliverable: nine-step procedure outcome

1. **Rebase + frozen base.** Pushed `llm-11a76ae` (snapshot of
   `origin/llm@11a76ae6` which already carries the 2026-06-04 zizmor
   CI fix via #426); rebased `docs/design-genie-integration` onto it
   with one designs/README.md conflict resolved by hand (merging the
   new base's "135 designs" totals paragraph with the genie-integration
   add line). Force-with-lease pushed.
2. **Fetched full body of inline 3369680410** from the GitHub API; the
   researcher's preview was complete (the maintainer's framing on
   pet-store-as-memory) and matched what the rewrite handled.
3. **Prettier on metadata table.** Aligned columns to Prettier-default
   padding (`.prettierignore` excludes `*.md` so `yarn format` does not
   enforce; alignment applied by hand). **Updated** date bumped to
   2026-06-08.
4. **§ 2 Memory rewrite** (inline 2). Lead with
   pet-store-as-typed-namespace per the maintainer's "stand the agent
   fully on the pet store" framing. References
   `designs/chat-spaces-gutter.md` as the worked precedent for encoding
   a typed namespace on top of untyped pet-store primitives. Example
   block shows the daemon plugin spawning the agent with no `Mount`
   involvement; `safePath` / `VFS` retire. Three Open Questions
   surfaced: pet-store-vs-`ScratchMount` shape, bag-of-files vs
   blob-per-snapshot, memory-index subscription shape.
5. **New `designs/scheduler.md` authored** (inlines 3 + 4). 571 lines.
   Daemon-side graduation of `packages/genie/src/interval/` (the Phase
   1 prototype of endoclaw-timer). Named **scheduler** per inline 4.
   Carries forward endoclaw-timer's ten Design Decisions verbatim;
   adds daemon-mail tick delivery (per `daemon-value-message`),
   `serial-jobs`-backed coalescing, per-`Interval` pet-name granting
   (per `daemon-agent-tools`), `HostInterface.makeScheduler` maker.
   Explicit § Conformance with the Capability Bank's Six Design
   Principles section maps the design to the
   `daemon-capability-bank.md` rubric. Five-phase rollout (Phase 5
   retires the genie prototype). Open Questions:
   replace-vs-extend-`timer`, per-`Interval` `setPeriod` ceiling,
   tick-message envelope shape, whether the whole `Scheduler` is
   grantable. § Prompt block carries the maintainer's directive
   verbatim and the inline-comment URLs.

   Genie-integration § 3 rewritten to reference the new sibling
   design rather than propose the daemon-side scheduler inline.
   Endoclaw-timer.md gained *Superseded by [scheduler](scheduler.md)*
   metadata field plus a header note; I judged the supplant correct
   based on the existing endoclaw-timer § Status which already
   anticipates the daemon-side graduation, but flagged it as
   reversible in the top-level summary comment in case the maintainer
   prefers to keep endoclaw-timer authoritative.
6. **§ 3 line 560 subsection removed** (inline 5). "Is this
   `serve-private-path` territory?" subsection gone; § 3 closes on
   "What lal and fae get".
7. **Pushed.** Force-with-lease for the rebase, regular append for the
   new commit (`f9440ed4f docs(designs): apply kriskowal
   CHANGES_REQUESTED on genie-integration`).
8. **Retargeted PR base.** `gh pr edit 89 --base llm-11a76ae`.
9. **Replies posted.** Five inline replies + one top-level summary.
   - Inline 1 → discussion_r3370517256
   - Inline 2 → discussion_r3370517791
   - Inline 3 → reply posted (id not captured in the suppressed output)
   - Inline 4 → reply posted
   - Inline 5 → reply posted
   - Top-level → issuecomment-4644905400

## Other touches (transitive consequences)

- `designs/README.md` totals paragraph: bumped from 135 → 137 designs
  (one for genie-integration on rebase, one for the new scheduler.md),
  Proposed count +1, and a note added about the genie-integration
  rebase plus scheduler add via PR #89.
- `designs/README.md` dependency graph (Agent Capabilities subgraph):
  added `esched[scheduler]` node and `etimer -.->|supersedes| esched`
  edge; replaced `etimer --> eproactive` with `esched --> eproactive`
  to reflect the supersedence.
- `designs/README.md` M3 milestone summary: renamed
  `endoclaw-timer` slot to `scheduler` (with the parenthetical
  "supersedes endoclaw-timer").
- `designs/README.md` Strategic Early Items table: scheduler added,
  endoclaw-timer reframed as "Superseded; daemon-side graduation
  tracked under the successor design".
- Genie-integration § 5 Rollout Sketch: Phase 3 retargeted at the new
  scheduler.md; Phase 4 reframed as pet-store-as-typed-namespace
  (with `ScratchMount` fallback noted under § 2 Open Questions);
  Phase 5 reframed as granting per-`Interval` handles.
- Genie-integration § 6: memory and scheduler trade-offs deferred to
  the sibling sections (§ 2 Open Questions and scheduler.md § Open
  Questions); § 6 retains the load-bearing pi-vendoring decision and
  the four cross-cutting calls that don't belong to either sibling.

## Authorizations consumed

- Pushed new frozen base `llm-11a76ae` and the rebased+appended head
  to `kriscendobot/endo-but-for-bots` (origin == `endojs/endo-but-for-bots`).
- Retargeted PR base to `llm-11a76ae`.
- Replied on each of the five inline threads + posted one top-level
  summary comment (`endo-but-for-bots` standing broad-comment
  authorization).
- **Did not** re-request review per dispatch instruction.

## What the orchestrator owes the maintainer next

The PR is still in `state: OPEN`, `reviewDecision: CHANGES_REQUESTED`,
`isDraft: false`. The maintainer either reviews the new head or marks
the changes accepted. Per the dispatch this is *not* the un-draft
chain (no panel / judge / fixer / un-draft follows a design-only
CHANGES_REQUESTED follow-up); the maintainer's next review is the
next signal.

If the maintainer chooses to keep endoclaw-timer authoritative rather
than supersede with scheduler, the smallest follow-up is to revert
the *Superseded by* line on endoclaw-timer.md and the supersedence
graph edge on README.md; the new scheduler.md can stay as a sibling
without claiming supplantation.

## Open questions deferred to the maintainer

The three new ones the design surfaces are listed under each design's
§ Open Questions (genie-integration § 2 + § 6 + scheduler.md § Open
Questions). None block the next builder dispatch on either design;
the implementation phase picks one resolution.

Self-improvement: nothing this time. The dispatch fit cleanly within
the designer role's existing skills (library-lookup with the
researcher's inlined references, frozen-base-branch, conflict-
resolution, pr-review-thread-replies). The library-lookup writeback
from the researcher pass already covered the corpus growth signal
(scheduler concept page, endoclaw-timer source page) that fell out of
this engagement.
