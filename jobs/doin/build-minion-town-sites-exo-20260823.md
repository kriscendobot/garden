---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Build the daemon-hosted `@sites` exo so weblet publish serves a live `<hash>.ocap.site`

Repository: kriscendobot/minion.town (private fork). Work from the natural
implementation base (`main`, currently `5e88fe66`), deliver a separate draft
implementation PR, and supervise the normal build gauntlet.

## Why (grounding)

The 2026-08-23 end-to-end production test (kriscendobot/garden#58 comment
5388560000-era press) proved the primary-phase chain live through OAuth-guest
auth → authenticated MCP daemon-guest tool access, including durable daemon
state mutation and scope enforcement. The **one** remaining primary-phase rung —
`weblet_publish` → served `<hash>.ocap.site` — is BLOCKED, tool-verified:
`weblet_publish` against live prod returns `⛔ Unknown pet name "5555…5555"`
(64 fives) and `weblet_list` shows no weblets.

Source-confirmed root cause at deployed HEAD:
- `src/endo/gateway/site-registry.ts:135-136` still ships the placeholder
  `formulaId: "5".repeat(64)` with the comment "The live service replaces this
  local registry with its daemon formula id."
- `src/http.ts:133` still wires `makeSiteRegistry(webletStore, …)` — the
  in-memory scaffold, NOT a real daemon-hosted `@sites` exo.

So publish reaches the register step and fails looking up the placeholder
formula id as a pet name. This is an **un-landed build**, not one of the open
maintainer design decisions — the governing design is already merged
(`designs/weblet-ocap-synthesis.md`, PRs #47/#51).

## What to build

Implement §9 units 1–2 of `designs/weblet-ocap-synthesis.md`:

1. The `@sites` site-registry service as a real daemon-hosted exo (replacing the
   in-memory `makeSiteRegistry` scaffold and the `"5".repeat(64)` placeholder
   formula id), and its endowment at the grant site (`composeFacet`).
2. `E(sites).register(directory)` plus the directory watch that reflects
   `front`/`back` into served content and the CapTP bootstrap.

Read §2 (the `@sites` model), §3 (the redesign — publish is `E(guest).evaluate`
calling `E(sites).register(directory)`; the site watches the directory; the
gateway is a conduit), §4 (where the guest gets `front`/`back`), and the §7
acceptance criteria before starting. Units 3–5 (re-wiring `weblet_publish`/
`weblet_upgrade`/`weblet_list`/`weblet_unpublish`, retiring the powers resolver
and close code 4012, legacy-record disposition, tests) may follow as a separate
chain if this build's slice is naturally bounded to the exo + register/watch;
if they are cheap to include coherently, include them and their §7 tests.

## Acceptance

The load-bearing acceptance is the exact e2e negative that is currently
failing: with a real guest-scoped token, `weblet_publish` of a static
`index.html` must succeed (no `Unknown pet name` error), `weblet_list` must show
it, and `GET https://<hash>.ocap.site/` must serve the content with the
origin-isolation header set (content-addressed `etag`, restrictive CSP, COEP/
COOP/CORP). Cover the §7 acceptance criteria with tests.

If a missing generic primitive must land in kriscendobot/endo-but-for-bots
first, do not fake it locally: post a dependency job, block this on it, and
carry the chain through.

Do not run `deploy/aws/scripts/deploy-cognito-guest-scope.sh` or make any AS/
Cognito change as part of this build — that is a separate maintainer AS-config
step tracked independently.

Originating directive: the standing minion.town press on kriscendobot/garden#58
(issue_spine: issue-kriscendobot-garden-58), 2026-08-23 e2e prod test next-action #1.

<!-- garden-reaped: 2 -->

<!-- garden-reap-now -->
---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-08-23T23:23:16Z
