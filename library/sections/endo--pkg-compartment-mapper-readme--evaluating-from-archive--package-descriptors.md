---
title: Package Descriptors
source: packages/compartment-mapper/README.md
source_repo: endojs/endo
source_commit: ee87476e0efcf8f6e412eec93eba5f3853ead6f3
source_date: 2024-12-15
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [bundles, compartments]
status: current
parent: endo--pkg-compartment-mapper-readme--evaluating-from-archive
---

The compartment mapper uses [Compartments], one for each Node.js package your
application needs.
The compartment mapper generates a compartment graph from Node.js packaged
module descriptors: the `package.json` files of the application and all its
dependencies.
Consequently, an application must have a `package.json`.

Each package has its own descriptor, `package.json`.
Some standard properties of the descriptor are relevant and used by a
compartment map.

* `name`
* `type`
* `main`
* `exports`
* `browser`
* `dependencies`
* `files`

The compartment map will contain one compartment for each `package.json`
necessary to build the application.
Like Node.js, the compartment mapper trusts the package manager to arrange the
packages such that a satisfactory version of every package's dependencies rests
in a parent directory, under `node_modules`.

The `main`, `browser`, and `exports` properties determine the modules each
package exports to other compartments.

The `exports` property describes [package entry points] and can be influenced
by build _conditions_.
Currently, the only conditions supported by the compartment mapper are
`import`, `browser`, and `endo`.
The `imports` condition indicates that the module map should use ESM modules
over CommonJS modules or other variants, and `endo`.
The `browser` condition also draws in the `browser` property from
`package.json` instead of `main`.
The `endo` condition only indicates that this tool is in use.

If no `exports` apply to the root of the compartment namespace (`"."`),
the `main` property serves as a default.

> [!NOTE]
> TODO: A future version may also respect the `imports` property.

> [!NOTE]
> TODO: A future version may also respect wildcard patterns in `exports` and
> `imports`.

The `files` property indicates all of the files in the package that
should be vended out to applications.
The file set implicitly includes all `**.js`, `**.mjs`, and `**.cjs` files.
The file set implicitly excludes anything under `node_modules`.

With the compartment mapper, just as in Node.js, a module specifier that has no
extension may refer either to the file with the `js` extension, or if that file
does not exist, to the `index.js` file in the directory with the same name.

> [!NOTE]
> TODO: The compartment mapper does not yet do anything with the `files` globs
> but a future version of the compartment mapper will collect these in archives.
> The compartment mapper should eventually provide the means for any
> compartment to access its own files using an attenuated `fs` module or
> `fetch` global, in conjunction with usable values for `import.meta.url` in
> ECMAScript modules or `__dirname` and `__filename` in CommonJS modules.

Source: [packages/compartment-mapper/README.md](https://github.com/endojs/endo/blob/ee87476e0efcf8f6e412eec93eba5f3853ead6f3/packages/compartment-mapper/README.md) at commit `ee87476e`.
