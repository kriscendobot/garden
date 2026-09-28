---
tier: mentat
dispatch: manual
---
role: designer
handler-timeout: 10800

# Plan: finish minion.town distributed persistence on AWS (S3 + DynamoDB)

Repo: `kriscendobot/minion.town` (design lands under `designs/` per that repo's conventions; follow the
garden designer norms in `roles/designer/AGENT.md`, including the open-questions review-PR carve-out). Cross-repo
design implications for Endo belong in a clearly marked section, not in edits to `endojs/endo-but-for-bots`.

## Maintainer framing (kriskowal, 2026-09-28)
A core notion of minion.town is that it scales to a distributed system by taking advantage of platform persistence
(S3 and DynamoDB on AWS). This works because the **Pet Daemon capabilities are generic and precise enough that the
database (formula store) and the content store can be replaced with platform-specific variants.** The work is to plan
finishing that on AWS (already planned), to plan the analogous stand-up on other backends, to integrate
endor/Iron Horse orthogonal persistence of running processes, and to shard by principal.

## Read first (prior art, verify each against the code)
- minion.town: the provider portability boundary (`src/` has no AWS SDK imports; adapters load by config, e.g.
  `ACCOUNT_STORE=dynamodb`; `src/auth/stores/dynamodb.ts`, `src/billing/stores/dynamodb.ts`),
  `designs/git-content-substrate.md`, `designs/clip-usage-metering.md`, `designs/clip-formula-id-origin-and-content-gc.md`,
  the deploy tree `deploy/aws/`, and `DEPLOYMENT.md`.
- Endo (`endojs/endo-but-for-bots`, branch `llm`): the daemon formula/persistence and content-store interfaces, the
  designs README entries for `daemon-xs-worker-snapshot`, `snapshot-mapper`, and `@endo/thixotrope` (orthogonally
  persistent ocap machine with XS and Iron Horse worker engines), and metering designs.
- Garden library (`journal/library/`): topics `xs-agent-runtimes`, `persistence`, `capability-security`, and the
  concept `xs-heap-snapshot-agent-persistence` (KaozKit, ingested 2026-09-25).
- Sibling mentat jobs posted together (read whichever have already landed, and cross-reference them):
  `mentat-minion-town-aws-distributed-persistence-plan`, `mentat-minion-town-cloudflare-backend-plan`,
  `mentat-minion-town-alt-hosts-backend-plan`, `mentat-minion-town-endor-ironhorse-snapshot-platforms`,
  `mentat-minion-town-per-principal-sharding`.

## Ground rules
Planning only: no deployments, no cloud accounts or resources created, no spending. Vendor facts must come from
current first-party documentation, with citations and "as of" dates; flag anything uncertain or pricing-sensitive
rather than guessing. Complete via the normal completion path. The report should name the design file, PR (if
any), the open questions for the maintainer, and a proposed build sequence (as suggested job basenames, not posted).

## This job
- Find the existing AWS persistence plan (the maintainer says this was already planned); reconcile it with the current code, and name what is done, what is missing, and in what order to finish.
- Map each Pet Daemon persistence interface (formula store, content-addressed store, any others) onto AWS: DynamoDB tables/keys/indexes and consistency, S3 layout/addressing/GC, and the coordination primitives needed for multiple daemon hosts (leases, fencing, ordering).
- Operational plan: migration from the single EC2 box, backup/restore, cost model at a few scales, failure modes, and how metering (`clip-usage-metering`) maps.
- Output `designs/aws-distributed-persistence.md` (or refine the existing plan document in place if one exists).
