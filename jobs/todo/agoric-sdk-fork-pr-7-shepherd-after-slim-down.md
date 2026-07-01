# PR #7 — shepherd to green after the slim-down/feedback churn (maintainer directive)
Repo: **kriscendobot/agoric-sdk** (BOT FORK; bot identity; NEVER upstream Agoric/agoric-sdk).
PR #7 — https://github.com/kriscendobot/agoric-sdk/pull/7 — DRAFT, base `master`, MERGEABLE/UNSTABLE.
kriskowal (2026-07-01T00:46Z, comment 4849206632): **"@kriscendobot Shepherd."**
Since the last shepherd, several jobs landed on #7 (slim-to-consume-@endo/hex, apply-richard-feedback,
title/description template, portable xsnap path — all in tada), and CI now has **6 red checks**:
`dependency-graph`, `lint-primary`, `lint-rest`, `test-codegen`, `test-fast-usdc-deploy (node-old)`,
`test-fast-usdc-deploy (node-new)` (63 pass, 12 skipping).
Task: drive them green.
- `dependency-graph` / lockfile: the slim-down added a **`@endo/hex` dependency** — reconcile the
  dependency graph + yarn.lock (separate `chore: Update yarn.lock` commit per the yarn-lock discipline).
- `lint-primary` / `lint-rest`: from the new/changed code — fix lint.
- `test-codegen`: the known **stale `fetched-chain-info.js` on master** — if the master regen hasn't
  merged, leave it as the explained pre-existing red (don't smuggle the regen into #7); else rebase.
- `test-fast-usdc-deploy (node-old/new)`: diagnose from the job log — real regression vs pre-existing;
  fix or explain. Escalate to a **fixer** for anything out of shepherd scope (standing auto-chain).
Finish with a **CI shepherding summary reply comment** on #7 (each red: fixed / explained-pre-existing,
final status). Keep #7 DRAFT unless the chain un-drafts it. Bot fork; no upstream contact.
