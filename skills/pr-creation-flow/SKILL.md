---
created: 2026-05-13
updated: 2026-05-20
author: gardener
---

# Skill: pr-creation-flow

The canonical procedure that ties the per-PR roles together: which role opens the PR, which roles touch it before the maintainer ever sees it, and which role decides it is ready for the maintainer's review queue. Read by every role the flow touches ([builder](../../roles/builder/AGENT.md), [assayer](../../roles/assayer/AGENT.md), [cleaner](../../roles/cleaner/AGENT.md), [judge](../../roles/judge/AGENT.md), the code-panel seats ([assessor](../../roles/assessor/AGENT.md), [typist](../../roles/typist/AGENT.md), [stylist](../../roles/stylist/AGENT.md), [packager](../../roles/packager/AGENT.md), [archivist](../../roles/archivist/AGENT.md), [prover](../../roles/prover/AGENT.md), [curator](../../roles/curator/AGENT.md), [migrator](../../roles/migrator/AGENT.md), [locksmith](../../roles/locksmith/AGENT.md), [warden](../../roles/warden/AGENT.md), [saboteur](../../roles/saboteur/AGENT.md), [breaker](../../roles/breaker/AGENT.md), [purist](../../roles/purist/AGENT.md), [spec-keeper](../../roles/spec-keeper/AGENT.md), [wire-watcher](../../roles/wire-watcher/AGENT.md), [engine-realist](../../roles/engine-realist/AGENT.md)), the design-panel seats ([critic](../../roles/critic/AGENT.md), [skeptic](../../roles/skeptic/AGENT.md), [copyeditor](../../roles/copyeditor/AGENT.md), [pedant](../../roles/pedant/AGENT.md), [novice](../../roles/novice/AGENT.md)), and [fixer](../../roles/fixer/AGENT.md)) and by the orchestrators ([liaison](../../roles/liaison/AGENT.md), [steward](../../roles/steward/AGENT.md)) that dispatch them.

The skill is the orchestration map. Per-role detail (how to write a test, how to address a review thread, how to delete dead code) lives in the role files and the role-specific skills.

## Vocabulary: "the gamut"

The flow as a whole has a maintainer-supplied synonym: **the gamut**. "Run the gamut" on a PR means resume the chain from wherever it currently sits and chase it until the judge un-drafts; "run the gamut on #N" names a specific PR; "run the gamut" without a PR specifier names the open set of garden-authored draft PRs. The procedure does not change; this section is only the vocabulary the orchestrators use when reading user prompts and inbox messages.

- The **liaison** runs the gamut in one engagement (multiple sequential dispatches, one liaison turn) when a user prompt names it; see `roles/liaison/AGENT.md` § Vocabulary: the gamut.
- The **steward**'s per-cycle PR-creation-flow scan **is** the gamut in autonomous form, dispatching the next-owed stage for each draft PR per cycle; an inbox `message: liaison → steward` saying "run the gamut on #N" rate-limits the per-cycle scan onto that PR until it un-drafts. See `roles/steward/AGENT.md` § Vocabulary: the gamut.

Both orchestrators read the next-stage-owed via *The next-stage-owed heuristic* below, and neither bypasses the chain's discipline (the cleaner still runs before the jury except on the explicit variants, the judge still runs the panel, and the fixer-loop still iterates).

## When to use

- The orchestrator dispatches a builder against an issue or design. The flow starts here.
- A maintainer asks for a fresh PR. The flow is the same.
- A cold PR opened by someone else gets a jury panel after the fact. The flow's cleaner and judge stages still apply; only the builder stage is skipped.

## Draft discipline

**The builder opens every PR in draft state**: `gh pr create --draft` (or the API equivalent with `draft: true`). The draft flag is the load-bearing signal that the bot-side chain has not yet finished. **The judge is the only role that moves the PR out of draft** (`gh pr ready <N>`), and only when the jury-fixer loop terminates with no in-scope must-fix.

Why draft state rather than labels: draft state is enforced by GitHub itself (reviewers cannot be auto-requested on a draft, the PR is visually distinct, the merge button is disabled). Labels are advisory text the bot writes and the bot reads; nothing outside the bot acts on them. The flow uses draft vs ready-for-review as the load-bearing state, with labels (if used at all) as advisory annotation.

## Flow ordering

```
builder (opens draft PR)
   |
   |  in concert (default), or before, or after
   v
assayer  --pushes tests to same branch
   |
   v
cleaner (coverage pass; dead-code; same branch)
   |
   |  cleaner pushes coverage commits, watches CI converge
   v
judge (foreperson; picks panel by PR shape; dispatches the panel)
   |
   |  judge runs the code panel (twenty-three seats, concurrent) + gh pr edit --add-reviewer @copilot
   |  OR the design panel (seven seats, concurrent; no @copilot) on a design-only PR
   v
panel verdict (judge aggregates, submits formal gh pr review)
   |
   |  if must-fix items, the orchestrator dispatches a fixer
   v
fixer --pushes follow-up commits
   |
   v
judge re-dispatches the same panel against the fixer's head
   |
   |  loop until the panel surfaces no further in-scope must-fix
   v
gh pr ready <N>  (judge un-drafts; PR enters maintainer's review queue)
```

Variants:

