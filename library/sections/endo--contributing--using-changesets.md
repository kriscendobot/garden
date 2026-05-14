---
title: Using Changesets
source: CONTRIBUTING.md
source_repo: endojs/endo
source_commit: 6ad084a6900b
source_date: 2026-01-08
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [repository-governance, tooling]
status: current
---

> Abstract: The changeset workflow for the monorepo: adding a changeset for a PR that affects published packages, editing existing changesets, deciding whether a changeset is needed (test-only, doc-only, internal-refactor PRs may not need one), and the release workflow that converts changesets into version bumps.

## Using Changesets

Endo uses [Changesets](https://github.com/changesets/changesets) to manage
versioning and changelogs.
A **changeset** is a Markdown file in the `.changeset/` directory that captures:

- Which packages need to be released
- The [semver](https://semver.org/) bump type (major, minor, or patch)
- A changelog entry describing the change

Changesets are "intents to release" that accumulate until maintainers cut a
release.
The changeset files themselves are temporary—when a release is cut, they are
consumed and removed from version control, with their contents incorporated into
each package's `CHANGELOG.md`.

This approach automates version bumping across the monorepo (including internal
dependency updates) and generates changelogs automatically, while keeping humans
in the loop to review and edit release notes before publishing.

Contributors make versioning decisions _at contribution time_ (i.e. _in the PR
itself_), when the context is fresh.

### Adding a Changeset

When your PR includes changes that should be released, add a changeset:

1. Run `yarn changeset`
2. Select the affected packages (use arrow keys to navigate, space to select,
   enter to confirm)
3. Choose the appropriate bump type for each package
4. Write a clear, complete description of the change—what changed, why, and any
   migration notes if needed. Consider security and performance implications.
   This text will appear verbatim in `CHANGELOG.md`, so make it useful for
   consumers of the package.
5. Commit the generated `.changeset/*.md` file with your PR

> Do not be alarmed by the unique, auto-generated names of the changeset files!
> This is expected.

### Editing a Changeset

You typically want to do this _before_ your PR lands, but all you need to do is
find the changeset file in `.changeset/`, edit it, and commit.

### Do I Need a Changeset?

Generally, you need a changeset only if your PR contains **user-facing changes**
to a package—bug fixes, new features, breaking changes, or other modifications
that consumers of the package would notice.

You typically **do not** need a changeset for:

- Documentation-only changes
- Test additions or fixes
- CI/build configuration changes
- Refactoring that doesn't change public behavior

The helpful [changeset-bot](https://github.com/apps/changeset-bot) will comment
on your PR if no changeset is present, but this won't block merging.  

> [!TIP]
>
> When in doubt, ask a friendly maintainer. Avoid the unfriendly ones.

### Release Workflow (For Maintainers)

The release process works as follows:

1. As changesets accumulate on `master`, the `changesets/action` GitHub Action
   (see [.github/workflows/release.yml](.github/workflows/release.yml))
   automatically creates and maintains a **Release PR** titled "Version
   Packages"
2. This Release PR applies all pending changesets; it bumps versions, updates
   `CHANGELOG.md` files, and deletes the consumed changeset files
3. Maintainers review the Release PR to verify versions and changelog entries
   look correct. Maintainer will approve and/or merge when ready.
   Merging will also create tags and GitHub Releases for each affected package.
4. After merging the Release PR, pull `master` and run `yarn release:npm` to
   publish the updated packages to npm.

Source: [CONTRIBUTING.md](https://github.com/endojs/endo/blob/6ad084a6900b/CONTRIBUTING.md) at commit `6ad084a6`.
