---
id: lifecycle-script-trust
aliases: [trustedDependencies, lifecycle scripts, postinstall trust, default-secure install, ignore-scripts, install script security, dependenciesMeta.built, enableScripts]
topics: [package-manifest, node-packaging]
---

# lifecycle-script-trust

Whether a package manager runs a dependency's install-time lifecycle scripts (`preinstall`/`postinstall`/…) — arbitrary shell commands that are both legitimately useful (building native add-ons) and a supply-chain attack surface. The managers diverge sharply. **npm** runs them by default. **Bun** is "default-secure": it runs lifecycle scripts only for packages on an allow list — a curated built-in list of popular npm packages plus whatever the project names in the `trustedDependencies` array of `package.json`; defining `trustedDependencies` **replaces** the built-in list rather than extending it, and only npm-source packages are ever covered (never `file:`/`link:`/`git:`/`github:` sources, to prevent name-spoofing). **Yarn Berry** expresses the same idea per-dependency through `dependenciesMeta.<pkg>.built` (a deny-list, flipping to an allow-list when the `enableScripts` yarnrc setting is off). Blanket opt-outs exist too: Bun's `--ignore-scripts` / `install.ignoreScripts`, and npm's `--ignore-scripts`. The same manifest therefore builds a different set of native artifacts under different managers, and a package that relies on a postinstall step may silently not build under a default-secure manager.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [bun--lifecycle--trusted-dependencies](../sections/bun--lifecycle--trusted-dependencies.md) | Bun's `trustedDependencies` allow-list and default-secure policy; the field replaces, not extends, the built-in list. |
| [yarn-berry--manifest-schema--dependency-metadata](../sections/yarn-berry--manifest-schema--dependency-metadata.md) | Yarn's `dependenciesMeta.<pkg>.built` deny/allow-lists a package's postinstall build script (interacts with `enableScripts`). |

## See also

- [[package-manager-pinning]] - which manager runs the install, and therefore which trust policy applies.
- [[dependency-overrides]] - the other root-only install-shaping controls.
