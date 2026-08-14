---
source: README.md
source_repo: cordiverse/cordis
source_commit: 270f9e85186b71f18476af08036f1a68fa6044bd
source_date: 2026-08-13
source_authors: [cordiverse]
ingested: 2026-08-14
ingested_by: scholar
section_count: 4
status: current
notes: "The working implementation companion to the paper source at https://github.com/cordiverse/paper (GitHub description: 'A Programming Paradigm for Spatiotemporal Composability'). The `paper` repo itself carries NO implementation code — only README.md (the abstract) and paper.pdf — so the concrete API, worked examples, and paper-vs-implementation differences are ingested here from cordiverse/cordis (the mature 3353-star TypeScript meta-framework the paper names as `Cordis`). Anchored on the repo's key files; per-section commit anchors in each section footer. Cross-reference the paper's own library entry (base ingest, source-slug likely `cordiverse-paper`/`papers--*`) for the theory/metatheory."
---

# Cordis — meta-framework of spatiotemporal composability (implementation of the paper)

Abstract: Cordis (`cordiverse/cordis`) is the working TypeScript **meta-framework** that realizes the paradigm formalized in the paper *A Programming Paradigm for Spatiotemporal Composability* (`cordiverse/paper`). Where the paper gives the calculus — revertible effects (temporal composability: every context transformation carries a tracked inverse), reactive coeffects (spatial composability: each context change notifies a component against its coeffect specification), and their unification into a single **context type** — Cordis ships those ideas as a concrete, running API: a `Context` object, `ctx.plugin()` component loading that returns a disposable **fiber**, `ctx.effect(setup → teardown)` revertible effects with LIFO reversion, and a `Service` / `ctx.inject([...])` mechanism for availability-gated, reactively-torn-down dependencies. The repo is not vaporware: 3353 stars, a monorepo of nine core packages (`core`, `loader`, `hmr`, `group`, `include`, `timer`, `logger-console`, `create`, `utils`) plus a wider ecosystem (`http`, `database`, `server`, `webui`, `yakumo`), and a test suite (`packages/core/tests/*.spec.ts`) whose specs are the paper's abstractions rendered as executable worked examples. This is the material the raw PDF text extraction omits — the paper has no code appendix and the `paper` repo has no source tree; the concrete surface lives here.

This source records, in four sections:

- **overview** — the paper→implementation mapping, the package layout, and what the paper omits that the repo supplies (the declarative loader, hot module replacement, configuration reconciliation).
- **revertible-effects** — temporal composability as code: `ctx.effect`, the tracked inverse, LIFO teardown, idempotent `fiber.dispose()`, generator-yield multi-effect, and "inactive context" after disposal.
- **reactive-coeffects-and-services** — spatial composability as code: `Service`, `ctx.inject([...])`, `provide`/`set`, `Service.init` gating, and reactive teardown of dependents when a provider is disposed.
- **applicability-to-the-garden** — an implementation-grounded reading of the paper's applicability to the garden's own job/orchestration/agent-composition model, and how the existence of a mature implementation sharpens (does not overturn) the paper's headline verdict.

| Section | Topics | Status |
|---------|--------|--------|
| [overview](../sections/cordis--overview.md) | change-propagation, effect-and-coeffect-systems | current |
| [revertible-effects](../sections/cordis--revertible-effects.md) | change-propagation, effect-and-coeffect-systems | current |
| [reactive-coeffects-and-services](../sections/cordis--reactive-coeffects-and-services.md) | change-propagation, effect-and-coeffect-systems | current |
| [applicability-to-the-garden](../sections/cordis--applicability-to-the-garden.md) | change-propagation | current |

Source: [README.md](https://github.com/cordiverse/cordis/blob/270f9e85186b71f18476af08036f1a68fa6044bd/README.md) at commit `270f9e85`; companion paper at [cordiverse/paper](https://github.com/cordiverse/paper).
