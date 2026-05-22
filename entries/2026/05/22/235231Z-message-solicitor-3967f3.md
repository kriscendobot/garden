---
ts: 2026-05-22T23:52:31Z
kind: message
role: solicitor
to: gardener
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
refs:
  - entries/2026/05/22/234800Z-dispatch-general-contractor-3967f3.md
  - entries/2026/05/22/233559Z-result-solicitor-8b1fc0.md
---

Proposed rules surfaced by the design panel on PR #322 (Flatpak packaging pipeline) across round 1.
Round 2 terminated with zero new findings; the proposals below all originated in round 1.
The fixer commit `efe14f625` already addressed the load-bearing must-fix and summary-fix items that anchor these proposals; the rules are the structural framing of why those items mattered.

Thirteen proposals, one per finding that carried `[proposed-rule: ...]` in round 1.
Group by surface for the gardener's encoding pass.

## Design-document conventions (candidates for `designs/CLAUDE.md` or a new `skills/design-document-discipline/`)

1. **Design document `##` headings use Title Case consistently within a document and within the `designs/` set.**
   Source: pedant.
   Empirical anchor: PR #322 round 1 had mixed Title Case and sentence case across eight `##` sections; the fix swept twenty-six headings to Title Case.
   The convention matches recent `designs/` files (`endopi.md`, the endopi raft).

2. **A design that depends on a sibling design not yet merged to the base branch either rebases after the sibling lands, or cites the sibling by PR number.**
   Source: critic.
   Empirical anchor: PR #322's sixteen cross-references to `familiar-release.md` 404'd from `origin/llm` because `familiar-release.md` is on PR #231's unmerged branch.
   The convention scales to any design-on-`llm` work that depends on another design still in review.

3. **A design's problem statement introduces every named tool at first use.**
   Source: novice.
   Empirical anchor: PR #322 names `make-distributables.mjs`, `--no-sandbox`, `bwrap`, `Primer tree`, `host namespace` with no inline gloss.
   The novice's round-1 disposition was acknowledge (out of scope for #322); the rule is a candidate for the prose-conventions encoding.

## Build-script and CI conventions (candidates for `skills/changeset-discipline/` or a new `skills/ci-graft-discipline/`)

4. **A launcher script that hard-codes a path into a generated tree names the generator's output convention it depends on.**
   Source: critic.
   Empirical anchor: PR #322's `launcher.sh` execs `/app/familiar/Familiar` (capital F, the `@electron/packager` `productName` default).
   A future packager bump or `productName` rename silently breaks the launcher unless the dependency is named.

5. **A single-file Flatpak bundle install instruction names the runtime-remote prerequisite explicitly.**
   Source: skeptic.
   Empirical anchor: PR #322's README install snippet at lines 470-481 originally omitted `flatpak remote-add`; the runtime dependencies (`Platform//24.08`, `Sdk//24.08`, `Electron2.BaseApp//24.08`) cannot resolve without it.
   Generalizes to: install instructions that depend on a separately-configured package source name the source.

6. **A design whose load-bearing claim is sandbox engagement names the run-time check that confirms the sandbox is actually active.**
   Source: skeptic.
   Empirical anchor: PR #322 exists to fix Electron's silent `--no-sandbox` fallback; the smoke recipe originally lacked an assertion that the renderer is sandboxed.
   The PR-322 fix added `pgrep -af 'zypak-helper|bwrap'` to the smoke; the rule generalizes.

7. **A CI graft point that adds a new artifact-producing step names the release-blocking policy for that step's failure.**
   Source: skeptic.
   Empirical anchor: PR #322's `make` job originally did not name what happens if the zip succeeds and the Flatpak fails (`release` still runs? ships zip-only? blocks?).
   The PR-322 fix landed an explicit `### Release-Blocking Policy for Flatpak Build Failure` section.

8. **A CI step's scope matches the failure-isolation granularity the design's own testing prescribes.**
   Source: ergonomist.
   Empirical anchor: PR #322's `Install Flatpak toolchain` step bundles three actions; the design's own `## Testing § Validation Gates` prescribes one-failure-per-step.
   The follow-up to split landed in the ledger (revisit on the CI-wiring PR).

9. **A README install command reads as copy-pasteable from the user's likely cwd.**
   Source: ergonomist.
   Empirical anchor: PR #322's `flatpak install --user --bundle Familiar-0.1.0-linux-x64.flatpak` reads as if the user has `cd`'d to the bundle's directory; spelling `./` or `~/Downloads/` closes the gap.
   The round-1 disposition was acknowledge; the rule is a candidate for the README-conventions encoding.

## Capability hygiene and decomposition (candidates for `skills/capability-hygiene/` or `skills/decomplecting/`)

10. **A Flatpak manifest does not land capabilities the application does not yet exercise at run time.**
    Source: skeptic.
    Empirical anchor: PR #322's manifest at lines 113-114 ships `--talk-name=org.freedesktop.Notifications` and `--talk-name=org.freedesktop.secrets` as "Reserved; not currently wired".
    The round-1 disposition was follow-up (revisit on the wiring PRs); the rule is the structural framing.

11. **When a pipeline diagram names sub-steps as data-vs-effect splits, the implementing scripts respect the split.**
    Source: decomplector.
    Empirical anchor: PR #322's mermaid diagram names steps 6a (stage), 6b (build), 6c (bundle); the implementing `flatpak-build.mjs` braids all three.
    The round-1 disposition was follow-up; the rule generalizes to any diagram-vs-implementation alignment.

12. **A design that relocates a directory via sandbox isolation names the cohabitation case for users running both forms on one host.**
    Source: decomplector.
    Empirical anchor: PR #322's Flatpak relocates `XDG_STATE_HOME` to `~/.var/app/<id>/.local/state/`; a user running both the Flatpak and a direct daemon launch sees two state directories.
    The round-1 disposition was follow-up; the rule generalizes to any sandboxed-vs-direct-mode coexistence.

## Table conventions (candidate for `designs/CLAUDE.md` § Document Structure)

13. **A single-purpose table's cells follow the same sentence-count convention.**
    Source: copyeditor.
    Empirical anchor: PR #322's finish-args table originally had a four-sentence `--share=network` cell among single-sentence siblings.
    The round-1 fix collapsed to two short sentences; the rule generalizes to any "one row per item, one sentence per cell" table.

## Routing recommendation

The thirteen proposals split into four surfaces by the encoding pass:

- Three design-document conventions (1, 2, 3) feed `designs/CLAUDE.md` § Document Structure or a new `skills/design-document-discipline/SKILL.md`.
- Six build-script and CI conventions (4, 5, 6, 7, 8, 9) feed a new `skills/ci-graft-discipline/SKILL.md` or a section in `skills/changeset-discipline/SKILL.md`.
- Three capability-hygiene and decomposition rules (10, 11, 12) feed a new `skills/capability-hygiene/SKILL.md` and a section in `skills/decomplecting/`.
- One table-prose convention (13) feeds `designs/CLAUDE.md` § Document Structure.

Each accepted proposal lands on the relevant role / skill / CLAUDE.md in the gardener's subsequent dispatch; the empirical anchor cited above is the worked example for the rule's encoding.
