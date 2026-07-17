---
title: Identity and metadata fields (name, version, description, keywords, homepage, bugs, license, people, funding)
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

Abstract: npm's authoritative reference for the identity and descriptive fields of `package.json`. `name` + `version` form a globally unique identifier and are the only required fields for publishing (both optional if you never publish). The section captures npm's naming rules (<=214 chars including scope, no new uppercase, URL-safe, optional `@scope/` prefix), that `version` must be node-semver parseable, and the shapes of the descriptive fields: `keywords` (array, feeds `npm search`), `homepage`/`bugs` (URL, plus `npm bugs`), `license` (SPDX identifier or expression; object/`licenses`-array forms deprecated; `UNLICENSED` plus `"private": true` for closed source), the `author`/`contributors` people fields (object or single `Name <email> (url)` string), and `funding` (object/string/array, surfaced by `npm fund`). This is the reference for the metadata column of the property matrix.

## name and version

If you plan to publish, `name` and `version` are the most important fields and are required; the two together form an identifier assumed to be completely unique, and changes to the package should come with a version change. If you do not publish, both are optional. Naming rules: <=214 characters including the scope for scoped packages; scoped names may begin with a dot or underscore (not permitted unscoped); new packages must not have uppercase letters; the name becomes part of a URL, a command-line argument, and a folder name, so no non-URL-safe characters. Tips: do not shadow a core Node module; do not put "js" or "node" in the name; keep it short but descriptive; check the registry first. A name can be prefixed by a scope, for example `@npm/example`. `version` must be parseable by node-semver.

## description and keywords

`description` is a string that helps discovery (listed in `npm search`). `keywords` is an array of strings, also surfaced in `npm search`.

## homepage, bugs

`homepage` is the project homepage URL. `bugs` is the issue tracker URL and/or an email address for reports; it may be an object `{ "url": ..., "email": ... }` or a bare URL string. A provided URL is used by `npm bugs`.

## license

Specify a license so people know how they may use the package. Use a current SPDX license identifier (for example `"BSD-3-Clause"`) or, for multiple licenses, an SPDX license expression (for example `"(ISC OR GPL-3.0)"`). For a non-SPDX or custom license, use `"SEE LICENSE IN <filename>"` and include that file at the top level. The old license-object and `"licenses"`-array forms are deprecated in favor of SPDX expressions. To grant no rights, use `"UNLICENSED"`, and consider also setting `"private": true` to prevent accidental publication.

## people fields: author, contributors

`author` is one person; `contributors` is an array of people. A "person" is an object with `name` and optional `url` and `email`, or a single string npm parses: `"Barney Rubble <barney@npmjs.com> (http://barnyrubble.npmjs.com/)"`. Email and url are optional. npm also sets a top-level `maintainers` field with your npm user info.

## funding

`funding` may be an object with a `url` (and optional `type`), a bare string URL, or an array mixing the two. `npm fund` lists the funding URLs of all direct and indirect dependencies; `npm fund <projectname>` visits a package's funding URL (the first when there are several).

Source: [docs/lib/content/configuring-npm/package-json.md](https://github.com/npm/cli/blob/ce7681fe7dbcc20abb5f1379558e14ddd069654f/docs/lib/content/configuring-npm/package-json.md) at commit `ce7681f`.
