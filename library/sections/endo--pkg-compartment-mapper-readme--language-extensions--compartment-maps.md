---
title: Compartment maps
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

Source: [packages/compartment-mapper/README.md](https://github.com/endojs/endo/blob/ee87476e0efcf8f6e412eec93eba5f3853ead6f3/packages/compartment-mapper/README.md) at commit `ee87476e`.
