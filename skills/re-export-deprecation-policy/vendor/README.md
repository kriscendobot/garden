# Vendored `@babel/parser`

`babel-parser.cjs` is the self-contained CommonJS bundle of
[`@babel/parser`](https://www.npmjs.com/package/@babel/parser) **version 7.29.7**,
copied verbatim from that package's `lib/index.js`. It has no `require()` of any
other module, so `node -e "require('./babel-parser.cjs')"` works with nothing
installed — which is exactly what the garden needs, because the garden does not
`npm install` or fetch a dependency at run time (design Decision 4). `LICENSE` is
Babel's MIT license, shipped alongside as its terms require.

`../reexport-parse.cjs` is the only caller: it `require`s this bundle to parse a
module's source and emit its qualified value re-exports for the
[`no-plain-reexport`](../../../scripts/jobs/gardening/pre-push-gates/probes/no-plain-reexport.sh)
probe and the [`reexport-auditor`](../../../roles/jurors/reexport-auditor/AGENT.md)
jury seat.

## Refreshing the bundle

There is no build step and no lockfile to bump. To move to a newer parser, copy the
new `lib/index.js` over `babel-parser.cjs` and its `LICENSE` over `LICENSE`, then
re-run the probe's test (`scripts/jobs/test/no-plain-reexport-probe-test.sh`) to
confirm the AST shape the helper reads (`ExportNamedDeclaration.source`,
`ExportAllDeclaration.exported`, per-specifier `exportKind`, `leadingComments`) is
unchanged:

```sh
P=/path/to/node_modules/@babel/parser
cp "$P/lib/index.js" babel-parser.cjs
cp "$P/LICENSE" LICENSE
# then: bash scripts/jobs/test/no-plain-reexport-probe-test.sh
```

Pin a version whose `lib/index.js` is a single self-contained file with no external
`require()` (true of the 7.x line); grep the copy for `require(` before committing.
