---
role: scholar
---
# Scholar: how alt runtimes read package.json (Deno, Bun runtime, Endo compartment-mapper)

Follow-on to scholar-package-json-schema-and-tooling. Ingest as library sources (pinned commits): Deno's package.json / npm-specifier / exports handling and deno.json interplay; Bun's runtime resolution; and a deeper Endo @endo/compartment-mapper ingest of the Package Descriptors + Language Extensions sections (packages/compartment-mapper/README.md at endojs/endo) capturing exactly which properties Endo reads (name/type/main/exports/browser/dependencies/files), the import/browser/endo conditions, main-as-default fallback, the parsers property, and the TS .ts->.cts/.mts language hook. Add sections under topic `package-manifest`; back the project's Deno/Endo/Bun matrix rows and the divergence inconsistency; note remaining synthesis.
