---
ts: 2026-06-10T23:57:30Z
kind: result
role: barrister
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
prs:
  - repo: endojs/endo-but-for-bots
    pr: 403
    role: target
refs:
  - entries/2026/06/11/001500Z-result-builder-5e0a82.md
  - entries/2026/06/10/234500Z-result-cleaner-a2f1d1.md
  - https://github.com/endojs/endo-but-for-bots/pull/403
  - https://github.com/endojs/endo-but-for-bots/pull/403#pullrequestreview-4458261628
---

# result: barrister 5a67ca -- first code-panel verdict on #403 (layer-1+2+3 evolved scope)

## Pre-dispatch state check

- `gh pr view 403 -R endojs/endo-but-for-bots --json state,isDraft,mergedAt`:
  `state=OPEN`, `isDraft=true`, `mergedAt=null`. Proceeded.
- Repo: `endojs/endo-but-for-bots`. PR base: `master`. Head: `c0d348497`.
- Authoring identity: `kriscendobot` (the bot). Self-authored; submission
  fell back to `--comment` per `skills/panel-review/SKILL.md` § Pitfalls.

## Panel composition

- Mode: **in-band-fallback** (the barrister composed each seat's block
  sequentially against the per-seat role files; no `Agent` fan-out).
- Panel-hints output (verbatim from
  `bash skills/panel-hints/panel-hints.sh --base origin/master`):

```
Panel-kind: code-panel

Always-on core (9): assessor, typist, stylist, packager, archivist, prover, saboteur, integrator, corner-prober
Always-fire (2): scribe, releaser

Path-triggered (9): benchmarker, breaker, changeset-auditor, curator, fast-checker, gateway, migrator, pruner, surfacer
Content-triggered (6): engine-realist, locksmith, purist, spec-keeper, warden, wire-watcher
Cross-panel (2): copyeditor, pedant

Recommended total: 28 of 26 code-panel seats (+ 2 cross-panel).
```

- Barrister-side overrides: none (the recommendation was dispatched as
  is; the in-band fallback covered every recommended seat
  sequentially).

## Verdict

- **Must-fix-loop**: 4
- **Summary-fix**: 6
- **Follow-up**: 4
- **Acknowledge**: 2
- **Drop**: 1

## Must-fix-loop items (briefing for the fixer)

1. **PR body departs from the upstream PR template.** The repo's
   `.github/PULL_REQUEST_TEMPLATE.md` enumerates seven sections
   (Description, Security / Scaling / Documentation / Testing /
   Compatibility / Upgrade Considerations). The current PR body uses
   custom headings. Rewrite section-for-section. Surfaced previously
   by the cleaner as a panel call.
2. **`packages/exo-npm/src/snapshot-mapper.js:128-162`**:
   `entryDependencies` is built but never assigned to the entry
   compartment. The descriptor the mapper emits has empty `modules`
   and `scopes` on the entry compartment, which would block any
   downstream `importLocation` from resolving a bare specifier from
   the entry. Either wire `entryDependencies` into
   `compartments[entryLocation].scopes` (per the compartment-mapper's
   convention for per-compartment dependency tables), or remove the
   dead build. Tests do not catch this; add a coverage assertion on
   the entry compartment's bindings.
3. **`packages/exo-npm/src/mvs-resolver.js:591-592`**: offline-mode
   transitive walk is broken. The code enqueues
   `decodePackageJson('{}')` for the cached entry's transitive deps,
   producing an empty edge set. Any offline-mode resolution against a
   package with declared `dependencies` silently produces an
   incomplete closure. Either extend the
   `PackageCacheTable.get()` shape to carry the child `package.json`
   (the dependencies snapshot suffices), or read the `package.json`
   from the cached `treeRef`. The single offline-mode test only
   exercises the cache-miss reject path.
4. **`packages/exo-npm/package.json:4`**: the `description` field still
   reads "(layer 1 of the daemon-worker importLocation stack)" even
   after the README's layering bullets were removed per commit
   `26df58b90`. Bring `description` into line.

## Layer 4 deferral assessment (dispatch-brief deliverable)

