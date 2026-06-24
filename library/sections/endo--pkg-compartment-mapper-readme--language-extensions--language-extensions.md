---
title: Language Extensions
source: packages/compartment-mapper/README.md
source_repo: endojs/endo
source_commit: ee87476e0efcf8f6e412eec93eba5f3853ead6f3
source_date: 2024-12-15
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [bundles, compartments, tooling]
status: current
parent: endo--pkg-compartment-mapper-readme--language-extensions
---

Node.js version 14 or greater treats `.mjs` files as ECMAScript modules and
`.cjs` files as CommonJS modules.
The `.js` extension indicates a CommonJS module by default, to maintain
backward compatibility.
However, packages with `type` "module" will treat a `.js` file as an ECMAScript
module.

Many Node.js applications using CommonJS modules expect to be able to `require`
a JSON file like `package.json`.
The compartment mapper therefore supports loading JSON modules from any type of
module, but using this feature may limit compatibility with the Node.js platform
(in which importing a JSON module requires [import attributes] including
`type: "json"`).

The compartment mapper supports loading CommonJS modules from ECMAScript
modules as well as loading ECMAScript modules from CommonJS modules.
This presumes that the CommonJS modules exclusively use `require` calls with a
single string argument, where `require` is not lexically bound, to declare
their shallow dependencies, so that these modules and their transitive
dependencies can be loaded before any module executes.
Use of this feature may limit compatibility with the Node.js platform, which did
not support loading ECMAScript modules from CommonJS modules until version 22.

The compartment mapper supports language plugins.
The languages supported by default are:

- `mjs` for ECMAScript modules,
- `cjs` for CommonJS modules,
- `json` for JSON modules,
- `text` for UTF-8 encoded text files,
- `bytes` for any file, exporting a `Uint8Array` as `default`,
- `pre-mjs-json` for pre-compiled ECMAScript modules captured as JSON in
  archives, and
- `pre-cjs-json` for pre-compiled CommonJS modules captured as JSON in
  archives.

The compartment mapper accepts extensions to this set of languages with
the `parserForLanguage` option supported by many functions.
See [src/types/external.ts](./src/types/external.ts) for the type and expected
behavior of parsers.

These language identifiers are keys for the `moduleTransforms` and
`syncModuleTransforms` options, which may map each language to a transform
function.
The language identifiers are also the values for a `languageForExtension`,
`moduleLanguageForExtension`, and `commonjsLanguageForExtension` options to
configure additional extension-to-language mappings for a module and its
transitive dependencies.

For any package that has `type` set to "module" in its `package.json`,
`moduleLangaugeForExtension` will precede `languageForExtension`.
For any packages with `type` set to "commonjs" or simply not set,
`commonjsLanguageForExtension` will precede `languageForExtension`.
This provides an hook for mapping TypeScript's `.ts` to either `.cts` or
`.mts`.

The analogous `workspaceLanguageForExtension`,
`workspaceCommonjsLanguageForExtension`, and
`workspaceModuleLanguageForExtension` options apply more specifically for
packages that are not under a `node_modules` directory, indicating that they
are in the set of linked workspaces and have not been built or published to
npm.

In the scope any given package, the `parsers` property in `package.json` may
override the extension-to-language mapping.

```json
{
  "parsers": { "png": "bytes" }
}
```

> [!NOTE]
> TODO: The compartment mapper may elect to respect some properties specified
> for import maps.

> [!NOTE]
> TODO: A future version of the compartment mapper may add support for
> source-to-source translation in the scope of a package or compartment.
> This would be expressed in `package.json` using a property like
> `translate` that would contain a map from file extension
> to a module that exports a suitable translator.
>
> For browser applications, the compartment mapper would use the translator
> modules in two modes.
> During development, the compartment mapper would be able to load the
> translator in the client, with the `browser` condition.
> The compartment mapper would also be able to run the translator in a separate
> non-browser compartment during bundling, so the translator can be excluded
> from the production application and archived applications.

> [!NOTE]
> TODO: The compartment mapper may also add support for compartment map plugins
> that would recognize packages in `devDependencies` that need to introduce
> globals.
> For example, _packages_ that use JSX and a virtual DOM would be able to add a
> module-to-module translator and endow the compartment with the `h` the
> translated modules need.

Source: [packages/compartment-mapper/README.md](https://github.com/endojs/endo/blob/ee87476e0efcf8f6e412eec93eba5f3853ead6f3/packages/compartment-mapper/README.md) at commit `ee87476e`.
