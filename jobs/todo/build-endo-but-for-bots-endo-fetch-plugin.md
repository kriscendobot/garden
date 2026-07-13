---
role: builder
---

Build the `@endo/fetch` unconfined plugin on endojs/endo-but-for-bots (base `llm`) from the just-completed endo-fetch design (draft PR #722, branch `design/endo-fetch`), implementing Phases 1-3 — a `make(powers, context, { env })` plugin composing the merged `makeHttpClientAndControl` (#566) to hand out `client()`/`control()` facets with VFS-backed durable policy and trust-on-first-bind pins, mirroring the `@endo/reminder` plugin (#721); keep the PR DRAFT and surface the design's two open questions (package name; policy-authority re-resolution) in the PR body for maintainer review.
