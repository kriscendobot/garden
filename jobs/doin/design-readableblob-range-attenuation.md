---
role: designer
---

# designer — rename/redesign the Endo daemon's ReadableBlob `fetch` into a coherent range attenuation

## Origin & context (maintainer direction)
The Endo daemon's **`ReadableBlob`** exo has a method **`fetch`** that corresponds
to a **ranged read**. The name is opaque — it collides conceptually with network
`fetch` and does not read as "a range of a blob." Meanwhile ranged reads are
already provided elsewhere via **`readRange*`** methods on the **directory-like
exos**. The goal: rename/redesign `fetch` so the interface is **descriptive,
indicative, and coherent** with that existing convention.

## Maintainer's preferred shape (the charter — refine for coherence, don't just restate)
- A **`range()` attenuation**: instead of a one-shot ranged read returning bytes,
  `range(<byte offsets>)` produces an **ephemeral range within the readable blob of
  the SAME interface** — i.e. it returns another `ReadableBlob` (same guard/methods)
  narrowed to that byte range, which the caller then reads from normally. A range is
  itself a readable blob; this composes (a range of a range) and is a clean
  capability attenuation.
- A corresponding **`textRange()`** that operates on **line numbers instead of byte
  offsets**, producing the same kind of ephemeral same-interface range but scoped by
  lines (requires deciding the line-index model — newline convention, 0/1-based,
  inclusive/exclusive end, encoding).

## What to design
1. **Investigate** the actual current surface: `ReadableBlob.fetch`'s signature and
   semantics, and the `readRange*` methods on the directory-like exos — so the new
   naming is coherent with (or deliberately supersedes) what already exists. Name
   the specific files/exos/interfaces.
2. **Specify the new interface:** the chosen method name(s) (`range()` / `textRange()`
   or a better-justified coherent alternative), signatures, the same-interface
   ephemeral-attenuation semantics, composition (range-of-a-range), bounds/clamping,
   empty/degenerate ranges, out-of-range and error behavior, and the `textRange`
   line-index model.
3. **Reconcile the convention:** should `readRange*` on the directory-like exos also
   evolve toward this range-attenuation shape for coherence, or stay as-is? Make a
   recommendation.
4. **Rename/refactor plan:** follow `skills/rename-discipline` — enumerate every
   caller/definition of `fetch`, the migration path (and any compat shim if the
   interface is consumed across a CapTP boundary), and a phased implementation plan.
   Land on `endojs/endo-but-for-bots` (the daemon lives on the fork); work in an
   isolated fork worktree keyed by the job base.

## Deliverable
A design doc specifying the new interface + the phased rename/refactor plan, with
open questions (e.g. the textRange line-index conventions, whether `readRange*`
co-evolves) called out for maintainer resolution rather than guessed. The
implementation is a follow-on (a rename/build job against the landed design).

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 10
  worker_kind: cleric
  claimed_at: 2026-07-22T06:16:26Z
