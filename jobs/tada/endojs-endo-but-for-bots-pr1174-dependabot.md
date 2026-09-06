---
handed-off: fix-endo-daemon-better-sqlite3-v13-ci
deliverable-complete: false
---
PR is OPEN, not merged, no auto-merge enqueued — correct for a HELD verdict. Inbox empty. The botanist review is complete end-to-end, with the terminal verdict deferred to the posted fixer + existing daily backstop.

---

## Completion report

**Job:** botanist review of Dependabot PR endojs/endo-but-for-bots#1174 — `better-sqlite3` 12.11.1 → 13.0.3 (major, direct prod dep of `@endo/daemon`).

**What I did (full workflow):**
- **Base-ref census (step 1, mine to do):** base `llm` resolves `better-sqlite3` at 12.11.1 (range `^12.0.0`); PR targets 13.0.3 — a genuine major bump, not superseded (head fully rebased mid-review, ahead 1 / behind 0). Sibling-PR leg already cleared by the watcher.
- **Diff shape:** clean — only `packages/daemon/package.json` + `yarn.lock`.
- **Transitive set:** net **reduction** — v13's N-API move drops the whole `prebuild-install` subtree (16 packages removed); only `node-addon-api@8.9.2` (official Node.js pkg, no install hooks) and `better-sqlite3@13.0.3` added. No new license; nothing <24h old.
- **Install:** scripts-disabled confirmed (`enableScripts: false`, node_modules present).
- **Source/API read:** v13 is an internal N-API refactor, not a public-API break; daemon uses only stable `Database/prepare/exec/get/all/run/close/pragma`. Stale `fix/daemon-better-sqlite3-v13` probe branch carries no source changes → no migration required.
- **Advisories (both sides):** OSV clean for every moved package. No CVE closed or opened.
- **Provenance:** strengthened — both sides published via GitHub Actions OIDC; v13.0.3 ships **no install script** (v12 ran `prebuild-install || node-gyp rebuild`).
- **Maturity:** satisfied — freshest moved version `node-addon-api@8.9.2` (2026-08-12T21:10Z), floor +7d = 2026-08-19, ~25d past.
- **Shepherded CI:** across 2 full runs + a failed-job re-run, the `test` legs are **reliably red** on `@endo/codex-sandbox › codex-client › …quarantined turn` (concurrency test) with `Failed to exit`/SIGINT teardown noise + a `node24 … No such file or directory` runner error. Base `llm` is green on all `test` legs across the last 4 runs, and the concurrent `electron` dependabot PR is green. codex-sandbox has no better-sqlite3/daemon dep and byte-identical code to base ⇒ the channel is shared-runner timing/resource contention from the daemon loading a from-source-compiled N-API better-sqlite3 v13 (worker-thread/process-exit behavior change).

**Verdict:** **HELD — not MERGE-NOW** (CI is a hard prerequisite and is reliably unmet). Not REJECT — the upgrade is benign, mature, advisory-clean; the failure needs project-code investigation, not a mechanical bump migration, and an escalation is in flight.

**Disposition executed (bot-owned repo):**
- Verdict comment posted on #1174 (as kriscendobot): https://github.com/endojs/endo-but-for-bots/pull/1174#issuecomment-5562252377
- Dependabotany ledger row recorded (canonical slug `endo-but-for-bots` — I caught and corrected an initial entry that used the minority `endojs-endo-but-for-bots` slug the daily backstop's grep would have missed).
- Daily backstop `dependabotany-recheck-endo-but-for-bots` already exists (confirmed).
- Escalation fixer job posted: `fix-endo-daemon-better-sqlite3-v13-ci` (carries the full diagnosis so it isn't re-derived).
- PR left **OPEN**, not merged, no auto-merge enqueued.

**Follow-ups:** the fixer job drives CI green (harden the codex-sandbox concurrency test and/or fix a daemon v13 open-handle/process-lifecycle interaction); once green, the daily backstop re-renders the terminal MERGE-NOW verdict (all other gates already pass). If v13 proves unabsorbable, the fixer reports back for a REJECT.

The terminal verdict is not yet rendered — it is owned by the posted fixer successor plus the existing daily backstop, so this attempt is a declared handoff rather than a clean completion.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1174-dependabot.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 124 tokens (6464177 cached reads)
- Output: 56310 tokens
- Cost: $6.008739500000001
- Wall-clock: 4436s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
