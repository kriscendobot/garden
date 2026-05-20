---
ts: 2026-05-20T05:07:24Z
kind: dispatch
role: liaison
project: endo-but-for-bots
to: designer
---

# Dispatch: designer studies antoinezambelli/forge and produces a gap analysis for Endo

Dispatch root: `dispatches/designer--50e490/`. Project worktree on `endojs/endo-but-for-bots@llm` (head `68246ad92`).

Maintainer directive (2026-05-20): *"Please dispatch a designer to clone and develop a deep understanding of the design of https://github.com/antoinezambelli/forge and produce a gap analysis for Endo."*

## What's being asked

The output is a **design document** placed under `designs/` on `endojs/endo-but-for-bots@llm`, opened as a DRAFT PR per the established designs-PR convention. The document is a *gap analysis*: what `antoinezambelli/forge` does, what `endojs/endo` does in the overlapping spaces, what `forge` does that endo doesn't, what endo does that `forge` doesn't, and which of forge's design choices (if any) endo might consider adopting or learning from.

Treat this as a **scout-meets-designer** assignment: the deep read of forge is upstream, and the gap analysis is a structured comparison written for the maintainer to decide what (if anything) to act on.

## Task

Read `garden/roles/COMMON.md` + `garden/roles/designer/AGENT.md` + `garden/skills/process-documents/SKILL.md` first. Then read `designs/CLAUDE.md` from the project worktree — it carries the design-doc structural conventions (frontmatter, Status field, Status section, Phased implementation, etc.).

1. **Clone forge** into a scratch directory inside the dispatch root (NOT inside the project worktree; somewhere like `/tmp/forge-study/` or `$DISPATCH_ROOT/scratch/forge/`). Use `git clone --depth=50 https://github.com/antoinezambelli/forge.git` so you have history without bloat. Note the head SHA on read; treat it as a frozen reference for the design document.

2. **Develop a deep understanding** of forge. Don't skim. Read its README, its design / architecture docs (if any), its `package.json` / `pyproject.toml` / `Cargo.toml` (whichever — confirm the implementation language and ecosystem on first inspection), the top-level entry points, and a representative subset of the source. Be alert for:
   - **The problem forge solves.** State it in one sentence. Be precise — vague problem statements yield vague gap analyses.
   - **Forge's architectural shape.** Is it a library? A framework? A toolchain? A bundler? An object-capability system? Sandbox?
   - **Its primitives.** What is the smallest unit of computation / isolation / composition forge exposes?
   - **Its trust model.** Object-capability? Ambient-authority? Permission-based? None?
   - **Its boundaries.** What crosses module / sandbox / network boundaries, and under what discipline?
   - **Its dependency surface.** What does it pull in, and does it stand on a shim/polyfill of its own?
   - **The community / maturity signal.** Stars, last commit, contributor count, issue/PR throughput — single line each.

3. **Map the overlap with Endo.** For each forge primitive or concept, name the closest Endo analogue (or "no analogue"). Use a table. Endo's main surfaces, for reference:
   - `@endo/init` + SES `lockdown()` — realm shim + intrinsic taming.
   - `@endo/harden` — surface/volumetric freeze + spackle.
   - `@endo/pass-style`, `@endo/patterns`, `@endo/marshal` — passable data + structural validation + serialization.
   - `@endo/exo`, `@endo/eventual-send` — defensive objects + `E()` promise pipelining.
   - `@endo/compartment-mapper` + Compartment — module isolation, per-module endowments.
   - `@endo/bundle-source` — package-to-bundle for cross-realm deployment.
   - `@endo/captp`, `@endo/netstring`, `@endo/syrup` — wire protocols for message-passing.
   - `@endo/daemon`, `@endo/cli`, `@endo/where` — process / capability daemon.
   - LavaMoat (sister project, not in this repo) — per-package isolation in npm dependency graphs.

