---
role: builder
---
<!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-07-11T09:12:37Z -->

---
role: builder
---

# Build: wire the AWS storage platform into a daemon flavour (phases 2-3 of designs/endo-daemon-aws-storage.md)

**Repo:** endojs/endo-but-for-bots, base branch `llm`. Design: `designs/endo-daemon-aws-storage.md` (draft PR #637, branch `design/endo-daemon-aws-storage`); the engines, SDK adapters, emulators, and tests already exist on that branch (`packages/daemon/src/daemon-database-aws.js`, `content-store-s3.js`, `daemon-aws-sdk.js`).

Phase 2: a `makeDaemonicPowers` variant paralleling the assembly in `daemon-node-powers.js` that accepts an injected `DaemonDatabase` (the AWS engine's promise) and an injected content store, plus a `daemon-aws.js` entry that dynamically imports the AWS SDK (optional peer), builds the two client powers from env config (table, bucket, region, key prefix), and runs `makeDaemon`. Includes the two flagged shared touches, each needing maintainer sign-off on the PR: (a) make the `DaemonDatabase` type's `db` handle engine-private/optional, (b) make the content-store maker in `daemon-persistence-powers.js` injectable (or carry a parallel module).

Phase 3: run the engine test suites against dynamodb-local and MinIO through `daemon-aws-sdk.js` (emulator-fidelity), and boot a full daemon on the AWS platform.

Build on a fresh branch off `llm`, rebasing onto whatever of PR #637 has landed by then.
