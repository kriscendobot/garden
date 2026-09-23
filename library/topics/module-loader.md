# Topic: module-loader

> Abstract: **System** (`gutentags/system`), the CommonJS/npm-compatible module + resource loader beneath Kris Kowal's **Guten Tag** framework. System runs both client- and server-side (Node.js), supports refresh-to-reload browser debugging and a Browserify-comparable `sysjs` build step for production bundles, and resolves both module *and resource* locations by module identifier across package boundaries. Its distinguishing feature is a per-package extension mechanism — `analyze(module)` populates run-time dependencies and `translate(module)` rewrites `module.text` from its source language to JavaScript — configured by `package.json` annotations and scoped to the packages that declare them; this is exactly how the `gutentag/extension` HTML-to-JavaScript translator plugs in. Descends from Tom Robinson's C.js → Montage Require (Mr) → System. Seeded 2026-07-06 from the System README. Distinct from `node-packaging` (npm package *layout* conventions) and `bundles` (Endo's Compartment-based module loading); System is the specific loader that gives Guten Tag its on-the-fly HTML translation.

## Sections

| Section | Source | One-line abstract |
|---------|--------|-------------------|
| [system--readme--overview](../sections/system--readme--overview.md) | system README | System: a CommonJS/npm module + resource loader for client and server, with refresh-to-reload debugging, a bundle build step, and configurable per-package translators and analyzers. |
| [system--readme--usage-and-bootstrapping](../sections/system--readme--usage-and-bootstrapping.md) | system README | The three ways to run an app: Node `loadSystem`/`import`, browser `boot.js` script tag (with `data-package`), and a `sysjs`-built production bundle. |
| [system--readme--extensions-translators-analyzers](../sections/system--readme--extensions-translators-analyzers.md) | system README | The extension model: `analyze`/`translate` plugins configured in `package.json`, package-scoped, with dependency `introduce`; how HTML modules become JavaScript on the fly or at build. |
| [system--readme--history](../sections/system--readme--history.md) | system README | Lineage: Tom Robinson's C.js → Motorola Mobility's Montage Require (Mr) → Kris Kowal's promise-based npm loader → Stuart Knightley → System's more-focused iteration. |
| [tc39-module-harmony--import-attributes--semantics-interoperability-and-the-cache-key](../sections/tc39-module-harmony--import-attributes--semantics-interoperability-and-the-cache-key.md) | tc39 import-attributes | The module cache key extends from (referrer, specifier) to (referrer, specifier, attributes), and unimplemented attributes should be rejected rather than ignored. |
| [tc39-module-harmony--asset-references--asset-declaration-syntax-and-semantics](../sections/tc39-module-harmony--asset-references--asset-declaration-syntax-and-semantics.md) | tc39 asset-references | A reference that resolves like an import specifier but triggers no load, and that a host loader may use to test the cache, clear an entry, or hot-reload. |
| [papers--shi-spatiotemporal-composability-2026--cordis-implementation-and-koishi](../sections/papers--shi-spatiotemporal-composability-2026--cordis-implementation-and-koishi.md) | Shi et al. 2026 | Cordis's declarative component loader: reconciles a running fiber tree against an edited configuration and performs hot module replacement by unloading the old component's tracked effects and loading the new. |

## See also

- [`html-modules`](html-modules.md): Guten Tag, whose HTML/XML component modules System translates to JavaScript via the `gutentag/extension` plugin.
- [`virtual-dom`](virtual-dom.md): Koerper and Wizdom, the DOM substrate the translated modules govern.
- [`node-packaging`](node-packaging.md): npm package layout conventions; System resolves and enforces those package boundaries.
- [`bundles`](bundles.md): Endo's Compartment/compartment-mapper module loading and bundling — a different lineage solving a related problem.
