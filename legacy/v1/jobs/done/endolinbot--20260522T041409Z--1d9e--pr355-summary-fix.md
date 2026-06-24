---
job: eac65c
posted_by_role: barrister
posted_by_host: endolinbot
posted_at: 2026-05-22T03:52:19Z
verb: summary-fix
project: endo
target:
  repo: endojs/endo-but-for-bots
  pr: 355
  issue: null
  design: null
authorizations:
  identity_switch: false
  comment_repos: []
priority: normal
deadline: null
eligible_roles:
  - steward
  - general-contractor
preconditions: []
refs:
  - entries/2026/05/22/034829Z-result-barrister-52354c.md
---

# Summary-fix bundle: PR #355 (mirror endo#3099 perf bundle-source)

Eight summary-fix items from the barrister's panel-1 review (see `entries/2026/05/22/034829Z-result-barrister-52354c.md`). The fixer addressing the must-fix-loop cluster on the same dispatch (or a separate fixer dispatch claiming this job) lands these as a second commit alongside the must-fix fixes; they do not block un-draft on their own but should not be deferred to a later round either.

Each item carries its full citation / proposed-rule tag from the panel body. Address them in one fixer commit titled `chore: address barrister summary-fix bundle for #355` (or similar).

## Items

1. `packages/bundle-source/src/profile.js:65-80` — when `ENDO_BUNDLE_SOURCE_PROFILE_STDERR=1`, emit the resolved trace path at the top of `flush()` (or at profiler construction), not only at successful flush. Surfaces auto-resolved `os.tmpdir()` path early enough for the user to redirect or pre-create the directory when the default is non-writable. One stderr line. [proposed-rule: instrumentation that opens an OS write surface should announce the surface at start, not only at success]

2. `packages/bundle-source/src/zip-base64.js:23-32` — `Number.parseInt(env, 10)` accepts `"100mb"` and silently truncates to `100`. Either warn on non-numeric tail (`if (String(parsed) !== env.trim()) ...`) or accept the suffix (parse `100mb` as `100 * 1024 * 1024`). README documents this env as raw bytes; the simpler fix is the warn-on-tail check. [rule: skills/pre-pr-checklist/SKILL.md § config-defensive]

3. `packages/bundle-source/src/zip-base64.js:33-65` — `cachedReads` Map evicts in insertion order on overflow; cache hits do not promote. Either implement true LRU (`cachedReads.delete(location); cachedReads.set(location, bytes);` on hit), or document the FIFO semantics in a file-header comment. The PR description names "process-local and keyed by transformed source + module URL" but does not name the eviction discipline. [rule: skills/changeset-discipline/SKILL.md § document load-bearing detail]

4. `packages/compartment-mapper/src/parse-archive-mjs.js:14-17, 80-87` — on cap overflow (`MAX_PARSE_ARCHIVE_MJS_CACHE_ENTRIES = 20_000`), the branch calls `parseArchiveMjsCache.clear()` and re-inserts only the current entry's location, thrashing a steady-state-over-cap workload to a one-entry hit rate. Either log a one-time warning when first hitting cap, or replace `Map.clear()` with a partial eviction (drop oldest 25 percent). Also lift the magic 20_000 to an env (`ENDO_PARSE_ARCHIVE_MJS_CACHE_ENTRIES`) or comment the workload that produced it. [rule: skills/changeset-discipline/SKILL.md] [proposed-rule: hardcoded numeric caps in instrumented caches should be either env-overridable or commented with the workload that produced them]

5. `packages/bundle-source/README.md` Profiling section — document `ENDO_BUNDLE_SOURCE_READ_CACHE_MAX_BYTES` (defined at `zip-base64.js:23` with a 64 MiB default). The README documents the four `ENDO_BUNDLE_SOURCE_PROFILE*` vars but not this one, even though it controls a always-on cache surface introduced by the same PR. [rule: skills/changeset-discipline/SKILL.md § README parity with introduced env]

6. `packages/bundle-source/src/profile.js:73-80` — the trace filename uses `Date.now() + nextTraceFileId` (module-scope counter). Two concurrent bundle calls in the same millisecond on the same pid in different processes will collide. Add `crypto.randomBytes(4).toString('hex')` (or `process.hrtime.bigint()`) to the filename template. [proposed-rule: trace filenames written to a shared directory should be collision-free across processes, not only within a process]

7. `packages/evasive-transform/test/evade-censor.test.js` — the cleaner's `2586a9952` widened `importLikePattern` to `\bimport\s*(?:\(|\/[/*])`. Add three asserts to pin the widened pattern: `import (`, `import //`, `import /*`. The current test additions cover `import(` directly; the two comment-mode cases are inferred from SES's `rejectImportExpressions` regex but not directly pinned. One ava test block, three asserts. [rule: skills/regression-evidence/SKILL.md]

8. `packages/zip/src/writer.js:37` — orphaned JSDoc tag: `/** type {Map<string, ZFile>} */` is missing the leading `@`. Even after the must-fix `ZFile` to `ArchivedFile` rename, the tag does nothing. Fix to `/** @type {Map<string, import('./types.js').ArchivedFile>} */`. [rule: skills/pre-pr-checklist/SKILL.md § typecheck]

## Coordination with the must-fix-loop fixer

The must-fix-loop cluster is its own fixer dispatch (three items, roughly a dozen lines across four files). This summary-fix bundle is a separate commit on the same fixer dispatch (or a separate fixer dispatch claiming this job after the must-fix dispatch returns). Either ordering works; the items here do not depend on the must-fix items being landed first.

## Post-fix expectations

- After the must-fix and summary-fix commits land, the orchestrator dispatches the **justice** (not the barrister) for the panel re-run per `roles/barrister/AGENT.md` § Operating norms. The justice's brief reads the prior verdict + the fixer's response; this job's items appear in the justice's re-run as either `acknowledge` (addressed) or repeated `summary-fix` (partially addressed).
- This PR remains `isDraft: true`. The terminating judge un-drafts; the barrister does not on this non-terminating first round.
