All verified. PR #1014 is open as draft against `llm` with exactly the 6 intended files (CLI + design + changeset; no daemon or http-confine changes), and #286 is closed with an explanatory comment linking the replacement.

## Completion report

**Job:** Rework the stranded `endo http mk` CLI verb from #286 onto `llm`'s policy-based HTTP client, open a new narrow PR, and close #286 as superseded-in-part.

**Delivered:**
- **New draft PR: [endojs/endo-but-for-bots#1014](https://github.com/endojs/endo-but-for-bots/pull/1014)** — `feat(cli): endo http mk on the policy-based HTTP client`, base `llm`, head `feat/cli-http-mk-on-policy-client`. Opened draft; registered via `ensure-pr.sh` (garden-job marker stamped, recorded on the work branch) so the gauntlet state machine supervises it.
- **#286 closed** with a comment explaining the daemon formula was superseded by `@endo/exo-http-client` + `endo-fetch` while the CLI verb was not, and linking #1014.

**What #1014 contains (affected package: `@endo/cli`):**
- `packages/cli/src/commands/http-mk.js` — verb rebuilt to call `E(agent).provideHttpClient(name, policy)`.
- `packages/cli/src/endo.js` — `http` command group + `mk <name>` wiring (`--origin` repeatable + `--max-requests-per-minute`/`--max-response-bytes`/`--policy-mode`/`--as`), plus a **Network** help section.
- `packages/cli/test/http-mk-command.test.js` — adapted to the single-name/policy shape: help-surface tests, daemon-driven registration test, empty-allowlist rejection test.
- `.changeset/cli-http-mk-phase-1.md` — `@endo/cli` minor only (dropped the `@endo/daemon` bump; the capability already landed).
- `designs/cli-http-client.md` + `designs/README.md` — revised to describe the verb on the landed policy client rather than the formula pair that no longer exists (the `llm` design doc was already reconciled as superseded-in-part; I added a "Landed CLI surface (Phase 1)" section and updated status/date).

**Key decisions on the evidence:**
- **Policy vs `allowedOrigins`: no design gap.** `llm`'s host method is `provideHttpClient(name, policy)` (there is no `makeHttpClient`), with policy `{ allowedOrigins, maxRequestsPerMinute?, maxResponseBytes?, policyMode? }`. `--origin` maps directly onto `policy.allowedOrigins`; the daemon's `normalizeHttpClientPolicy` stays the validity authority. So the verb takes a policy, faithfully.
- **Dropped the entire #286 daemon reimplementation** (the collision): `packages/daemon/src/http-client.js` + tests, the `host/formula-type/interfaces/daemon/types.d.ts/help-text-data/help.md/package.json` edits, `formula-type.test.js`, `tsconfig.composite.json`. The daemon wiring the verb needs already exists on `llm`.
- **http-confine change: assessed and NOT carried.** It is not landed on `llm` (still returns the live `response`; `freeze === harden` there). But on the `llm` path `@endo/exo-http-client` already snapshots headers via its own `headersToRecord` and never sends the live `Response`/`Headers` over CapTP — unlike #286's own daemon shape where the bug was observed. Whether `harden()` actually reaches the live undici `Headers` (a getter, not an own data prop) is version-dependent, and CI is pinned to Node 24 where the changeset itself says the slot isn't tripped. Verdict: a *plausible independent Node-22 parity fix* whose relevance to the `llm` code path is unverified — out of scope for this narrow CLI PR; recommended as a separate PR with a Node-22 repro.

**Follow-ups / caveats:**
- **Could not run `pre-push-gates` (format/lint/tsc/ava) locally.** This host's shared yarn cache has hit the ext4 hardlink ceiling (`EMLINK: too many links` on `.yarn/berry/index`), so `node_modules` cannot be linked in any fresh worktree here — a host-infra limit, not a defect in the change. All three JS files pass `node --check`; the code mirrors landed sibling commands (`mktmp.js`/`mkguest.js`) closely. Authoritative lint/type/test will run in CI and the gauntlet's fixer loop will address anything they surface. Worth flagging to the sysop: the EMLINK ceiling will block installs for other jobs on this host until the shared cache is repacked/pruned.
- The maintainer approval on #286 (2026-08-15) was deliberately not carried over; #1014 goes through the normal draft + gauntlet path, and the builder stage now hands off to the panel.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr286-cli-verb-rework.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (1 unmetered)
- Input: 119 tokens (6516388 cached reads)
- Output: 53748 tokens
- Cost: $5.975127 (1 engagement(s) unpriced)
- Wall-clock: 800s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
