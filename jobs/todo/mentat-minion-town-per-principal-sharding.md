---
tier: mentat
dispatch: manual
---
role: designer
handler-timeout: 10800

# Plan: shard minion.town by principal (user / guest / agent)

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
- Rearchitect each offering (AWS, Cloudflare, the alt hosts) so that every user, guest, and agent has its own **key material, database shard, and independent content-addressed store**, plus its own **orthogonally persistent formula-manager worker** and however many additional workers it wishes to create, **bounded only by metering**.
- Cover: principal identity and key management (per-principal keys, rotation, recovery, including SIWE guest recovery per `designs/siwe-guest-recovery.md`); shard routing and placement; cross-shard capability references (how an OCapN sturdy ref crosses shards); isolation guarantees; metering and quota enforcement per principal; and noisy-neighbor and cost controls.
- Per-platform realization (e.g. a Durable Object per principal on Cloudflare; a partition key and prefix per principal on AWS; machine per principal on fly.io), migration from today's shared daemon, and the operational cost of many small shards.
- Output `designs/per-principal-sharding.md`.
