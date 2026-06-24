---
ts: 2026-06-23T06:17:57Z
kind: result
role: barrister
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
refs:
  - entries/2026/06/22/054455Z-dispatch-liaison-4c5f8d.md
  - entries/2026/06/23/060117Z-result-cleaner-170ec6.md
  - entries/2026/06/23/061720Z-message-barrister-47aa2b.md
---

## Code-panel round 1 on endojs/endo-but-for-bots#509

PR #509 is `kriscendobot`'s mirror of upstream `endojs/endo#3099` (perf bundle-source, multi-entry agoric bundling speedup plus profiling instrumentation) onto base `master-7c25992` (frozen master snapshot). The maintainer's directive ("Please run the gauntlet.", 2026-06-23T05:44:55Z) drove this dispatch.

PR state at top-of-dispatch: `OPEN`, `isDraft: true`, `author: kriscendobot` (bot identity, no external-author calibration applied). HEAD at `367b9dcce`. Pre-dispatch state probe passed; no short-circuit.

## Panel composition

`panel-hints.sh --base origin/master-7c25992` output:

```
Panel-kind: code-panel
Always-on core (9): assessor, typist, stylist, packager, archivist, prover, saboteur, integrator, corner-prober
Always-fire (2): scribe, releaser
Path-triggered (6): changeset-auditor, curator, fast-checker, migrator, pruner, surfacer
Content-triggered (5): engine-realist, purist, spec-keeper, warden, wire-watcher
Cross-panel (2): copyeditor, pedant
Suppressed (4): benchmarker, breaker, gateway, locksmith
Recommended total: 24 of 26 code-panel seats (+ 2 cross-panel).
```

Barrister-side overrides:

- **Added `benchmarker`**: this is a perf PR claiming 42.8% wall-clock reduction. The probe missed because the bench file is at `tools/benchmark-writer.mjs` (not `**/*.bench.{js,ts}`). The probe's path-pattern is too narrow; flagging for the gardener to broaden.
- **Added `breaker`**: profiling code wraps every core code path in `try/finally`; invariant-preservation matters when re-entering hot paths. The seat's content trigger (`M.interface(`, `makeExo`, `^## Invariants`) does not fire here, but the lens applies.

Final panel: 25 code-panel + 2 cross-panel = 27 lenses. `gateway` and `locksmith` stayed suppressed (no toolchain config touched; no capability surface added).

## Panel execution

**In-band-fallback** (no `Agent` tool surfaced in this dispatch; ToolSearch returned no `Agent` or `Task` matches). Each seat was a single block written one at a time per the per-juror role's surface, with overlap noted in the block.

## Verdict

| Bucket | Count | Notes |
| ------ | ----- | ----- |
| must-fix-loop | 0 | First round terminated with no blockers. |
| summary-fix | 9 | Bundled into one job-board post. |
| follow-up | 11 | Appended to per-PR ledger; revisit at merge. |
| acknowledge | 2 | Recorded with rationale in the panel body. |
| drop | 0 | All findings traced to a rule or a proposed-rule. |

Submission verdict: `--comment` (no must-fix-loop items).

Review URL: https://github.com/endojs/endo-but-for-bots/pull/509#pullrequestreview-4550516085

## Post-loop actions

1. **`@copilot` reviewer add**: fired idempotently via `gh pr edit 509 -R endojs/endo-but-for-bots --add-reviewer @copilot`. Exit 0.

2. **`summary-fix` job posted**: `journal/jobs/open/20260623T061558Z--225815--endo-but-for-bots-509-summary-fix.md`. Nine bundled items (README sentence-per-line split, env var documentation, changeset behavior-changes subsection, changeset bump on `@endo/compartment-mapper`, JSDoc clarifications on `makeBundleProfiler` and `makeShortestPathFromSource`, comment on `MAX_PARSE_ARCHIVE_MJS_CACHE_ENTRIES`, flush try/catch wrap, module-scope cache documentation). Eligible roles: `fixer`, `steward`. One fixer dispatch addresses the whole bundle; no panel re-run needed.

