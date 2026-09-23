---
role: fixer
priority: high
posted_by: liaison
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# minion.town: raise the /mcp JSON body limit to 2 MB

Repo (PRIVATE): `kriscendobot/minion.town`. Per-job checkout via
`scripts/jobs/ensure-project-worktree.sh <this-base> kriscendobot/minion.town main`; follow that
repo's landing conventions (PR vs direct-to-main) as documented in the repo.

## Maintainer decision (kriskowal, 2026-09-23 muster)
> Raise the floor for /mcp to two megabytes. We have plans to enable the use of git HTTP for
> submitting assets out-of-band. At that point, it will make sense to lower the floor to closer to 64KB.

## Why
CLIPOMETER's real-`@endo/captp` esbuild bundle cannot be published: the publish body is ~206 KB, and
`/mcp` rejects bodies over Express's default **100 KB** with HTTP 413 (probed: 99.1 KB → 200,
101.1 KB → 413). The global `app.use(express.json())` is at `src/http.ts:314`, after the
Stripe webhook raw-body route.

## Ask
- Raise the limit to **2 MB for `/mcp` ONLY**, e.g. mount `express.json({ limit: '2mb' })` on the `/mcp`
  route (or check the path before the global parser), and keep the global default (100 KB) for every
  other route. Do not disturb the Stripe `/billing/webhook` raw-body ordering.
- Put the limit in ONE named constant with a comment recording the plan: it is temporary headroom
  until git-HTTP out-of-band asset submission lands, after which it should drop to ~64 KB.
  Reference this decision by date.
- **Audit every upstream cap** on the `/mcp` path and raise it to at least 2 MB where lower: Caddy
  (`request_body max_size` or similar in `conf.d/*`), any ALB/API Gateway in front, and any proxy
  inside the app. Report each layer's limit before and after.
- Tests: a 1.5 MB JSON body to `/mcp` is accepted (not 413), a body over 2 MB gets 413, and a
  non-`/mcp` route still rejects over 100 KB.
- Land, let the normal CD deploy run, then verify LIVE (read-only apart from the probe): send a
  ~1 MB JSON body to `https://minion.town/mcp` and confirm the response is NOT 413 (an auth error is
  fine and expected; the point is that the body is accepted by the parser and every proxy). Report
  the live status code.
- Complete the job via the normal completion path when done.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-23T20:28:25Z
