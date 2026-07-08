---
role: designer
---

# Design: a CloudFlare storage platform for the Endo daemon (a peer of node / web / endo)

**Repo:** `kriscendobot/endo` — the bot's fork of `endojs/endo`. Isolated checkout: `scripts/jobs/ensure-project-worktree.sh <this-base> kriscendobot/endo master` (confirm the default branch). Endo conventions apply. **DESIGN** (spec + toy/scaffold), ferried upstream later — **no upstream PR from this job**.

## Mandate
Analogous to the AWS storage-platform design (`design-endo-daemon-aws-storage`): design a new **CloudFlare platform** for **Endo daemon storage** — a peer of the node/web/endo modules in `@endo/daemon` (`packages/daemon/src/`: `daemon-node-powers.js`, `daemon-node.js`, `pet-store.js`, …), **paralleling those modules**.

## Requirements (maintainer)
- **Study the low-level storage interface FIRST** (same as the AWS job — read the real pet-store / content-addressed store / reader powers and the node implementation: filesystem + sqlite3 + crypto). Implement *that* interface.
- Map onto **CloudFlare primitives**, choosing the best fit and justifying each against the low-level interface:
  - **D1** (serverless SQLite) is the nearest analog to the daemon's **sqlite3** store — likely the closest port; evaluate it first for the structured/mutable store (its SQLite compatibility may let much of the existing store logic port directly).
  - **R2** (S3-compatible object storage) for the **content-addressed** blob store.
  - **KV** / **Durable Objects** where they fit better — DO for stateful per-daemon coordination + strongly-consistent transactional storage; KV for small eventually-consistent values.
- Parallel the node/web/endo module shape (e.g. `daemon-cloudflare-powers.js` / `daemon-cloudflare.js`); **keep the daemon core untouched** (platform adapter behind the existing powers/interface).

## Consider (the runtime differs — surface it)
- **CloudFlare's platform is Workers** (V8 isolates, **not** Node) **+ Durable Objects** for stateful/transactional needs. The Endo daemon's execution context on Workers/DO is more than storage — scope this design to the **storage** platform primarily, but **surface the runtime implications** (what a Workers/DO-hosted daemon requires; where the node powers assume a long-lived process/filesystem that Workers don't have).
- **Transactional semantics**: D1 / Durable Object transactional storage vs. the sqlite transactions the daemon relies on (atomic formula writes) — where they differ and how to preserve them.
- The **ocap/reader model**: content-addressed streams onto R2 get/put + range reads.
- **Config/powers injection**: no ambient CloudFlare auth; account/bindings (D1/R2/KV/DO namespaces) injected as powers; account-agnostic.
- **Sibling job:** the AWS platform (`design-endo-daemon-aws-storage`) is designed in parallel — both implement the SAME pre-existing daemon storage interface; stay consistent.

## Deliverables
- A **design doc** (Endo-norm placement) covering: the interface mapping, the D1 schema (or DO/KV choice) + the R2 content-store design, the semantic-gap and runtime analysis, the config/powers surface, and a phased build plan.
- A **scaffold + runnable toy/tests** against CloudFlare primitives or local emulators (miniflare / `wrangler dev` / workerd) — state which.
- Follow-on build job(s) parked `--go-ahead`.

Ground in the real `@endo/daemon` code; keep the daemon core untouched; bindings/creds as injected powers.
