---
title: §Roadmap-calibration-per-git-blame as named design-doc structure
source-slug: endo-but-for-bots--llm-designs-platform-fs
source-url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/platform-fs.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/platform-fs.md
total-lines: 787
ingest-cycle: 242
ingest-date: 2026-06-08
lane: designs
parent: endo-but-for-bots--llm-designs-platform-fs--platform-package-with-conditional-exports-and-type-lattice-and-elevator-module-and-roadmap-calibration-per-git-blame-and-structural-attenuation
---

The §Status section opens with a one-paragraph completion summary, then a §Roadmap-calibration sub-section that enumerates §five-named-bursts derived from `git blame` with specific commit hashes per burst:

- Burst 1 (2026-03-20): initial landing `e0dda06fb` + `ed234c6a7` CLI integration.
- Burst 2 (2026-03-30): `292a6d591`, `b8cca2d00` unification of cli exec.
- Burst 3 (2026-04-11): `a2dc8ec9f`, `d5a36e8ee`, `441770389`, `9faaddb92` types/lint/format fixups under PR #122 review.
- Burst 4 (2026-05-11): `194547611` typescript-catalog adoption.
- Plus content-store-gc work in `packages/daemon` triggering follow-up 2026-05-06 `5798b56f5`.

§Thirty-first-honest-design-evolution-record family member; §fifteenth-different-shape in 2026-06 cluster: §Roadmap-calibration-per-git-blame as the §retrospective-shape-of-an-already-shipped-design. §When-a-design-is-Complete, §the-Status-section-captures-the-implementation-history-as-named-bursts + §each-burst-cites-specific-commit-hashes + §the-active-development-span-distinguishes-calendar-time-from-active-authoring-time.

§Calendar-vs-active-development-distinction explicit: *the active authoring span includes long stretches of light-touch refactor / lint maintenance after the initial landing*. §When-a-shipped-design's-active-period-spans-many-weeks-but-most-of-them-are-light-touch, §name-the-light-touch-stretches-explicitly + §don't-overstate-the-effort-by-counting-calendar-days. §Sibling-to-cycle-238's-design-revision-after-CHANGES_REQUESTED (forward-looking provenance) — cycle 242 is the §retrospective-provenance shape: §two-different-temporal-postures-on-PR-provenance in 2026-06 cluster.
