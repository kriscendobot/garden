---
title: Component lifecycle kinds
source: docs/architecture/component-authoring-lock-boundary.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-29
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
topics: [agentic-sdlc, testing]
status: current
---

> Abstract: Lifecycle kind is an authored Component contract, not a Flavor rename: cli-application is an explicit subclass with a JSON-array argv ABI, framework test/smoke modes, and process-invocation acceptance; omitted kind is inferred from entrypoints to keep identities stable; COMPONENT-KIND-002 accepts component, cli-application, library, persistent-service, packaged-module, ui, and schema-only and declines wrapped-source, batch, and event.

`cli-application` is an explicit subclass of the base `component` kind, not the implicit base. Default `litai init` Flavor selectors are unchanged: kind is an authored Component contract, not a Flavor catalog rename.

Omitted `kind` infers from entrypoints so existing `component.md` identities stay stable:

| Entrypoints | Inferred kind |
| --- | --- |
| at least one `portable-application` | `cli-application` |
| at least one `persistent-service` and no portable CLI | `persistent-service` |
| empty or other | `component` |

CLI-only generated assumptions that other kinds must not inherit: one JSON-array argv ABI for the runnable artifact; framework `--litai-test` and `--litai-smoke` dispatcher modes; process-invocation acceptance rather than import or render oracles; at least one `portable-application` entrypoint. Reviewed inverse graph nodes map `cli` → `cli-application`, `library` → `library`, and `service` → `persistent-service`.

Kind candidates (COMPONENT-KIND-002):

| Candidate | Decision | Named lifecycle difference |
| --- | --- | --- |
| `component` | accepted | generic lock/generate/accept; no CLI argv ABI |
| `cli-application` | accepted | JSON-array argv, framework test/smoke modes, process-invocation acceptance |
| `library` | accepted | empty product entrypoints; sealed directory package, exact language import surface, generated test adapter, verifier-owned capability oracle |
| `persistent-service` | accepted | `persistent-service` entrypoint; no portable CLI argv |
| `packaged-module` | accepted | the package is the artifact; no portable CLI argv |
| `ui` | accepted | no CLI argv; lint-and-render acceptance is a later oracle |
| `schema-only` | accepted | empty entrypoints; schema validate, no generated runtime |
| `wrapped-source` | declined | convert-phase quarantine, not a generation kind |
| `batch` | declined | same lifecycle as `cli-application` |
| `event` | declined | same lifecycle as `persistent-service` |

An authored `kind` is omitted from the authoring identity projection when empty. Existing samples that still declare a portable-application entrypoint keep inferring `cli-application`, including `samples/generated-library`.

Source: [docs/architecture/component-authoring-lock-boundary.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/component-authoring-lock-boundary.md) at commit `fcc40bc`.
