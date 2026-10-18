---
gate: go-ahead
priority: normal
posted_by: producer
posted_at: 2026-10-18T21:12:05Z
---

---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# endo-but-for-bots: upgrade the pi family (@earendil-works/*) to 1.x together

Repo: endojs/endo-but-for-bots @ llm. Packages: `packages/agentry`, `packages/agent-tools`, `packages/lal`.

Dependabot proposes the pi packages one at a time. Each 0.87 -> 1.x bump on its own leaves two `pi-ai` copies across a major boundary and breaks the build. #1493 (`pi-agent-core` -> 1.1.0) was closed: CI was red with `TS2322 StreamFn` at `packages/agentry/src/harness/pi-agent.js:82` and 12 failing `@endo/lal` tests in `pi-agent-tools` and `smallcaps-footgun`. #1441 (`pi-tui`) was closed earlier. Upgrade `pi-agent-core`, `pi-ai`, `pi-coding-agent` and `pi-tui` to 1.x together in one PR, adapt the agentry harness and the tests to the 1.x `StreamFn` and agent APIs, and get CI green.

Maintainer decision still open from #1441: all pi versions (0.85+ and 1.x) require Node `>=22.19.0`, while the root `package.json` declares `^20.17.0 || >=22.9.0`. Either give these packages their own Node floor or raise the root floor. That choice affects whether this upgrade should also adjust `engines`.

Parked go-ahead: it is a cross-package feature upgrade, not a bot-routine bump.
