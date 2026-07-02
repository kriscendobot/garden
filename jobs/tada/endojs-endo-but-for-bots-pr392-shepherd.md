State is unchanged since the stale 2026-06-03 run (head unchanged, base tip == base_sha, still draft, still `unstable`). Nothing to re-run — the failure is deterministic version-drift, not a flake, so a re-run would reproduce it. This is a structural impasse: no shepherd-scoped code fix and no in-diff fixer fix exists; the resolution is refreshing the stale stack's dependencies/base onto current master, which is a merge-order/structural decision the maintainer owns (and this is an intentionally-stacked, parked draft). I made no commits — there is no in-scope repair to push.

---

## Shepherd report — endojs/endo-but-for-bots PR #392

**Verdict: escalate. `next: liaison`** (structural / merge-order decision on a parked draft stack; not auto-advanceable).

**Live CI state (head `7f98b99`, re-confirmed):** RED. Failing: `lint`, all 8 `test (…)` matrix legs, `cover (20.x)`, `cover (24.x)`. Passing: build, build-wasm, xs, hermes, python, test262, sandbox-drivers, zizmor, etc. Runs are a month stale (2026-06-03); head + base tip both unchanged since.

**Root cause — base-staleness infra drift, NOT this PR's diff:**
- Crash is `TypeError: results.values(...).filter is not a function` at `emittery-2.0.0/index.js:780` inside ava's `Api.emit`, hit while testing packages the PR never touches (`@endo/immutable-arraybuffer`, `@endo/where`, `@endo/cache-map`). Deterministic across every failing leg — not a flake.
- The PR head's `yarn.lock` carries a **dual** emittery resolution (`^1.2.0`→1.2.0 and `^2.0.0`→2.0.0); current **master consolidated to a single `^2.0.0`→2.0.0** and **master CI is green**. This is the known ava↔emittery version-drift breakage that master already fixed via a dependency/lockfile bump.
- PR #392 is a **DRAFT** at the top of a **4-deep, fully-unmerged stack** (phase 4 → base `design/gateway-package-phase-3` (#389) → phase 2 → …); the stack bottom is **127 commits behind** master and untouched since 2026-06-03. `mergeable_state: unstable` (no conflicts — weaver-for-conflicts does not apply).

**Why not fixed here:** There is no gateway-code fix — the failure is repo-wide dependency drift. A lockfile dedupe alone would be speculative (master's fix rides a `package.json`/ava bump, not just a re-resolve). The correct remedy is refreshing the stale stack's dependencies/base onto current master, but rebasing/retargeting a mid-stack **draft** PR (which would balloon the "phase 4" diff to include phases 1–3, or reorder merges) is a **structural / merge-order decision the maintainer owns** per the shepherd hard-escalation points. The stack is also plausibly parked intentionally (month-old, quiet drafts).

**Recommended maintainer action:** rebase/refresh the gateway phase stack onto current master (picking up the emittery/ava lockfile fix) in the intended merge order — or confirm the stack is parked and CI-red is expected for now. Once the stack is refreshed onto green master, these failures clear without any change to #392's own semantic diff.

**Follow-up (optional, low value):** shepherd role could note that stale long-lived stacked *draft* PRs commonly fail on base-infra drift (here ava/emittery) rather than their own diff; classify as `next: liaison` (structural refresh), not `next: fixer`. The existing "structural decision needed" impasse already covers this, so no role edit is warranted.
