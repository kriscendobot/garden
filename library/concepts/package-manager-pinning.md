---
id: package-manager-pinning
aliases: [packageManager, packageManager field, Corepack, corepack, devEngines.packageManager, pin package manager, package manager version pin, known good release]
topics: [package-manifest, node-packaging]
---

# package-manager-pinning

The `package.json` mechanism for declaring which package manager (and which version) a project expects, so contributors and CI all use the same one. The exact-version `packageManager` field (`name@x.y.z[+sha224.<hash>]`, where `name` is `yarn`/`npm`/`pnpm` or a `.js`/`.tgz` URL) is consumed by **Corepack** — the zero-runtime-dependency Node shim that intercepts `yarn`/`pnpm`/`npm` calls, downloads and caches the pinned version, and refuses to run the wrong manager against a pinned project. Corepack shipped with Node from 14.19.0 up to (not including) 25.0.0; `corepack enable` installs the Yarn/pnpm shims. A companion field, `devEngines.packageManager`, differs from `packageManager` in that it accepts a version *range* and an `onFail` policy (`ignore`/`error`/`warn`); Corepack uses it to validate the manager and as a fallback when the top-level `packageManager` field is absent. pnpm additionally resolves `devEngines.packageManager` into its lockfile (`packageManagerDependencies`). The field is read by this tooling layer, not by the Node runtime.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [corepack--readme--package-manager-field](../sections/corepack--readme--package-manager-field.md) | Corepack reads `packageManager` (name@version+hash) and `devEngines.packageManager` to pin and enforce the project's manager. |
| [yarn-berry--manifest-schema--publishing-and-install-config](../sections/yarn-berry--manifest-schema--publishing-and-install-config.md) | Yarn sets `packageManager` on `yarn set version`; it serves the same purpose as the lockfile, but for Yarn itself. |
| [pnpm--package-json--pnpm-field-moved-and-engines](../sections/pnpm--package-json--pnpm-field-moved-and-engines.md) | pnpm's `devEngines.packageManager` supports a version range and resolves into `pnpm-lock.yaml`, unlike the exact `packageManager` field. |

## See also

- [[dependency-overrides]] - the other root-only fields that shape an install, versus which manager runs it.
