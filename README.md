# Garden bulletin

_As of 2026-06-25T16:45:49Z · updated continuously as the job board advances (garden-bulletin.service). Rewritten only when the dashboard changes, so this marks the last change._

The maintainer dashboard: what needs a human first, then the state of ongoing
autonomous work. Regenerated deterministically by scripts/jobs/bulletin.sh, with a
journalist's narrative in the Latest section. This page (the journal's README.md)
IS the bulletin; the journal's layout and design narrative lives in [DESIGN.md](DESIGN.md).

## Messages to the maintainer

- `20260625T154855Z-c21859` — from gardener:finish-ebfb-pr96, reply_to `finish-ebfb-pr96` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260625T154855Z-c21859.md)

> PR #96 (compartment-mapper auxiliary package.json) — Phase 7 collision report.
>
> While I was implementing "finish #96 as designed", a concurrent peer gardener
> finished Phase 7 first and pushed it to the PR:
>   729e07f11 / 905cb7204 "honor languageForExtensionByPrefix at parse time (#96)".
> That commit addresses your flagged gap (collectLanguageOverrides was computed but
> unconsumed) for the ENTRY-path case: a `.js` file under a `{"type":"module"}` /
> `{"type":"commonjs"}` auxiliary that sits on the entry module's own path now parses
> correctly. Your fixture (apackage/afolder/file.js) and the design's nested case
> (rootpkg/sub1/sub2/x.js, loaded as the entry) are covered. So the PR-facing ask is
> satisfied — no action needed from me there.
>
> That commit explicitly DEFERS one piece as "future work": auxiliary subtrees that
> live inside a DEPENDENCY package reached by relative import (not on the entry path)
> are still not honored. Example: app imports aux-pkg by name; aux-pkg/index.js does
> `import "./cjs-sub/leaf.js"` where cjs-sub/ is a `{"type":"commonjs"}` auxiliary —
> leaf.js is still misparsed.
>
> I independently implemented that general case via a lazy per-module walk in the
> import hook (it has maybeRead + the sync/async trampoline, so it covers both paths).
> To avoid clobbering the peer's just-pushed commit, I did NOT push to the PR; my work
> is on a side branch instead:
>   origin/pr96-auxiliary-lazy-parse-general-case  (5483f04ba)
> All 917 compartment-mapper tests pass (12 known failures unchanged), tsc + eslint
> clean, regression-proven (neutralizing the override fails all 3 integration tests).
>
> The two implementations overlap (both touch map-parser resolveLanguage, the
> languageForExtensionByPrefix field, and types) and use different architectures
> (peer: precompute on the entry compartment at map time; mine: lazy per-module at
> parse time), so they don't compose trivially.
>
> Decision for you: (a) accept the entry-path scope now on #96 and treat the general
> dependency-subtree case as future work, or (b) reconcile onto the lazy approach so
> the general case lands too. If (b), point me at it and I'll rebase my side branch
> onto the current PR head and reconcile the two mechanisms into one.


## Board
### todo (0)
(none)

### doin (2)
- `design-propagator-endo-exo` — Design: a Sussman/Radul propagator at the Endo and Exo layers
- `scholar-ingest-cask-14` — Scholar: continue the library ingest of kriskowal/cask (cycle 15) — comment-f...

### tada (126)
- `reconstruct-cancel-on-llm` — Inbox empty. The job is already satisfied — I will not duplicate the work. Wr...
- `shepherd-ebfb-pr96` — Completion report
- `finish-ebfb-pr96` — Completion report — finish endo-but-for-bots #96 (Phase 7)
- `fix-reaper-requeue-reliability` — Report: fix-reaper-requeue-reliability
- `scholar-ingest-cask-13` — Completion report — scholar-ingest-cask-13 (gardener 91, endolinbot)
- … and 121 more

## Watch set
(none)

## Hosts
- endolinbot: 100 gardeners

## Recent progress
- 152754Z-progress-gardener-df8b49.md: gardener-80 on endolinbot completed job scholar-ingest-cask
- 152946Z-result-scholar-e7f75d.md: # Scholar cask ingest cycle 14 (job `scholar-ingest-cask-13`)
- 153108Z-progress-gardener-694fe6.md: gardener-24 on endolinbot claimed job scholar-ingest-cask-14
- 153243Z-progress-gardener-25fcae.md: gardener-78 on endolinbot completed job scholar-ingest-cask-13
- 153454Z-progress-gardener-088800.md: gardener-91 on endolinbot completed job scholar-ingest-cask-13
- 153500Z-message-scholar-bef28b.md: # Double-claim defect: `scholar-ingest-cask-13` was claimed and fully worked by two gardeners
- 153621Z-progress-gardener-cc5d91.md: gardener-76 on endolinbot claimed job shepherd-ebfb-pr96
- 153657Z-progress-gardener-29d71b.md: gardener-27 on endolinbot completed job finish-ebfb-pr96
- 153823Z-error-gardener-6e2874.md: gardener-24 on endolinbot: job scholar-ingest-cask-14 handler FAILED; output captured as e69de29bb2d1d6434b8b29ae775ad8c2e48c5391, escalated to the gardener inbox, left in doin for the reaper
- 154136Z-progress-gardener-3a798b.md: gardener-47 on endolinbot completed job fix-reaper-requeue-reliability
- 154945Z-progress-gardener-35fe1c.md: gardener-33 on endolinbot completed job finish-ebfb-pr96
- 155052Z-progress-gardener-af96ac.md: gardener-76 on endolinbot completed job shepherd-ebfb-pr96
- 164312Z-progress-gardener-6027f4.md: gardener-65 on endolinbot claimed job reconstruct-cancel-on-llm
- 164519Z-progress-gardener-82a378.md: gardener-26 on endolinbot claimed job design-propagator-endo-exo
- 164527Z-progress-gardener-cef1d0.md: gardener-65 on endolinbot completed job reconstruct-cancel-on-llm
## Latest

A peer gardener claimed and immediately completed `reconstruct-cancel-on-llm` (gardener-65) — it found its inbox empty and the work already satisfied, so it declined to duplicate. The propagator design job (`design-propagator-endo-exo`) was claimed by gardener-26 and is now the only active work besides the ongoing cask scholar ingest (cycle 15). The item a maintainer should actually look at is the PR #96 collision report now sitting unread in the maintainer inbox: two gardeners independently implemented Phase 7 of the compartment-mapper auxiliary `package.json` work, a peer pushed the entry-path fix first (729e07f11 / 905cb7204), and the second gardener parked its broader fix — the general dependency-subtree case via a lazy per-module parse — on side branch `origin/pr96-auxiliary-lazy-parse-general-case` rather than clobber the peer. It needs a decision: accept the entry-path scope on #96 and defer the general case, or reconcile onto the lazy approach so both land.
