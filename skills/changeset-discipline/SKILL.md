---
created: 2026-05-13
updated: 2026-06-26
author: liaison, gardener
---

# Skill: changeset-discipline

A changeset (e.g., `@changesets/cli`'s `.changeset/<adjective-noun-thing>.md`)
is written only when the change is user-observable. When one is warranted, the
body addresses a dependency updater reading the published release notes, nothing
else. Consumed by the builder and cleaner steps of the gardening state machine,
and by several jury seats (changeset-auditor, releaser, migrator).

## When to write one

- A new exported API.
- A change in observable behavior of an existing exported API.
- A bug fix the user could have noticed.
- A breaking change (removed export, changed signature, stricter validation).
- A migration step the user must perform on upgrade.

## When not to

Skip entirely (don't write a "no-op" entry) if all of:

- The change does not enable the user to do anything new.
- The change does not obligate the user to perform any migration.
- The user could not detect the change by reading the package's documentation,
  signatures, or behavior.

Examples that do *not* need a changeset: removing an unused devDependency;
moving tests into a sibling synthetic test package; renaming an internal-only
file under `src/`; adding a private internal subpath gated by a test export
condition; refactoring a fixture; updating a comment, JSDoc, or README that
describes already-existing behavior; CI workflow tweaks; build- or lint-only
changes; additions or edits under `.claude/` (project-internal agent context
that is not part of any package's public surface).

A noisy changelog full of "removed unused devDep" or "moved tests" entries
trains downstream consumers to ignore the changelog, which makes the genuinely
user-facing entries harder to notice.

## When in doubt, ask

A changeset is easier to add than to remove (after publish, the entry ships
forever). When unsure, ask the maintainer in the PR description rather than
defaulting to writing one. The PR description's `[Documentation]` line should
say "no changeset (internal hygiene)" when omission is deliberate.

## What goes inside

A changeset's audience is a downstream package author reading the published
release notes and deciding whether to upgrade. Write to that reader.

- **One changeset per PR per release cycle.** A PR is a single release-cycle
  change; fix-up commits responding to review feedback are part of that one
  change, not new ones. Do not add a second `.changeset/*.md` for a subsequent
  fix; revise the existing entry. Multiple files in `.changeset/` for one PR
  almost always wants consolidating.
- **Keep the changeset current as the PR evolves.** A description of the
  interface from an earlier draft is worse than no description; it actively
  misleads. When the PR's interface, naming, or migration path changes during
  review, sweep the changeset in the same commit. "No longer true" review
  comments on a changeset are the regression mode.
- **Omit implementation details.** A reader updating a dependency cares about
  the new affordance, the obligation on upgrade, and the breakage shape. They do
  not care about which internal helper was extracted, why the third revision
  changed the scratch-buffer layout, or how the test harness was rewired. Cite
  the user-visible fact; let the diff carry the rest.
- **No process commentary.** A changeset is not a place to narrate the PR's
  review history, the rationale for splitting from a sibling PR, or the agent's
  own scope decisions. "Reverted from earlier draft", "split out of #N",
  "addresses reviewer ask" all belong in the PR body or in the commit message,
  not in the published release notes.

## New-package initial release

When the change introduces a brand-new package (e.g. a new `@endo/*`
workspace), the initial release follows a fixed shape. The release tooling
regenerates `CHANGELOG.md` from changesets at publish, so a hand-authored
initial changelog is always wrong.

- **`CHANGELOG.md` starts empty** — the standard stub and nothing more:

  ```
  # Change Log

  All notable changes to this project will be documented in this file.
  See [Conventional Commits](https://conventionalcommits.org) for commit guidelines.
  ```

  No hand-written release notes, no `## 0.1.0 (unreleased)` heading, no
  bullet list of features. Authoring release prose in the changelog is the
  builder error this rule exists to prevent.
- **`package.json` version is `0.1.0`** at creation.
- **The changeset bumps `major`** (`'@endo/pkg': major`). A major bump from
  `0.1.0` yields a first published release of **1.0.0**, which is what the
  regenerated changelog will reflect. A `minor` or `patch` initial-release
  changeset is wrong: it would publish `0.2.0` / `0.1.1` instead of `1.0.0`.
- **The "what this package is" prose lives in the changeset body**, not in
  the changelog. The changeset body is the substantive description a
  downstream reader consults; the changelog is regenerated from it.

Reference exemplar already in-tree: `@endo/cancel` (changeset
`cancel-initial-release.md`, `major`; version `0.1.0`; empty stub
`CHANGELOG.md`).

Provenance: kriskowal review directive on `endojs/endo-but-for-bots#513`
(inline comment on `packages/pubsub/CHANGELOG.md`, 2026-06-26) — *"keep the
initial changelog empty, the first version 0.1.0, and a changeset bumping the
major, such that the first release is 1.0.0 as will be reflected in the change
log."*

## Notes from the field

- _2026-05-13_: adopted from a reference garden. The discipline applies wherever
  Changesets is in use. Per-project conventions (the file path under
  `.changeset/`, the YAML front-matter shape) belong in a journal entry tagged
  with the relevant project slug.
- _2026-05-14_: the *What goes inside* section was extracted from kriskowal's
  review of endojs/endo#3232 (no process commentary; stale interface in the
  changeset body; implementation detail not interesting to package authors;
  consolidate when a single release cycle produces multiple `.changeset/*.md`
  files).
- _2026-06-18_: the `.claude/` exclusion in the *When not to* list was added per
  a panel finding (changeset-auditor seat) on a `.claude/skills/.../skill.md`
  edit that did not warrant a changeset entry. The `.claude/` directory is
  project-internal agent context; it never reaches a downstream consumer reading
  release notes.
- _2026-06-24_: migrated into v2. Pure discipline; no coordination wording to
  rewire. Consumed by builder/cleaner script steps and the changeset-auditor/
  releaser/migrator jury seats rather than by a dispatched judge.
- _2026-06-26_: added the *New-package initial release* section (empty stub
  changelog, version `0.1.0`, `major` changeset → first release `1.0.0`, prose
  in the changeset body) per kriskowal's review directive on
  `endojs/endo-but-for-bots#513`. The directive asked for both builder guidance
  (this section) and reviewer prohibition (added to the changeset-auditor seat,
  whose dangling `§ Bump level for new packages` citation now points here and
  enforces the concrete `0.1.0`/`major`/`1.0.0` shape).
