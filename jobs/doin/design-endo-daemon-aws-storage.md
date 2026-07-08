---
role: designer
---

# Design: an AWS storage platform for the Endo daemon (a peer of node / web / endo)

**Repo:** `kriscendobot/endo` — the bot's fork of `endojs/endo` (the Endo monorepo). Work in an isolated per-job checkout: `scripts/jobs/ensure-project-worktree.sh <this-base> kriscendobot/endo master` (confirm the fork's default branch; endojs/endo uses `master`). Endo conventions apply (yarn, lint, changesets). This is a **DESIGN** (spec + toy/scaffold) to be ferried upstream to `endojs/endo` later — **no upstream PR from this job**.

## Mandate
Design a new **AWS platform** for **Endo daemon storage** — a peer of the existing platform modules in `@endo/daemon` (`packages/daemon/src/`: `daemon-node-powers.js`, `daemon-node.js`, `pet-store.js`, `web-server-node*.js`, `worker-node*.js`, …). The maintainer's framing: **AWS is a new platform alongside node / web / endo, and should parallel those modules.**

## Requirements (maintainer)
- **Study the low-level storage interface FIRST** — researcher precedence, read the *actual* code, not memory: the daemon's persistence abstraction (the pet-store / formula store, the content-addressed blob store, and any reader/stream powers) and how the **node** platform implements it (filesystem + **sqlite3** + crypto powers). The AWS platform must implement *that same* interface.
- **DynamoDB** in place of **sqlite3** for the structured/mutable store (formulas, the pet-name graph, etc.).
- **S3** for the **content-addressed store** (blobs keyed by hash) — **or a better-fit AWS primitive if the low-level interface argues for it** (large-blob streaming, small-value inlining in DynamoDB, multipart, range reads, readers). Justify the choice against the interface.
- Parallel the node/web/endo module shape (e.g. `daemon-aws-powers.js` / `daemon-aws.js` analogues); **keep the daemon core untouched** — this is a platform adapter behind the existing powers/interface.

## Consider
- The **ocap/reader model**: content-addressed reads/writes are streams (readerRef) — map faithfully onto S3 get/put + range reads.
- **Consistency semantics**: DynamoDB's model vs. the sqlite transactions the daemon relies on (atomic formula writes, etc.) — call out where semantics differ and how to preserve them (conditional writes, TransactWriteItems).
- **Credentials/config as powers** (no ambient AWS auth; region/table/bucket injected). The garden runs an AWS account (`292378781985`, us-west-1, IAM `garden-fleet`) available for a reference deployment, but the package must be **account-agnostic**.
- **Sibling job:** an analogous CloudFlare storage platform is being designed in parallel (`design-endo-daemon-cloudflare-storage`). Both implement the SAME pre-existing daemon storage interface — stay consistent so AWS and CloudFlare read as two implementations of one abstraction.

## Deliverables
- A **design doc** (placement per Endo norms — a DESIGN.md in the new module/package or under `packages/daemon`) covering: the interface mapping, the DynamoDB schema + the S3 (or better) content-store design, the semantic-gap analysis, the config/powers surface, and a phased build plan.
- A **scaffold + runnable toy/tests** proving the storage interface against AWS (or a faithful local emulator — dynamodb-local / minio / moto — state which).
- Follow-on build job(s) parked `--go-ahead`.

Ground in the real `@endo/daemon` code; keep the daemon core untouched; secrets/creds as injected powers.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 10
  claimed_at: 2026-07-08T05:52:11Z
