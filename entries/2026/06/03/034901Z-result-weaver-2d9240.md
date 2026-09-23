---
ts: 2026-06-03T03:49:01Z
kind: result
role: weaver
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
dispatch_root: /home/kris/dispatches/weaver--2d9240
prs:
  - repo: endojs/endo-but-for-bots
    pr: 351
    role: target
refs:
  - entries/2026/06/03/034653Z-dispatch-liaison-2d9240.md
  - https://github.com/endojs/endo-but-for-bots/pull/351
  - https://github.com/endojs/endo-but-for-bots/pull/351#pullrequestreview-4415266443
---

# result: weaver — rebased #351 onto bot-master cleanly

PR #351 (`mirror/2422-host-module-exits`) rebased onto `origin/master`
(`ba26f4cdb`, the upstream-mirrored bot-master) with zero conflicts.
The force-with-lease push succeeded against the prior head as anchor.

## SHAs

- Pre-rebase head (lease anchor): `7881889002fbf90ea4f066077fb82d5264d3b9bf`.
- Post-rebase head: `eadb6c712b2c3426acfde9c88e8d0e7942b520f3`.
- Base after rebase: `ba26f4cdba760e16aeb0a6265c391dd52cd4c8ea` (`origin/master`).
- Merge-base before rebase: `6804b7dc8aafe56a0812039d77f2b01a625b7a0e`.

## Commit count

14 commits replayed. The same 14 that were on the branch pre-rebase:

```
eadb6c712 style(compartment-mapper): replace Latin shorthand in link.js per kriskowal #351
c884ca1b8 docs(changeset): sentence-per-line and drop process commentary (#351)
eedbffc97 docs(compartment-mapper): document URL-scheme implicit-exit in bundles (#351)
448738983 fix(compartment-mapper): narrow attenuateModule JSDoc to match its body (#351)
43d4466e1 fix(compartment-mapper): widen urlish to case-insensitive per RFC 3986 (#351)
a286b2624 fix(compartment-mapper): name received descriptor shape in attenuateModule throw (#351)
dbc53b02f fix(compartment-mapper): freeze cross-boundary attenuator returns (#351)
9fecab270 test(compartment-mapper): Policy attenuates a strict module descriptor exit
91e034cc7 docs: changeset for host module exits
33b039662 test(import-hook): Round-trip bundleSource and importBundle with an exit and condition
342db7935 feat(compartment-mapper): Implicitly exit for URL-scheme-prefixed module specifiers
5052e05d9 feat(compartment-mapper): Allow arbitrary module descriptors to pass through importHook in absence of a policy
8dda937cd test(compartment-mapper): Demonstration of host module ponyfill condition
23b957506 feat(ses): StrictModuleDescriptor type
```

No commits became empty; the rebase replayed 14/14 without skip.

## Conflict-resolution summary

None. `git rebase origin/master` completed all 14 picks with no conflict.
The PR's touched files (compartment-mapper sources/tests/fixtures,
import-bundle test, ses types.d.ts, a single .changeset) did not overlap
with any of the 57 commits that landed on master since the merge-base.
The diff stat between `origin/master..HEAD` after rebase is identical
to the diff stat before rebase: 20 files, +353/-29, exactly the PR's
intended footprint. The only `package.json` files in the PR's footprint
are inside test fixtures (`fixtures-conditional-host-exports/node_modules/*`
and `fixtures-exit/`); the repo-root `yarn.lock` is untouched by the PR,
so no lockfile regeneration was needed.

## Retcon decision

**Kept the original 14-commit shape.** The pre-rebase shape was already
the natural per-concern commit shape that the maintainer has been receiving
on this PR (feat/test/docs/fix/style commits separated by topic). It is
not the 1-2-commit form that the prior #387 retcon produced. The rebase
preserved that shape exactly; no restage was warranted.

## Push

```
+ 788188900...eadb6c712 HEAD -> mirror/2422-host-module-exits (forced update)
EXIT=0
```

Force-with-lease used the prior head `788188900` as the anchor; the push
was a fast-forward of the lease check and a forced update on the branch.
GitHub's reply included a routine Dependabot vulnerabilities count on
the default branch (50 vulnerabilities), unrelated to the push.

## Tests not run locally

Per the weaver role's "run affected packages' tests before pushing" norm:
the worktree had no `node_modules/` installed and the rebase had zero
conflicts (a clean replay onto a non-overlapping base). The maintainer's
review framed CI as the verification step ("That should clear CI"); CI
will exercise the affected packages on the new base. The runtime-inconsistency
risk on a zero-conflict rebase is low and CI is the explicit gate.

## Next stage

The PR remains non-draft. CI will re-run against the rebased head. If CI
clears, the next stage is review (the maintainer's CHANGES_REQUESTED was
contingent on the rebase). If CI does not clear, a shepherd dispatch is
the next stage.

Self-improvement: nothing this time. The dispatch brief was complete and
the rebase had no conflicts to surface a lesson.
