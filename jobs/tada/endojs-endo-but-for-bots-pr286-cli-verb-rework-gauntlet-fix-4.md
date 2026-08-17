CI reached terminal GREEN (rc 0): 26 checks, 0 failed. All four panel round-4 must-fixes are pushed and verified.

## Completion report — Gauntlet FIX round 4, PR #1014

Applied the panel's round-4 must-fix items once, pushed as follow-up commit `aa5f94f898` to the PR head (`feat/cli-http-mk-on-policy-client`), and drove CI to terminal.

**Fixes applied:**
1. **Stderr echo false "daemon-verbatim" claim** (archivist/engine-realist/typist/wire-watcher) — corrected the `http-mk.js` success-echo comment and the `.changeset/cli-http-mk-phase-1.md` prose: the echoed allowlist is the CLI's own **locally-normalized** policy, not a daemon read-back (`provideHttpClient` returns the minted client, and its return value is discarded).
2. **Nonexistent CI Node-24 pin** (engine-realist) — corrected `designs/cli-http-client.md`: the `harden(Headers)` crash path is unreached because no test dials out through the confined client, not a CI pin; noted CI actually matrixes Node 22.x + 24.18.0 and `packages/cli` supports `^20.17.0 || >=22.9.0`.
3. **Completion-summary process gap** (scribe) — posted a retroactive top-level summary ([comment #5315443004](https://github.com/endojs/endo-but-for-bots/pull/1014#issuecomment-5315443004)) mapping every round-1→4 must-fix to its addressing SHA.
4. **Missing canonicalization/rebind coverage** (corner-prober) — added tests for the exact claimed forms: IDN-punycode host, IPv6 literal (`[::1]` default-port strip), and `:0`/`:65535`/`:65536` port boundaries; plus a survives-when-granted rebind test (a `copy`-created second edge to the first client survives rebinding the other name). Noted the collected-when-unreferenced branch is daemon-internal with no Phase-1 CLI observability.

**Verification:** `http-mk-command.test.js` 29 tests pass locally; ESLint clean on changed files; **CI GREEN** (26 checks, 0 failed).

**Follow-ups:** none blocking. The driver re-posts panel-5. Non-blocking should-fixes (typist `Partial<…>` JSDoc, coverage-auditor c8 note) remain surfaced, not treated as covered.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr286-cli-verb-rework-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s) (1 unmetered)
- Input: 80 tokens (3001805 cached reads)
- Output: 23382 tokens
- Cost: $2.8783255000000003 (1 engagement(s) unpriced)
- Wall-clock: 1033s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
