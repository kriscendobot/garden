---
title: moduleFormat explanations
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

> Abstract: The moduleFormat option's variants and what each one means: nested, getExport, endoScript, etc. Each format is a different way of representing the bundled module graph in the resulting string.

## `moduleFormat` explanations

<a id="getexport-moduleformat"></a>
### getExport

The most primitive `moduleFormat` is "getExport".
It generates a script where the completion value (last expression evaluated)
is a function that accepts an optional `sourceUrlPrefix`.

```js
cosnt { source } = await bundleSource('program.js', { format: 'getExport' });
const exports = eval(source)();
```

A bundle in "getExport" format can import host modules through a
lexically-scoped CommonJS `require` function.
One can be endowed using a Hardened JavaScript `Compartment`.

```js
const compartment = new Compartment({
  globals: { require },
  __options__: true, // until SES and XS implementations converge
});
const exports = compartment.evaluate(source)();
```

> [!WARNING]
> The "getExport" format was previously implemented using
> [Rollup](https://rollupjs.org/) and is implemented with
> `@endo/compartment-mapper/functor.js` starting with version 4 of
> `@endo/bundle-source`.
> See [nestedEvaluate](#nestedevaluate) below for compatibility caveats.

<a id="nestedevaluate-moduleformat"></a>
### nestedEvaluate

This is logically similar to the "getExport" format, except that the code
may additionally depend upon a `nestedEvaluate(src)` function to be used
to evaluate submodules in the same context as the parent function.

The advantage of this format is that it helps preserve the filenames within
the bundle in the event of any stack traces.

The completion value of a "nestedEvaluate" bundle is a function that accepts
the `sourceUrlPrefix` for every module in the bundle, which will appear in stack
traces and assist debuggers to find a matching source file.

```js
cosnt { source } = await bundleSource('program.js', { format: 'nestedEvaluate' });
const compartment = new Compartment({
  globals: {
    require,
    nestedEvaluate: source => compartment.evaluate(source),
  },
  __options__: true, // until SES and XS implementations converge
});
const exports = compartment.evaluate(source)('bundled-sources/.../');
```

In the absence of a `nextedEvaluate` function in lexical scope, the bundle will
use the `eval` function in lexical scope.

> [!WARNING]
> The "nestedEvaluate" format was previously implemented using
> [Rollup](https://rollupjs.org/) and is implemented with
> `@endo/compartment-mapper/functor.js` starting with version 4 of
> `@endo/bundle-source`.
> Their behaviors are not identical.
>
> 1. Version 3 used different heuristics than Node.js 18 for inferring whether
>    a module was in CommonJS format or ESM format. Version 4 does not guess,
>    but relies on the `"type": "module"` directive in `package.json` to indicate
>    that a `.js` extension implies ESM format, or respects the explicit `.cjs`
>    and `.mjs` extensions.
> 2. Version 3 supports [live
>    bindings](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/import#imported_values_can_only_be_modified_by_the_exporter)
>    and Version 4 does not.
> 3. Version 3 can import any package that is discoverable by walking parent directories
>    until the dependency or devDependeny is found in a `node_modules` directory.
>    Version 4 requires that the dependent package explicitly note the dependency
>    in `package.json`.
> 4. Version 3 and 4 generate different text.
>    Any treatment of that text that is sensitive to the exact shape of the
>    text is fragile and may break even between minor and patch versions.
> 5. Version 4 makes flags already supported by format "endoZipBase64"
>    universal to all formats, including `dev`, `elideComments`,
>    `noTransforms`, and `conditions`.


Source: [packages/bundle-source/README.md](https://github.com/endojs/endo/blob/1af1999ec5a7b77f39a1044073ed545ff526c90b/packages/bundle-source/README.md) at commit `1af1999e`.
