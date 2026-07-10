---
role: designer
---
<!-- garden-promoted-from-plan: gate=deferred priority=low at=2026-07-10T07:19:05Z -->

# Design (LOW PRIORITY): release-automation trigger — flag `.js`-export cleanup on a planned major bump

**Repo:** endojs/endo-but-for-bots, base `llm`. **Priority: low.** Deliberately
lower priority than the exports migration itself.

## Purpose

The additive extensionless-`exports` migration
(`design-exports-extensionless-migration`) leaves each package with BOTH `.js`
and extensionless subpath keys, retained for compatibility, with a changeset note
reserving the right to remove the `.js` keys **in the next major version**. This
plan gives us a machine reminder so that window is not missed: when a PR carries a
**planned major bump** for such a package, release automation should surface that
the `.js`-suffixed `exports` keys are now removable.

## Requirements

- **Detect a planned major bump.** Read the PR's pending changesets
  (`.changeset/*.md`) and identify packages declared for a `major` bump.
- **Cross-reference retained `.js` keys.** For each such package, check whether
  its `package.json` `exports` still carries `.js`-suffixed subpath keys that have
  extensionless siblings (i.e. legacy-compat keys left by the migration).
- **Surface on the PR.** If any exist, emit an **informational, non-blocking**
  notice on the PR (a comment or a check annotation) listing the removable `.js`
  keys per package, framed as "major bump → opportunity to complete the
  extensionless-exports cleanup."
- **Deterministic, no LLM.** Runs in plain release-automation/CI code.

## Dependency

Meaningful only after the migration's **pass 1** lands the dual keys. Not a hard
blocker to authoring, but its notice is inert until such packages exist.

## Definition of done

A design (or directly the CI/release-automation check) that fires the
informational notice on major-bump PRs for packages with retained `.js` exports,
non-blocking, with a clear message pointing at the cleanup.
