---
title: "Cordis overview: the paper's paradigm as a running meta-framework"
source: README.md
source_repo: cordiverse/cordis
source_commit: 270f9e85186b71f18476af08036f1a68fa6044bd
source_date: 2026-08-13
source_authors: [cordiverse]
ingested: 2026-08-14
ingested_by: scholar
topics: [change-propagation]
status: current
notes: "Repo-side companion to the paper source (cordiverse/paper). Captures what the raw PDF text extraction omits: the concrete package layout and the declarative loader / HMR / config-reconciliation machinery named in the abstract but not present in the paper repo's files."
---

Abstract: Cordis is the meta-framework named in the paper's abstract as the implementation of spatiotemporal composability. It maps the paper's formal objects onto concrete TypeScript: the **context type** becomes the `Context` class; a **component** becomes a *plugin* applied with `ctx.plugin(plugin, options)`, which returns a **fiber** (the disposable scope tracking that component's effects); **revertible effects** become `ctx.effect(setup)` returning a disposer; **reactive coeffects** become the `Service` + `ctx.inject([...])` dependency mechanism. Beyond the core calculus the repo supplies the three machinery pieces the abstract promises but the paper text only names — a **declarative component loader** (`packages/loader`), **hot module replacement** (`packages/hmr`), and **configuration reconciliation** — none of which appear in the `paper` repo (which holds only README.md and paper.pdf).

## The two dimensions, made concrete

The paper identifies two orthogonal dimensions of dynamic composition and lifts classical *effect* and *coeffect* concepts to runtime mechanisms:

- **Temporal composability** — the ability to completely revert a component's side effects upon removal. In Cordis this is `ctx.effect(() => teardown)`: every context transformation registers its inverse, the runtime tracks it on the owning fiber, and `fiber.dispose()` runs the inverses. See [cordis--revertible-effects](cordis--revertible-effects.md).
- **Spatial composability** — the ability to declare and reactively manage inter-component dependencies. In Cordis this is `Service` + `ctx.inject(['foo'], cb)`: a component declares which services it needs, the callback activates only when they are available, and disposing a provider reactively tears down its dependents. See [cordis--reactive-coeffects-and-services](cordis--reactive-coeffects-and-services.md).

The paper unifies the effect context and the coeffect context into a **single context type**; Cordis's `Context` is that unified object — `packages/core/src/index.ts` re-exports `context`, `events`, `fiber`, `logger`, `registry`, `service`, `utils`, and a plugin's `apply(ctx)` (or `constructor(ctx)`) receives one `Context`, on which both `ctx.effect(...)` and `ctx.inject(...)` live.

## Package layout (monorepo)

`packages/` in `cordiverse/cordis`:

| Package | Role |
|---------|------|
| `core` | The calculus: `Context`, `fiber`, `registry` (plugin + effect), `service` (inject/provide), `events`, `reflect`. |
| `loader` | Declarative component **loader** — loads components from configuration (the "declarative component loader with configuration reconciliation" of the abstract). |
| `hmr` | **Hot module replacement** plugin — re-applies changed components without a full restart, using the fiber/effect machinery to revert the old version's effects and apply the new. |
| `group` | Grouping of components under a shared sub-scope. |
| `include` | Conditional inclusion of components. |
| `timer` | Timer **service** for Cordis (an example first-class service). |
| `logger-console` | Console logger service. |
| `create` | Project scaffolding (`create-cordis`). |
| `utils` | Shared utilities. |

The wider `cordiverse` org realizes the same paradigm across an application stack: `http` (HTTP/WebSocket client), `server` (HTTP/WebSocket server), `database` (type-driven database framework), `webui`, `sso`, `mail`, `sms`, and `yakumo` (workspace manager) — each is a Cordis service or plugin, evidence the paradigm scales "from a single component to a whole system of interleaved components" as the paper's metatheory claims.

## What the paper repo omits (why this companion exists)

The `cordiverse/paper` repository contains exactly three files — `.gitattributes`, `README.md` (the abstract, ~1.7 KB), and `paper.pdf` (~2.1 MB). There is **no** implementation code, no worked example, and no API reference in that repo; the README is the abstract plus a "Draft of August 13, 2026 — preprint under active revision" caveat. Everything concrete — the `Context` surface, the `plugin`/`effect`/`inject` API, the disposal semantics, the loader and HMR machinery — is only observable in `cordiverse/cordis`. A reader who ingested only the PDF text would have the calculus and metatheory but none of the running mechanics; this companion source supplies them.

## Status caveat (both repos)

Both repos self-describe as unstable: the paper is "a preprint under active revision; content may change substantially," and Cordis's READMEs carry "Cordis is under active development. The API is not yet stable and may change without notice." Treat the specific API names below as accurate as of the recorded commits, not as a frozen contract.

Source: [README.md](https://github.com/cordiverse/cordis/blob/270f9e85186b71f18476af08036f1a68fa6044bd/README.md) at commit `270f9e85`; paper: [cordiverse/paper](https://github.com/cordiverse/paper).