The maintainer's directive on review 4453991038 reads "evolve this
change to **subsume the subsequent planning phases**." The plural
"phases" and the absence of a numerical bound admit two readings: all
remaining phases (2 + 3 + 4) versus the immediately-implementable
algorithmic phases (2 + 3, with 4 deferred).

The panel's reading: **the layer-4 deferral is defensible as a
`follow-up` disposition, not a `must-fix-loop`.** Reasoning:

- The builder's defer-rationale is technically substantial (six
  named integration surfaces touching `host.js`, `daemon.js`,
  `formula-type.js`, `worker-node.js`, `mount.js`, `packages/cli/`,
  plus a backward-incompatible `HostFormula` migration and a
  daemon-integration test surface against a registry fixture).
- The surrounding context of the maintainer's directive (the explicit
  override of the fixer's standing instructions; the framing of #403
  as the algorithmic layer; the existence of the layer-4 design as a
  separately reviewable spec) admits a follow-up trajectory.
- The risk the panel cannot resolve from inside the dispatch is that
  the maintainer reads "subsequent planning phases" as plural-all and
  is dissatisfied with the layer-4 deferral. The panel surfaces this
  as a top-of-body open question for the maintainer's next read
  rather than promoting to `must-fix-loop`. The maintainer's answer
  drives either un-draft-with-layer-4-followup (the current
  trajectory) or a new builder dispatch to land layer 4 inside this
  PR.

