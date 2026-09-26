Diagnosis complete. Emitting the shepherd escalation report.

Shepherd on endojs/endo-but-for-bots **PR #393** ("feat(gateway): relay-policy admission for /ocapn-cbor-np (#343 phase 5)").

**Live state (re-fetched):** DRAFT, OPEN, MERGEABLE, head `a1905d36`, last pushed 2026-06-03. Red run `26912580646`. Failing checks: `lint`, `cover (20.x/24.x)`, and every `test (20.x/22.x/24.x × ubuntu/macos)`. All the pass/fail duplicates (e.g. two `lint`, two `test`) are the newer `CI` workflow on master being green vs. this stale branch's run being red.

**Root cause — NOT in this PR's diff.** The PR touches only `packages/gateway/**` (+ `.gitignore`). Every red `test`/`cover` job dies at the same place, in a transitive test-harness dependency, before any gateway code runs:

```
node_modules/.store/emittery-npm-2.0.0/package/index.js:780
    .filter(result => result.status === 'rejected')
TypeError: results.values(...).filter is not a function
    at Api.emit (emittery/index.js:780)   →  @endo/cjs-module-analyzer:test  (turbo aborts the whole run)
```

`@endo/cjs-module-analyzer` is untouched by this PR. The crash is a **stale-branch dependency-resolution artifact**: this branch's root `package.json` still pins `"ava": "^6.4.1"`, whereas current master uses `"ava": "catalog:dev"` (→ `^8.0.1` via `.yarnrc.yml`). The branch's `yarn.lock` therefore carries a **mixed ava 6.4.1 + 8.0.1 / emittery 1.2.0 + 2.0.0** graph; master consolidated to a single ava 8.0.1 line. The branch is **127 commits / ~4 weeks behind master** (diverged at `ba26f4cdb`), and **master's identical `CI` workflow is currently green** — so this is not a trunk-wide breakage and not caused by the gateway change. (The `lint` failure is the same-vintage staleness: master since added the "underscore-delimited numeric literals" eslint rule, which this branch's `cjs-module-analyzer/index.js` predates.)

**Why I did not push a fix.** The remedy is to refresh the dependency graph — i.e. rebase/regenerate the lockfile — not a surgical edit inside `packages/gateway`. This PR is a **DRAFT stacked on the also-stale, unmerged `design/gateway-package-phase-4`**; a proper refresh means rebasing the phase-4 → phase-5 design stack (two PRs) onto current master and regenerating `yarn.lock`. That is a multi-PR structural operation, and there is no maintainer directive (auto-dispatched job, no comment). Per the shepherd role's hard escalation points (structural decision needed) and external-repo etiquette (no comment authorization in the job body), I did not unilaterally rebase the stack or post to the PR. No commits made; garden worktree clean.

**Escalation — `next: liaison`** (mechanical remedy = a **weaver** rebase once approved): decide whether to refresh the stale gateway design stack. Concretely: rebase `design/gateway-package-phase-4` then `design/gateway-package-phase-5` onto current `origin/master`, re-run `yarn install` to regenerate `yarn.lock` (drops the ava 6.4.1 / emittery 1.2.0 duplication), and re-push; that clears both the `emittery`/`cjs-module-analyzer` crash and the numeric-literal lint failure. Given it's a 4-week-stale DRAFT whose base has not merged, the alternative is to simply leave it until the maintainer advances the stack — worth confirming rather than churning an unowned draft.

Follow-up worth noting for the fleet: the CI-status watcher auto-minted (and repeatedly reaped/requeued) this shepherd against a long-stale DRAFT whose only failure is inherited staleness — a candidate for the watcher to skip drafts whose base is N commits behind master, or to route them to weaver rather than shepherd.
