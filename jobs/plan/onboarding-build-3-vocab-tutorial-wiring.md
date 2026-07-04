---
gate: orchestrated
orchestrated_by: onboarding-implementation
priority: normal
posted_by: producer
posted_at: 2026-07-04T07:00:20Z
---

---
role: builder
model: opus
---

# Build (phase 3/4): the `help` verb + tutorial wiring

**GARDEN self-development.** Per-job worktree off `origin/main2`; push **directly to `origin/main2`** (no PR). Depends on phase 2 (the `context/first-run/` fragments exist). Implement from **`designs/streamlined-onboarding.md`** § 2, § 2.1, § 2.3, and § 6 phase 3.

> **Worktree caution (host endolinbot2):** if your `gardener-wt-*` git admin entry is swept mid-job, commit/push from a standalone scratch clone.

## What to wire

- **CLAUDE.md:**
  - Add a **`help` vocabulary row** (first-class liaison-session vocabulary — **never watcher-recognized**, per § 2.1).
  - Add a **virgin-instance greeting** to the session preflight, in **guard-then-probe order** (the container guard runs first, then the help/virgin-instance probe) — reconcile with the existing § Container guard preflight I already added; do not duplicate or reorder the guard.
  - Retitle the bring-up concept to **"Starting the garden"** wherever CLAUDE.md references it (the migration of the command detail itself is phase 4; this phase does the vocabulary/preflight/reframe pointers).
- **`roles/liaison/AGENT.md`:** add a **§ Help** section — the tutorial the liaison runs on `help`: the ordered, conversational stage track anchored in `context/first-run/README.md` (authored phase 2), read **on demand**; the **ask-before-acting** interaction contract (§ 2.3); "start the garden" jumps to its stage and the liaison performs the steps (reading `context/operations/starting.md`), asking before consequential operations. Keep the existing stand-up/stand-down and Monitor contracts; shrink any long procedural passages to routes into `context/operations/`.

Honor the design's recommendations for the still-open questions (Q4 help mechanics: vocabulary row + virgin greeting, no watcher recognition; Q5 boundary as drawn) — the maintainer greenlit implementing per the design.

## Definition of done

`help` is honored as liaison-session vocabulary (not watcher-side); the preflight greets a virgin instance guard-then-probe; `roles/liaison/AGENT.md § Help` defines the on-demand tutorial + ask-before-acting contract routing into `context/first-run/` and `context/operations/`; "Starting the garden" reframe is in place. Push to main2; report the commit sha.
