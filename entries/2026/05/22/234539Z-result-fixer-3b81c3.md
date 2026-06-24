---
ts: 2026-05-22T23:45:39Z
kind: result
role: fixer
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
refs:
  - entries/2026/05/22/233700Z-dispatch-general-contractor-173961.md
  - entries/2026/05/22/233559Z-result-solicitor-8b1fc0.md
---

PR #322 (design(familiar-flatpak-pipeline)) solicitor round 1
addressed in one commit (`efe14f625`, pushed to
`feat/familiar-flatpak-pipeline`).

## Must-fix (3 of 3 addressed)

1. **Finish-args API names corrected.**
   `@endo/where`'s actual exports (verified by reading
   `packages/where/index.js`): `whereEndoState` (XDG_STATE_HOME),
   `whereEndoCache` (XDG_CACHE_HOME), `whereEndoEphemeralState`
   (XDG_RUNTIME_DIR), `whereEndoSock`.
   No `whereEndoLog` or `whereEndoConfig`; no XDG_DATA_HOME or
   XDG_CONFIG_HOME use.
   Dropped the `--filesystem=xdg-data/endo:create` and
   `--filesystem=xdg-config/endo:create` lines from the manifest's
   `finish-args` block; rewrote the two remaining `--filesystem=`
   table rows (xdg-state and xdg-cache) against the actual public
   API; rewrote the corresponding Known Gaps TODO to invert the
   framing (the gap is "if the implementation surfaces a write
   under data or config, grow the manifest accordingly", not "the
   manifest already covers it").

2. **Cross-references converted to PR #231 citation.**
   All 16 in-doc cross-references to `familiar-release.md`
   (including the metadata-table Source line, the G2 / G3 / G4 /
   G5 / G6 / G11 / G12 / G16 references, the dependency-table
   entry, the in-scope/out-of-scope deferral note, the
   phased-implementation footer, and the Pipeline Shape /
   Manifest Choice prose references) now cite "`familiar-release.md`
   (PR
   [#231](https://github.com/endojs/endo-but-for-bots/pull/231))".
   The verbatim quote in the `## Prompt` block at line 731
   (`designs/familiar-release.md L205`) is preserved as the
   maintainer's actual text.
   Decision shape: per Open Question 1, the PR bases on `llm`
   rather than rebasing onto a master that does not yet carry
   `familiar-release.md`; once #231 lands on `llm`, a sweep can
   convert the citations back to relative-path links.

3. **PR-body Open Questions surfaced in the document.**
   Added a `## Open Questions` section between Known Gaps and
   Prompt, with the three PR-body questions (master vs llm base,
   missing finish-args lines, Flathub listing timing).
   Question 1 explicitly names the cross-reference convention
   (cite by PR number while #231 is unmerged); Question 2 names
   the actual `@endo/where` public API the design assumes.

## Summary-fix bundle (8 of 8 addressed)

- **Title Case across all headings.** 12 headings retitled:
  `Status Quo`, `Pipeline Shape`, `Manifest Shape`, `Runtime
  Choice`, `Finish-Args: Capability Surface Justification`, `What
  the Manifest Excludes`, `Launcher and Metadata Files`, `Build
  Script`, `CI Workflow Integration`, `Signing Posture (Deferred)`,
  `Flathub Listing (Deferred)`, `Local Build (Developer Host on
  Linux)`, `CI Smoke`, `Validation Gates the Manifest Itself Must
  Pass`, `Release-Blocking Policy for Flatpak Build Failure`,
  `Phased Implementation`.

- **`@electron/packager` productName convention named.** Added a
  paragraph after the `launcher.sh` block that names the
  `Familiar` (capital F) productName dependency and the parallel
  update obligation if the packager output convention changes.

- **README install snippet adds Flathub remote-add prerequisite.**
  Added the `flatpak remote-add --if-not-exists --user flathub
  https://flathub.org/repo/flathub.flatpakrepo` line before the
  bundle-install line; named the runtime-dependency resolution
  through whichever remote is configured.

- **Sandbox-engagement assertion added.** New
  `#### Sandbox-Engagement Assertion` subsection under
  `### Local Build (Developer Host on Linux)`; the assertion is
  `pgrep -af 'zypak-helper|bwrap' > /tmp/familiar-sandbox.log`
  followed by `test -s` to fail-closed when the renderer is not
  sandboxed.

- **Release-blocking policy named.** New
  `### Release-Blocking Policy for Flatpak Build Failure`
  subsection under `## Testing`; the policy is "make job fails as
  a whole, no `continue-on-error: true` on the Flatpak steps",
  reasoning that shipping zip-only silently regresses the sandbox
  story this design fixes.

- **Release-job assertion cites the actual matcher pattern.** The
  paragraph at the end of `### CI Workflow Integration` now cites
  `familiar-release.yml` lines 132 to 136 and names the
  `actions/download-artifact` pattern as `familiar-*`.

- **Script-name unified.** Mermaid diagram step 6a was
  `flatpak-prepare.mjs`; the `## Build Script` section was
  `flatpak-build.mjs`. Unified on `flatpak-build.mjs` (the
  single-script form the section names); added a clarifying
  paragraph that names the conceptual phases the diagram preserves.

- **Copyeditor fixes.** Line 26 comma splice rewritten as two
  sentences; the multi-sentence `--share=network` table cell
  collapsed to two sentences (summary + scope clarification); the
  exclusion paragraph moved into the `#### What the Manifest
  Excludes` subsection it belonged in; the hanging "it" antecedent
  at the zypak-wrapper paragraph rewritten as "The wrapper
  replaces...".

## Items deliberately not touched

- **Follow-up items (5):** the `--talk-name=` reserved capability
  question, the prepare/build script split, the three-CI-step
  toolchain unpack, the dependency-table label refactor, the
  state-cohabitation note. These are panel-marked `follow-up` and
  per the dispatch brief are not the fixer's lane on this round;
  the orchestrator's terminating-round logic appends them to the
  followup ledger.
- **Acknowledge items (5):** taste-level rationale-framing, the
  Flathub runtime/sdk/base-app verification, the README cwd
  copy-pasteability nit, the novice background-assumption notes,
  the metadata-table `Updated` field omission. I did add an
  `Updated: 2026-05-22` row to the metadata table; the panel
  flagged its absence as `acknowledge`, which the role file
  permits taking up if it falls naturally into the must-fix
  sweep (it did).

## Files changed

- `designs/familiar-flatpak-pipeline.md`: 188 insertions, 64
  deletions (239-line diff including moves).
- `designs/README.md`: index-row Updated date bumped to 2026-05-22;
  recently-added paragraph cross-link rewritten to PR #231 citation.

## CI / re-request review

This is a design-only PR; no CI to drive green. Per
`roles/solicitor/AGENT.md`, the next stage after a fixer push on a
must-fix round is solicitor re-dispatch for round 2 (the
orchestrator initiates).
No `gh pr review` re-request needed by the fixer per
`roles/COMMON.md` § External-repo etiquette (the dispatch did not
authorize per-action commenting; the panel-review surface is the
solicitor's, not the fixer's).

Self-improvement: the `--filesystem=` line set in the panel's must-fix
finding traces to `@endo/where`'s public-API surface, but the design
doc's TODO list also held a stale assumption about `whereEndoLog`.
Fixing the table while leaving the TODO inverted would re-introduce
the same finding on round 2. Worth a one-line note on
`skills/verify-upstream-state-before-pinning/SKILL.md`'s procedure:
"When the panel's finding cites a stale upstream-name assumption,
search the rest of the document for the same name before pushing the
fix; a single citation often has parallel instances in TODOs, gaps
checklists, or design-decision rationale." Marginal lesson; not worth
a CLAUDE.md row.