- **Cleaner-skipped tiny-PR variant.** When the PR is pure documentation, lockfile-only churn, a one-file format sweep, or a single bug-fix line whose test fixture is already in the diff, the cleaner has no coverage surface to expand. The orchestrator skips the cleaner and **dispatches the judge directly after the builder**. There is no procedural no-op cleaner stage; the cleaner is skipped, not run-as-a-no-op. The judge still runs the panel and un-drafts at the end of the loop.
- **Design-only-PR variant.** When the PR is **design-only** (file additions only under `<project>/designs/` or the project's equivalent design directory, no source changes, no test changes), the flow is **builder → judge (design panel) → fixer loop → un-draft**. The assayer is skipped (no test surface to author against), and the cleaner is skipped (no coverage surface, no source dead code). The orchestrator dispatches the judge directly after the builder; the judge picks the design panel per `roles/judge/AGENT.md` § Panel-kind discrimination and runs the seven-seat design panel (critic, skeptic, decomplector, ergonomist, copyeditor, pedant, novice). The fixer loop and un-draft step are unchanged from the default flow; the fixer's commits on a design-only PR are revisions to the design document itself. The base of a design-only PR is the project's bot-fork roadmap branch rather than the implementation base; see *Designs versus implementations* below for the base-split rule.
- **No must-fix on first panel round.** The fixer step is skipped. The judge declares the loop done after the first panel verdict and un-drafts immediately.
- **Pre-merge fix-up rounds (after maintainer review).** The maintainer's `CHANGES_REQUESTED` triggers the standard fixer loop (fixer to CI-green to re-request maintainer); neither the cleaner nor the judge re-runs by default. The PR stays out of draft; the maintainer's review queue is the venue. A maintainer who explicitly asks for a fresh cleaner or judge pass overrides this default.

## Designs versus implementations

Design PRs and implementation PRs are two separate PRs against two different bases. The maintainer's framing on 2026-05-14: "We don't carry designs onto the master branch. The designs should be based on llm. The implementations should be based on master, for those designs."

- A **design PR** lands on the project's bot-fork roadmap branch (today `llm` on `endojs/endo-but-for-bots`). The designer opens it in draft; its diff is the `designs/<slug>.md` file. It runs through the *Design-only-PR variant* of this skill's flow chain: builder, judge (with the design panel), fixer loop, un-draft. The assayer and cleaner stages are skipped (no test or source surface).
- An **implementation PR** lands on the project's natural implementation base (today `master` on `endojs/endo-but-for-bots`). A separate builder dispatch opens it; its diff is the source change that realizes the design. It runs through the full flow chain (builder, assayer, cleaner, judge with the code panel, fixer, un-draft).
- The boatman later ferries the implementation to the upstream `master` if and when the maintainer authorizes.
- Reference shape: `endojs/endo-but-for-bots#232` (Node-18-drop design on `llm`) and `endojs/endo-but-for-bots#246` (Node-18-drop master-base implementation, mirrored from `#232`).

The two PRs are intentionally not combined. A single PR carrying both the `designs/<slug>.md` file and the implementation source forces the maintainer to review documentation prose alongside source diff, dilutes the design review's audience (anyone interested in the design must filter implementation noise), and prevents the boatman from ferrying the implementation alone. The split also lets the implementation land before, with, or after the design at the maintainer's discretion. The split also lets the design and code panels review the two surfaces independently with the seat lists each shape warrants.

## Assayer placement

The assayer authors tests for *this PR's contribution*. The default placement is **in concert with the builder**: the assayer and builder are dispatched concurrently against the same branch, the builder writes the production change, the assayer writes the tests that pin the contract, and both push to the same branch as their commits land. The two roles coordinate via the dispatch briefs and the PR's commit log, not via an explicit synchronization step.

Two other orderings are supported when the change's shape calls for them:

- **Before the builder (TDD-style).** The assayer writes tests that fail closed against the current production code; the builder is then dispatched to make them pass. Best fit: the contract is fully specified in the issue or design, and the builder benefits from a fail-fast definition of done.
- **After the builder (regression-coverage).** The builder writes production and lands a draft PR; the assayer is then dispatched to pin the regressions the change closes. Best fit: the change is a bug fix where the contract is "the behavior described in the bug report"; the assayer's test pins exactly that.

The orchestrator names the placement in the dispatch brief. Default is in concert unless the brief specifies otherwise.

### Default rationale

In-concert is the default because:

- The builder and assayer share the same branch; concurrent pushes work cleanly because their commits touch disjoint files (production vs test).
- TDD-style requires the builder to be blocked on the assayer's first push; the time-to-first-CI-green stretches.
- Regression-after means the assayer's test is written against code that already passes (less load-bearing per `skills/regression-evidence/SKILL.md`'s shape); the assayer has to temporarily break the production code to confirm the test fails, which is an extra step.

The notes-from-the-field section accumulates evidence as the flow runs; if a different default emerges, this section updates.

## Cleaner placement

The cleaner stands **between the builder (and any in-concert assayer) and the judge**. By the time the panel reads the PR, the test surface has been expanded and dead code is gone, so the panel reviews the final shape rather than a half-tested draft. The cleaner's remit:

- Run a coverage pass on the package(s) the PR touched, per `skills/coverage-driven-testing/SKILL.md`.
- Push coverage commits to the same branch.
- Watch CI converge to green (or only documented pre-existing infra red) on the cleaner's own HEAD.
- Report done. **The cleaner does not un-draft.**

Un-draft authority moved from the cleaner to the judge in the 2026-05-14 redesign. The maintainer's framing on the move: "I don't see the cleaner as a juror since it both writes and runs tests, which is to say, it should continue to stand between the builder and the jury." The cleaner is explicitly **not a juror**; its mutating work (writing and running tests) does not fit the read-only review posture the panel seats hold.

If the PR is `CONFLICTING` against its base when the cleaner arrives, the cleaner does not push coverage commits onto a non-mergeable head. It surfaces "needs a weaver before cleaner" and the orchestrator dispatches a weaver first.

## Jury composition

There are **two default panels**: the code panel (twenty-three seats, for source-touching PRs) and the design panel (seven seats, for design-only PRs). The judge picks one per round based on the PR's file list per `roles/judge/AGENT.md` § Panel-kind discrimination.

