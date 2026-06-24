---
source: designs/daemon-rename-to-manager.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 8ddfab0d9dc7a4de8c1fb0eb4c9974e0d1d068e5
source_date: 2026-05-05
source_authors: [Kris Kowal (prompted)]
ingested: 2026-06-03
ingested_by: scholar
section_count: 1
status: current
notes: |
  Thirty-ninth-comment-style design ingest (cycle 155). 431-
  line *Not Started* status methodological-refactor design by
  Kris Kowal *(prompted)*, created 2026-05-04 / updated
  2026-05-05. Last touch commit `8ddfab0d9` 2026-05-05 by
  Kriscendo Bot.

  Bundles two unrelated renames: `Daemon → Manager` (the JS
  orchestration layer) + `MignonicPowers → WorkerPowers` (the
  worker-side powers record). §Coherent-rename-batch: bundling
  is right because (a) changes touch overlapping files and (b)
  reviewer attention can hold both at once.

  §Load-bearing-name-collision: with Rust `endor` supervisor,
  JS code hosted as in-process XS thread *or* Node.js child;
  in both cases *the Rust side is the daemon and the
  supervisor; the JS side is the orchestration layer that the
  supervisor hosts*. §JS-not-the-daemon observation. §Rust-
  already-calls-it-manager precedent (`ManagerMode`,
  `ENDO_MANAGER_NODE`, `spawn_inproc_xs_manager`). §Asymmetric-
  vocabulary-across-boundary problem.

  Single most structurally interesting move: §namer-procedure-
  applied-with-citations. Each candidate name run through
  Laws 0/1/2 from `roles/namer.md`: Law 0 (describes the
  thing) / Law 1 (describes no other thing — grep verification)
  / Law 2 (shortest concise form) + antonym/dual check +
  precedent check. §Verdict-line per candidate. §Methodology-
  not-just-decision discipline: shows the work.

  §Antonym-dual-as-naming-criterion observation: namer
  procedure includes a *pair coherence check*. `Daemon`/
  `Worker` was fractured; `Manager`/`Worker` is symmetric.
  §Pair-coherence-matters discipline.

  §Opaque-metaphor-to-non-native-readers observation:
  `MignonicPowers` adjective form of "mignon" requires
  French/cultural context to parse. §Forbidden-synonym
  argument: codebase uses `Worker` everywhere else; keeping
  `Mignonic` is *the forbidden synonym*. §Two-names-for-one-
  thing-is-the-forbidden-synonym principle. §Existing-name-
  wins-the-tie tiebreaker.

  §Prompt-author's-spelling-correction discipline: user
  prompted "Mignion"; actual identifier is `MignonicPowers`
  (cite source location). §Verify-the-prompt-before-acting
  habit.

  §Coinage-was-defensive-no-longer-needed: `Daemonic` was an
  English-parsing-defensive coinage; with `Manager` the
  ambiguity is gone, so the defensive coinage is unnecessary.
  §Removing-a-name-by-fixing-the-underlying-problem.

  §What-stays section names the negative space: what's NOT
  renamed (`EndoWorker`, package directory, npm name, CLI
  binaries, user-facing prose). §Scope-boundary-explicit
  discipline; §user-facing-prose-untouched observation
  (prose-level "daemon" stays — refers to OS-level process,
  which is real).

  §Three-phased rename plan with §minimum-disruptive-PR-
  boundary: Phase 1 (file renames + import updates) → Phase 2
  (identifier renames) → Phase 3 (consumer updates). Each
  independently mergeable. §Incremental-rename-not-big-bang.
  §Phase-1-safest-review-rationale: counterintuitive that the
  *largest* diff is the *easiest* review (git mv + import-
  diffs only; no runtime change). §Big-churn-but-easy-review.
  §Git-mv-preserves-blame property.

  §Exhaustive-mechanical-inventory discipline: file renames
  (13-row table) / identifier renames (per-file with line
  numbers) / consumer updates. §Grep-recipe-as-source-of-
  truth provision — *the builder's authoritative source of
  truth* is the grep command, not the design's own
  enumeration. §Automate-the-find-step.

  §Wire-protocol-coordination-window: exo tag
  `'EndoDaemonFacetForWorker'` is wire-visible but producer
  and consumer ship in same package + same release →
  §coordinated-rename-because-coordinated-deployment;
  §atomic-rename-when-deployment-is-atomic.

  §No-deprecated-alias-kept rationale: search of `endojs/endo`
  master + visible downstream repos *did not find any
  consumer that imports a `Daemon*` identifier from
  `@endo/daemon`*. §Search-confirms-rename-is-outright-cut.
  §Evidence-based-deprecation-decision: deprecation has cost;
  worth it only if there are users to migrate. §Look-for-
  downstream-consumers-before-deciding-on-deprecation;
  §absence-of-consumers-means-no-deprecation rule.

  §Package-name-stays observation: §inside-vs-outside-the-
  name-boundary; the package name encompasses the
  daemon-supervisor-worker triad (larger than the orchestration
  file). §Nested-naming-scopes discipline.

  §Don't-retroactively-edit-older-designs discipline:
  §sweep-only-new-prose; §don't-rewrite-history norm. Older
  designs are historical artifacts; editing creates false
  historical record. Parallel to cycle 95's §roadmap-
  calibration-via-git-blame discipline (preserves history via
  *blame* rather than overwrite).

  Cycle 155 was nominally papers-lane (cycle 154 was
  comments). Papers-lane has been blocked for 49+ consecutive
  cycles. Cycle 155 pivoted to designs-lane.
