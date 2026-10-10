---
title: HTML observability: performance, workflow, health, and dashboard views
source: docs/architecture/html-observability.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-29
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
topics: [agentic-sdlc, testing]
status: current
---

> Abstract: The performance-history, workflow-routing, version-check, lock-health, and verification-health surfaces each render an existing producer's report verbatim with bounded reads and no recomputed verdicts, working without JavaScript; verification-health deliberately excludes the HTML-artifact gate to avoid self-reference, and an offline dashboard shell composes already-rendered per-project artifacts via relative iframes with no rollup.

**Performance history.** Renders existing diagnostic `PerformanceSpan` records as run, stage, duration, and failure history, reading at most the 4,096 newest records and stating when older rows were omitted. An empty log is shown as unavailable history, not evidence that builds passed; native duration bars need no chart library.

**Workflow routing.** Reads only the manifest's declared workflow and routing roots; workflow Markdown is normalized by the existing planner, routing JSON retained verbatim, and each entry carries the SHA-256 of its source bytes. Traversal is bounded and rejects links or paths outside the declared root; it exposes stage dependencies and routing policy without creating another executor or router.

**Dashboard.** `litai render dashboard --root ROOT --project PROJECT ...` is the Phase 3 offline composition shell: each selected project contributes its declared, already-rendered `html_render_requests`, and missing, edited, foreign, or unrecognized artifacts refuse the whole dashboard. The shell records each artifact digest and embeds only relative iframe references, with no live refresh, discovery daemon, or correctness rollup; each pane keeps its own provenance and verdict, and existing foreign dashboard output is preserved.

**Version-check health.** Calls `check_versions(require_project=True)`, validates its published schema, and binds the canonical JSON bytes, retaining the `literate-ai/version-check@1` discriminator and all diagnostics. It does not recompute the producer's `ok` or turn a policy-permitted missing release tag into a failure; schema-catalog diagnostics are labeled as diagnostics, not a passing verdict. Readable without JavaScript or network; supports `inline-only`. The timestamp describes an observation, not continuous monitoring, and version agreement runs no builds, tests, or `verify`. Installed-wheel screenshots (`330dd21a`, desktop and mobile, collapsed and expanded, script disabled) are retained review evidence.

**Lock health.** Renders the shared verifier observation under the v2 lock-health schema: each committed Component lock's path, current/not-current/error state, full lock-command report, and any refusal, with resolution identities, providers, and artifact-check diagnostics in native expandable sections. Repository failure leaves Component checks unobserved, and Components without committed locks are outside the gate; neither is shown as success. It calls shared lock orchestration in `adapters/component_lock_commands.py` and `adapters/repository_lock_commands.py`, never the CLI or full verification, so it cannot recurse through the HTML gate, and computes currentness from inputs and artifact checks rather than a stored audit. Wheels `3b0f941d` and `64e6dbe0` passed installed qualification, the latter across current, missing-audit, malformed-lock, and empty fixture states (16 browser cases, desktop/mobile, JavaScript on/off); full-suite and hosted qualification remain open.

**Verification health.** Renders the existing `literate-ai/project-verify@1` report through a shared read-only adapter, preserving gate diagnostics, counts, and verdict. It observes authority, locks, source intelligence, and the test receipt but excludes the HTML-artifact gate, since including it would make the report's source identity depend on its own output; the page discloses this and labels its verdict "Selected gates". Ordinary `litai verify` still evaluates all five gates. Skips are shown separately from passes, observation builds and tests nothing, and the adapter refuses unavailable or malformed reports, wrong scope, unexpected gate coverage, or inconsistent counts and verdict.

Source: [docs/architecture/html-observability.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/html-observability.md) at commit `fcc40bc`.
