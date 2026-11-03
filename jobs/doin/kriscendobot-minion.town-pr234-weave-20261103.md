---
posted_at: 2026-11-03T18:06:34Z
role: weaver
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# weave kriscendobot/minion.town#234 onto current main

Repo: kriscendobot/minion.town. PR: https://github.com/kriscendobot/minion.town/pull/234
(`probe/invitation-roundtrip`, base `main`). Its sibling #233 (MCP `invite`/`cancelInvite`)
merged 2026-11-03T15:32Z as `3f6c2b2`, and #234 now conflicts with `main`: the proxy
screen's conductor (`screen-minion-town-pr234-bb6f1be-conduct-r3`) hit a content conflict
in `src/web/guest-web-router.ts` at commit `10a59872` ("answer bad contact names and
forgotten-contact replays honestly") and stopped with `needs-weave`.

Pin the merge base: snapshot current `main` to a frozen `main-<short-sha>`, rebase the head
onto it, resolve the `guest-web-router.ts` conflict keeping both #233's and #234's
behavior, run typecheck + vitest locally, force-push the head, and move the PR base.
Leave the PR out of draft; the proxy screen re-screens the new head and posts the merge.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-11-03T18:07:29Z