**Panel-kind rule.** A PR is **design-only** when every changed path is under `<project>/designs/` (or the project's equivalent design directory) and no path is under `src/`, `test/`, `tests/`, or `packages/<name>/src/`. Otherwise the PR is source-touching, and the code panel applies. Mixed PRs (source plus design document) get the code panel; the design content rides as supplementary context in the code panel's report rather than as its own pass.

### Code panel (default for source-touching PRs)

Twenty-three seats, dispatched by the judge as one panel round. The 2026-05-14 redesign halved each of the prior six seats' responsibilities into two more-focused successor seats so the panel hits each inquiry area twice with one primary per area; the 2026-05-15 expansion added four maintainer-modeled seats (ocap purity, spec rigor, wire integrity, engine realism) whose lenses were distilled from the empirical PR-feedback patterns of senior reviewers across `endojs/endo` and `Agoric/agoric-sdk`; the 2026-05-18 expansion added a fifth maintainer-modeled seat (`integrator`, empirical source: `@kriskowal`) for integration-coherence reading; the 2026-05-20 expansion added six narrow PR-#75-derived seats (`benchmarker`, `changeset-auditor`, `surfacer`, `scribe`, `pruner`, `gateway`) for one-lens-each coverage of the recurring complaint classes the seventeen-seat panel was missing.

- [assessor](../../roles/assessor/AGENT.md): correctness logic, control flow, error handling. Secondary: invariant claims overlap with the breaker.
- [typist](../../roles/typist/AGENT.md): type accuracy (TS, JSDoc types, narrowings). Secondary: public-API signature correctness overlap with the curator.
- [stylist](../../roles/stylist/AGENT.md): naming and identifier choice. Secondary: doc-name accuracy overlap with the archivist.
- [packager](../../roles/packager/AGENT.md): diff hygiene, commit splitting, changeset content. Secondary: public-surface rename description overlap with the stylist and curator.
- [archivist](../../roles/archivist/AGENT.md): docs and comment / JSDoc prose accuracy. Secondary: naming-vs-docstring overlap with the stylist.
- [prover](../../roles/prover/AGENT.md): regression evidence (test load-bearingness). Secondary: correctness on the tested path overlap with the assessor.
- [curator](../../roles/curator/AGENT.md): public API surface, exported identifier shape. Secondary: bump-level correctness overlap with the migrator.
- [migrator](../../roles/migrator/AGENT.md): backwards compatibility, behavior under prior callers, peer-dep cascade, bump-level. Secondary: silent contract shifts on the public surface overlap with the curator.
- [locksmith](../../roles/locksmith/AGENT.md): capability flow and attenuation. Secondary: boundary-crossing capabilities overlap with the warden.
- [warden](../../roles/warden/AGENT.md): SES / hardened-JS boundary, harden discipline, unguarded globals, prototype pollution. Secondary: capability-on-boundary overlap with the locksmith.
- [saboteur](../../roles/saboteur/AGENT.md): adversarial inputs (boundary, type confusion, adversarial values, reentrancy, timing). Secondary: invariant adjacency overlap with the breaker.
- [breaker](../../roles/breaker/AGENT.md): invariant attacks against claimed contracts (`M.interface()`, attenuator promises, vat-boundary contracts). Secondary: capability-attack overlap with the locksmith.
- [purist](../../roles/purist/AGENT.md): ocap purity and conceptual integrity (passability, frozen-property hygiene, side-channel closure, type-vs-value namespace separation, family-consistency, minimum viable abstraction). Secondary: invariant-claim integrity overlap with the breaker. Empirical source: `@erights`.
- [spec-keeper](../../roles/spec-keeper/AGENT.md): ECMA-262 / WebIDL / TC39-proposal rigor, engine variance, primordial preservation, forward-compat with proposals, brittle-test resistance, less-coupling. Secondary: regression-evidence on engine-variance tests overlap with the prover. Empirical source: `@gibson042`.
- [wire-watcher](../../roles/wire-watcher/AGENT.md): security-protocol correctness on the wire (check-before-trust ordering, in-band-marker trust-bypass, parser divergence, identifier discipline, protocol state-machine invariants, failure-mode test catalog). Secondary: capability-on-trust-boundary overlap with the locksmith and warden. Empirical source: `@warner`.
- [engine-realist](../../roles/engine-realist/AGENT.md): V8 / XS realism, vat-lifecycle phase, allocation and GC budget, ephemeral vs virtual vs durable storage, engine-version compat, work-deferral. Secondary: regression-evidence on engine-semantic tests overlap with the prover. Empirical source: `@mhofman`.
- [integrator](../../roles/integrator/AGENT.md): integration coherence with the project's existing structure (merge-commit readability, concept-namespace coherence, rename-completeness sweep, convention probe, forward-compose probe, test-pins-constant, public-surface-in-tests, type-level discouragement, cycle-obviation, diagram maintainability, commit grouping, master-base mirror, minimum cleavage). Secondary: diff-hygiene overlap with the packager and docs-prose overlap with the archivist on the integration slice. Empirical source: `@kriskowal`.
- [benchmarker](../../roles/benchmarker/AGENT.md): benchmark-closure on every optimization claim (every thread proposing an optimization is closed with a posted measurement or an explicit "not pursuing" rationale). Secondary: regression-evidence-on-performance overlap with the prover. Empirical source: PR #75 (`r3176092650`, `r3177640845`, `r3177641818`, `r3177661512`, and five more across 16 reviews).
- [changeset-auditor](../../roles/changeset-auditor/AGENT.md): changeset-vs-diff coherence (front-matter package set, bump level, body identifier coherence, sentence-per-line, no process commentary). Secondary: diff-hygiene overlap with the packager on the changeset-content slice. Empirical source: PR #75 (`r3270497748`, `r3270499077`, `r3270500584`).
- [surfacer](../../roles/surfacer/AGENT.md): public-surface coherence (`package.json` exports, `index.js` thunk, published types, README's claimed-public surface all agree). Secondary: public-API-shape overlap with the curator on the four-surface coherence slice. Empirical source: PR #75 (`r3178360817`, `r3270527743`, `r3270531154`).
- [scribe](../../roles/scribe/AGENT.md): knowledge-capture closure (every maintainer "note this in standing orders" ask produces an actual edit or a proposed-rule message to the gardener). Secondary: docs-prose overlap with the archivist on the process slice. Empirical source: PR #75 (`r3223744548`, `r3223667088`, `r3178360817`, `r3223741240`, `r3223690950`).
- [pruner](../../roles/pruner/AGENT.md): documentation padding (boilerplate sections, padding-for-padding's-sake, sections beneath the reader's needs). Secondary: docs-prose accuracy overlap with the archivist and prose-mechanics overlap with the copyeditor on the omit-this-section slice. Empirical source: PR #75 (`r3270553775`, `r3223670237`).
- [gateway](../../roles/gateway/AGENT.md): repo-root-config justification (any change to repo-root config carries explicit scope-justification; per-package alternatives considered when relaxation would suffice locally). Secondary: diff-scope overlap with the packager on the root-config slice. Empirical source: PR #75 (`r3270550084`).

Plus one fire-and-forget shell call alongside the twenty-three dispatches (not a separate `Agent` invocation):

```sh
gh pr edit <N> -R <owner>/<repo> --add-reviewer @copilot
```

### Design panel (default for design-only PRs)

Seven seats, dispatched by the judge as one panel round. The panel reviews a design document as a written artifact rather than reviewing code, so the seats target prose-and-argument inquiry areas rather than code-correctness areas.

- [critic](../../roles/critic/AGENT.md): substantive critique of the proposed approach (goals, constraints, tradeoffs, rejected alternatives, composition with the rest of the system). Secondary: rationale-integrity overlap with the skeptic.
- [skeptic](../../roles/skeptic/AGENT.md): adversarial premise attacks (assumptions, spec reading, workflow framing, compatibility, test-catalog completeness, failure-mode handling). Secondary: rationale-of-approach overlap with the critic.
- [decomplector](../../roles/decomplector/AGENT.md): Rich-Hickey-lens reading (simple-vs-easy, complecting vs decomplecting, essential vs accidental complexity, value-oriented vs place-oriented, minimum viable abstraction). Secondary: invariant-survivability overlap with the code panel's breaker (mirror seat across the design / code boundary).
- [ergonomist](../../roles/ergonomist/AGENT.md): interface ergonomics on the proposed surface (API: surface coherence, discoverability, least-surprise, parameter order, return shape, error visibility; UI: layout, accessibility, user path, affordance). Secondary: approach-rationale overlap with the critic.
- [copyeditor](../../roles/copyeditor/AGENT.md): prose mechanics (grammar, sentence structure, paragraph flow, voice consistency, jargon introduction, section transitions). Secondary: sentence-level clarity overlap with the novice.
- [pedant](../../roles/pedant/AGENT.md): formal style (Chicago Manual conventions plus the garden's own style rules: em-dash discipline, relative-path discipline). Secondary: rule-settled prose-mechanic overlap with the copyeditor.
- [novice](../../roles/novice/AGENT.md): top-down clarity as a naive reader (logical progress, assumed background, skipped reasoning steps, prose density, example clarity). Secondary: mental-model-gaps-after-jargon-introduction overlap with the copyeditor.

The design panel does **not** add `@copilot`: the design surface is prose rather than code, and Copilot's code-review heuristics do not apply.

### Why twenty-three seats (code panel)

Maintainer's framing (2026-05-14): each seat should carry **half** of what the prior six-seat version did, so the panel can be deeper in each inquiry area without diluting any seat's focus. The earlier framing remains true ("each kind of review is conducted more than once, but a wide variety of concerns are evaluated"); the 2026-05-14 directive narrows the per-seat lens by splitting each prior seat into two successor seats with disjoint primary surfaces and one deliberate overlap each.

Splits, one line per prior seat:

- **assessor** split into `assessor` (correctness logic and control flow) plus `typist` (type accuracy). Rationale: the typist's lens (JSDoc / TS type accuracy) is mechanically distinct from logic correctness and benefits from a dedicated reader.
- **stylist** split into `stylist` (naming only) plus `packager` (diff hygiene, commit splitting, changeset). Rationale: naming is a code-side concern; the packager's lens is the shape of the PR itself.
- **archivist** split into `archivist` (docs and comment prose) plus `prover` (regression evidence). Rationale: the regression-evidence audit is procedural (would the test reden if reverted) and warrants a dedicated reader; the archivist's lens stays on prose accuracy.
- **curator** split into `curator` (public surface and signature shape) plus `migrator` (backwards compat, peer-dep cascade, bump-level). Rationale: the curator inventories what changed; the migrator audits what depends on it.
- **locksmith** split into `locksmith` (capability flow and attenuation) plus `warden` (SES boundary, harden discipline, prototype pollution). Rationale: capability flow inside the module is mechanically distinct from the SES / hardened-JS boundary discipline.
- **saboteur** split into `saboteur` (adversarial inputs) plus `breaker` (invariant attacks against claimed contracts). Rationale: input-shape attacks target the code's behavior; invariant attacks target the code's published contract.

The 2026-05-15 expansion added four maintainer-modeled seats whose lenses were distilled from the empirical PR-feedback patterns of senior reviewers across `endojs/endo` and `Agoric/agoric-sdk`. The seat slugs name the lens, not the reviewer; the empirical source is recorded in each role file:

- **purist** (empirical source: `@erights`). Ocap purity and conceptual integrity: passability of introduced values, property hygiene on frozen prototypes, side-channel closure on opaque boundaries, type-vs-value namespace separation, family-consistency across related symbols, minimum viable abstraction. Distinct from `warden` (SES boundary specifically) and `breaker` (invariant attacks specifically): the purist's lens is conceptual integrity of the symbol family across the module, not the boundary or the contract.
- **spec-keeper** (empirical source: `@gibson042`). ECMA-262 / WebIDL / TC39-proposal rigor and engine-variance awareness: spec-citation discipline, multi-engine behavior, primordial preservation (captured `Reflect.apply` over `.call`), forward-compat with in-flight proposals, brittle-test resistance, less-coupling preference. Distinct from `migrator` (downstream-caller compat): the spec-keeper's frame is upstream-spec compat.
- **wire-watcher** (empirical source: `@warner`). Security-protocol correctness on the wire: check-before-trust ordering when loading bytes, in-band-marker trust-bypass attacks, parser-divergence hazards, identifier-format discipline, protocol state-machine invariants under failure, failure-mode test catalog. Distinct from `locksmith` and `warden` (capability flow and SES boundary): the wire-watcher's lens is the identifier or hash that gates the capability the others audit.
- **engine-realist** (empirical source: `@mhofman`). V8 / XS realism and vat-lifecycle awareness: engine-variance test coverage, resilience against capability override, vat-phase-appropriate work, allocation and GC budget, ephemeral vs virtual vs durable storage choice, engine-version compat, work-deferral preference. Distinct from `prover` (regression evidence generally): the engine-realist's frame is the runtime a future caller will be on.

The 2026-05-18 expansion added a fifth maintainer-modeled seat, whose lens was distilled from the maintainer's own pull-request review pattern across the same two repos. The seat slug names the lens; the empirical source is recorded in the role file:

- **integrator** (empirical source: `@kriskowal`). Integration coherence with the project's existing structure: merge-commit readability of the PR title and description, concept-namespace coherence with names the project already uses, rename-completeness sweep across every region the old name appears, convention probe before introducing a new file or pattern, forward-compose probe asking whether sibling packages will extend the pattern cleanly, tests that pin constants by direct assertion rather than narrating with comments, public-surface use in tests where the internal reach is not justified, type-level discouragement over runtime guards, cycle-obviation tracking on the package dependency graph, diagram maintainability (mermaid over ASCII), commit grouping for the merge-commit reader, master-base mirror PRs when the change is also wanted on the default branch, and minimum cleavage when splitting packages or breaking cycles. Distinct from `migrator` (downstream-caller compatibility): the migrator reads from inside the change outward to callers; the integrator reads from outside the change inward to the project's existing structure and the future reader.

The 2026-05-20 expansion added six narrow seats distilled from the recurring maintainer feedback on PR #75 (71 inline comments + 14 top-level comments across 16 reviews). Each owns one tight lens that the prior seventeen-seat panel was missing. The seat slugs name the lens; each role file carries the empirical source:

- **benchmarker**. Benchmark-closure on every optimization claim. Every thread proposing an optimization is closed with either a posted measurement or an explicit "not pursuing" rationale. Distinct from `scout` (which runs benchmarks): the benchmarker reads the PR's discussion and verifies closure; it does not run benchmarks itself.
- **changeset-auditor**. Changeset-vs-diff coherence: front-matter package set, bump level, body identifier coherence, sentence-per-line, no process commentary. Adjacent to `packager` (broader diff hygiene); the changeset-auditor's lens is narrower (does the changeset's content track the diff's content).
- **surfacer**. Public-surface coherence: `package.json` `exports`, `index.js` re-export thunk, published TypeScript shape, and README's claimed-public surface all agree on the same set of identifiers. Adjacent to `curator` (which reads "is this the right public surface to commit to"); the surfacer reads "given a claimed public surface, do all four surfaces actually expose it consistently".
- **scribe**. Knowledge-capture closure: every maintainer ask in the PR's history to "note this in standing orders" or "leave a record for future reference" produces either a standing-orders edit in the PR's diff or a `message: panel → gardener` proposing the edit. Adjacent to `archivist` (docs-prose accuracy); the scribe is process-oriented (did the writing happen) rather than product-oriented.
- **pruner**. Documentation padding: agent-written READMEs over-document; "About this document" sections, padding-for-padding's-sake, sections beneath the reader's needs. Adjacent to `archivist` and `copyeditor`; the pruner asks "should this be there at all" where the other two ask "is what's there correct".
- **gateway**. Repo-root-config justification: any PR that touches a repo-root config file (tsconfig, eslint, root package.json, workflows, root prettier / editorconfig) carries an explicit scope-justification in the PR body, commit message, or review-thread reply. The gateway flags root-level reach when a per-package alternative would have sufficed.

Smaller panels (3 to 6 seats) remain valid for tiny PRs when the orchestrator names a reduced composition in the dispatch brief; the reference's 17-perspective panel is now a subset rather than the default.

### Sites that name the panel size

When a future expansion or contraction changes either panel's seat count, sweep these sites in one commit so the library does not drift (the 2026-05-15 +4 expansion and the 2026-05-18 +1 expansion each missed several of them on first landing, and a gardener sweep had to catch up):

- `CLAUDE.md` § Current inventory: jury-seat-role count, the two per-panel seat lists, and the historical narrative paragraph.
- `README.md` § (top-level pipeline paragraph): the seat-count and the inline seat list.
- `roles/judge/AGENT.md`: opening paragraph, *Panel-kind discrimination* heading and prose, the per-panel seat list, the aggregation word-count range in *Operating norms*, the *In-band fallback* count, and the 2026-05-14-framing paragraph after the seat list.
- `roles/liaison/AGENT.md` § Vocabulary: the gamut and the *PR-creation-flow chaining* norm.
- `roles/steward/AGENT.md` § Bounded dispatch authority: the judge line in the dispatch table and the *Vocabulary: the gamut* section.
- `roles/saboteur/AGENT.md` § Operating norms: the "alongside the other N seats" line and the "N-seat panel returns one block each" line. (Saboteur is the canonical site because of how the reference's saboteur came in; other seats do not name the panel count.)
- `skills/pr-creation-flow/SKILL.md` (this file): the *Code panel* heading, the seat list, *Why N seats (code panel)* heading, *Sites that name the panel size* (this list), and the Notes-from-the-field entry naming the expansion.
- `skills/panel-review/SKILL.md`: header paragraph, *Panel composition* section, *Aggregation* should-fix bullet, and the *Posting the review* aggregation word-count range.
- `skills/garden-ab-evaluation/SKILL.md`: *Step 2* flow description and the *Cost* paragraph.

Historical narrative ("after the 2026-05-14 twelve-seat redesign moved X to seat Y") in `roles/<seat>/AGENT.md:13` and in any `Notes from the field` entry dated _2026-05-14_ or _2026-05-15_ or _2026-05-18_ describes what happened on that date and **stays as written**; only current-state references update.

### Why seven seats for the design panel

The maintainer's framing (2026-05-14): "Designs should be reviewed by a critic, a skeptic, a copy editor, a Chicago Manual style guide enthusiast, and a naive reader who only understands short sentences with clear logical progress." The 2026-05-15 expansion added two more seats: a Rich-Hickey-lens reader (the `decomplector`, who applies simple-vs-easy, complecting / decomplecting, value-oriented / place-oriented, essential / accidental complexity to design choices about state, identity, value, and time) and an interface-ergonomics reader (the `ergonomist`, who reads the proposed API or UI surface as the eventual user's hands and eyes will read it). Seven perspectives cover the design surface (substantive critique, adversarial premise attacks, complexity-axis reading, ergonomics, prose mechanics, formal style, top-down clarity) without redundancy. The design panel remains smaller than the code panel because the design surface is narrower: a design document is one artifact (a single prose document), while a code PR can touch many files and many inquiry axes that warrant the halved-responsibility overlap the code panel uses plus the four maintainer-modeled seats the 2026-05-15 expansion added.

The design panel is what gets dispatched when the steward's per-cycle scan picks up a design-only PR (the first cohort: the SES top-level-await draft PR #249 and the SES import-attributes draft PR once its builder lands).

### Concurrency

The judge dispatches all seats **concurrently by default**, on both panel sizes. Sequential `Agent` invocations would compound wall-clock cost beyond what the chain can absorb. The judge sends the panel out in parallel, waits for all results to land, then aggregates. Sequential dispatch remains valid when the orchestrator explicitly requests it (e.g., for a panel where one seat's findings should inform another's), but is not the working default at either panel size. The deliverable shape is the same either way: one aggregated panel verdict, one formal `gh pr review` submission from the judge.

When the harness does not surface an `Agent` (or `Task`) tool to the judge subagent, the judge falls back to the in-band procedure named in `roles/judge/AGENT.md` § In-band fallback: each seat's block is written one at a time against the per-seat role file's primary surface, aggregation runs after all seats land, and one formal `gh pr review` is still submitted. The `result` entry names the panel-execution mode and the panel kind (`code-panel` or `design-panel`) for audit.

### Copilot as a thirteenth reviewer (code panel only)

The `@copilot` `gh pr edit --add-reviewer` call is fire-and-forget. The `@copilot` token is `gh`'s canonical handle for the Copilot reviewer; the login that appears in `reviewRequests` and `reviews[].author.login` afterward is `copilot-pull-request-reviewer`. Copilot leaves a `COMMENTED` review on its own schedule (typically minutes); the judge does not poll or block on it. If Copilot's review has landed by the time the judge writes the panel's formal `gh pr review`, the judge considers it part of the panel's reading; otherwise the panel proceeds without it. The `gh pr edit` is idempotent for the same reviewer; on a re-round it re-requests Copilot's review.

Copilot is added only when the judge dispatches the **code panel**. Design-panel rounds skip the `@copilot` call. The orchestrator does not add Copilot to PRs outside the judge-dispatch flow.

## Jury-fixer loop

After the judge submits the panel's verdict (with per-finding disposition tags per `skills/panel-review/SKILL.md` § Dispositions):

1. **If the verdict has any `must-fix-loop` disposition**: the orchestrator dispatches a fixer with the must-fix-loop list inline as the brief. The fixer addresses each item (or replies on threads citing why an item is verified-no-change or deferred), pushes follow-up commits, and reports done.
2. **The orchestrator re-dispatches the judge** with the fixer's `result` cited. The judge re-dispatches the same panel (or an equivalent one), briefed with the prior verdict plus the fixer's response so each juror verifies the prior must-fix-loop items are addressed and surfaces any *new* in-scope finding the fix introduced. The judge re-classifies each new finding into one of the five dispositions per the rubric in `skills/panel-review/SKILL.md` § Disposition rubric.
3. **Loop until the panel surfaces no further `must-fix-loop`-disposition items.** `summary-fix`, `follow-up`, `acknowledge`, and `drop` dispositions do **not** block the loop. The judge does not promote them to `must-fix-loop` to keep the loop spinning; each disposition has its own productive response (the post-loop actions in `roles/judge/AGENT.md` § Operating norms).
4. **When the judge declares the loop done** (an `--approve` verdict or a `--comment` verdict with no `must-fix-loop` dispositions): the judge runs the three post-loop actions (submit the disposition-tagged review, post the `summary-fix` job to the board if any summary-fix dispositions were assigned, append the followup ledger if any follow-up dispositions were assigned) and then `gh pr ready <N>`.

Loop-exit discipline: the panel cannot block the loop on non-`must-fix-loop` findings. If a juror keeps surfacing the same finding across rounds with the same disposition, the judge demotes it to `acknowledge` or `drop` with rationale; the loop does not iterate on it forever.

## Maintainer entry point

The maintainer reviews only PRs that are out of draft. Before un-drafting, the flow's internal review (builder + assayer + cleaner + jury panel + fixer loop) is the quality bar; the bot's job is to make sure a PR in the maintainer's queue is genuinely ready for the maintainer's time.

A draft PR sitting in the bot's chain is not in the maintainer's queue; the maintainer should not be looking at it. The bulletin (in `journal/README.md`) lists ready-for-review PRs; draft PRs are tracked in the bot's own dashboards (e.g., the PR backlog section, with a `DRAFT` annotation) but not in the *Pending kriskowal reviews* section.

## State on the PR

The flow encodes position in two layers:

- **Draft vs ready-for-review** (load-bearing). Draft means the bot-side chain is in progress; ready-for-review means the judge has un-drafted and the maintainer's queue is the next venue.
- **Labels** (advisory). When useful, the bot can annotate the PR with labels like `state:building`, `state:cleaning`, `state:in-review`, `state:fixing`, `state:ready`. These are for the bot's own dashboard and dispatch-decision triage. Labels are not load-bearing; the orchestrator never makes a flow-decision based on a label alone (it would key on the actual GitHub state: PR draft? has reviews? CI green?). Labels can be added or omitted without affecting correctness.

The garden's current default is **draft-state only**; we have not yet built the dashboard machinery that would benefit from labels. Adding labels is a non-breaking enhancement when a future bulletin or summary view needs them.

## Orchestrator's dispatch responsibilities

The orchestrator (liaison when a user is present, steward otherwise) is the dispatcher across all flow stages **with one exception**: the judge dispatches the jurors itself, because the panel composition is the judge's contract. The orchestrator dispatches the builder, the assayer (in concert), the cleaner, the judge, and the fixer (when a panel verdict has must-fix). The orchestrator does **not** dispatch individual jurors; that is the judge's job.

Per-stage dispatch decisions:

- **Builder dispatched** when an issue or directive points at code that does not exist yet.
- **Assayer dispatched in concert** with the builder by default. Concurrent invocation against the same branch.
- **Cleaner dispatched** when the builder's (and any in-concert assayer's) `result` entries have landed, or skipped on the tiny-PR variant above.
- **Judge dispatched** when the cleaner's `result` lands (or directly after the builder on the cleaner-skipped variant). The judge dispatches the panel from there.
- **Fixer dispatched** when the judge's panel verdict has must-fix items.
- **Judge re-dispatched** after the fixer's `result` entry lands. The judge re-runs the panel; the orchestrator does not.
- **Weaver dispatched first** if any of the above stages find the PR is `CONFLICTING`. The weaver rebases; the interrupted stage re-dispatches.

## Orchestrator chaining is load-bearing

The single-stage dispatch (build a PR and stop) is the **failure mode** this skill exists to prevent. A builder dispatch that lands a draft PR is *not* "done"; the PR is in the bot's chain, in draft state, with no maintainer review possible until the judge un-drafts. If no role advances it, the PR sits orphaned: the bot opens drafts the bot itself never finishes, the maintainer's queue stays empty, and the cycle of work never closes. Observed evidence (as of 2026-05-14): a backlog of garden-authored draft PRs on `endojs/endo-but-for-bots` whose builders returned without the orchestrator continuing the chain.

The discipline lives in two places: the **liaison** when a user-in-session dispatches a builder, and the **steward**'s per-cycle scan when no user is in the loop.

### The next-stage-owed heuristic

For each open draft PR authored by the garden (`gh pr list -R <repo> --author kriscendobot --draft --state open`), the next stage owed is the first stage whose preceding stage's artifact exists but whose own artifact does not. Detection reads the PR state directly from GitHub, not from journal entries (which can lag, be misfiled, or describe a stage the orchestrator never dispatched).

Reading order, top to bottom; the first match is the stage owed:

1. **PR is `CONFLICTING` against its base?** Weaver is owed first, before any of the below. Re-evaluate the next-owed stage after the weaver returns.
2. **Judge has un-drafted?** PR is no longer draft. Flow complete; the PR is in the maintainer's queue. Nothing owed.
3. **Panel `--approve` (or `--comment` with no in-scope must-fix) submitted, with no later builder/fixer push, but the PR is still draft?** The judge should have un-drafted but did not. The orchestrator un-drafts directly (`gh pr ready <N>`) and surfaces the discipline lapse. Owed: un-draft.
4. **Panel verdict has must-fix items, and the fixer has not yet pushed addressing commits since?** Fixer is owed.
5. **Fixer pushed since the last panel verdict, and the judge has not re-dispatched the panel since the fixer's HEAD?** Judge re-dispatch is owed.
6. **Cleaner pushed and CI is green (or only documented pre-existing infra red), and no panel verdict yet?** Judge is owed. (On the cleaner-skipped tiny-PR variant or the design-only-PR variant, the orchestrator dispatches the judge directly when no cleaner is owed and no panel verdict exists; see the qualifiers in step 7.)
7. **Builder's PR is open and no cleaner push exists yet?** Cleaner is owed (default). On the tiny-PR variant (pure docs, lockfile-only, one-file format sweep, single-line bug fix with test fixture already in the diff), skip the cleaner and dispatch the judge instead. On the design-only-PR variant (every changed path under `<project>/designs/`, no source or test changes), skip both the assayer and the cleaner and dispatch the judge directly; the judge will pick the design panel per `roles/judge/AGENT.md` § Panel-kind discrimination. The orchestrator decides which variant applies by inspecting the diff.

A *panel verdict* is a `kriscendobot`-authored formal `gh pr review` (state `CHANGES_REQUESTED`, `COMMENTED`, or `APPROVED`) whose body matches the panel-review shape (in-scope / out-of-scope sections, must-fix / should-fix verdicts). A plain `gh pr comment` is not a panel verdict and does not advance the flow; the judge's role file requires the formal-review submission. The verdict shape is the same for both panel kinds; the body's seat list and word count vary.

The orchestrator decides whether to dispatch concurrently (multiple PRs' next stages in one cycle) or rate-limit (one stage per PR per cycle) based on its own load. The steward's default is concurrent dispatch; the liaison's default is sequential and explicit (the user is in the loop and watching).

### Discipline

- A single-stage dispatch (the orchestrator dispatches a builder and the PR sits) is a **discipline violation**. The next orchestrator turn (liaison's next prompt, or the steward's next cycle) corrects it by reading the next-stage-owed and dispatching it.
- The orchestrator does not need a maintainer's per-PR authorization to advance a garden-authored draft PR through its own chain; the chain is the garden's normal operation. Authorization is only required for the cross-repo etiquette actions per `roles/COMMON.md` § External-repo etiquette (the boatman handoff, replying on inline review threads, posting top-level PR comments). The chain itself (builder push, assayer push, cleaner push, panel verdict submission, fixer push, un-draft) is implicit in each role's dispatch.
- A draft PR that has been quiet for more than one steward cycle without a clear "owed" stage is a signal that the heuristic is missing a case. Surface it via a `message` to `liaison` rather than guessing.

## Pitfalls

- **A non-judge role un-drafting is a discipline violation.** Only the judge un-drafts, and only after the panel declares the loop done. A builder that opens a PR ready-for-review (skipping the draft) bypasses the entire flow; the orchestrator's first action on noticing is to `gh pr ready --undo <N>` and report the discipline violation.
- **The cleaner un-drafting is a discipline violation.** The 2026-05-14 redesign moved un-draft authority from the cleaner to the judge. A cleaner that runs `gh pr ready <N>` is operating on an outdated role file; the orchestrator surfaces the lapse and the next gardener dispatch refreshes the cleaner's worktree.
- **The jury-fixer loop spinning on out-of-scope findings.** If a juror keeps re-raising a concern that is genuinely out of scope, the judge promotes the concern to a separate follow-up and clears it from the loop. The loop's exit condition is "no in-scope complaints," not "all complaints addressed."
- **The cleaner pushing onto a CONFLICTING head.** The cleaner verifies `mergeable_state` before pushing; if `CONFLICTING`, surface "needs weaver" and stop.
- **A maintainer's `CHANGES_REQUESTED` reactivating the flow's draft state.** It does not. After the maintainer has reviewed, the loop is fixer to CI-green to re-request maintainer (no re-cleaner, no re-judge by default). The PR stays out of draft; the maintainer's review queue is the venue.
- **The orchestrator dispatching individual jurors directly.** The judge dispatches the jurors; the orchestrator dispatches the judge. A liaison or steward that dispatches a juror role directly bypasses the panel's aggregation and produces a finding without a verdict the dispatch matrix can read. The exception is a maintainer's explicit directive ("run an assessor on PR #N"), which the orchestrator can honor; the deliverable is then the juror's `result` entry, not a panel verdict.

## Notes from the field

- _2026-05-13_: skill landed. The default assayer placement is in concert with the builder, the jury composition was a fixed juror plus saboteur pair, and labels were advisory while draft state was the load-bearing flag.
- _2026-05-14_: backlog of garden-authored draft PRs accumulated on `endojs/endo-but-for-bots` (#236, #237, #238, #239, #240, #241, #242, #243) because builder dispatches landed and the orchestrator stopped, treating the open draft as "done". The maintainer framed it as a systemic failure of chaining. Repair: the *Orchestrator chaining is load-bearing* section and the next-stage-owed heuristic above are now mandatory reading for the orchestrator, and the steward's per-cycle PR-creation-flow scan (see `roles/steward/AGENT.md` § PR-creation-flow scan) enforces the chain automatically.
- _2026-05-14_: jury-judge redesign. The single generic `juror` role split into five named seats (assessor, stylist, archivist, curator, locksmith) plus the existing saboteur for six total, with deliberate overlap so every inquiry area is touched by at least two seats. The judge role was added as the panel's foreperson (dispatches the jurors, aggregates, submits one verdict, un-drafts on loop completion). The cleaner moved from last-in-the-chain to between-builder-and-jury, and lost un-draft authority. Old single-stage juror-plus-saboteur panels remain valid by maintainer override; the default is the six-seat panel.
- _2026-05-14_ (same day, later): twelve-seat panel. The maintainer's directive was to halve each seat's responsibilities. Each of the six prior seats split into two successor seats: assessor → assessor + typist, stylist → stylist + packager, archivist → archivist + prover, curator → curator + migrator, locksmith → locksmith + warden, saboteur → saboteur + breaker. Concurrent dispatch became the explicit default at this size; sequential dispatch is an override. Smaller panels (3 to 6 seats) remain valid when the dispatch brief names a reduced composition.
- _2026-05-14_ (same day, later still): design / implementation split codified. Maintainer directive after the SES top-level-await and SES import-attributes designers landed: designers default to opening draft PRs against the project's bot-fork roadmap branch (today `llm` on `endojs/endo-but-for-bots`); implementations of those designs are separate builder dispatches that land on the project's natural implementation base (today `master`). Node-18-drop pattern (`#232` design on `llm`, `#246` master-base mirror) is the reference shape. The *Designs versus implementations* section above carries the base-split rule.
- _2026-05-14_ (later same day): "the gamut" landed as the maintainer's vocabulary for the chain end to end. Maintainer directive: *"I would like the steward's role to recognize that 'the gamut' means the PR end-to-end workflow. For example, 'Run the gamut' in the context of a PR should be understood to mean resume the workflow until done. The liaison should recognize 'Run the gamut on #xxx' to mean the same on a specific PR."* The procedure is unchanged; the *Vocabulary: "the gamut"* section above and per-orchestrator sections in `roles/steward/AGENT.md` and `roles/liaison/AGENT.md` encode the synonym. `CLAUDE.md` § Dispatch contract carries the one-line glossary entry.
- _2026-05-14_ (later same day): design panel landed. The maintainer's framing: "Designs should be reviewed by a critic, a skeptic, a copy editor, a Chicago Manual style guide enthusiast, and a naive reader who only understands short sentences with clear logical progress." The judge gained panel-kind discrimination per `roles/judge/AGENT.md` § Panel-kind discrimination: design-only PRs (paths only under `<project>/designs/`) get the five-seat design panel; everything else gets the existing twelve-seat code panel. The design-only flow skips both the assayer and the cleaner and dispatches the judge directly after the builder. This supersedes the same-day, earlier "design-only PRs skip the flow chain" stance: design-only PRs now run through the chain with the design panel rather than being skipped entirely. The first design-panel rounds will run against PR #249 (SES top-level-await design) and the SES import-attributes design PR once its builder lands; the steward's per-cycle scan picks them up.
- _2026-05-15_: design panel grew from five seats to seven. Two new seats joined: the `decomplector` (Rich-Hickey-lens reader: simple-vs-easy, complecting / decomplecting, value-oriented / place-oriented, essential / accidental complexity, minimum viable abstraction; mirror seat to the code panel's `breaker` across the design / code boundary) and the `ergonomist` (interface-ergonomics reader on the proposed API or UI surface: coherence, discoverability, least-surprise, parameter order, return shape, error visibility, layout, accessibility, user path, affordance). The seat-count was the load-bearing decision; the procedural shape (concurrent dispatch, one aggregated verdict, jury-fixer loop, no `@copilot`) is unchanged. The decomplector seat's name (verb `decomplect` rather than the eponym `hickey`) was a deliberate choice to keep the seat list non-eponymous; future role-authors weigh that precedent before naming a seat after a person.
- _2026-05-15_ (parallel dispatch, same day): code panel expanded from twelve to sixteen seats with four maintainer-modeled additions. The maintainer's directive: model reviewer seats on the empirical PR-feedback patterns of senior contributors (`@erights`, `@gibson042`, `@warner`, `@mhofman`), with slug names that protect the innocent (the seat names the lens, not the reviewer; the reviewer is recorded as the empirical source in the role file). The four seats: `purist` (ocap purity and conceptual integrity, from erights), `spec-keeper` (ECMA-262 / WebIDL / TC39 rigor and engine variance, from gibson042), `wire-watcher` (security-protocol correctness on the wire, from warner), `engine-realist` (V8 / XS realism and vat-lifecycle awareness, from mhofman). All four joined the code panel; none are primarily design-panel-only (the design surface is one prose artifact; these lenses each target code- or wire-shaped material the design surface does not carry). Panel concurrency unchanged at sixteen seats; the judge's aggregation upper bound widens accordingly. The two 2026-05-15 expansions (design panel +2, code panel +4) were authored in parallel-dispatched gardener sessions; this skill landed both expansions sequentially as the gardener dispatches returned.
- _2026-05-18_: code panel expanded from sixteen to seventeen seats with the maintainer's own lens added as a fifth maintainer-modeled seat. The `integrator` (empirical source: `@kriskowal`) reads each PR for integration coherence with the project's existing structure: merge-commit readability of the title and description, concept-namespace coherence with names the project already uses, rename-completeness sweep, convention probe before introducing a new pattern, forward-compose probe asking whether sibling packages will extend the pattern cleanly, tests that pin constants by direct assertion rather than narrating with comments, public-surface use in tests, type-level discouragement over runtime guards, cycle-obviation tracking, diagram maintainability (mermaid over ASCII), commit grouping for the merge-commit reader, master-base mirror PRs, and minimum cleavage when splitting packages. The lens was distilled from the maintainer's pull-request review pattern across `endojs/endo` and `endojs/endo-but-for-bots`; the recurring directives (rename sweep "lingering remnants of the term", "Please refresh the title and description consistent with standing instructions", "Why can we not simply import [E] from the public surface in tests?", "verifying that the magic number is indeed === [value], rather than relying on the veracity of a comment", "we use mermaid diagrams and eschew ASCII") are the empirical signal. Panel concurrency unchanged; the judge's aggregation upper bound widens by ~6%.
- _2026-05-20_: code panel expanded from seventeen to twenty-three seats with six narrow PR-#75-derived additions. The maintainer's framing: *"PR #75 is an example of a change that required many rounds of feedback from maintainers and continues to churn. We may need deterministic heuristics and post-build / post-fix hooks to automate some of the kinds of recurring feedback, as well as some permanent jurors for very narrowly scoped feedback. Many of the articles of feedback I've provided are in the standing instructions. Having a much larger panel with much more focused responsibilities may help, too."* Six new seats (`benchmarker`, `changeset-auditor`, `surfacer`, `scribe`, `pruner`, `gateway`) own one tight lens each that the prior seventeen-seat panel was missing. Each was distilled from PR #75's empirical pattern (71 inline comments + 14 top-level across 16 reviews); see the *Code panel* and *Why twenty-three seats* sections above for the per-seat empirical provenance. Same-day companion landings: cite-or-propose discipline at `skills/panel-review/SKILL.md` § Cite-or-propose (every finding either cites a standing rule or proposes one); pre-push gates at `skills/pre-push-gates/SKILL.md` (deterministic-checkable complaints — Prettier drift, ASCII banners, pull-request citations in package code, filename stutter, test-package main, SECURITY.md hash, sentence-per-line markdown — auto-fix-and-re-stage before any builder or fixer push). The three landings compose: gates catch the deterministic class; the six narrow seats catch the narrow-juror class; the cite-or-propose discipline forces every juror to consult the standing rules.
