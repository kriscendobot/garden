The deliverable is complete and verified. Draft PR **#1015** is open against `llm`, and the build auto-runs the gauntlet next per the standard build flow.

---

## Completion report

**Job:** Builder — implement `@endo/claude` per merged `designs/endo-claude.md` (child of the `pr995-endo-claude-orch` orchestration).

**Deliverable:** draft PR **[endojs/endo-but-for-bots#1015](https://github.com/endojs/endo-but-for-bots/pull/1015)** against `llm` (head `endo-claude-package`), opened via `ensure-pr.sh` identity reconciliation (garden-job marker embedded, journal `work/` pointer recorded).

**Affected packages:** `@endo/claude` (new), `@endo/claude-sandbox` (extended).

### What I built
The design is very large and rests on several unbuilt prerequisites; per its own guidance ("a gap-revealing DRAFT is acceptable over a wrong committal"), I implemented the **dependency-injected confinement core** the design names as the testable spine (no live `claude`, no daemon):

- **`tool-permissions.js` (DD2)** — one pinned, pre-pruned `tools/list` snapshot as a hardened null-prototype record (never a `Map`) driving both the `--allowedTools` list and the server-side dispatch check; `__`/dunder/code-eval/charset-violating names pruned at the boundary; empty post-prune catalog is a hard error.
- **`argv.js` (DD1)** — the five-flag spawn-refusal predicate, `--tools`/`--setting-sources` empty-value assertions, pinned-`2.1.232` version gate, prompt delivered on stdin at no argv index (construction invariant), never `--resume`/`--continue`.
- **`child-env.js`** — a constructed env allowlist, not inherited-minus-one.
- **`credentials-pool.js` (DD5)** — allocator with swappable `selectSubscription`, reject-with-a-tag admission, occupancy freed on every exit path.
- **`harness.js` (DD4/DD8)** — `make` → host-only non-passable provider; `makeGuestInference` → per-guest `infer` exo carrying no designator; the hardened/passable DD8 result taxonomy; DI seams for broker/spawn/pool.
- **`shim.js`** — opt-in v1 stopgap stdio MCP `bin`, marked for deletion once `@endo/agent-tools` lands.
- **`@endo/claude-sandbox`** — extended `ClaudeCredentials` with the `subscription` kind at all three sites (factory/module admit; env-var-routed client-module explicitly refuses it).

### Verification evidence (actually run)
- `@endo/claude`: **56 tests pass** (ava), including fast-check property tests for the argv construction invariant, the five-flag refusal over every strict subset, the env allowlist over a hostile parent env, the value assertions, the allow-list round-trip, and an `fc.commands` pool-lifecycle-never-strands model. `eslint` clean, `tsc` clean.
- `@endo/claude-sandbox`: all tests pass, including 2 new subscription-kind tests. `eslint` clean.
- `scripts/check-package-uniformity.mjs` exit 0; composite tsconfigs regenerated (`generate-composite-tsconfigs.mjs`); pre-push probes `no-inline-import-jsdoc`, `typedefs-belong-in-dts`, and `spell-out-identifiers` report clean for `packages/claude`.
- Two changesets: `add-endo-claude` (major) and `claude-sandbox-subscription-kind` (minor). `yarn.lock` churn isolated in its own `chore:` commit.

### Assumptions noted in the PR body (where an open question blocked a choice)
Inference-trigger shape, model default (`pinnedModels[0]`, membership-validated), operator-set pool weights + cooling flag, best-effort rarer-failure payloads, and "managed settings assumed not suppressible." Named prerequisites left for follow-on: the `@endo/agent-tools` MCP adapter, the live negative-and-positive confinement test against a real `claude -p`, the `--bare`+`apiKeyHelper` subscription credential-path verification, the DD7 credential-attenuation residual, the entitlement question, and the DD6 slice network profile.

### Notes / caveats
- The workspace `yarn install` under the default pnpm linker fails host-wide with `EMLINK: too many links` on an exhausted yarn-berry hardlink-index inode (`b878c11a…dat`); I installed this worktree via the copy-based `node-modules` linker to run tests. This is a host-infra issue worth surfacing to the sysop/maintainer (it will bite any fresh worktree install), not a defect in this change.
- Base is `llm` (explicitly directed by the job and design, and consistent — I edited the `llm` version of `claude-sandbox`). The gauntlet auto-runs on this draft PR under the standard build flow; no separate "run the gauntlet" is needed.
- Test load-bearingness: the property/unit tests directly exercise each confinement branch (e.g. dropping a required flag makes the refusal property fail), though I did not run an explicit per-test mutation pass.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-endo-claude-build.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 250 tokens (30015315 cached reads)
- Output: 153734 tokens
- Cost: $21.990242500000004
- Wall-clock: 2104s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
