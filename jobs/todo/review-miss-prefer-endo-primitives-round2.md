---
role: fixer
tier: mentor
fallback-tier: minion
arc: garden-upkeep
dispatch: automatic
---
**Role: fixer.** Ship **round 2** of the review-miss cluster `prefer-endo-primitives`. Maintainer approved all of it (kriskowal, liaison muster 2026-10-07). Garden repo `kriscendobot/garden`: push to `main2` directly; journal changes go to `journal2`.

**Trigger:** the review-retro on https://github.com/kriscendobot/minion.town/pull/146 (job `kriscendobot-minion.town-pr146-review-64a01f1e-retro`; maintainer message `msg-kriscendobot-minion.town-pr146-review-64a01f1e-retro-40202fed3594.md`). The maintainer asked for upstream `@endo/cancel` instead of a vendored TypeScript copy. The panel accepted "package is unpublished" and the build-vs-buy check never fired, because journal `config/export-index-providers` is absent.

**Do all of:**
- **(a)** Seed journal `config/export-index-providers` with `kriscendobot/minion.town -> endojs/endo-but-for-bots@llm`, in whatever format the build-vs-buy detector reads. Confirm the detector now indexes endo exports for minion.town, for example by re-running it against #146's vendored file.
- **(b)** Make an `@endo/*` provider that resolves as "blocked: not yet a dependency" emit a **should-fix** finding ("add the dependency and consume it") instead of nothing.
- **(c)** Add a builder rule and a purist juror rule: an unpublished upstream is no license to vendor a copy; consume it (dev registry or workspace link, or block and ask).
- **Close the cluster** in `review-misses/` with this round's improvements recorded, so the recorder flags any later miss as a recurrence. Reconcile the three misses since 08-04: endojs/endo-but-for-bots#1336, kriscendobot/minion.town#140 and kriscendobot/minion.town#146.

Add or adjust tests for (b), and run the affected suites. Note that `/tmp` is noexec on this host, so set `TMPDIR` to an exec-capable dir.
