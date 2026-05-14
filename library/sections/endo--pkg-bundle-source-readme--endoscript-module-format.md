---
title: endoScript moduleFormat
source: packages/bundle-source/README.md
source_repo: endojs/endo
source_commit: 1af1999ec5a7b77f39a1044073ed545ff526c90b
source_date: 2025-08-02
source_authors: [Richard Gibson]
ingested: 2026-05-14
ingested_by: scholar
topics: [bundles]
status: current
---

> Abstract: Detailed coverage of the endoScript moduleFormat: the canonical format for Endo bundles. Describes the serialization shape, the entry-point convention, and how compartment-mapper consumes endoScript archives.

## endoScript moduleFormat

The `ses` shim uses the "endoScript" format to generate its distribution bundles,
suitable for injecting in a web page with a `<script>` tag.
For this format, extract the `source` from the generated JSON envelope and place
it in a file you embed in a web page, an Agoric
[Core Eval](https://docs.agoric.com/guides/coreeval/) script, or evaluate
anywhere that accepts scripts.

```js
const { source } = await bundleSource('program.js', { format: 'endoScript' });
const compartment = new Compartment();
compartment.evaluate(source);
```

Unlike "getExport" and "nestedEvaluate", the `dev` option to `bundleSource` is
required for any bundle that imports `devDependencies`.
The "endoScript" format does not support importing host modules with CommonJS
`require`.

<a id="endozipbase64-moduleformat"></a>
### endoZipBase64

An Endo (zip, base64) bundle is an object with properties:

- `moduleFormat` is "endoZipBase64".
- `endoZipBase64` is a zip file encoded in Base64.
- `endoZipBase64Sha512`, if present, is the SHA-512 of the
  `compartment-map.json` file inside the `endoZipBase64` archive.
  If the `compartment-map.json` includes the SHA-512 of every module, this is
  sufficient as a hash of the bundled application for checking its integrity
  and is consistent regardless of whether the program is extracted from the
  archive.

To inspect the contents of a bundle in a JSON file:

```sh
jq -r .endoZipBase64 | base64 -d | xxd | less
```

To extract the contents:

```sh
jq -r .endoZipBase64 | base64 -d > bundle.zip
unzip bundle.zip -d bundle
```

Inside the zip file, the `compartment-map.json` expresses the entire linkage of
the bundled program starting at its entry module, with explicitly marked "exit"
modules (host modules that must be endowed).

The compartment map then names all of its compartments, and within each
compartment, specifies each module that will be evaluated in that compartment.
These indicate the path within the archive of the physical text of the module.
The `parser` indicates how `importBundle` or the equivalent Compartment Mapper
utilities will interpret the physical text of the module.

To avoid entraining large dependencies and a slow precompilation step, modules
in a bundle are currently precompiled, so instead of finding source text, you
will find a JSON record describing the bindings and behavior of the module,
including code that is similar to the source but not identical.

The bundle may have any of these `parser` properties:

- "pre-mjs-json": precompiled ESM
- "pre-cjs-json": precompiled CommonJS
- "json": raw JSON (exports the corresponding value as `default`)
- "text": UTF-8 encoded text (exports the corresponding string as `default`)
- "bytes": a sequence of octets (exports the corresponding Uint8Array as `default`)

The JSON of a `pre-mjs-json` module will have all the properties of an object
generated with `StaticModuleRecord` from `@endo/static-module-record`, but
particularly:

- `__syncModuleProgram__`: the code, which has been transformed from the ESM
  source to a program that a compartment can evaluate and bind to other ESM
  modules, and also had certain censorship-evasion transforms applied.

So, to extract the source-similar program for visual inspection:

```
jq -r .__syncModuleProgram__ module.js > module.source.js
```

Source: [packages/bundle-source/README.md](https://github.com/endojs/endo/blob/1af1999ec5a7b77f39a1044073ed545ff526c90b/packages/bundle-source/README.md) at commit `1af1999e`.
