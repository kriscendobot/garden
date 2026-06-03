---
source: docs/platform-specific.md
source_repo: MetaMask/ocap-kernel
source_url: https://github.com/MetaMask/ocap-kernel/blob/main/docs/platform-specific.md
source_path: docs/platform-specific.md
source_commit: a3eff0efb70ba5f4c5919290aa295fe32138df4f
section_kind: doc
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - daemon
  - tooling
  - getting-started
genre: §sibling-implementation-comparison
cycle: 165
lane: comments
status: current
---

# Platform-obvious vs platform-implicit exports with six-step contributor guide for Node / browser split

> §Sibling-implementation-comparison genre (fifth ingest;
> §ocap-kernel-mini-series cycles 161 / 162 / 163 / 164 /
> 165). §Queued-doc-4 from cycle 161 overview's plan.

`docs/platform-specific.md` (92 lines) is the **§contributor-
onboarding-document** for ocap-kernel's Node-vs-browser
split. Distinctively for the ocap-kernel docs, it doesn't
describe the *system* — it describes the *development
workflow* for adding platform-specific features. §Doc-as-
contract-with-future-contributors.

§The-document-targets-contributors-not-users — distinct from
cycle 164's identity-backup-recovery.md (which targeted
users). This positions the docs as a §two-audience-surface:
some docs are user reference, others are contributor
discipline.

## §Two-platforms-Node-and-browser-as-canonical-targets

> *Currently, the kernel targets two primary platforms:
> Node.js - Server-side JavaScript runtime; Browser -
> Client-side web environment.*

§Two-platform-canon. §Node-as-server-side; §browser-as-
client-side. The doc acknowledges these are the *current*
targets — §implicit-extensibility (additional platforms
could be added) but no commitment to them.

§Endo-comparison: Endo's daemon is Node-only; the
EndoTether (cycles 145, 147 et al.) is the browser
counterpart. The two-platform shape is the same; ocap-
kernel's version is more *coupled* (kernel runs on both
platforms; one or the other is chosen per deployment).
Endo's version is *split-roles* (daemon-on-Node + tether-
on-browser as cooperating components, not alternates).

## §Layered-architecture-with-core-and-runtime-packages

> *The kernel follows a layered architecture where core
> packages contain both abstract type declarations and
> their corresponding platform-specific implementations.
> The platform-specific runtime packages serve as
> orchestrators that import the appropriate
> implementations from core packages via specialized
> export paths.*

§Two-layer-package-structure:

1. **Core packages**: contain both §abstract-types-as-
   API-surface AND §platform-specific-implementations
   side-by-side.
2. **Runtime packages** (`kernel-browser-runtime`,
   `nodejs`): §orchestrators-that-import-the-right-one.

§Don't-split-platform-implementations-into-separate-packages
discipline: keeping Node-impl and browser-impl in the same
core package gives §single-source-of-truth-for-the-
abstraction. The runtime packages just choose.

§Endo-comparison: Endo's daemon package mixes Node-specific
code with abstractions; the split between abstraction and
implementation is less formalized. §Synthesis-target: a
§named-core-vs-runtime-layering convention could make
Endo's Node-vs-browser story more discoverable.

## §Platform-obvious-vs-platform-implicit-exports

> *Platform-obvious exports: Modules like `kernel-store/
> sqlite/nodejs` clearly target Node.js environments.
> Platform-implicit exports: Modules like `kernel-store/
> sqlite/wasm` target browser environments through
> WebAssembly.*

§The-naming-convention-tells-platform. Two flavors:

- **§Obvious**: the path segment says `nodejs` or `browser`.
- **§Implicit**: the path segment says the *mechanism*
  (`wasm`) — readers infer the platform.

§Mechanism-named-not-platform-when-platform-is-implied.
§Reader-must-know-WASM-implies-browser — there's a §reader-
literacy-prerequisite. The doc explicitly calls this out,
which is §discipline-by-disclosure.

§Synthesis-target: Endo's per-package conditional exports
(via `package.json` `"browser"` field or similar) hide the
platform choice from the reader; this naming convention
exposes it. §Surface-the-choice-don't-hide-it could be
borrowed.

## §Mermaid-diagram-of-package-relationships

> ```mermaid
> graph TD
>     A["Core Kernel Packages"] -->|browser implementation| B["kernel-browser-runtime"]
>     A -->|node implementation| C["nodejs"]
>     B -->|e2e testing| D["extension"]
>     C -->|e2e testing| E["kernel-test"]
> ```

§Visual-of-the-package-graph. Four packages named:
kernel-browser-runtime, nodejs, extension, kernel-test.

§Mermaid-as-doc-tool. §Diagram-shows-arrow-direction-of-
dependency (core → runtime → e2e-test). The arrows say
*who imports whom*.

§E2E-testing-packages-as-distinct-layer: the testing
infrastructure is its own package per platform (not mixed
into the runtime package). §Test-isolation-as-package-
isolation; cycle 153's §ci-no-npm-lifecycle three-layer-
auditable defense has a sibling here: §test-package-as-
auditable-boundary.

## §Six-step-development-guideline (the contributor flow)

The doc's §single-most-structurally-interesting-move: a
numbered §six-step-flow for adding a platform-specific
feature:

1. **§Package-Creation** — create or reuse a package.
2. **§Platform-Agnostic-Implementation** — implement
   shared types and abstractions in `my-package/src/`.
3. **§Platform-Specific-Implementation** — choose simple
   (`<platform>/`) or complex (`<feature>/<platform>/`)
   directory structure.
4. **§Package-Configuration** — update `package.json`
   exports.
5. **§Platform-Integration** — wire into runtime package.
6. **§End-to-End-Testing** — add tests to the per-
   platform e2e package.

