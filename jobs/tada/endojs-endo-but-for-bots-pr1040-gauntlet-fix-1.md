Confirmed: head is my commit `91e55f986`, all 27 checks green, 0 pending, 0 failures.

## Completion report — Gauntlet FIX round 1, endojs/endo-but-for-bots PR #1040

Applied the panel-1 request-changes must-fix items to the `@endo/hardened262` package in one review-feedback follow-up commit (`91e55f986`), pushed to the PR head (`kriskowal-hardened262`) via `safe-push-pr-head.sh`, and drove CI to green.

**Must-fix items addressed:**
- **Silent scenario drop** (assessor/breaker/purist/spec-keeper): `scripts/test.js` `runTests` generated the full agent × mode × lockdown × compartment cross product but dispatched only `module`/`lockdownModule`, dropping every sloppy/strict and `compartment` scenario with no output. Rewrote `runTests` so any scenario no agent runs yet is reported as an explicit `skip` (via `agentRunsScenario`), so a run and `--list` enumerate the same scenarios; reporters (`terseEnd`/`compactEnd`) render the skip state. README documents this. Verified locally: `module`/`lockdownModule` pass on `sesNode`, all others print `skip`.
- **Unhandled `spawn` error** (assessor/saboteur/breaker): added `child.on('error', reject)` to both `scripts/agents/node.js` and `scripts/agents/xs.js`, so a missing/unspawnable binary (e.g. `xst` off PATH) fails loud instead of hanging the awaited promise forever.
- **New-package convention** (packager/migrator): `package.json` version → `0.1.0`; seeded `CHANGELOG.md` with the standard stub; added a `major` initial-release changeset (`.changeset/add-endo-hardened262.md`).
  - **Caught a conflict the jurors missed:** `test262-stream` reads *this package's* `package.json` version as the "corpus version" and rejects anything outside major 1–5 — so a bare `0.1.0` breaks the harness at runtime (why the author had used `1.0.0`). Resolved by passing `acceptVersion: corpusVersion` (read from the package's own `package.json`) to the `TestStream` constructor, satisfying both the `0.1.0` convention and the runtime. Verified the harness runs.
- **Typist code points** (typist): `×`→`x` in `README.md`, `…`→`...` in `node-helper.js` comment.

Local gates before push: `eslint` (0 errors; one pre-existing await-separator warning untouched), `tsc` (clean), `prettier --check` (clean), `node --check` on all edited JS.

**CI:** GREEN — all 27 checks pass on head `91e55f986`. Two jobs (`browser-tests`, `sandbox-drivers`) hung on a bad runner window (30-min timeout / 1h+ no step progress) unrelated to the `packages/hardened262`-only diff; cancelled + reran each on fresh runners and both went green in normal time.

**Follow-ups (not applied — out of scope for an append-only fix stage):**
- packager #3 (`yarn.lock` bundled into the feat commit rather than a separate `chore:` commit) needs a history rewrite/retcon, not a follow-up commit; my changes introduce no new lockfile churn.
- Deeper design items left as should-fix/comment-only by the panel (Compartment-axis execution not implemented; harness has zero CI reach; spec citations in the corpus) are named gaps for a later design pass, not round-1 must-fixes.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1040-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 8 on 2 host(s) (5 unmetered)
- Input: 145 tokens (7878518 cached reads)
- Output: 44405 tokens
- Cost: $6.270919 (5 engagement(s) unpriced)
- Wall-clock: 4043s
- Model(s): claude-opus-4-8 ×3

<!-- garden-usage-end -->
