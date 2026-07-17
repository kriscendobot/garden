---
id: subpath-exports
aliases: [subpath exports, exports map, exports field, package entry points, exports encapsulation, subpath imports, imports field, subpath patterns, exports sugar, ERR_PACKAGE_PATH_NOT_EXPORTED]
topics: [package-manifest, module-loader]
---

# subpath-exports

The `package.json` `"exports"` field and its private counterpart `"imports"`, which together define a package's public entry-point map. `"exports"` replaces the single `"main"` with a map from public subpaths (`"."`, `"./feature"`, `"./features/*.js"`) to internal files, and takes precedence over `"main"` in supported Node versions. Its defining property is **encapsulation**: once `"exports"` is present, any subpath it does not list is forbidden (`require('pkg/private.js')` throws `ERR_PACKAGE_PATH_NOT_EXPORTED`), which is why introducing `"exports"` on an existing package is usually a breaking change. Targets must be relative URLs starting with `./` and may not traverse outside the package. `"imports"` entries start with `#`, apply only within the package, and (unlike `"exports"`) may map to external packages. Both support `*` string-replacement patterns (with `null` targets to exclude subtrees) and the conditional-object form (see [[conditional-exports]]). Exports remain statically enumerable because pattern targets expand as a glob over the package's own files.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [node--doc-api-packages--package-entry-points](../sections/node--doc-api-packages--package-entry-points.md) | The `"exports"` main entry, `"."` sugar, encapsulation guarantee, and target validation rules. |
| [node--doc-api-packages--subpath-exports-imports-and-patterns](../sections/node--doc-api-packages--subpath-exports-imports-and-patterns.md) | `"imports"` and the `*` subpath-pattern wildcard with `null` exclusion. |
| [node--doc-api-packages--overview](../sections/node--doc-api-packages--overview.md) | `"main"` vs `"exports"` and why encapsulation is a breaking change. |
| [node--doc-api-packages--field-definitions](../sections/node--doc-api-packages--field-definitions.md) | `"exports"` and `"imports"` as runtime-honored fields. |

## See also

- [[conditional-exports]] - the conditional-object form of an `"exports"` target.
- [[package-type-field]] - `"type"` decides the module format of the file a subpath resolves to.
