# Finalize garden#4 per kriskowal's answers to the open questions (review round 2)

Maintainer COMMENTED review round 2 (kriskowal, 2026-06-25T17:36Z) on **kriskowal/garden #4**
(design/plan-in-journal, head `5f6da168`) —
https://github.com/kriskowal/garden/pull/4#pullrequestreview-4573434772
answers the four open questions the designer raised in its revision. Wear the **designer**
role. Repo `kriskowal/garden`, PR **#4**, revise `designs/plan-in-journal.md` on the head
branch (bot identity). Posted by the liaison (the comment-watcher dropped this — empty-body
COMMENTED review, plain-language inline feedback).

## Decisions to fold in (resolve the open questions)

1. **:290 granularity** — "Per-design files are the source of truth. These get aggregated."
   → Per-design files (`journal/plan/designs/<project-slug>/<design-slug>.md`) are the SoT;
   the plan/roadmap is an **aggregation** of them. Make per-design-file the authoritative
   unit; the aggregate roadmap is generated.
2. **:293 reconciliation gating + schedule** — "The reconciliation is not gated by the
   maintainer. Let's continuously update the plan. Let's add weekly recalibration and
   grooming to the schedule, Sunday evenings." → Reconciliation is **NOT maintainer-gated**;
   it runs **continuously**. Additionally specify a **weekly recalibration + grooming**
   scheduled task on **Sunday evenings** (via the `schedule` skill / `set-schedule.sh`).
   Remove the "is the Complete flip gated?" open question (it is not).
3. **:295 redirect lifetime** — "Keep indefinitely." → The endo `designs/README.md`
   generated redirect is **kept indefinitely** (not retired in Phase 4). Remove that open
   question.
4. **:297 field name** — "Repository is a good name still since some projects span
   repositories." → Use **`repository`** as the field/concept name; note that a project may
   **span multiple repositories**. Remove the project-vs-repository open question.
5. **:284** — "Acknowledged. This artifact can be confirmed and removed." → Confirm and
   remove the artifact that comment is attached to (read the line context).

## Task

Revise the design to fold in all five, removing the now-answered open questions. Push to the
PR branch. Reply on each inline thread (citing the revising SHA), post a **top-level summary
comment** mapping each answer to how it was addressed, and re-request review. If the design is
now essentially settled, say so in the summary.

## Definition of done

`designs/plan-in-journal.md` finalized per kriskowal's five answers, open questions resolved,
pushed under the bot identity, inline replies + a top-level summary comment posted, review
re-requested. Report the head SHA. Surface any remaining genuine open question on the PR.

Posted by the liaison on behalf of the maintainer.
