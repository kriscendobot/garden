---
created: 2026-08-19
author: designer
source: endojs/endo-but-for-bots#282 review (kriskowal, 2026-08-19, CHANGES_REQUESTED)
---

# Design: the endor↔node compartment-mapper fixture-parity ratchet

Maintainer directive (kriskowal, PR #282 review, 2026-08-19): *"ratchet up the
fixtures that are exercised until we reach parity, understanding that these
fixtures often have dedicated harnesses that will need to be emulated or refactored
to not require the harness for either endor or node."*

This turns the one-time parity **manifest** the prior job landed
(`rust/endo/tests/compartment_mapper_fixture_parity.rs`, on PR head
`feat/endor-run-entry-point-deps`) into a **driven campaign**: a monotonic ratchet
from **7-of-40 exercised** toward full parity between endor's `entry_walk` walker
and node's `@endo/compartment-mapper` reference, capability by capability.

## Where the substrate stands today

The manifest accounts for **every** `packages/compartment-mapper/test/fixtures-*`
directory (40 of them) as one of two dispositions:

- **`Exercise { entry, compartments }`** — 7 fixtures: `cthuloops`, `cycle-mjs`,
  `implicit-reexport`, `no-name`, `order`, `stack`, `strict`. Genuine static-ESM
  `node_modules` graphs; the walker runs against the canonical entry and its output
  is asserted (today: a compartment count, plus `no-name`'s unnamed-package id
  fall-back).
- **`Exclude { reason }`** — 33 fixtures, each naming the compartment-mapper
  feature the walker does not yet implement.

Two guards keep it honest: `no_unaccounted_fixture_drift` fails the suite if a
`fixtures-*` dir exists on disk without a manifest entry (or vice versa), and
`every_exclusion_has_a_reason` blocks a blank skip. That drift guard is the anchor
the ratchet rides on — a fixture cannot silently leave the accounting.

**Out of scope (deferred by the prior job, reaffirmed here):** hoisting the
fixtures into a shared top-level `test/fixtures` tree. They stay under
`packages/compartment-mapper/test`.

## 1. The 33 exclusions, grouped by blocking capability

Read from the manifest's exact `reason` strings. Each fixture is filed under its
**primary** blocker; a *(+X)* note flags a secondary blocker that must also land
before it can graduate.

### Group A — CommonJS `require()` graph-following
The single largest cluster and a prerequisite for several others. The
static-import walker does not follow `require()` edges at all.
- `fixtures-cjs-compat` — every module edge is a `require()`.
- `fixtures-cycle-cjs` — CommonJS import cycle via `require()`.
- `fixtures-digest` — CommonJS `module.exports` entry point (not a static-ESM graph).
- `fixtures-esm-imports-cjs-define` — ESM importing CJS `define()`d modules (interop).
- `fixtures-0` — mixed CJS/ESM kitchen-sink; reaches `.cjs` via `require()` *(+C exports)*.

### Group B — dynamic `import()` / dynamic `require()`
Edges the static walker cannot see because the specifier is an expression.
- `fixtures-dynamic` — dynamic `require()` ancestry (webpack-style).
- `fixtures-dynamic-ancestor` — dynamic `require()` resolved against an ancestor package.
- `fixtures-dynamic-import-esm` — dynamic `import()` expression.
- `fixtures-optional` — optional dependency reached via dynamic `import()`/`require()` *(+D)*.

### Group C — conditional & subpath `package.json` exports/imports
Resolution-algorithm gaps: the walker resolves only the default/index fall-back.
- `fixtures-conditional-host-exports` — `exports` host-condition selection (`endo:lib`).
- `fixtures-export-patterns` — subpath-pattern `exports` (`./x/*/y`).
- `fixtures-package-imports-exports` — `#imports` plus subpath-pattern `exports`.
- `fixtures-nested-pkg` — nested-package subpath resolution the walker rejects.

### Group D — dev/peer/optional dependency classification
The walker follows every static import regardless of dev/prod classification.
- `fixtures-no-trans-dev-deps` — transitive devDependency exclusion. **NON-parity
  today:** the walker over-includes the devDependency compartment-mapper omits, so
  this must NOT be exercised until classification lands, or it would falsely claim
  parity.
- `fixtures-missing-optional-peer-dependencies` — optional/peer handling *(+A require)*.
- `fixtures-optional-peer-dependencies` — optional peer-dependency handling *(+A require)*.

### Group E — non-JS asset languages / language-for-extension
Needs a parser-registration surface the walker lacks.
- `fixtures-assets` — imports non-JS asset modules (`.text` and similar).
- `fixtures-language-for-extension` — custom per-extension parser/language config.

### Group F — host hooks & synthetic sources
No `node_modules` graph exists on disk; the source is injected by the harness.
- `fixtures-exit` — `exitModuleImportHook` / non-file host specifiers (`h2g2:meaning`).
- `fixtures-module-source-hook` — `moduleSourceHook` synthetic-source injection.
- `fixtures-error-handling` — deliberate resolution/parse error injection to
  exercise compartment-mapper *diagnostics* (a negative fixture — see §3).

### Group G — nested-node_modules duplicate / upward resolution
Resolver-strength gaps around multiple `node_modules` layers, duplicates, symlinks.
- `fixtures-1` — multi-package upward resolution with nested `node_modules` copies
  and no single walkable app entry point.
- `fixtures-stability` — nested `node_modules` duplicate copies (`b/node_modules/dep`)
  the single-root-per-compartment walker rejects, plus an entry-vs-dependency
  compartment-id collision (`a@1.0.0`). **NON-parity today** (walker rejects it).
- `fixtures-common-deps` — common-dependency hoisting/dedup; shared dep not
  resolvable by a plain upward walk.
- `fixtures-symlink` — symlinked package resolution (realpath).
- `fixtures-resolve` — browser/`resolve` field and alias resolution.

### Group H — compartment-mapper-specific semantics (candidate durable excludes)
Behaviors that are compartment-mapper-internal concerns, not dependency-ingestion
concerns. Most are proposed as **durable** exclusions (§3), not pending ones.
- `fixtures-retained` — retained-modules (retention across the graph) flag.
- `fixtures-shortest-path` — shortest-path compartment naming over a require()-graph *(+A)*.
- `fixtures-shortest-path-cycle` — shortest-path naming with a require()-based cycle *(+A)*.
- `fixtures-policy` — policy enforcement plus conditional exports *(+C)*.
- `fixtures-strictly-inconsistent-directories` — strict-mode directory-inconsistency
  diagnostic plus CJS *(+A)*.
- `fixtures-strictly-inconsistent-packages` — strict-mode package-inconsistency diagnostic.
- `fixtures-noble` — conditional exports plus require()-based deps *(+A, +C)*.

All 33 are accounted: A(5) + B(4) + C(4) + D(3) + E(2) + F(3) + G(5) + H(7) = 33.

## 2. The harness problem — emulate vs. refactor, per group

This is the crux of the maintainer's note. compartment-mapper's fixtures are driven
by its own ava harnesses (`node.test.js`, `import.test.js`) that inject host import
hooks, policies, `moduleSourceHook`, per-extension language config, and non-standard
conditions. For a parity comparison to be **apples-to-apples**, endor's walker
output must be compared against node's output *for the same inputs* — which means
each group needs a decision: **emulate** the harness input inside endor's parity run
(pass the walker the same options the harness passes compartment-mapper), or
**refactor** the fixture so it runs harness-free for *both* engines.

The guiding rule: **do not refactor away the thing under test.** A harness input
that *is* a compartment-mapper feature (a condition set, a `dev:false` flag, a
language registration) should be **emulated** — supplied identically to both the
node oracle and endor's walker — because erasing it would erase the parity the
fixture exists to prove. Refactor only when the harness merely *stages* the fixture
(scaffolding) rather than *defines* its behavior.

| Group | Harness dependency | Decision |
| --- | --- | --- |
| A — CJS require | none special; `require()` is plain node semantics | **Neither.** Node oracle runs default options; endor gains `require()`-following. Harness-free on both sides already. |
| B — dynamic | none special (dynamic-`require` webpack fixtures may carry a `commonjs` language transform) | **Emulate** the walker capability (detect statically-analyzable dynamic specifiers; record dynamic edges as compartment-mapper does). Default options otherwise. |
| C — exports/imports | `conditional-host-exports` passes a non-standard **condition** (`endo:lib`) from the harness | **Emulate** the condition set: the parity run supplies the same conditions to *both* oracle and walker. Refactoring to a standard condition would delete the feature under test. |
| D — dep classification | the `dev`/`peer`/`optional` flags are compartment-mapper **options** the harness sets | **Emulate** by matching the option (e.g. `dev:false`) on both sides. Fixes today's NON-parity over-inclusion. |
| E — assets/language | harness registers a `.text` (and similar) parser via `parserForLanguage`/`languageForExtension` | **Emulate**: endor gains a language-for-extension config + asset parser, and the oracle runs with the matching registration. Refactor is impossible — the asset *is* the fixture. |
| F — host hooks | `exit`/`module-source-hook` sources are **injected by the harness**; nothing on disk | **Emulate-or-durably-exclude.** These need a host-hook surface on endor's `run` entry point. Until that surface exists they stay excluded; when it lands, the parity run supplies the same hook to both. `error-handling` is a negative fixture (§3). |
| G — nested/upward/symlink/resolve | mostly none; `resolve` sets a non-default **browser/resolve** option | **Emulate** the resolver (multi-layer `node_modules`, duplicate-copy id disambiguation, realpath for symlinks). For `resolve`, match the browser-field option on both sides. |
| H — cm-specific | policy/strict-diagnostics/retained/shortest-path are harness- and flag-driven internals | **Durable exclude** (§3) for most: parity of a naming strategy or policy engine is not a walker concern. |

**Node reference oracle (harness-free, both engines).** The parity assertion is
made concrete by a committed, harness-free node script
(`rust/endo/tools/gen-parity-golden.mjs`, suggested) that imports
`@endo/compartment-mapper` directly, calls `mapNodeModules`/`makeArchive` on a
fixture's canonical entry with **explicitly stated options** (the emulated
condition set / `dev` flag / language map for that fixture — *not* the ava
harness), and serializes a **stable, structural** compartment map — compartment
names/ids, per-compartment module specifiers, and parser language per module —
to `fixtures-<name>/expected-compartment-map.json`. This golden IS "node." endor's
walker emits the same structural shape; the parity test asserts structural
equality against the golden, upgrading today's compartment-*count* assertion to a
full-structure one. Because the oracle is a plain script (no ava, no fixture
harness), it can be regenerated in CI and diffed to catch reference drift when
compartment-mapper itself updates.