---

> Abstract: `daemon-rename-to-manager.md` (431 lines, *Not
> Started*) is a methodological-refactor design by Kris Kowal
> *(prompted)*. Created 2026-05-04 / updated 2026-05-05.
>
> Bundles two unrelated renames: `Daemon → Manager` + `Mignonic
> Powers → WorkerPowers`. §coherent-rename-batch.
>
> §Load-bearing-name-collision: Rust supervisor + JS
> orchestration both calling themselves "daemon" overloads
> two distinct meanings. §JS-not-the-daemon observation;
> §Rust-already-calls-it-manager precedent.
>
> **Single most structurally interesting move**: §namer-
> procedure-applied-with-citations. Laws 0/1/2 from
> roles/namer.md + antonym/dual check + precedent check
> applied to *each* candidate. §Verdict-line per candidate.
> §Methodology-not-just-decision discipline.
>
> §Forbidden-synonym fix for `MignonicPowers` — §opaque-
> metaphor-to-non-native-readers + §existing-name-wins-the-
> tie. §Prompt-author's-spelling-correction (user typed
> "Mignion"; actual is `MignonicPowers`).
>
> §What-stays section names the negative space. §Scope-
> boundary-explicit.
>
> §Three-phased rename with §minimum-disruptive-PR-boundary.
> §Phase-1-safest-review-rationale (counterintuitively the
> largest diff is the easiest review).
>
> §Exhaustive-mechanical-inventory with §grep-recipe-as-
> source-of-truth.
>
> §Wire-protocol-coordination-window: §coordinated-rename-
> because-coordinated-deployment.
>
> §No-deprecated-alias-kept via §search-confirms-rename-is-
> outright-cut. §Absence-of-consumers-means-no-deprecation.
>
> §Don't-retroactively-edit-older-designs discipline.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [namer-procedure-applied-via-Laws-0-1-2-with-three-phased-rename-and-exhaustive-mechanical-inventory](../sections/endo-but-for-bots--llm-designs-daemon-rename-to-manager--namer-procedure-applied-via-Laws-0-1-2-with-three-phased-rename-and-exhaustive-mechanical-inventory.md) | daemon, agent-conventions, repository-governance | current |

Tight 431-line *Not Started* methodological-refactor design.
One cohesion-honest section.

## Provenance

- Fetched 2026-06-03 from `endojs/endo-but-for-bots@
  8ddfab0d9` (branch `origin/llm`) via the local bare-clone.
- Created 2026-05-04 / updated 2026-05-05 / status *Not
  Started*. Author Kris Kowal *(prompted)*.
- Last touch commit `8ddfab0d9` 2026-05-05 by Kriscendo Bot:
  `design(daemon): drop test-directory split open question
  (#85)`.
- **Thirty-ninth-comment-style design ingest.**
- Cycle 155 was nominally **papers-lane** (cycle 154 was
  comments). Papers-lane has been blocked for **49+
  consecutive cycles** due to lack of PDF-fetching
  infrastructure. Cycle 155 pivoted to designs-lane.
- One cohesion-honest section.
