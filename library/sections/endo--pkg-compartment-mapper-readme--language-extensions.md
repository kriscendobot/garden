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
---

> Abstract: Source-language support: how compartment-mapper handles CommonJS, ES modules, JSON, and transpiled forms. Covers the per-extension parsers and the source-transform pipeline. The longest sub-section by line count; technical reference for adding support for new languages or tweaking existing ones.

## Language Extensions

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

# Source Maps

The `makeArchive`, `makeAndHashArchive`, and `writeArchive` tools can receive a
`sourceMapHook` as one of its options.
The `sourceMapHook` receives a source map `string` for every module it
archives, along with details `compartment`, `module`, `location`, and `sha512`.
The `compartment` is the fully-qualified file URL of the package root.
The `module` is the package-relative module specifier.
The `location` is the fully-qualified file URL of the module file.
The `sha512`, if present, was generated with the `computeSha512` power from the
generated module bytes.

The functions `importArchive`, `loadArchive`, and `parseArchive`
tools can receive a `computeSourceMapLocation` option that recives the same
details as above and must return a URL.
These will be appended to each module from the archive, for debugging purposes.

The `@endo/bundle-source` and `@endo/import-bundle` tools integrate source maps
for an end-to-end debugging experience.

# XS (experimental)

The Compartment Mapper can use native XS `Compartment` and `ModuleSource` under
certain conditions:

1. The application must be an XS script that was compiled with the `xs`
  package condition.
  This causes `ses`, `@endo/module-source`, and `@endo/import-bundle` to
  provide slightly different implementations that can fall through to native
  behavior.
2. The application must opt-in with the `__native__: true` option on any
  of the compartment mapper methods that import modules like `importLocation`
  and `importArchive`.

# Design

Each workflow of the compartment mapper executes a portion of a sequence
of underlying internals.

* search ([search.js](./src/search.js)): Scan the parent directories of a given
  `moduleSpecifier` until successfully finding and reading a `package.json` for
  the containing application.
* map compartments from Node.js packages
  ([node-modules.js](./src/node-modules.js)): Find and gather all the
  `package.json` files for the application's transitive dependencies.
  Use these to construct a compartment map describing how to construct a
  `Compartment` for each application package and how to link the modules each
  exports in the compartments that import them.
* load compartments ([archive.js](./src/archive.js)): Using `compartment.load`,
  or implicitly through `compartment.import`, create a module graph for the
  application's entire working set.
  When creating an archive, this does not execute any of the modules.
  The compartment mapper uses the compartments and a special `importHook` that
  records the text of every module the main module needed.
* import modules ([import.js](./src/import.js),
  [import-archive.js](./src/import-archive.js)): Actually execute the working
  set.

Around this sequence, we can enter late or depart early to store or retrieve an
archive.
The compartment mapper provides workflows that use `read` and `write` hooks
when interacting with a filesystem or work with the archive bytes directly.

This diagram represents the the workflows of each of the public methods like
`importLocation`.
Each column of pipes `|` is a workflow from top to bottom.
Each asterisk `*` denotes a step that is taken by that workflow.
The dotted lines `.'. : '.'` indicate carrying an archive file from the end of
one workflow to the beginning of another, either as bytes or a location.

In the diagram, "powers" refer to globals and built-in modules that may provide
capabilities to a compartment graph.
For `writeArchive` and `makeArchive`, these may be provided but will be ignored
since the application does not execute.

```
                 loadLocation  writeArchive
             importLocation |  | makeArchive
                          | |  | |
                          | |  | |      parseArchive
                          | |  | |      | loadArchive
                          | |  | |      | | importArchive
                          | |  | |      | | |...
               search ->  * *  * *      | |'| . '
     map compartments ->  * *  * *   .'.| | |' : :
         read archive ->  |    | |  '   | * *  : :
       unpack archive ->  |    | |  :   * * *  : :
assemble compartments ->  *    * *  :       *  : : <- powers
    load compartments ->  *    * *  :       *  : :
       import modules ->  *    | |  :       *  : :
         pack archive ->       * *  '          : :
        write archive ->       * '.' <- data   : :
                               '..............'  : <- files
                                '...............'
```

# Compartment maps

The compartment mapper works by generating a _compartment map_ from your
application workspace and all of the `node_modules` it needs.
A compartment map is similar to a lock file because it collects information
from all of the installed modules.
A compartment map describes how to construct compartments for each
package in your application and link their module namespaces.

The compartment map shape:

