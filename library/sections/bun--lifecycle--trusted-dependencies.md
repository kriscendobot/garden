---
title: trustedDependencies and Bun's default-secure lifecycle policy
source: docs/pm/lifecycle.mdx
source_repo: oven-sh/bun
source_commit: 16a7269639d9093da7685fcf3edcea53431df0a7
source_date: 2026-06-30
source_authors: [Alistair Smith, Jarred Sumner, Lydia Hallie, robobun]
ingested: 2026-07-17
ingested_by: scholar
topics: [package-manifest, node-packaging]
status: current
---

Abstract: Packages can define lifecycle scripts (`preinstall`, `postinstall`, `preuninstall`, `prepublishOnly`, and others) — arbitrary shell commands the package manager runs at install time, commonly used to build native add-ons (for example `node-sass`). Because running arbitrary code is a security risk, Bun is **"default-secure"**: unlike other npm clients it does **not** execute lifecycle scripts by default, running them only for packages on an allow list. A curated built-in list covers popular npm packages; `trustedDependencies` in `package.json` names additional ones. Two subtle rules: (1) defining `trustedDependencies` **replaces** the built-in list rather than extending it (three modes: omitted → built-in list; explicit array → only those; `[]` → none); and (2) the built-in list applies **only to npm-source packages** — `file:`/`link:`/`git:`/`github:` dependencies must always be listed explicitly, so a malicious local package cannot spoof a trusted name. `--ignore-scripts` (or `install.ignoreScripts` in bunfig / `.npmrc`) disables scripts entirely.

## trustedDependencies

Bun only runs lifecycle scripts for packages on an allow list. To allow scripts for a package, add its name to the `trustedDependencies` array:

```json
{
  "name": "my-app",
  "version": "1.0.0",
  "trustedDependencies": ["node-sass"]
}
```

After adding it, (re)install; Bun reads the field and runs that package's lifecycle scripts. A curated list of popular npm packages with lifecycle scripts is allowed by default (Bun's built-in `default-trusted-dependencies.txt`).

**Only npm sources get the built-in list.** The default trusted list applies only to packages installed from npm. Packages from other sources (`file:`, `link:`, `git:`, `github:`) must be explicitly added to `trustedDependencies` to run their lifecycle scripts, **even if the package name matches a default-list entry** — this prevents malicious packages from spoofing trusted names through local paths or git repositories.

## trustedDependencies replaces, not extends

Defining `trustedDependencies` **replaces** the default list. Exactly one of three modes applies per project:

| `package.json` | Packages allowed to run lifecycle scripts |
| --- | --- |
| `trustedDependencies` omitted | The packages in Bun's built-in list (npm sources only). |
| `trustedDependencies: ["pkg-a", ...]` | **Only** the listed packages. The default list is ignored. |
| `trustedDependencies: []` | **No** packages, including none from the default list. |

Set `[]` to opt out of the default allow list entirely without passing `--ignore-scripts` on every install. If you supply an explicit list, remember to include any default-list packages whose scripts you still need (for example `sharp` or `esbuild`) — they are no longer trusted implicitly.

## --ignore-scripts

`bun install --ignore-scripts` disables lifecycle scripts for all packages. Make it the project default with `install.ignoreScripts = true` in `bunfig.toml`, or `ignore-scripts=true` in `.npmrc`.

Source: [docs/pm/lifecycle.mdx](https://github.com/oven-sh/bun/blob/16a7269639d9093da7685fcf3edcea53431df0a7/docs/pm/lifecycle.mdx) at commit `16a7269`.
