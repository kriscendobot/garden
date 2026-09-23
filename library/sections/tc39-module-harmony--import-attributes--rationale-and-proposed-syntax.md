---
title: Import Attributes — rationale for in-band metadata, and the `with { }` syntax in every context
source_kind: web
source_url: https://raw.githubusercontent.com/tc39/proposal-import-attributes/master/README.md
source_content_sha256: f9ee63b07ed212445afc977b380df504aacd38fa0e6eb3066d725f7cbf73b32f
source_authors: [Sven Sauleau, Daniel Ehrenberg, Myles Borins, Dan Clark, Nicolò Ribaudo]
source_date: 2023-03-01
ingested: 2026-07-29
ingested_by: scholar
topics: [module-harmony]
status: current
---

Abstract: The design argument for putting module metadata *in the JavaScript source text* rather than in the specifier or in an out-of-band manifest, and the concrete `with { key: "value" }` surface that argument produced in each context an import can appear: static `import`, re-exporting `export … from`, dynamic `import()` (as an options-bag entry, not a bare second argument), Worker instantiation, HTML `<script>`, and a WebAssembly `importattributes` custom section. Two details matter downstream for module harmony. First, the dynamic-import second argument is deliberately an **options bag** with `with` as one entry, which is precisely the slot the Module Source Imports proposal reuses for its `phase` property, so attributes and phases coexist as sibling keys rather than competing for the same position. Second, the curly-brace object-literal shape was chosen for developer familiarity and for unambiguous multi-line termination.

## Rationale: three places the data could live

There are three places this data could be provided:

- **As part of the module specifier** (as a pseudo-scheme). Challenges: adds complexity to URLs or other module-specifier syntaxes, and risks confusing developers. webpack supports this sort of construct with inline loader syntax; users have asked for similar behavior in Parcel, with pushback from some maintainers.
- **Separately, out of band** (a separate resource file). Challenges: how to load that resource file, what the format should be, and the unergonomic requirement to jump between files during development.
- **In the JavaScript source text.** Challenges: requires a change at the JavaScript language level (this proposal).

The proposal pursues the third option, expecting it to lead to the best developer experience and hoping the language-design and standardization issues can be resolved.

## The syntax, per context

Import attributes have to be available in several different contexts. They use a key-value syntax preceded by the `with` keyword, with `type` used as the example key indicating the module type.

**Import statements.** The `ImportDeclaration` allows arbitrary attributes after `with`:

```mjs
import json from "./foo.json" with { type: "json" };
```

Curly braces were chosen (discussion in issue #5) because JavaScript developers already know object-literal syntax and its trailing comma makes copy/pasting attributes easy, and because braces clearly indicate the end of the attribute list when it is split across multiple lines.

**Re-export statements.** The `ExportDeclaration`, when re-exporting from another module, allows the same arbitrary attributes after `with`:

```mjs
export { val } from './foo.js' with { type: "javascript" };
```

**Dynamic `import()`.** The `import()` pseudo-function takes the attributes in an **options bag** as the second argument:

```js
import("foo.json", { with: { type: "json" } })
```

The proposal is explicit that the second parameter is an options bag whose only currently defined option is `with`, and that other proposals expect to add entries to that bag: "for example, the [Module Source Imports](https://github.com/tc39/proposal-import-reflection) proposal introduces a `phase` property."

## Integration into host environments

Host environments often provide other ways of loading modules; the analogous string is passed through those.

**Worker instantiation:**

```js
new Worker("foo.wasm", { type: "module", with: { type: "webassembly" } });
```

**HTML.** Changes to HTML are not specified by TC39, but the sketched idea is that each `with` attribute becomes an HTML attribute usable on script tags:

```html
<script src="foo.wasm" type="module" withtype="webassembly"></script>
```

The proposal notes a standing uncertainty in both cases: whether importing WebAssembly modules needs to be marked specially at all, or whether they are imported just like JavaScript (discussion in issue #19).

**WebAssembly.** In the context of the [WebAssembly/ESM integration proposal](https://github.com/webassembly/esm-integration), for imports of other module types from within a WebAssembly module, this proposal would introduce a new custom section named `importattributes` that annotates each imported module listed in the import section with its attributes.

Source: [proposal-import-attributes/README.md](https://github.com/tc39/proposal-import-attributes/blob/master/README.md) at content sha256 `f9ee63b0`. Stage 4; retrieved 2026-07-29.
