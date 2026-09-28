---
tier: mentat
dispatch: manual
---
role: designer
handler-timeout: 10800

# Plan: endor / Iron Horse orthogonal persistence of running processes on each platform

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
- How to integrate endor (and specifically Iron Horse) worker snapshotting, i.e. orthogonal persistence of running processes, on AWS, Cloudflare, Hetzner, DigitalOcean, fly.io, and exe.dev.
- Per platform: where snapshots live (content-addressed store), when they are taken (idle only, as Endo's XS-worker snapshot design requires), restore and migration across hosts, compatibility and versioning (engine version, architecture, host-function table), and cold-start and cost implications.
- Compare against KaozKit's approach (garden library `xs-agent-runtimes`), and state what Iron Horse must provide (a stable snapshot format and determinism guarantees) versus what the platform layer provides.
- Output `designs/process-snapshot-persistence-by-platform.md`.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-28T05:54:29Z
