---
title: Common confusions
source: designs/chat-playwright-smoke.md
source_repo: endojs/endo-but-for-bots
source_branch: design/chat-playwright-smoke
source_commit: 2a97b2d6c4c0e1714631fc42f6c34cd78e18db5b
source_date: 2026-05-06
source_authors: [Kris Kowal]
topics: [chat-ui, testing]
status: current
notes: |
  **Status: Not Started** upstream. The implementation cluster of the
  chat-playwright-smoke design: three steps (build, serve, exercise) plus
  CI integration, with two acceptable serve approaches enumerated and a
  preference for extending the existing static-file server over adding
  an `http-server` dependency.
parent: endo-but-for-bots--llm-designs-chat-playwright-smoke--build-serve-and-playwright-fixture
---

- **"Why not just add `http-server` as a dependency?"** The design's preference for Approach 2 is that *the dependency surface should stay minimal in a security-sensitive workspace*. `http-server` is a small, widely-used package, but every dependency is one more thing to audit; the static-file server pattern in `browser-test/server.js` is already there. The design *allows* Approach 1 but prefers Approach 2.
- **"The 30s timeout is arbitrary."** It is the canary spec's timeout, chosen to absorb cold-start variance in CI runners. A faster bundle (or a regression that fails fast) doesn't pay the full timeout; a slow bundle (or a transient CI lag) is given enough time to load. The number is a single-knob value with a clear rationale.
- **"What if the bundle loads but the WebSocket fails?"** The smoke navigates *without* a fragment, so the entry point never attempts a WebSocket connection. The fragment-less path is a deterministic daemon-free fallback. If a future change makes the WebSocket connection attempt unconditional, the smoke would catch it as a `pageerror` (because the WebSocket connection would fail without a daemon) — which is the correct outcome: the bundle would no longer be running in a daemon-free environment without throwing.
- **"What if approach 1 and approach 2 are both impractical?"** The design enumerates exactly these two; the maintainer's choice is between them. If both prove problematic in implementation, the design's prompt invites a follow-up dispatch to revise the approach — but the design notes "either path is acceptable" before recommending approach 2, signaling the design is implementation-flexible.
- **"`vite.config.js`'s `base: './'` is fragile."** It is *required* for the smoke to work — without a relative base, the bundle's asset URLs would be absolute and the `/chat/` prefix would not work. The smoke implicitly depends on this Vite config; a regression that changes `base:` would be caught by the smoke (assets would 404) and the engineer would update both the Vite config and the smoke together.