```ts
// CompartmentMap describes how to prepare compartments
// to run an application.
type CompartmentMap = {
  tags: Conditions,
  entry: Entry,
  compartments: Record<CompartmentName, Compartment>,
  realms: Record<RealmName, Realm>, // TODO
};

// Conditions influence which modules are selected
// to represent the implementation of various modules.
// These may include terms like "browser", meaning
// each compartment uses the implementation of each
// module suitable for use in a browser environment.
type Conditions = Array<Condition>;
type Condition = string;

// Entry is a reference to the module that is the module to initially import.
type Entry = CompartmentModule;

// CompartmentName is an arbitrary string to name
// a compartment for purposes of inter-compartment linkage.
type CompartmentName = string;

// Compartment describes where to find the modules
// for a compartment and how to link the compartment
// to modules in other compartments, or to built-in modules.
type Compartment = {
  location: Location,
  modules: ModuleMap,
  parsers: ParserMap,
  types: ModuleParserMap,
  scopes: ScopeMap,
  // The name of the realm to run the compartment within.
  // The default is a single frozen realm that has no name.
  realm?: RealmName // TODO
};

// Location is the URL relative to the compartment-map.json's
// containing location to the compartment's files.
type Location = string;

// ModuleMap describes modules available in the compartment
// that do not correspond to source files in the same compartment.
type ModuleMap = Record<InternalModuleSpecifier, Module>;

// Module describes a module in a compartment.
type Module = CompartmentModule | FileModule | ExitModule;

// CompartmentModule describes a module that isn't in the same
// compartment and how to introduce it to the compartment's
// module namespace.
type CompartmentModule = {
  // The name of the foreign compartment:
  // TODO an absent compartment name may imply either
  // that the module is an internal alias of the
  // same compartment, or given by the user.
  compartment?: CompartmentName,
  // The name of the module in the foreign compartment's
  // module namespace:
  module?: ExternalModuleSpecifier,
};

// FileLocation is a URL for a module's file relative to the location of the
// containing compartment.
type FileLocation = string

// FileModule is a module from a file.
// When loading modules off a file system (src/import.js), the assembler
// does not need any explicit FileModules, and instead relies on the
// compartment to declare a ParserMap and optionally ModuleParserMap and
// ScopeMap.
// The compartment mapper provides a Compartment importHook and moduleMapHook
// that will search the filesystem for candidate module files and infer the
// type from the extension when necessary.
type FileModule = {
   location: FileLocation,
   parser: Parser,
};

// ExitName is the name of a built-in module, to be threaded in from the
// modules passed to the module executor.
type ExitName = string;

// ExitModule refers to a module that comes from outside the compartment map.
type ExitModule = {
  exit: ExitName
};

// InternalModuleSpecifier is the module specifier
// in the namespace of the native compartment.
type InternalModuleSpecifier = string;

// ExternalModuleSpecifier is the module specifier
// in the namespace of the foreign compartment.
type ExternalModuleSpecifier = string;

// ParserMap indicates which parser to use to construct module sources
// from sources, for each supported file extension.
// For parity with Node.js, a package with `"type": "module"` in its
// `package.json` would have a parser map of `{"js": "mjs", "cjs": "cjs",
// "mjs": "mjs"}`.
// If `"module"` is not defined in package.json, the legacy parser map // is
// `{"js": "cjs", "cjs": "cjs", "mjs": "mjs"}`.
// The compartment mapper adds `{"json": "json"}` for good measure in both
// cases, although Node.js (as of version 0.14.5) does not support importing
// JSON modules from ESM.
type ParserMap = Record<Extension, Parser>;

// Extension is a file extension such as "js" for "main.js" or "" for "README".
type Extension = string;

// Parser is a union of built-in parsers for module sources.
// "mjs" corresponds to ECMAScript modules.
// "cjs" corresponds to CommonJS modules.
// "json" corresponds to JSON.
type Parser = "mjs" | "cjs" | "json";

// ModuleParserMap is a table of internal module specifiers
// to the parser that should be used, regardless of that module's
// extension.
// Node.js allows the "module" property in package.json to denote
// a file that is an ECMAScript module, regardless of its extension.
// This is the mechanism that allows the compartment mapper to respect that
// behavior.
type ModuleParserMap = Record<InternalModuleSpecifier, Parser>;

// ScopeMap is a map from internal module specifier prefixes
// like "dependency" or "@organization/dependency" to another
// compartment.
// The compartment mapper uses this to build a moduleMapHook that can dynamically
// generate entries for a compartment's moduleMap into Node.js packages that do
// not explicitly state their "exports".
// For these modules, any specifier under that prefix corresponds
// to a link into some internal module of the foreign compartment.
>> When the compartment mapper creates an archive, it captures all of the Modules
>> explicitly and erases the scopes entry.
type ScopeMap = Record<InternalModuleSpecifier, Scope>;

// Scope describes the compartment to use for all ad-hoc
// entries in the compartment's module map.
type Scope = {
  compartment: CompartmentName
};


// TODO everything hereafter...

// Realm describes another realm to contain one or more
// compartments.
// The default realm is frozen by lockdown with no
// powerful references.
type Realm = {
  // TODO lockdown options
};

// RealmName is an arbitrary identifier for realms
// for reference from any Compartment description.
// No names are reserved; the default realm has no name.
type RealmName = string;

// ModuleParameter indicates that the module does not come from
// another compartment but must be passed expressly into the
// application by the user.
// For example, the Node.js `fs` built-in module provides
// powers that must be expressly granted to an application
// and may be attenuated or limited by the compartment mapper on behalf of the
// user.
// The string value is the name of the module to be provided
// in the application's given module map.
type ModuleParameter = string;
```

# Compartment map policy

The `policy` option accepted by the compartment-mapper API methods provides means to narrow down the endowments passed to each compartment independently.  
The rules defined by policy get preserved in the compartment map and enforced in the application. To explore how policies work, see [Policy Demo].

The shape of the `policy` object is based on `policy.json` from LavaMoat. MetaMask's [LavaMoat] generates a `policy.json` file that serves the same purposes, using a tool called TOFU: _trust on first use_.

> [!NOTE]
> TODO: Endo policy support is intended to reach parity with LavaMoat's
> policy.json.
> Policy generation may be ported to Endo.

  [LavaMoat]: https://github.com/LavaMoat/lavamoat
  [Compartments]: ../ses/README.md#compartment
  [Policy Demo]: ./demo/policy/README.md
  [import attributes]: https://nodejs.org/docs/latest/api/esm.html#import-attributes
  [package entry points]: https://nodejs.org/api/esm.html#esm_package_entry_points
  [`require.resolve()`]: https://nodejs.org/docs/latest/api/modules.html#requireresolverequest-options

Source: [packages/compartment-mapper/README.md](https://github.com/endojs/endo/blob/ee87476e0efcf8f6e412eec93eba5f3853ead6f3/packages/compartment-mapper/README.md) at commit `ee87476e`.
