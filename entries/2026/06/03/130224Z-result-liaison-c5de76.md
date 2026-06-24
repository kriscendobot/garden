---
kind: result
role: liaison
host: endolin
dispatch_root: /home/kris/garden/dispatches/liaison--c5de76
ts: 2026-06-03T13:02:24Z
ref_id: c5de76
---

# Cycle 155 result — daemon-rename-to-manager.md (thirty-ninth-comment-style design ingest)

Cycle 155 of the librarian arc. Nominally papers-lane (cycle 154 was
comments); papers-lane has been blocked for **49+ consecutive
cycles**. Pivoted to designs-lane.

## Source

`endo-but-for-bots/designs/daemon-rename-to-manager.md` — 431-line
*Not Started* methodological-refactor design by Kris Kowal
*(prompted)*. Created 2026-05-04 / updated 2026-05-05. Last touch
commit `8ddfab0d9` 2026-05-05 by Kriscendo Bot.

## Structural moves captured

- **§Load-bearing-name-collision**: with Rust `endor` supervisor,
  the same JS code is hosted as either an in-process XS thread or
  Node.js child. *In both cases the Rust side is the daemon and
  the supervisor; the JS side is the orchestration layer that the
  supervisor hosts*. §Rust-already-calls-it-manager precedent
  (`ManagerMode`, `ENDO_MANAGER_NODE`, `spawn_inproc_xs_manager`).
  §JS-not-the-daemon observation. §Asymmetric-vocabulary-across-
  boundary problem.

- **Single most structurally interesting move**: §namer-procedure-
  applied-with-citations. Each candidate run through Laws 0/1/2
  from `roles/namer.md` (describes the thing / describes no other
  thing via grep / shortest concise form) + antonym/dual check +
  precedent check + §verdict-line. §Methodology-not-just-decision
  discipline (shows the work).

- **§Pair-coherence-matters**: `Daemon`/`Worker` was fractured
  (different metaphor families); `Manager`/`Worker` is symmetric.

- **§Forbidden-synonym argument** for `MignonicPowers`: codebase
  uses `Worker` everywhere else; keeping `Mignonic` is *the
  forbidden synonym*. §Opaque-metaphor-to-non-native-readers (the
  "mignon" French metaphor requires cultural context).

- **§Prompt-author's-spelling-correction discipline**: user
  prompted "Mignion"; actual identifier is `MignonicPowers`. The
  design *corrects the prompt* with cite-source-location.

- **§Coinage-was-defensive-no-longer-needed**: `Daemonic` was an
  English-parsing-defensive coinage; with `Manager` the ambiguity
  disappears, so the defensive coinage is unnecessary.

- **§What-stays section** names the negative space (EndoWorker /
  package directory / npm name / CLI binaries / user-facing prose
  all stay). §Scope-boundary-explicit + §user-facing-prose-
  untouched.

- **§Three-phased rename** with §minimum-disruptive-PR-boundary.
  §Phase-1-safest-review-rationale: counterintuitive that the
  largest diff (file renames via `git mv`) is the easiest review.

- **§Exhaustive-mechanical-inventory** with §grep-recipe-as-
  source-of-truth provision.

- **§Wire-protocol-coordination-window**: exo tag
  `'EndoDaemonFacetForWorker'` is wire-visible but producer +
  consumer ship in same package + same release → §coordinated-
  rename-because-coordinated-deployment + §atomic-rename-when-
  deployment-is-atomic.

- **§No-deprecated-alias-kept** via §search-confirms-rename-is-
  outright-cut. §Evidence-based-deprecation-decision: search of
  `endojs/endo` master + downstream repos found no consumer that
  imports a `Daemon*` identifier. §Absence-of-consumers-means-no-
  deprecation rule.

- **§Package-name-stays** with §inside-vs-outside-the-name-
  boundary distinction. §Nested-naming-scopes discipline.

- **§Don't-retroactively-edit-older-designs**: §sweep-only-new-
  prose; §don't-rewrite-history norm. Parallel to cycle 95's
  §roadmap-calibration-via-git-blame discipline.

## Output summary

- **Source slug**: `endo-but-for-bots--llm-designs-daemon-rename-to-manager`
- **Sections**: 1 cohesion-honest section
  - `endo-but-for-bots--llm-designs-daemon-rename-to-manager--namer-procedure-applied-via-Laws-0-1-2-with-three-phased-rename-and-exhaustive-mechanical-inventory.md`
- **Topics**: daemon, agent-conventions, repository-governance
- **Library totals**: 659 sections from 200 source documents — **the
  library crosses 200 sources**.
- **Lane rotation**: nominally papers-lane (49+ consecutive blocks);
  pivoted to designs-lane

Cycle 155 closes. Schedule next wake 1500s for cycle 156.