## 3. Ratchet increments (easiest / highest-parity-value first)

Each increment lands a walker capability, generates+commits the goldens, flips the
group's fixtures `Exclude`→`Exercise`, and bumps the exercised **floor** (§4). The
acceptance gate per increment is stated inline.

- **Increment 0 — parity oracle & scoreboard scaffold** *(prerequisite for all)*.
  Land `gen-parity-golden.mjs`, the golden JSON schema + structural walker output,
  the exercised-count **floor** assertion, and split `Exclude` into
  `PendingExclude { capability }` / `DurableExclude { reason }` so progress is
  measurable. No fixtures graduate yet. **Gate:** suite green; golden regeneration
  is deterministic; scoreboard prints `7 exercised / N pending / M durable`.

- **Increment 1 — CommonJS `require()` (Group A).** Highest value, unblocks the
  largest cluster and is a prerequisite for D/H. **Gate:** `cjs-compat`,
  `cycle-cjs`, `digest`, `esm-imports-cjs-define` exercised with committed goldens;
  `fixtures-0` exercised once its exports edge (Inc 2) also lands. Floor → 11.

- **Increment 2 — conditional & subpath exports/imports (Group C).** Self-contained
  resolution algorithm, ubiquitous in real packages. **Gate:**
  `conditional-host-exports` (with emulated `endo:lib` condition), `export-patterns`,
  `package-imports-exports`, `nested-pkg`, and `fixtures-0` exercised. Floor → 16.

