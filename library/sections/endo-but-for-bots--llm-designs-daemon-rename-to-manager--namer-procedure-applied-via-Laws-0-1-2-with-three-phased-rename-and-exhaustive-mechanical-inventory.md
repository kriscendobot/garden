---
section: namer-procedure-applied-via-Laws-0-1-2-with-three-phased-rename-and-exhaustive-mechanical-inventory
source: endo-but-for-bots--llm-designs-daemon-rename-to-manager
topics: [daemon, agent-conventions, repository-governance]
status: current
---

# Namer procedure applied via Laws 0/1/2 with three-phased rename and exhaustive mechanical inventory

> *The candidate set is run through the namer procedure
> ([`../roles/namer.md`](../roles/namer.md)).*
>
> — `designs/daemon-rename-to-manager.md` §Naming

`daemon-rename-to-manager.md` (431 lines, *Not Started* status,
created 2026-05-04 / updated 2026-05-05) is a **methodological-
refactor design** by Kris Kowal *(prompted)*. Last touch 2026-05-05
by Kriscendo Bot (commit `8ddfab0d9`): *design(daemon): drop
test-directory split open question (#85)*. The design **applies a
named procedure (the namer's Laws 0/1/2) to each rename candidate**
and produces an *exhaustive mechanical inventory* a builder can
execute.

## The §load-bearing-name-collision

The §What-is-the-Problem-Being-Solved section names the exact
collision:

> *`packages/daemon/src/daemon.js` and its peer `daemon-*.js`
> power modules carry the orchestration responsibilities of an
> Endo instance: formula graph, controller table, host/guest
> provisioning, worker management, gateway, mail. None of those
> responsibilities require the OS-level meaning of "daemon" (a
> long-running detached background process).*

The §JS-not-the-daemon observation: with the Rust `endor`
supervisor, the same JS code is hosted in *two distinct ways*:

1. **In-process XS machine** on a dedicated `std::thread`
   (`endor daemon`'s default) — *there is no separate OS process
   for the JS at all*.
2. **Node.js child of `endor`** under `ENDO_MANAGER_NODE=1` —
   *the JS is supervised by Rust and is plainly not the daemon*.

*In both cases the Rust side is the daemon and the supervisor.
The JS side is the orchestration layer that the supervisor
hosts.*

The §Rust-already-calls-it-manager precedent: Rust source uses
`ManagerMode`, `ENDO_MANAGER_NODE`, `spawn_inproc_xs_manager`.
*The JS side has not caught up*. The §asymmetric-vocabulary-
across-boundary problem: same code is called "daemon" on the JS
side and "manager" on the Rust side, *confusing anyone
straddling the boundary*.

## The §single most structurally interesting move — §namer-procedure-applied-with-citations

The design applies a *named procedure* (the namer's Laws) to
each rename candidate. The §applying-named-procedure-with-
citations discipline:

> *The candidate set is run through the namer procedure
> ([`../roles/namer.md`](../roles/namer.md)).*

For each candidate name, the design enumerates:

- **Law 0**: *describes the thing* — what the name's referent is.
- **Law 1**: *describes no other thing* — grep across `packages/`
  for false positives.
- **Law 2**: *shortest concise form* — no abbreviation if a
  single word works.
- **Antonym/dual**: pairs naturally with the existing partner.
- **Precedent**: the choice the Rust supervisor or sibling code
  already uses.

The §verdict-line discipline: each candidate concludes with
**Verdict: `<chosen-name>`**. A reader can scan only the verdicts
to see the renames; the bodies justify each.

The §methodology-not-just-decision observation: the design
*shows its work*. Future renames apply the same procedure;
future readers can audit the choices.

## The §Daemon → Manager rationale via Laws

Walking through the Daemon → Manager verdict:

- **Law 0**: *The orchestration layer manages formulas,
  controllers, hosts, guests, workers, and the mail hub.
  "Manager" describes that role without claiming OS-process
  semantics.*
- **Law 1**: *Grep across `packages/` for `\bManager\b` finds
  two unrelated hits: a comment header `// Manager / Entry
  Point` in `packages/lal/agent.js` and prose in `packages/fae/
  NANOBOT-ARCHITECTURE.md`. Neither is a class or interface.*
- **Law 2**: *"Manager" is a single word, no abbreviation
  needed.*
- **Antonym/dual**: *"Manager" pairs naturally with "Worker"
  ... The pair was previously fractured: `Daemon` was managing
  `Worker`s. After the rename the pair `Manager` / `Worker` is
  symmetric.*
- **Precedent**: *The Rust supervisor already uses the same word
  for the same role*.

The §antonym-dual-as-naming-criterion observation: the namer
procedure includes a *pair coherence check*. `Daemon`/`Worker`
was *fractured* (different metaphor families); `Manager`/
`Worker` is symmetric. The §pair-coherence-matters discipline.

## The §MignonicPowers → WorkerPowers — the §forbidden-synonym fix

`MignonicPowers` (adjective form of "mignon", small/dainty
subordinate) is described as **opaque**:

> *"Mignonic" is a metaphor (small/dainty subordinate) that is
> opaque to a non-French reader and adds no information not
> already carried by `Worker`.*

The §opaque-metaphor-to-non-native-readers observation: a
metaphor that *requires cultural / linguistic context* fails Law
0 for readers without that context.

The §forbidden-synonym argument:

> *The codebase already uses `Worker` everywhere else for the
> same entity (`EndoWorker`, `WorkerInterface`, `WorkerFormula`,
> `provideWorker`). Keeping `Mignonic` solely on the powers
> shape is exactly the forbidden synonym.*

The §two-names-for-one-thing-is-the-forbidden-synonym
principle: the namer procedure forbids *multiple names for the
same entity*. The §existing-name-wins-the-tie tiebreaker.

The §prompt-author's-spelling-correction discipline: the user
prompted "Mignion"; the actual identifier is `MignonicPowers`.
The design *corrects the prompt* and cites the source location
(`packages/daemon/src/types.d.ts` line 89). The §verify-the-
prompt-before-acting habit.

## The §Daemonic-collapses-to-Manager rationale

> *The `Daemonic` adjective collapses to plain `Manager`; there
> is no need for `Manageric` or `Managerial`. "Daemonic" was a
> coinage to avoid `DaemonPowers` reading like "the powers of [a]
> Daemon[Core]". With `Manager` there is no such ambiguity:
> `ManagerPowers` reads as the powers handed to the manager.*

The §coinage-was-defensive-no-longer-needed observation. The
*reason* for `Daemonic` was a parsing ambiguity in English; the
rename removes the ambiguity, so the defensive coinage is
unnecessary. §removing-a-name-by-fixing-the-underlying-problem.

## The §What-stays section — naming the negative space

The §What-stays subsection lists what is *not* renamed:

- `EndoWorker`, `WorkerFormula`, `WorkerInterface`,
  `provideWorker`, `mainWorker`, `nodeWorker`,
  `WorkerDeferredTaskParams` — already correct.
- Package directory `packages/daemon/` and npm name
  `@endo/daemon` — see Open Questions (the package-level still
  scoped to the daemon as a whole).
- The `endo` and `endod` CLI binaries and the literal word
  "daemon" in user-facing prose ("the Endo daemon") *where it
  does mean the long-running process* — out of scope.

The §scope-boundary-explicit discipline: the design names *what
it doesn't touch* as carefully as *what it does*. Avoids
scope-creep at review time.

The §user-facing-prose-untouched observation: prose-level
"daemon" stays. The rename targets *JS identifiers*, not the
*concept of the daemon as a long-running process* (which exists
and is real).

## The §three-phased rename plan with §minimum-disruptive-PR-boundary

§Phased Implementation:

| Phase | Scope | Reviewability |
|-------|-------|---------------|
| **1** | File renames only via `git mv`; import-specifier updates | Mostly path changes |
| **2** | Identifier renames (project-wide grep-replace) | Semantic content change |
| **3** | Consumer updates in workspace | Cross-package validation |

The §minimum-disruptive-PR-boundary discipline: each phase is
*independently mergeable*; phase 2 depends on phase 1, phase 3
depends on phase 2. §incremental-rename-not-big-bang.

§Phase-1-safest-review-rationale:

> *Phase 1 file renames create the largest mechanical churn but
> are the safest review. Reviewers can validate by reading
> import diffs; nothing about runtime behavior changes.*

The §big-churn-but-easy-review insight: counterintuitive that
the *largest* diff is the *easiest* review. The §git-mv-
preserves-blame property makes phase 1 trivially reversible
and trivially verifiable.

## The §exhaustive-mechanical-inventory discipline

The §Rename Inventory section is *exhaustive enough that a
builder can execute it mechanically*:

- **File renames**: 13 files in `packages/daemon/src/` (table).
- **Identifier renames**: per-file enumeration with line
  numbers (`makeDaemon` at line 5427; `makeDaemonCore` at line
  294; etc.).
- **Consumer updates**: workspace search with concrete grep
  recipe.

The §grep-recipe-as-source-of-truth provision:

```sh
grep -rlE '\b(makeDaemon|DaemonCore|DaemonFacet|DaemonInterface|
DaemonDatabase|DaemonicPowers|DaemonicPersistencePowers|
DaemonicControlPowers|DaemonicGoPowers|WorkerDaemonFacet|
DaemonFacetForWorker|DaemonWorkerFacet|DaemonNode|DaemonProcess|
MignonicPowers)\b' packages/
```

is named as the *builder's authoritative source of truth*. The
§automate-the-find-step discipline: the design doesn't claim its
own enumeration is complete; it names the *command* a builder
should run.

## The §wire-protocol-coordination-window

> *The exo tag `'EndoDaemonFacetForWorker'` appears in CapTP
> traffic between manager and worker. Since both endpoints ship
> in the same package and the same release, there is no
> protocol-version skew.*

The §coordinated-rename-because-coordinated-deployment
discipline: the rename touches a *wire-visible identifier* —
which would normally require a deprecation window — but because
both endpoints *ship together*, the rename is *atomic at the
release boundary*. §atomic-rename-when-deployment-is-atomic.

The §protocol-version-skew distinction matters elsewhere in the
@endo project where producers and consumers ship in *different*
packages or different release cadences. Here, *they don't*, so
the constraint relaxes.

## The §no-deprecated-alias-kept rationale

§Compatibility considerations name four risks: wire / persistence
/ public exports / upstream / downstream. The §search-confirms-
rename-is-outright-cut conclusion:

> *Search of the `endojs/endo` master and visible downstream
> repositories did not find any consumer that imports a `Daemon*`
> identifier from `@endo/daemon`. The rename is therefore an
> outright cut, not a deprecation.*

The §evidence-based-deprecation-decision discipline: a
deprecation window has *cost* (carrying two names; eventually
removing one). It's only *worth* it if there are users to
migrate. Here, the search shows there are *none* outside the
package itself; the rename can be a *cut* rather than a
*deprecation*.

The §look-for-downstream-consumers-before-deciding-on-deprecation
discipline. The §absence-of-consumers-means-no-deprecation rule.

## The §package-name-stays observation

> *The npm package `@endo/daemon` and the directory
> `packages/daemon/` keep their current names. The package-
> level name is still correctly scoped to the daemon as a whole
> (including the supervisor and worker processes); only the
> orchestration file and the `Daemon*` identifiers within it
> are renamed.*

The §inside-vs-outside-the-name-boundary observation. The
*package* names something larger than the *file* — the package
encompasses the daemon-supervisor-worker triad; the file
encompasses just the orchestration layer. The rename is
*inside* the package's naming scope; the package name itself
remains valid.

The §nested-naming-scopes discipline: a name can be wrong at
file granularity but right at package granularity (or
vice-versa). The fix is at the level where the wrongness lives.

## The §two-renames-in-one-design rationale

The design bundles **two unrelated renames**:

1. `Daemon → Manager` (the orchestration layer)
2. `MignonicPowers → WorkerPowers` (the worker-side powers
   record)

Both are §forbidden-synonym fixes. Both touch the same
worker-side files (`worker.js`, `worker-node-powers.js`,
`worker-go-powers.js`, `bus-worker-node-powers.js`). The
§coherent-rename-batch observation: bundling them produces
*one* refactor PR rather than two interleaved ones.

The §when-bundling-helps-vs-hurts judgment: bundling is right
when (a) the changes touch overlapping files and (b) reviewer
attention can hold both renames at once. Both criteria hold
here.

## The §don't-retroactively-edit-older-designs discipline

§Documentation subsection:

> *`designs/`: existing design documents reference `daemon.js`
> and `Daemon`-prefixed names freely. Sweep only the prose your
> PR adds or modifies; do not retroactively edit older designs
> (per [`../skills/em-dash-style-rule.md`](../skills/em-dash-
> style-rule.md) pitfalls).*

The §sweep-only-new-prose discipline. The §don't-rewrite-history
norm: older designs are *historical artifacts* of the project
at their authoring time; retroactively editing them creates
false historical record.

Parallel to cycle 95's chat-rename-dismiss-to-clear's
§roadmap-calibration-via-git-blame discipline (preserves
historical accuracy via *blame* rather than overwrite).

## Related sections

- cycle 95 (`chat-rename-dismiss-to-clear`) — sibling rename
  design with §roadmap-calibration-via-git-blame discipline.
  Cycle 95's rename was *cleaner* (PR shipped); this design is
  *Not Started*.
- cycle 149
  [[endo-but-for-bots--llm-designs-unhandled-rejection-display--two-coordinated-changes-with-error-shape-sentinel-and-four-case-rendering-fallback]]
  — §three-day-active-development calibration via git-blame
  (same discipline applied to ship-rate).
- cycle 151
  [[endo-but-for-bots--llm-designs-app-sharing-milestone--three-pillar-cut-with-verified-current-state-methodology-and-adopt-existing-plan-discipline]]
  — sibling §verified-current-state methodology + §audit-before-
  spec applied to *milestone coordination* rather than *rename
  inventory*. Both produce *exhaustive enumeration* that a
  builder can mechanically execute.
- cycle 153
  [[endo-but-for-bots--llm-designs-ci-no-npm-lifecycle--three-layer-auditable-lifecycle-script-defense-with-belt-and-suspenders-env-and-CI-lint]]
  — sibling design from the same author with §exhaustive-
  workflow-audit + §enumerate-every-workflow discipline.
