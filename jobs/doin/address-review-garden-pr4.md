# Address kriskowal's review on garden#4 (the cross-repo plan-in-journal design)

Maintainer COMMENTED review (kriskowal, 2026-06-25T17:24Z) on **kriskowal/garden #4**
"design(plan-in-journal): the plan as cross-repo garden journal2 state" (head
`design/plan-in-journal`, base `main2`) —
https://github.com/kriskowal/garden/pull/4#pullrequestreview-4573331488

This is the garden's OWN design PR (output of `design-subsume-plan-into-journal`). Wear
the **designer** role (`roles/designer/AGENT.md`). Repo: `kriskowal/garden`, PR **#4**,
revise `designs/plan-in-journal.md` on the head branch. This is garden-meta design work;
push under the bot identity.

## The six review decisions to fold in (inline on designs/plan-in-journal.md)

1. **:234 "Move it all into the garden's journal to avoid a coordination problem."** —
   the plan moves FULLY into the garden journal (journal2), not split across repos.
2. **:237 "The journal should be the source of truth."** — journal2 is the single SoT
   for the plan; design around that (no per-repo authoritative copies).
3. **:239 "The reconciler may take responsibility for updating the plan."** — a
   reconciler keeps the plan current (rather than each design author hand-syncing a
   summary table). Specify the reconciler's role in updating the plan.
4. **:243 "Consolidate the new role with the bulletin generator."** — do NOT introduce
   a separate plan-updating role; consolidate it with the **bulletin generator /
   journalist** (`scripts/jobs/bulletin.sh` + the journalist) which already runs
   continuously over journal2. The plan reconciliation rides on that, not a new service.
5. **:246 "Latency remains a garden-wide metric; no per-project granularity."** —
   review-queue latency is tracked garden-wide, not per project. Simplify accordingly.
6. **:249 slug/repo mapping** — use a short project **slug** for now (kebab-case,
   adaptable). Track the **mapping from project slug → repository URL**, and keep the
   model open to **repositories not on GitHub** (don't bake GitHub-only assumptions into
   the plan's repo identity).

## Task

Revise `designs/plan-in-journal.md` to reflect all six decisions (plan fully in journal2
as SoT; reconciler updates it, consolidated into the bulletin/journalist rather than a
new role; garden-wide latency; slug→repo-URL mapping with non-GitHub repos allowed).
Keep it coherent and self-contained. Push to the `design/plan-in-journal` branch.

## Communicate (standing norm)

Reply on each of the six inline threads citing how it was addressed (and the revising
commit SHA), AND post a **top-level summary comment** on #4 summarizing the revision and
the decisions folded in. Re-request review from kriskowal.

## Definition of done

`designs/plan-in-journal.md` revised per all six decisions, pushed to the PR branch under
the bot identity, six inline replies + a top-level summary comment posted, review
re-requested. Report the head SHA and a one-line-per-decision résumé of how each was
addressed. If a decision conflicts with another part of the design, surface it on the PR
rather than guessing.

Posted by the liaison on behalf of the maintainer.

---
claim:
  host: endolinbot
  gardener: 15
  claimed_at: 2026-06-25T17:26:58Z