§Steps-are-ordered-with-explicit-dependency. §Abstraction-
first-then-platforms-then-integration-then-tests. §Tests-
come-last-not-out-of-laziness-but-because-they-validate-
the-prior-five-steps.

§Endo-comparison: Endo's contributor docs (cycle 17's
top-level CONTRIBUTING + per-package READMEs) don't have
this clean a §named-flow for adding platform-specific
features. §Synthesis-target: §six-step-named-flow could
be adopted for Endo's platform additions.

## §Two-directory-structure-choices

> *Simple platform variants: `my-package/src/<platform>/`*
> *Complex feature-platform combinations: `my-package/src/
> <feature>/<platform>`*

§Simple-or-complex-choice. The doc gives §explicit-
permission-for-both — §convention-with-justified-flexibility
discipline.

§Why-two-shapes: simple when a package has *one* platform
split; complex when a package has *multiple features*
each with platform splits. §Don't-force-deep-nesting-when-
shallow-works.

§Cycle-157's-exo-zip-package-design has a sibling pattern:
§Don't-formalize-what-doesn't-need-formalizing applies to
directory structure too.

## §Package-json-export-paths-match-directory-structure

> *Ensure the export paths match your implementation
> directory structure and follow the project's naming
> conventions.*

§Discipline-named: §directory-structure-becomes-export-
paths. §No-mismatch-between-filesystem-and-package-graph.

§Why-this-matters: when the directory structure and export
paths diverge, the reader must do §two-lookups to find code
(open package.json, find the export path, find the file).
When they match, §one-lookup suffices. §Reduce-cognitive-
overhead-by-removing-renames.

§Endo-cycles-67-69-marshal observation: Endo's marshal
package has some indirection between exports and file paths
(historical baggage). The convention here would reduce
that overhead going forward.

## §Integration-points-named-explicitly

For Node:
- `vat-worker.ts` — vat-related features.
- `make-kernel.ts` — kernel construction features.

For browser:
- `kernel-worker.ts` — kernel worker functionality.
- `iframe.ts` — vat iframe functionality.

§Don't-leave-the-contributor-guessing-where-to-wire-things-
in. §Concrete-file-paths-as-integration-targets. §The-
contributor-knows-which-file-to-edit-from-step-5.

§Endo-comparison: Endo's contributor docs typically say
"register your service" without naming the file. §Synthesis-
target: §name-the-integration-file would make Endo
contributor work more concrete.

## §E2E-testing-strategy

> *Browser platform: Tested through the `extension`
> package. Node.js platform: Tested through the
> `kernel-test` package.*

§Per-platform-e2e-package. §Each-platform-has-a-canonical-
test-home.

§Why-not-co-locate-tests-with-the-feature: e2e tests
require platform setup (browser harness for one, Node
harness for the other). Putting them in a dedicated
package keeps the platform setup §amortized-across-all-
e2e-tests-for-that-platform.

§Synthesis-target: Endo has package-local tests but no
canonical per-platform e2e home. The slot machine work
will need both Node-side and browser-side e2e harnesses;
§canonical-per-platform-test-package is borrowable.

## §Doc-as-contract-with-future-contributors

The doc is the *contract* between current maintainers and
future contributors: §here-is-how-we-do-this; §follow-it-
and-your-PR-will-be-mergeable.

§The-doc-is-a-norm-not-an-explanation. §Reading-it-tells-
you-the-rules-not-the-rationale (mostly). §This-is-fine-
for-contributor-onboarding — rationale lives in design docs;
*how* lives in contributor guides.

§Cycle-161-overview's-AGENTS.md observation has a sibling
here: AGENTS.md is the *agent* equivalent of this doc.
§Two-norm-surfaces (human-contributor + agent-contributor)
with similar structure.

## §Gap-revealing-comparison with garden cycles

| Cycle | Observation |
|-------|-------------|
| Cycle 145 (formula-inspector) | UI surface; browser-side; cycle 145's discipline doesn't name a §platform-specific-development-guide |
| Cycle 147 (workers-panel) | Daemon-observability; cross-platform concern |
| Cycle 137 (daemon-message-streaming) | Straddles Node and browser; could benefit from §platform-obvious-vs-platform-implicit-exports |
| Cycle 161 (overview) | Named ocap-kernel's 30-package layout; this doc tells contributors how to add to it |
| Cycle 164 (identity-backup-recovery) | User-targeted doc; contrasts with this contributor-targeted doc — §two-audience-surface |

## §Tier-1 vocabulary borrowing candidates

§Core-vs-runtime-package-layering, §platform-obvious-vs-
platform-implicit-exports, §six-step-development-flow,
§directory-structure-becomes-export-paths, §canonical-
per-platform-test-package, §name-the-integration-file.

§Tier-2: §two-audience-surface (user docs vs contributor
docs), §doc-as-contract-with-future-contributors.

## §Reference-not-substrate stance

This doc's *vocabulary* is borrowable; its *implementation*
choices (kernel-browser-runtime + nodejs as package names,
extension + kernel-test as e2e packages) are ocap-kernel-
specific. §Borrow-the-shape-not-the-names.

## §Small-doc-is-still-substantive

92 lines is the smallest doc in the §ocap-kernel-mini-
series ingest queue so far (cycle 162: 203 lines; 163:
240; 164: 289). §Cohesion-honest-section-count is still
one: §the-six-step-flow-is-the-spine-of-the-doc; splitting
would fragment the §contributor-onboarding-shape.

§Small-doc-doesn't-mean-shallow-ingest: the §gap-revealing-
comparisons are as substantive as larger docs' would be.
The doc's brevity is a feature of the source (§terse-by-
design), not of the comparison.
