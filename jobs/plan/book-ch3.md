---
gate: orchestrated
orchestrated_by: garden-book-orch
priority: normal
posted_by: producer
posted_at: 2026-09-30T03:44:11Z
---

---
handler-timeout: 7200
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Garden book, chapter 3: Using the garden

One chapter of a multi-part "book" (orchestration `garden-book-orch`). Write
to `journal/projects/garden-book/ch3-using-the-garden.md` as Markdown.

## Ground this in real sources

- `roles/liaison/AGENT.md` in full — this is the operating manual for the
  role a human actually talks to.
- `CLAUDE.md` § Orchestrator vocabulary (the full verb table) and the
  compound-idiom / plan-queue / fleet-operation mentions that route to the
  liaison file.
- `README.md` § Key vocabulary (the authoritative table CLAUDE.md defers to).
- The muster section of `roles/liaison/AGENT.md` (interactive maintainer-
  inbox review) and the plan-queue section.

## What this chapter should cover

1. **Who you're talking to.** Standing in the garden root, a human is
   talking to the liaison — a relay/orchestrator, not a doer. Explain the
   posture: it posts jobs, it does not do the work itself, with the narrow
   in-session exceptions (local garden operations, the maintainer inbox,
   small library edits).
2. **The vocabulary**, organized by what a person actually wants to do:
   getting oriented (`help`, `help <topic>`), starting up (`start the
   garden`), getting work done (`design X`, `build X`, `fix X`, `run the
   gauntlet #N`, `retcon #N`, `americanize #N`, `deslop #N`, `weave #N` /
   `pin the merge base #N`, `shepherd #N`, `merge #N`, `ferry #N`), managing
   the queue (`defer/park X`, `promote X` / `go ahead`), fleet operations
   (stand up/stand down/drain/lift/restore), and negation (`don't X`).
   Explain each verb's actual effect, not just its name — what job gets
   posted, what happens next.
3. **Muster**: what it is, why it exists (the inbox accumulates faster than
   a human can read it), the three-pass shape (compact, classify, dispose),
   and the TypeSafe pilot now run by default.
4. **The plan queue**: parking work that shouldn't auto-run, and the
   promotion primitives.
5. **A worked example or two**: narrate, step by step, what actually happens
   when someone says "build #1234" or "run the gauntlet #56" — from the
   words typed to the job landing on the board to a gardener claiming it.

Write for the actual user of this system: someone sitting at a terminal
talking to the liaison, who wants to know what to type and what it does.
