All work complete. Final report follows.

---

## Completion report: reconcile the two SHA-256 implementations

**Outcome: #903 driven green and mergeable on live `llm`, awaiting a fresh maintainer approval. #836's work absorbed, not lost.**

### Diff inventory (the two implementations)
The directive's premise checked out and inverts in practice: **#836 is already merged** but only into the **frozen** base `llm-bfc91f5` (so `packages/sha256` is invisible from live `llm`); **#903 is open on live `llm`** — the actual merge target.

- **Same public contract** — both expose `sha256` / `sha256Into` with identical `xs`/`browser`/`node`/`default` export conditions. **No API divergence** → step-3 "STOP and report a fork" did not apply.
- **#903 is a strict superset**, not rebase noise:
  - *Cleaner package shape*: shared JS core (`shared.js` + `sha256-js.js`) with thin per-condition wrappers, vs #836 inlining the pure-JS impl into `sha256-browser.js` and a local `assert.js`.
  - *Richer tests*: fast-check property tests, plus `exports`/`shared`/`xs` suites (`sha256-xs.test.js` is 251 lines), vs #836's single test + XS-generation harness.
  - *Actual integration #836 never carried*: daemon `host-tool-powers` (+node/test/types), `rust/endo/xsnap` crypto powers (`crypto.rs`, `lib.rs`, `host_aliases.js`), `packages/git` + `exo-git` backends, the blob-ref migration — i.e. the "unblock the XS daemon bundle" work.
- **Nothing in #836 was materially unique** (its `assert.js`/`generate-test-xs.js` are subsumed). **Nothing needed porting.**

### Carrier choice
**Carrier = #903**, on evidence above: it is already on live `llm`, is a functional superset, and loses nothing from #836. Advancing #836 instead would have meant cherry-picking its (less complete) tree off a dead-end base 254 commits behind and discarding #903's daemon/rust integration — the opposite of the directive's goal.

### Lint disposition — PR-introduced, not the pre-existing flake
The failing `lint` leg was `build:types:check` reporting `Drift detected: packages/git/tsconfig.composite.json`. **Checked before fixing** (per the #873/#652 warning): this is **PR-introduced** — #903 added `@endo/sha256` (and `@endo/hex`) to `packages/git/package.json` without regenerating the composite tsconfig. `yarn build:types:gen` changed exactly that one file (adding the `hex` + `sha256` references). Committed as `a1a18e3f7`, pushed to `pr824-endo-sha256`. **All 26 CI legs now pass; PR is MERGEABLE.**

### Closed-loser cross-reference
#836 is already merged (to the frozen base), so there is no open PR to close. Posted cross-reference comments on **both** PRs recording the absorption: #903#issuecomment-5260891329 (why it's the carrier + the lint fix) and #836#issuecomment-5260891465 (its work carried forward to live `llm`).

### Not merged
Both prior approvals are stale against the current head; the gate correctly refuses. Left green and mergeable, **awaiting a fresh maintainer approval on `a1a18e3f7`** — messaged the maintainer to request it.

### Self-improvement finding + proposed fix
**Why the fleet built it twice:** the **frozen-base blind spot**. A producer scoping "does `@endo/sha256` exist?" reads live `llm`, where the answer is correctly *no* because #836's merge landed on frozen `llm-bfc91f5`. Not isolated — `llm-bfc91f5` strands three PRs (#836/#888/#943) at 254 behind, and frozen-base drift also hit #621/#503/#475/#910. **Proposed fix (structural, sent to `role/liaison`, not landed here):** (1) a producer-side **supersession check** at build-scoping time — search open + recently-merged PRs fleet-wide for the same package/changeset slug across *all* bases before starting net-new work (a single `packages/sha256` search would have caught this); (2) optionally, a policy that new packages land on the live base, with frozen-base merges emitting a fleet-visible "X now exists on frozen base Y" note. Recommended (1) as the narrow, additive first step.

Self-improvement: journal `msgs/role/liaison` proposal (producer-side supersession check + frozen-base merge policy); no role/skill file edited (structural proposal is the liaison's call).

Follow-up owned by others: maintainer approval on #903@`a1a18e3f7`; eventual reconciliation of `packages/sha256` when the `llm-bfc91f5` stack (#888/#943) rebases forward onto live `llm`.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endo-sha256-dedupe-836-903.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 64 tokens (2367126 cached reads)
- Output: 23304 tokens
- Cost: $2.4830870000000007
- Wall-clock: 2348s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
