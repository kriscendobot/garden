---
title: The literate-markdown@1 specification provider
source: docs/architecture/mission-specification-composition.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-29
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
topics: [agentic-sdlc]
status: current
---

> Abstract: The `literate-markdown@1` provider accepts free-form UTF-8 Markdown nodes with a strict, small YAML frontmatter (required `name`, `summary`, `kind`; optional `references`, `status`, and asserted `id`/`parent`). IDs and parents derive from the `spec.md` folder layout, structural errors fail before any coding-agent call, and the provider emits a canonical `effective-specification-context` graph with one derived typed requirement per node.

The `literate-markdown` specification provider accepts UTF-8 Markdown with a small, strict YAML-frontmatter subset. The body is free-form Markdown: prose, tables, diagrams, and code are valid without Requirement/Scenario boilerplate. A node needs only three fields:

```markdown
---
name: Scene loading
summary: Load and validate one factory scene
kind: component
references:
  - vfi.core.scene-contract
---
```

| Field | Required | Meaning |
| --- | --- | --- |
| `name` | yes | short human title |
| `summary` | yes | one-line purpose for navigation and model context |
| `kind` | yes | vertical-owned portable label such as `app`, `component`, `part`, `contract`, `flow`, or `kpi` |
| `references` | no | ordered local specification-node IDs whose statements constrain this node |
| `status` | no | `draft`, `review`, `approved`, or `deprecated` authoring signal |
| `id` | no | assertion of the path-derived dotted ID; rejected if it differs |
| `parent` | no | assertion of the folder-derived parent; rejected if it differs |

The first declared artifact is the corpus `spec.md`. A `spec.md` describes its folder; another Markdown file is its child, and a subfolder's `spec.md` begins another subtree. IDs and parents are derived; authors may state them for review but never maintain two independent truths. Unknown keys, duplicate keys, missing containing `spec.md` nodes, unresolved references, and reference cycles fail before a coding-agent call. JSON supporting artifacts such as `app.json` may be declared beside the nodes but do not become hierarchy nodes.

There is deliberately no hand-bumped `revision` or required `date`: Component SemVer, content identities, exact locks, and Git record those facts more accurately. There is also no language, OS, build-system, model, package-manager, or test-runner field; those belong to Flavors, routing, dependency declarations, and skills.

The provider emits a canonical `effective-specification-context` document. For each node it lists the root-to-parent ancestor chain, transitive explicit references with their own ancestors, and finally the node itself. Original documents occur once in the generation recipe; the context graph points at them rather than copying prose into every bundle. It also derives one typed context requirement per node, giving the kernel a stable machine handle even for free-form prose. Authors may still use `### Requirement` and `#### Scenario` blocks when exact machine-addressable scenarios help; those are additional to the derived handle. Pipeline: small Markdown nodes → structural validation → canonical node + edge graph → bounded Component context → pinned planning skills → generated implementation glue.

Source: [docs/architecture/mission-specification-composition.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/mission-specification-composition.md) at commit `fcc40bc`.
