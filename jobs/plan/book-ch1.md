---
gate: orchestrated
orchestrated_by: garden-book-orch
priority: normal
posted_by: producer
posted_at: 2026-09-30T03:43:48Z
---

---
handler-timeout: 7200
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Garden book, chapter 1: Philosophy, history, and metamorphosis

This is one chapter of a multi-part "book" about the garden (orchestration
`garden-book-orch`; the final assembly/publish job gathers every chapter).
Write chapter content to `journal/projects/garden-book/ch1-philosophy-history-metamorphosis.md`
(create the `garden-book/` directory if needed) as clean, well-structured
Markdown — the assembly job converts it to HTML, so don't hand-write HTML
yourself.

## Ground this in real sources, don't paraphrase from memory

- `README.md` (the maintainer-facing tutorial and top-level framing) and
  `CLAUDE.md` (the liaison's own orientation — read its opening framing of
  what the garden is).
- `HISTORY.md` in full — this is the garden's own account of its staged
  self-evolution, explicitly narrated as a series of "metamorphoses." Quote
  and cite its actual stage descriptions rather than summarizing from a
  vague memory of what a "metamorphosis" narrative usually contains.
- `README.md`'s "The bidding market: the next metamorphosis" section, which
  frames what comes after the current stage.

## What this chapter should cover

1. What the garden is, in plain terms: a library of roles and skills plus a
   journal-backed coordination substrate for a fleet of AI agents working
   across many forks of GitHub repositories.
2. Why it exists — the problem it solves (coordinating many agents on real
   software work without a human in every loop) and the shape of the
   solution (job board, message bus, gardener fleet).
3. The metamorphosis narrative itself: walk each named stage from
   `HISTORY.md` in order, what changed at each one, and why the change was
   necessary (what broke or didn't scale about the prior stage). This
   history matters practically: someone standing up their own instance is
   about to inherit the current stage's shape, and understanding what it
   evolved *from* clarifies why things are built the way they are.
4. Where the garden considers itself to be now, and what it expects the next
   metamorphosis to look like.

Write for a reader who has never seen this system before but is technically
sophisticated — explain garden-specific vocabulary the first time it's used.
