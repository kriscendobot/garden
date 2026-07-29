---
title: ShadowRealm proposal README — status, the two-method API, and the road from Realms to ShadowRealm
source_kind: web
source_url: https://raw.githubusercontent.com/tc39/proposal-shadowrealm/main/README.md
source_content_sha256: 09b2b5df4561f0eabe6665a9fbc67bbd359670054ef19c4ce70e3c872a70903b
source_authors: [Dave Herman, Caridy Patiño, Mark S. Miller, Leo Balter, Rick Waldron, Chengzhong Wu]
source_date: 2024-12-01
ingested: 2026-07-29
ingested_by: scholar
topics: [module-harmony]
status: current
---

Abstract: The proposal repository's front page, ingested as a single section because it is a status card rather than a document: current stage (**Stage 2.7**, not Stage 3, a correction the library's module-harmony concept page carried the other way), the six champions, the whole API in four lines of TypeScript, and a short history recording that the API moved from an exposed-`globalThis` model to a lean isolated-realms API, that the work dates to the ES2015 time frame and never went through the stages process then, and that the original idea was Dave Herman's "What are Realms?" gist. The one-sentence definition it gives: "ShadowRealms are a distinct global environment, with its own global object containing its own intrinsics and built-ins (standard objects that are not bound to global variables, like the initial value of Object.prototype)." Everything substantive lives in the companion explainer, ingested separately as `tc39-module-harmony--shadowrealm-explainer`.

## Status

- Explainer: `explainer.md` in the same repository (ingested as `tc39-module-harmony--shadowrealm-explainer`).
- HTML-rendered spec: <https://tc39.es/proposal-shadowrealm/>.
- Currently at **[Stage 2.7](https://tc39.es/process-document/)**.

Champions: `@dherman`, `@caridy`, `@erights`, `@leobalter`, `@rwaldron`, `@legendecas`.

## What are ShadowRealms?

> ShadowRealms are a distinct global environment, with its own global object containing its own intrinsics and built-ins (standard objects that are not bound to global variables, like the initial value of Object.prototype).

## The API

```ts
declare class ShadowRealm {
    constructor();
    importValue(specifier: string, bindingName: string): Promise<PrimitiveValueOrCallable>;
    evaluate(sourceText: string): PrimitiveValueOrCallable;
}
```

The return type is the whole security story in one token: only primitives or callables cross the boundary.

## History

- The proposal moved on from the exposed-`globalThis` model to a lean isolated-realms API (issues #289 and #291).
- The work was done during the ES2015 time frame, so it never went through the stages process then (an `ES6 Realm Objects proto-spec.pdf` survives in the repository), and "got punted to later (rightly so!)".
- The original idea came from Dave Herman's gist, [What are Realms?](https://gist.github.com/dherman/7568885).

The README also lists the proposal's TC39 presentations from 2018 through the December 2024 Stage 3 request, which is the best available public timeline of how the API narrowed.

Source: [proposal-shadowrealm/README.md](https://github.com/tc39/proposal-shadowrealm/blob/main/README.md) at content sha256 `09b2b5df`. Stage 2.7; retrieved 2026-07-29.
