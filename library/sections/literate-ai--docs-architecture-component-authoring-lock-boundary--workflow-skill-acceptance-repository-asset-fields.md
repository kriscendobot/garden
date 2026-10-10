---
title: Workflow, routing, skill, acceptance, repository, and asset fields
source: docs/architecture/component-authoring-lock-boundary.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-29
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
topics: [agentic-sdlc, repository-governance]
status: current
---

> Abstract: For each authoring-input family the selector, the exact lock datum, and the evidence-only residue are distinct: prompts, transcripts, case results, clone and build logs, and fetch timing never enter the lock; non-code asset bytes are in the input closure but outside the model-writable tree, verified before generation and overlaid at assembly.

| Family | Authored intent / selector | Exact lock data | Evidence only |
| --- | --- | --- | --- |
| Workflow | catalog-relative path and optional pin | content reference | execution trace and outcome |
| Model routing | policy path and optional pin; explicit user model preference | exact policy/model binding selected for generation | prompts, responses, timing, token use |
| Skill | role/kind and path with optional pin | exact skill content reference | agent loading transcript |
| Acceptance | behavioral oracle location and optional pin | exact acceptance content reference | case results and verifier receipts |
| Repository source | URL, revision selector, dependency kind, optionality, integration selector | commit, source snapshot/tree, resolver, exact integration contract | clone/build/index/admission evidence |
| Non-code asset | Component-relative path, `project:///` path, or HTTP(S) URI; target path, role, media type, optional pin | selector plus exact SHA-256, byte size, and media type | fetch timing/cache observation and assembly evidence |

Asset bytes are part of the Component input closure but never part of the model-writable tree. Lock planning must prove reachability and integrity before generation. Generation context holds only locked asset metadata; assembly overlays the verified bytes after the model returns text. A changed or unreachable asset invalidates the lock and stops test creation and build, while an unrelated shared asset does not affect Components that do not select it.

Exact repository locks are selected inputs. The temporary clone, build logs, quarantine state, and cache-admission history are runtime evidence even when they prove the selected lock was safe to consume.

Source: [docs/architecture/component-authoring-lock-boundary.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/component-authoring-lock-boundary.md) at commit `fcc40bc`.