- **Increment 3 — dep classification dev/peer/optional (Group D).** Fixes the
  existing NON-parity over-inclusion. Depends on Inc 1 for the require-based peer
  fixtures. **Gate:** `no-trans-dev-deps` flips from NON-parity to parity;
  `missing-optional-peer-dependencies`, `optional-peer-dependencies` exercised.
  Floor → 19.

- **Increment 4 — dynamic `import()`/`require()` (Group B).** Harder: requires
  deciding how statically-analyzable dynamic specifiers are followed and how
  dynamic edges are recorded to match compartment-mapper. **Gate:** `dynamic`,
  `dynamic-ancestor`, `dynamic-import-esm`, `optional` exercised. Floor → 23.

- **Increment 5 — nested/duplicate/symlink/resolve resolution (Group G).** Fixes
  `stability`'s NON-parity rejection. **Gate:** `fixtures-1`, `stability`,
  `common-deps`, `symlink`, `resolve` (matched browser-field option) exercised.
  Floor → 28.

- **Increment 6 — language-for-extension & non-JS assets (Group E).** Needs the
  parser-registration surface. **Gate:** `assets`, `language-for-extension`
  exercised with the emulated parser registration on both sides. Floor → 30.

- **Increment 7 — host hooks & synthetic sources (Group F)** *(gated on endor
  growing a host-hook surface; otherwise deferred, not forced).* **Gate:** `exit`,
  `module-source-hook` exercised via a shared hook supplied to oracle and walker.
  Floor → 32.

