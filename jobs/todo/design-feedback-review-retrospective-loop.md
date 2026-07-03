---
model: fable
---
# designer: the double-loop — treat every PR comment as an indictment of the review process

**Garden-infra design on `main2`.** The design doc lands under `designs/` in the **garden repo** (isolated worktree off `origin/main2`), not a fork. This designs the garden's OWN gardener workflow.

## Directive (kriskowal, 2026-07-03)

For every comment on a PR in the gardener workflow, dispatch **two** responses:
1. **Address the feedback as written** — exactly as we do today (the comment-watcher's fixer / branch-op job). UNCHANGED.
2. **A second, retrospective job** that views the feedback as an **indictment of the review process for failing to anticipate it**. It should: (a) track common patterns across similar such failures, and (b) **past a subjective threshold**, dispatch a job to improve the **roles, skills, context library, or standing instructions** — with a two-fold goal: **prevent the error**, and **sense-and-correct the error in the review cycle** (so the review anticipates it next time instead of the maintainer having to catch it).

The insight: a maintainer comment that a good review *should* have caught is a **review-process failure**, not just a code defect. Fixing the code closes the symptom; the second loop closes the *cause*.

## Current state (verify against main2)

`scripts/jobs/comment-watcher.sh` posts ONE job per recognized PR comment (address the feedback). The garden already has self-improvement machinery to reconcile with: `skills/self-improvement`, the `mentor` role, `skills/panel-hints`, the scripted review `skills/panel` and its juror seats, the `triager`, and the context library (`journal/library/`). Do NOT duplicate these — extend/wire them.

## Design questions to resolve (the substance)

1. **Dispatch point + gate.** The comment-watcher posts the 2nd (retrospective) job alongside the 1st. Every comment, or gated? Most comments that are pure new-direction / taste / scope-change are NOT review failures — the review could not have anticipated them. The retrospective must distinguish **"the review SHOULD have caught this"** (a real miss: a bug, a style/spec violation, a missed edge case, a convention the panel knows) from **"this is new/subjective direction"** and only feed the former into the learning loop. Specify that discriminator (it can itself be the retrospective agent's judgment, with recorded grounds).
2. **The review-miss store.** Where and how are misses recorded and **clustered** with similar prior misses? Propose a structured record (the comment, the PR/role that produced the work, the diagnosed root cause, which role/skill/juror-seat *should* have caught it, a category) and a taxonomy of review-failure categories. Journal store vs a library section — pick and justify.
3. **The subjective threshold.** It is deliberately *subjective* — so the retrospective agent judges, but with **recorded rationale and a floor** (e.g. a cluster must recur K times, or the agent must cite the pattern). Specify how the threshold is evaluated against the accumulated store.
4. **The improvement dispatch — both goals.** When the threshold trips, dispatch a job to change the specific **role / skill / context-library page / standing instruction**. It must serve BOTH: (a) **prevention** — the doing role stops making the error; and (b) **review-cycle sensing** — the panel/gauntlet gains the ability to *catch* it (a new juror-seat check, a `panel-hints` entry, a skill the panel consults). Specify how a learned pattern becomes a durable review check, not just a prose note.
5. **Reconcile with existing self-improvement.** How this differs from / composes with `skills/self-improvement` (the per-engagement lesson) and the `mentor` role. This is the *aggregate, feedback-driven, review-process-focused* loop; the existing skill is the per-job one.
6. **Cost + noise.** A 2nd job per comment ~doubles comment-driven dispatch. Weigh the gate against cost; a cheap deterministic pre-filter before any `claude -p` is desirable.

## Deliverable

A design doc under `designs/` (garden repo, main2) specifying the mechanism end-to-end — the comment-watcher change, the miss store + clustering taxonomy, the subjective-threshold evaluation, the dual-goal improvement dispatch (prevention + review-sensing), the noise gate/discriminator, and the wiring into `self-improvement` / `mentor` / `panel-hints` / the panel — plus a **staged build plan**. Land it on `main2` from an isolated worktree; journal a `result` entry. The build is a separate job blocked on this design.

## Definition of done

An approved-quality design doc for the double-loop retrospective self-improvement mechanism, landed under `designs/` on `main2`, resolving all six design questions above with concrete choices, and carrying a staged build plan. Reconciled with existing self-improvement/mentor/panel machinery. Cite the files you inspected.
