---
title: Cordis, the component loader, and the Koishi case study
source: "A Programming Paradigm for Spatiotemporal Composability"
source_kind: paper
source_authors: [Yifan Shi, Wei Zhang, Tianyi Cui]
source_year: 2026
source_venue: "Preprint (cordiverse/paper on GitHub)"
source_url: https://github.com/cordiverse/paper/blob/main/paper.pdf
source_pdf_sha256: 4d48478dc0b6222d9f74d7db10ee776449b1209eb112632336544d32a49db97f
ingested: 2026-08-14
ingested_by: scholar
topics: [dynamic-composition, module-loader]
status: current
---

Abstract: This derived digest, not the original paper, captures the practical realization of the model as *Cordis*, a TypeScript meta-framework, and its validation on the Koishi chatbot framework. Cordis is layered: (1) a core library realizing effects and coeffects directly, where *every* context mutation flows through one primitive `ctx.effect(callback)` that returns a `dispose` closure; (2) a declarative component loader adding configuration reconciliation and hot module replacement (HMR); (3) application frameworks (Koishi) that add only domain vocabulary. Koishi's 4000+ community plugins over four years are an existence-and-adoption result for the paradigm — plugins are unloaded in place without restart, and an open ecosystem of independently authored plugins coordinates through nothing but the coeffects that connect them.

**Cordis is a meta-framework.** Unlike an application framework targeting a domain (web routing, ORM, UI), Cordis prescribes no scenario; its sole responsibility is to supply universal dynamic-composition semantics. Three tiers: core library → component loader → application frameworks.

**Core library — one mutation primitive.** Every context mutation (coeffect provision, component instantiation, everything) reduces to a `ctx.effect(callback)` call, so any operation performed through the context is automatically tracked and recovered on unload. `ctx.effect` realizes the effect iterator: it drives the callback, folds each yielded inverse into a single composite (prepending, hence LIFO recovery), and returns a `dispose` closure that fires recovery *at most once* (an `armed` flag also halts any in-flight iteration). `dispose` is prepended to the enclosing context's accumulated inverse `ctx.dispose`, so a child effect's inverse is itself an effect on the parent. The runtime does *not* verify that the supplied inverse actually reverts the effect — that is an obligation on the component author (delimited by the system boundary of §6.1). Coeffect ops map to `ctx.get(key)` / `ctx.set(key, value)` (a `ctx.effect` call whose inverse deletes the binding and notifies), `ctx.isolate(key, realm)`, `ctx.intercept(key, metadata)`. `notify` walks live fibers and `refresh`es any whose `inject` set contains a changed key resolving to the same realm — the reactive classification. Context access is exposed both by method (`ctx.get`/`ctx.set`) and, via a JavaScript `Proxy`, by property access.

**Component loader (§5.2).** Above the core, a loader turns a *declarative configuration* (a tree of component entries with their config) into a running fiber tree, *reconciling* the running system against an edited configuration — adding, removing, and reconfiguring components to match. *Hot module replacement* re-applies edited components on save: because each component's effects are tracked, the loader unloads the old version (running its accumulated inverse) and loads the new one, preserving cache state and live connections elsewhere in the system. This turns what is traditionally an infrastructure operation into an application-level composition pattern.

**Case study — Koishi (§5.3).** Koishi is an open-source chatbot framework built on Cordis, with 4000+ community plugins (Koishi's "plugin" is the paper's "component"). Findings: (1) *Expressiveness* — every Koishi feature is a plugin over the context primitives; the same model reappears unchanged in Koishi's browser-side web console (a second, independent Cordis application). (2) *Temporal composability without cognitive overhead* — an orchestrator disables a plugin from the console and its effects are withdrawn in place; even an inexperienced author gets ordered cleanup without writing an uninstall path, because inverses are composed automatically. (3) *Spatial composability across an open ecosystem* — IM adapters, database drivers, and functional plugins form a genuine dependency topology; reconfiguring a provider at runtime reactivates only the dependents whose resolved dependency changed, and a plugin whose dependency is unavailable stays inactive (does not error) until it appears — across code authored by strangers who coordinate on nothing beyond the connecting coeffect. *Threat to validity*: a single ecosystem in a single host language, observational rather than a controlled comparison; an existence-and-adoption result, not a quantitative one.

Source: [paper.pdf](https://github.com/cordiverse/paper/blob/main/paper.pdf) §5 (cordiverse/paper), content SHA-256 `4d48478d…`.