- **Durable exclusions (reclassify, do not chase).** `retained`, `shortest-path`,
  `shortest-path-cycle`, `policy`, `strictly-inconsistent-directories`,
  `strictly-inconsistent-packages`, `noble` (Group H), and `error-handling` (a
  negative-diagnostic fixture whose "parity" is matching an error, a different
  assertion kind). Move these to `DurableExclude` so the pending set shrinks to a
  true campaign horizon rather than reading forever as unfinished. Reaching the end
  of Increments 1–7 with these seven durably excluded IS the parity finish line for
  the walker's scope; whether any later becomes exercisable is a separate decision.

## 4. Ratchet mechanism & anti-backslide gate

Monotonic, drift-proof coverage rests on four mechanisms, three of which extend
the manifest that already exists:

1. **Two-tier exclusions.** Replace the single `Exclude { reason }` with
   `PendingExclude { capability }` (blocked on a named capability group; will
   graduate) and `DurableExclude { reason }` (out of scope for the walker). The
   scoreboard test then reports `exercised / pending / durable`, making campaign
   progress a measurable number rather than prose.

2. **Graduation is atomic.** A fixture moves to `Exercise` **only** in the same
   commit that (a) lands the enabling walker capability and (b) commits its
   node-reference golden. The existing `no_unaccounted_fixture_drift` +
   `every_exclusion_has_a_reason` guards already forbid dropping a fixture from the
   accounting or flipping it to a blank skip.

3. **Exercised floor (anti-backslide).** The existing "expected several exercised"
   assertion becomes a hard, ratcheting floor: each increment raises the minimum
   exercised count (7 → 11 → 16 → 19 → 23 → 28 → 30 → 32). A later change that
   silently re-excludes a graduated fixture drops below the floor and **fails the
   suite** — regressions cannot pass unremarked.

4. **Parity asserted against node, structurally.** "Parity with node" is the
   committed golden compartment-map (compartment ids, module specifiers, parser
   language) from the harness-free oracle, diffed structurally against the walker's
   output — not a hand-written count. CI regenerates the goldens from
   `@endo/compartment-mapper` and fails on drift, so a reference-behavior change is
   caught rather than silently masked.

## 5. Follow-up build increments (the orchestration)

Per the standing multi-part rule, the campaign is carried by **one orchestration**
with **parked children**, not a loose pile. Recommended: **serial**,
`--on-child-failure halt` (each increment depends on the prior's capability and
floor). Children map one-to-one to the increments above; child 0 (the oracle
scaffold) must run first because every later increment consumes its golden
mechanism.

| Order | Child base | Increment | Depends on |
| --- | --- | --- | --- |
| 0 | `endor-parity-oracle-scaffold` | Inc 0 — oracle + scoreboard + two-tier exclude + floor | — |
| 1 | `endor-walker-cjs-require` | Inc 1 — CommonJS `require()` (Group A) | 0 |
| 2 | `endor-walker-exports-resolution` | Inc 2 — conditional/subpath exports (Group C) | 0 |
| 3 | `endor-walker-dep-classification` | Inc 3 — dev/peer/optional (Group D) | 1 |
| 4 | `endor-walker-dynamic-import` | Inc 4 — dynamic `import()`/`require()` (Group B) | 1 |
| 5 | `endor-walker-nested-resolution` | Inc 5 — nested/duplicate/symlink/resolve (Group G) | 0 |
| 6 | `endor-walker-language-extensions` | Inc 6 — language-for-extension/assets (Group E) | 0 |
| 7 | `endor-walker-host-hooks` | Inc 7 — host hooks (Group F), gated on host-hook surface | 0 |

Each child is a builder job against the PR head branch
`feat/endor-run-entry-point-deps` (or `llm` if it has landed), carrying the
local-build gotcha (copy the gitignored Moddable `xs/` sources and empty
`xsnap/src/*_bootstrap.js`/`ses_boot.js` stubs from a sibling worktree at the same
commit; never commit them). The top-level `test/fixtures` hoist stays out of scope.

The orchestration is posted when this design merges; the design→PR pipeline then
advances the ratchet increment by increment until the pending set is empty and only
the durable exclusions remain — which is what *"until we reach parity"* means for
the walker's scope.