4. **Author the gap analysis** at `designs/forge-gap-analysis.md` (or a slug the designer prefers; align with the existing `designs/` slug convention). Use the `designs/CLAUDE.md` shape (frontmatter with title/status/owner/etc., Status prose section, ordered sections). Recommended sections:
   - **Summary** — one paragraph: what forge is, what endo is, the one or two highest-signal gaps either direction.
   - **Forge in brief** — problem, shape, primitives, trust model, boundaries, dependencies, maturity. Cite the forge head SHA. Use code snippets sparingly; cite paths.
   - **The overlap map** — a table: forge primitive → endo analogue → divergence (one line).
   - **What forge does that endo doesn't** — the gap *from endo's perspective*. For each: what is it, why might endo care, what would adopting it look like, and what's the cost (LOC, design churn, semantic mismatch with endo's trust model). The cost field is what makes this a *gap analysis* rather than a wishlist.
   - **What endo does that forge doesn't** — the inverse. For each: what is it, why does endo have it, would forge benefit (this is for the maintainer's interest; don't dispatch a contribution to forge from this — that's a separate decision).
   - **Where the trust models clash** — if forge uses ambient authority and endo uses ocap, name the friction points. If they're compatible, say so directly. This is often the highest-signal section.
   - **Recommendations** (designer's call) — three buckets: *adopt as-is*, *adopt with adaptation*, *do not adopt, but note for future reference*. Each entry one to three sentences with a rationale.
   - **Open questions** — explicitly list what you couldn't determine and why. The designer's discipline here is to *surface* uncertainty rather than paper over it.
   - **References** — forge head SHA, key forge file paths, key endo file paths.
   - **Prompt** — capture the maintainer's directive verbatim at the bottom per `designs/CLAUDE.md`.

5. **Sync into `designs/README.md`**: add a row to the Summary table (size estimate: this is analysis-only, so S or XS depending on document length). It does not belong in the milestone schedule — it's an exploratory design analysis, not implementation work. The designer's call whether to put it under a milestone or in an "Exploratory" / "Unscheduled" section; if no such section exists, add the row to the Summary table without a milestone and note "exploratory" in the size column.

6. **Open as DRAFT PR** against `endojs/endo-but-for-bots@llm`. Branch: `design/forge-gap-analysis`. Title: `design: gap analysis of antoinezambelli/forge vs. Endo`. Body cites the maintainer directive, summarizes the highest-signal gaps in both directions, and asks the maintainer to weigh in on the recommendations section.

## Style discipline (the same the spackle dispatch carries)

- No agentic tropes: no "Let's explore", "we'll dive into", "Importantly,", "In essence,", "Furthermore,".
- Factual, structured, no marketing voice. Read `docs/message-passing.md` in the endo repo (you can fetch a copy into your scratch dir) for tone reference.
- **One sentence per line, 80–100 col wrap** per endo's CONTRIBUTING.md style guide. The designs/ directory on endo-but-for-bots may not yet enforce this, but adopting it makes the document portable.
- **Be specific about endo**. The maintainer is the maintainer of endo; vague handwaving like "endo has a comprehensive isolation story" will not pass the smell test. Cite packages and files by name.
- **Be honest about forge**. If forge solves a problem endo doesn't address, say so plainly. If forge's design has a weakness from the ocap perspective, say so without sneering — the goal is understanding, not advocacy.

## Per-action authorization

Standing on endo-but-for-bots: push to `design/forge-gap-analysis`, open draft PR. No comment authority on anything outside the new PR's body. READ-ONLY on `endojs/endo` and on `antoinezambelli/forge` upstream (you may clone, you may not push, you may not file issues there). Cloning forge is read-only by construction — git clone over HTTPS is fine; no GitHub-API write surfaces involved.

## Out of scope

- No implementation. This is a gap-analysis document, not a build.
- No edits to `@endo/*` source.
- No PR or contribution to `antoinezambelli/forge` upstream.
- No un-draft of the design PR — it stays draft until the maintainer green-lights.

## Report

≤ 500 words: PR URL + head SHA, forge head SHA at the time of read, design path on llm, the one-sentence problem statement for forge, the top 3 gaps from endo's perspective, the top 3 gaps from forge's perspective, the trust-model verdict (compatible / friction / incompatible), any high-leverage adoption recommendation, the open questions you surfaced, one-line `Self-improvement: ...`. The liaison adds a bulletin row.