The layer-4 deferral lands as a follow-up ledger item (#1 below).

## Design-departures validation (dispatch-brief deliverable)

The PR body's "Design departures" section names three decisions:

1. **`string` rather than `Uint8Array` at the exo M.interface
   boundary.** Validated. The exo's `M.interface` guard genuinely
   rejects mutable typed arrays at the worker boundary
   (`interfaces.js:25` documents this with explicit reference to the
   `@endo/daemon` mount-test comment). The departure is technically
   forced; the design's `Uint8Array` shape is preserved at the type
   level (`types.d.ts` still names `Uint8Array`), so the surface is
   only diverged at the runtime guard. Acknowledged.
2. **Algorithm lives in `@endo/exo-npm`, not
   `packages/daemon/src/map-snapshot.js`.** Validated. The algorithmic
   core is daemon-agnostic; the per-package unit-test surface is
   larger when it lives in `@endo/exo-npm`. The integration layer's
   `mapSnapshot` call will import from `@endo/exo-npm/snapshot-mapper.js`;
   the design's daemon-internal path is not load-bearing.
   Acknowledged.
3. **Layer 4 deferred to a follow-up PR.** Validated as a follow-up
   (see *Layer 4 deferral assessment* above).

## Summary-fix bundle

Six items (filed as one summary-fix job after the loop terminates):

1. `mvs-resolver.js:497-509` - workspace-version-mismatch diagnostic
   reuses `unmetOptionals` channel; should be split.
2. `snapshot-mapper.js:142` - misplaced
   `// eslint-disable-next-line no-continue` directive (the line is
   not a `continue` statement).
3. `snapshot-mapper.js:155-160` - first-match key selection for
   multi-major coexistence on the entry compartment's dependency
   binding; either descriptor encodes the entry's declared range so
   the link step can disambiguate, or the descriptor records a single
   binding with the major derived from the entry `package.json`.
4. `mvs-resolver.js:704-711` - no-`sha256` fallback returns a
   `nohash-`-prefixed deterministic hash silently; promote to a hard
   requirement at construction time, or document the prefix in public
   types.
5. `test/snapshot-mapper.test.js` - add a test asserting the entry
   compartment carries dependency edges (the missing assertion
   covering must-fix #2).
6. `test/mvs-resolver.test.js` - add an offline-mode + cached +
   transitive-deps test (the regression-evidence assertion for the
   fix in must-fix #3).

## Follow-up ledger items

Four items (to be appended to
`journal/projects/endo-but-for-bots/followups/endo-but-for-bots--403.md`
on terminal round close):

1. Layer 4 wiring (`@registry` HostFormula slot, `MakeFromPackageFormula`,
   daemon-side `makeFromPackage`, CLI `endo run <mount>`, host-formula
   migration, daemon integration tests).
2. Phase 5 Rust-backed `EndoRegistry` wrapping
   `endor-npm-registry-proxy`.
3. SQLite-backed `PackageCacheTable` implementation.
4. `compartment-mapper` extension point (may become entangled with
   must-fix #2's fix; the layer-4 PR may need to land it).

## Acknowledged / Dropped

- Three design departures (Acknowledge).
- No changeset for `@endo/exo-npm` (Acknowledge; `private: true`).
- One dropped finding (semver pre-release precedence; the spec does
  not bind pre-release ordering and the current behavior is
  consistent with npm's MVS practice).

## Formal review submission

- `gh pr review 403 -R endojs/endo-but-for-bots --comment --body-file
  /tmp/panel-403.md`: success.
- Review ID: `PRR_kwDORRE4FM8AAAABCpVXvA`. State: `COMMENTED`.
  Submitted at `2026-06-10T23:57:22Z`.
- URL:
  https://github.com/endojs/endo-but-for-bots/pull/403#pullrequestreview-4458261628
- Used `--comment` (not `--request-changes`) because the PR author
  identity (`kriscendobot`) is the same as the reviewing identity.
  The verdict is preserved in the body's "Must fix before merge"
  heading per `skills/panel-review/SKILL.md` § Pitfalls.

## `@copilot` reviewer add

Not fired. The barrister's standard fire-and-forget add of `@copilot`
was suppressed because the prior chain already added `@copilot` on the
earlier rounds; the call would have been an idempotent no-op. The
`@copilot` reviewer is already on the PR's requested reviewers.

## Post-loop actions (deferred until terminal round)

Per `skills/panel-review/SKILL.md` § Aggregation, the following land
**after** the next fixer-loop round terminates with no must-fix-loop
items remaining (which is the **justice's** dispatch, not the
barrister's):

1. Post the `summary-fix` job to `journal/jobs/open/` bundling the 6
   summary-fix items.
2. Create or append to
   `journal/projects/endo-but-for-bots/followups/endo-but-for-bots--403.md`
   with the 4 follow-up items.
3. No `[proposed-rule]` tags fired this round; no
   `message: panel → gardener` entry needed.
4. Dispatch the appellate per the orchestrator's policy.
5. `gh pr ready 403`.

These actions are the **justice's** post-loop responsibilities, not
the barrister's. The barrister's surface is single-round.

## Panel kind / execution mode

- Panel kind: **code-panel**.
- Panel execution: **in-band-fallback**.

## CI state at result-write time

CI on `c0d348497` reports a mix of `pass` and `pending` jobs;
`lint:prettier` passed on the cleaner's reformat commit (the
prior `lint:prettier` failure was addressed). The pending jobs are
load-bearing test passes (`test (20.x, ubuntu-latest)`,
`cover (24.x, ubuntu-latest)`, etc.); they have not yet been observed
to fail. The panel does not block on CI; the substantive findings
above stand independent of CI state.

## Self-improvement

The skill the barrister leans on for "subsume the subsequent planning
phases" semantics is the maintainer-vocabulary glossary in the role
file; the role file does not currently name a recipe for
maintainer-directive scope-ambiguity resolution. The pattern that
emerged this dispatch: when the maintainer's directive is ambiguous
(plural without a bound), the panel disposition of the deferred work
is the right level (`follow-up` lets the maintainer answer at the
next read; `must-fix-loop` forces a builder dispatch to subsume the
deferred work before the maintainer's read). A skill or role addition
that names this pattern would help future dispatches. Filing as a
future gardener consideration; not promoted to a
`message: barrister → gardener` because the pattern is one-off enough
that the current `acknowledge` disposition treatment captures the
audit-trail.

Self-improvement: nothing this time. The dispatch's brief was clear,
the panel-hints script worked as documented, and the in-band fallback
mode produced the same disposition counts a multi-seat-dispatch would
have given on this code surface.

**Recommended next stage**: `next: fixer` to address the four
must-fix-loop items above. Fixer-brief shape: hand the must-fix items
to the fixer one by one with file:line citations; the fixer is the
appropriate dispatch because the changes are mechanical (template
rewrite, dead-binding fix, offline-mode transitive walk repair,
package-description edit) and do not need a fresh design pass.
After the fixer's `result` lands, the orchestrator dispatches the
**justice** for the re-run (not the barrister); the justice's
briefing reads this verdict and the fixer's response.
