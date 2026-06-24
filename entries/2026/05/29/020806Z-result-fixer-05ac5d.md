---
ts: 2026-05-29T02:08:06Z
kind: result
role: fixer
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
refs:
  - jobs/claimed/20260529T020045Z--endolinbot--general-contractor--711e--112f87--summary-fix-324.md
---

Addressed the six-item summary-fix bundle on PR #324 (`test(lal):
Primer-into-CAS packaged-build smoke`).
One commit on branch `test/familiar-primer-cas-smoke`:

- new head: `27d000370`
- previous head: `657606f73`
- commit: `test(lal): Apply summary-fix bundle on #324`

Per-item mapping (all in one combined commit per the dispatch's
"Likely one combined commit" hint):

1. **assessor (idempotent branch)**: addressed.
   Added Step 5 to the sub-guest test that observes
   `has('primer') === true` after the first `storeIdentifier`,
   takes the no-op branch of `provisionPrimer()`'s guard, and
   re-resolves the primer to confirm the cap survives the
   no-op pass.

2. **typist (return-type JSDoc)**: addressed.
   Added `@returns {Promise<{ host: any, config: ReturnType<typeof
   makeConfig> }>}` to `prepareDaemonHost` with a sentence
   describing each field's meaning and source.

3. **prover (strict-superset assertion + cross-ref)**: addressed.
   Test #2 now reads the bundled-primer directory once, asserts
   `bundledFiles.length >= required.length` with a diagnostic
   message, and the docstring cross-references
   `lal/agent.js`'s `provisionPrimer` at lines 1653-1657 (not
   the 733-779 the bundle named; `provisionPrimer` actually
   lives later in the current source).

4. **saboteur (`ensureBundledPrimer` in `test.before`)**:
   addressed.
   Wrapped the existing `ensureBundledPrimer` invocation in a
   `test.before('ensure the familiar bundle is present', ...)`
   hook so a bundle-step failure surfaces as a normal AVA
   failure with full diagnostic context.

5. **integrator (explicit `@endo/platform` devDependency)**:
   verified-no-change.
   The bundle's premise that the dep "currently arrives
   transitively via `@endo/daemon`" is stale: `packages/lal/
   package.json` line 43 already lists `@endo/platform:
   workspace:^` as an explicit runtime dependency (the
   `agent.js` import requires it at runtime, so it cannot be
   demoted to `devDependencies`). Spirit of the item
   ("explicit-dependency hygiene, no transitive reliance")
   already holds.

6. **corner-prober (label-prefix-disjointness)**: addressed.
   Added a comment near `makeConfig` documenting the
   prefix-disjointness constraint, naming the two current
   labels (`host-checkin`, `guest-provision`) that begin with
   distinct first segments, and naming the rule new labels
   must honor.

Local lint/test outcomes:

- Pre-push gates: ran in `--summary` mode.
  All pre-existing repo-wide probe failures (filename-no-stutter
  on `chat/chat-bar-component.js`, ASCII banner in
  `designs/trust-on-first-bind.md`, inline `import()` JSDoc in
  `captp.js`, bare `#<n>` reference in `chat/add-space-modal.js`,
  divergent SECURITY.md hash, sentence-per-line drift in many
  pre-existing markdown files) are unrelated to this diff and
  not introduced by it. `git status` confirmed only the test
  file was modified after the gate ran. `yarn format` /
  `yarn lint --fix` did not mutate any unrelated files.
- Prettier: `npx prettier --check packages/lal/test/
  primer-cas-smoke.test.js` reports "All matched files use
  Prettier code style!".
- ESLint: project `node_modules/` not installed in the
  per-dispatch worktree; `yarn lint` cannot run. CI on the
  PR head will exercise the test under the proper toolchain.
- `node --check`: passes.
- `yarn typecheck`: no typecheck script in `packages/lal` so
  the gate skipped.

The bundle is a post-un-draft cleanup pass; the items do not
block merge. No CHANGES_REQUESTED reply owed (panel-derived, not
maintainer-derived). No PR comments or reactjis posted (no per-
action authorization in this dispatch). The dispatch's "out of
scope" items (two `follow-up` items in
`journal/projects/endo-but-for-bots/followups/endo-but-for-bots--
324.md` with `status: parked`) remain parked.

Self-improvement: When a panel-bundle item names a line range
(`agent.js:733-779`) that's stale relative to current head, do a
quick grep for the named symbol (`provisionPrimer`) before
inlining the citation, and quote the current line range in the
fixer's response with a "currently around lines N-M" qualifier
so the next reader knows the citation is keyed to the symbol,
not the absolute line.