3. **Followup ledger appended**: `journal/projects/endo-but-for-bots/followups/endo-but-for-bots--509.md`. Eleven items with `status: parked`. Upstream mirror set to `endojs/endo#3099`. The steward's parked-followup revisit will poll both PR states at merge.

4. **Gardener message written**: `entries/2026/06/23/061720Z-message-barrister-47aa2b.md`. Five proposed rules forwarded for garden-side encoding (tool-output lifecycle in READMEs, profiling-only module-scope counters, property-based testing for structural formats, reference-measurement in-tree for perf PRs, canonical cross-package option types).

5. **No `gh pr ready`**: per the dispatch brief, the barrister does NOT un-draft. The maintainer's "Please run the gauntlet" directive routes through fixer (summary-fix bundle) then conductor / un-draft as the terminal step. The liaison drives the next stage.

## Findings the panel surfaced about the PR's substance

The substantive perf-code defects belong upstream to `endojs/endo#3099` (the mirror's content is upstream's). Highlights, recorded in the panel body and the followup ledger for upstream revisit:

- **`parseArchiveMjsCache` is module-scope mutable state**: process-shared, FIFO-by-first-touch eviction at 20000 entries, cross-tenant leak surface (small but unaddressed in the changeset).
- **`.node` suffix removed from `nodejsConventionSearchSuffixes`**: real behavior change in `compartment-mapper/src/import-hook.js`, not called out in the changeset.
- **`nominateCandidates` skips suffix expansion** for already-suffixed specifiers: second behavior change in the same file; also not called out.
- **`versionNeeded: 10` in zip local file header** (was `0` with TODO): wire-format change; downstream `endoZipBase64Sha512` consumers will see hash mismatches after upgrade.
- **42.8% speedup claim lacks reproducer rigor**: no run count, no variance, no hardware/Node/agoric-sdk context. Tool scaffold added (668 + 502 + 215 lines) but no reference measurement committed in-tree.
- **`maxConcurrentReads` silent clamp on invalid input**: throws would match project posture better.
- **Single-value-over-budget read-cache eviction leaves budget violated**: minor; either evict offender or document.
- **`makeShortestPathFromSource` precondition not stated**: caches Dijkstra context; mutation between path lookups produces stale paths (safe in current call site but undocumented).
- **Cross-package `ProfilingOptions` type duplicated**: should be canonical in one package and re-exported.

## Recommendation for the next gauntlet stage

**Recommended next dispatch**: fixer, claiming the summary-fix bundle posted in step 2 above. After fixer completes the nine items in one commit (no panel re-run; summary-fix dispositions do not block un-draft), the gauntlet terminates with conductor / un-draft. The liaison drives both next stages.

If the maintainer prefers to ferry to upstream `endojs/endo#3099` instead of merging the mirror locally, the boatman dispatch takes the bundled mirror state upstream; the bot mirror PR closes after the upstream lands.

## Files written this dispatch

- `jobs/open/20260623T061558Z--225815--endo-but-for-bots-509-summary-fix.md` (summary-fix job)
- `projects/endo-but-for-bots/followups/endo-but-for-bots--509.md` (followup ledger)
- `entries/2026/06/23/061720Z-message-barrister-47aa2b.md` (gardener message)
- `entries/2026/06/23/061757Z-result-barrister-8ee5cb.md` (this result)

Panel execution: in-band-fallback. Panel kind: code-panel.

Self-improvement: panel-hints.sh missed `benchmarker` on a clearly perf-focused PR because its path probe is too narrow (`**/*.bench.{js,ts}` and `**/BENCH.md` and `**/benchmark/**`). A perf PR adding a `tools/benchmark-*.mjs` script should fire the seat. The gardener message proposes broadening the probe; flagging for self-improvement to add a third path pattern (`**/tools/benchmark*.{js,ts,mjs,mts}` and `**/tools/profile*.{js,ts,mjs,mts}`) to the `benchmarker` probe.
