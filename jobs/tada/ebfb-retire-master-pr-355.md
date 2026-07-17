Confirmed the PR is untouched (OPEN, base `master`, not draft). I made no remote changes — no reflection branch, no force-push, no base edit. The rebase probe was local-only and aborted. This is a project-repo diagnostic job, so there's nothing to commit to the garden. Writing the report.

Job complete. Report follows.

---

**Job: retire-master-base for endojs/endo-but-for-bots#355 — REPORTED, NOT SWEPT**

**What I did:**
- Confirmed PR #355 (`perf(bundle-source): cut multi-entry agoric bundling time...`) is **OPEN**, **not draft**, and still targets **`master`**. Head branch `mirror/3099-bundle-source-perf` lives on `endojs/endo-but-for-bots` (bot-authored by kriscendobot, 8 commits).
- Obtained the base SHA from **upstream `endojs/endo` master** per directive: `46d4edf3...` → reflection name would be **`master-46d4edf`**. (Did not read from the fork master; note `origin/endo-but-for-bots master` = `fcbb540` is a distinct, further-drifted ref.)
- Measured drift: head is **8 ahead / 112 behind** upstream endo master (166 behind the fork master). Merge-base `67c5fcd`. GitHub already reports the PR as CONFLICTING/DIRTY; last activity 2026-05-23 (~2 months idle).
- Ran a **local, throwaway rebase probe** of the head onto upstream endo master to gauge conflict scope, then aborted it.

**Finding — conflict is far beyond a focused weave (sweep not applied):**
The very first (core) commit `0e300cdde7 perf(bundle-source)...` fails to apply with structural conflicts across many files:
- Content conflicts: `compartment-mapper/src/map-parser.js`, `compartment-mapper/src/types/external.ts`, `module-source/src/module-source.js`, `module-source/src/transform-analyze.js`, `zip/package.json`.
- **Modify/delete**: `module-source/src/transform-source.js` was **deleted upstream** but is modified by the perf commit — a signal the module-source package was restructured upstream underneath this branch (weaver→fixer escalation territory, not a mechanical weave).

Per the job directive ("if there is a conflict beyond a focused weave, report it rather than changing the fork master" and "if the PR is a long-idle or stale mirror, do not wedge this sweep"), I **did not** create the `master-46d4edf` reflection, **did not** force-push the head, and **did not** edit the PR base. The fork master and PR are untouched; the PR remains OPEN on base `master`.

**Condition for maintainer follow-up:**
- PR #355 is a **long-idle (2mo), pre-conflicting mirror** of the still-open upstream `endojs/endo#3099` (OPEN, last updated 2026-06-18). Its 8 commits do not rebase cleanly onto current upstream endo master (112 commits of drift, including a deleted file the perf commit still modifies).
- Recommended options: (a) resync the mirror from a current snapshot of upstream endo #3099 (which itself may have moved on) before any base-retirement; (b) run a full **fixer/weave** to resolve the structural conflicts (module-source restructure) if the branch is still wanted; or (c) close the stale mirror if #3099 is being tracked upstream directly. The master-base retirement for #355 should follow whichever of these lands, not precede it.

**Follow-ups:** none for the garden library. This PR is excluded from the master-base retirement sweep pending the maintainer decision above.
