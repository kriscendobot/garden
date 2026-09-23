---
id: package-type-field
aliases: [type field, "type": "module", type module, type commonjs, module system determination, nearest parent package.json, .mjs, .cjs, syntax detection]
topics: [package-manifest, module-loader]
---

# package-type-field

The `package.json` `"type"` field, which tells Node.js whether to interpret `.js` files (and extensionless input) whose nearest parent `package.json` this is as CommonJS or as ES modules. `"module"` makes `.js` ESM; absent or `"commonjs"` makes `.js` CommonJS; if the volume root is reached with no `package.json`, `.js` is CommonJS. The field applies not only to the entry file but to every `.js` reached by `import`/`import()`. Two extensions override `"type"` unconditionally: `.mjs` is always ESM and `.cjs` is always CommonJS, which is how a package mixes formats. For genuinely ambiguous input (a `.js`/extensionless file with no controlling `"type"`, or `--eval`/STDIN with no `--input-type`), Node's **syntax detection** parses the source and treats it as ESM if it contains ESM-only syntax. The `"type"` field is consumed by nearly every downstream tool (bundlers, TypeScript's `nodenext`/`node16` resolution, Endo's compartment-mapper), so it is one of the highest-leverage single fields in the manifest.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [node--doc-api-packages--determining-module-system](../sections/node--doc-api-packages--determining-module-system.md) | How `"type"`, extension, `--input-type`, and syntax detection decide CommonJS vs ESM. |
| [node--doc-api-packages--field-definitions](../sections/node--doc-api-packages--field-definitions.md) | `"type"` as one of the five fields the Node runtime honors. |
| [npm--configuring-npm-package-json--files-entry-points-and-bin](../sections/npm--configuring-npm-package-json--files-entry-points-and-bin.md) | npm's note that `"type"` "is not used by npm" and defers to the Node docs. |

## See also

- [[conditional-exports]] - `"type"` decides the format of the target a condition selects.
- [[dual-package-hazard]] - `"type"` and `.cjs`/`.mjs` decide which build a file belongs to.
