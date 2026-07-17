---
title: Dependencies and resolution overrides (dependencies, dev/peer/bundle/optional, peerDependenciesMeta, overrides, packageExtensions)
source: docs/lib/content/configuring-npm/package-json.md
source_repo: npm/cli
source_commit: ce7681fe7dbcc20abb5f1379558e14ddd069654f
source_date: 2026-06-18
source_authors: [Max Black, Josh Soref, Michael Smith]
ingested: 2026-07-17
ingested_by: scholar
topics: [package-manifest, node-packaging]
status: current
---

Abstract: npm's reference for every dependency-declaring field and the two root-only resolution-control fields. `dependencies` maps names to version ranges (a rich specifier grammar: exact, comparators, `~`, `^`, `x`-ranges, hyphen ranges, `||`, tarball/git/GitHub-shorthand/local-path URLs, dist-tags, and `npm:` aliases). `devDependencies` are omitted for consumers (built by the `prepare` script). `peerDependencies` express plugin/host compatibility and, as of npm v7, are installed by default (warned but not installed in npm 3-6); `peerDependenciesMeta` can mark a peer `optional`. `bundleDependencies` (also spelled `bundledDependencies`, or a boolean) bundle named deps into the `npm pack` tarball. `optionalDependencies` do not fail the install on build/fetch failure and override same-named `dependencies`. `overrides` (root-only) force a version/replacement anywhere in the tree, with nested selectors and `$name` references to a direct dependency's spec. `packageExtensions` (root-only) declaratively add/correct a third-party manifest's dependency metadata (dependencies/optionalDependencies/peerDependencies/peerDependenciesMeta) and refuses to publish on a non-private package. This is the reference for the dependency-resolution column of the property matrix.

## dependencies (and the specifier grammar)

`dependencies` maps a package name to a version range (a string of one or more space-separated descriptors); deps can also be a tarball or git URL. Do not put dev-time tools here. Descriptors include: exact `version`; comparators `>`, `>=`, `<`, `<=`; `~version` (approximately equivalent); `^version` (compatible with); `1.2.x`; `http://...` tarball URL; `*` or `""` (any version); `version1 - version2` (inclusive range); `range1 || range2`; `git...` URLs; `user/repo` GitHub shorthand; a `tag` (a published dist-tag such as `latest`); a local `path/path/path`; and `npm:@scope/pkg@version` (a custom alias). Git URLs take the form `<protocol>://.../<path>[#<commit-ish> | #semver:<semver>]` with `<protocol>` one of `git`, `git+ssh`, `git+http`, `git+https`, `git+file`; installing from a git repo triggers a build if `workspaces` or any of `build`/`prepare`/`prepack`/`preinstall`/`install`/`postinstall` scripts are present. Local paths (`../foo/bar`, `~/foo/bar`, `./foo/bar`, `/foo/bar`) normalize to a relative `file:` spec and are for local offline development, not for publishing; a locally-linked path does not get its own dependencies installed.

## devDependencies

For tools a consumer does not need (test/doc frameworks, transpilers). Installed on `npm install`/`npm link` from a package root. For non-platform-specific build steps (for example compiling CoffeeScript), use the `prepare` script and make the tool a devDependency; `prepare` runs before publishing and during local install.

## peerDependencies and peerDependenciesMeta

`peerDependencies` express compatibility with a host tool/library without doing a `require` of it (the plugin pattern). In npm 3-6 peers were not auto-installed and warned on an invalid version; as of npm v7 they are installed by default. Keep the requirement broad (for example `"^1.0"`) to avoid conflicts. `peerDependenciesMeta` gives npm more information per peer, notably marking one `optional` (npm will not auto-install an optional peer), letting a plugin interact with a variety of hosts without requiring all be installed.

## bundleDependencies and optionalDependencies

`bundleDependencies` is an array of package names bundled into the tarball produced by `npm pack` (names only; versions come from `dependencies`). The misspelling `bundledDependencies` is also honored; a boolean `true`/`false` bundles all/none. `optionalDependencies` is a map like `dependencies` whose build/fetch failures do not fail the install; `npm install --omit=optional` skips them; your code must handle absence (the `try { require(...) } catch` pattern). Optional entries override same-named `dependencies`, so declare each dependency in only one place.

## overrides

`overrides` (considered only in the root `package.json`; ignored in installed dependencies and workspaces) replace a package in the dependency tree with another version or another package entirely. Values may be any dependency specifier (exact version, semver range, dist-tag, or a replacement such as `npm:`, `file:`, or a Git URL). The short form `{ "foo": "1.0.0" }` forces the version everywhere; the object form nests to scope the override to a package under a parent (to any depth), and a version key (`"bar@2.0.0"`) scopes to a specific parent version. You may not override a package you directly depend on unless the specs match exactly; a `$name` reference makes the override match the direct dependency's spec (`"foo": "$foo"`). Replacement methods: `npm:@scope/forked-package@1.0.0`, `github:username/repo#branch`, or `file:../local-fork`, at top level or nested.

## packageExtensions

`packageExtensions` applies small declarative repairs to third-party dependency manifests before npm resolves the tree: add a missing `dependencies`/`optionalDependencies`/`peerDependencies` entry or correct `peerDependencies`/`peerDependenciesMeta` while waiting for an upstream fix. It is especially useful under `install-strategy=linked` (fully isolated deps) where a package sees only what it declared. It complements `overrides`: `overrides` changes what an existing edge resolves to; `packageExtensions` adds or corrects the metadata that creates the edge. Like `overrides` it is honored only in the root `package.json` (the workspace root); npm refuses to publish a non-private package containing it. Each key is a selector (`"foo"`, `"foo@1"`, `"@scope/foo@^2.3.0"`) matched against a candidate's own `name`/`version` (no dist-tag/git/file/URL/`npm:` selectors; at most one selector may match a package). Only the four fields above may be extended; `dependencies`/`optionalDependencies` add-only (adding an existing name is an error, use `overrides` to change a version), `peerDependencies` merge-by-name replacing a range, `peerDependenciesMeta` merge-by-name-then-key (every entry must correspond to a `peerDependencies` entry). Deletion is unsupported (`null`/`false`/`"-"` is an error). It does not rewrite the installed manifest on disk or modify `bundleDependencies`; affected packages are recorded in `package-lock.json` and surfaced by `npm explain`/`npm ls`.

Source: [docs/lib/content/configuring-npm/package-json.md](https://github.com/npm/cli/blob/ce7681fe7dbcc20abb5f1379558e14ddd069654f/docs/lib/content/configuring-npm/package-json.md) at commit `ce7681f`.
