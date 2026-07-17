---
title: Files, entry points, executables (files, exports, main, type, browser, bin, man, directories, repository)
source: docs/lib/content/configuring-npm/package-json.md
source_repo: npm/cli
source_commit: ce7681fe7dbcc20abb5f1379558e14ddd069654f
source_date: 2026-06-18
source_authors: [Max Black, Josh Soref, Michael Smith]
ingested: 2026-07-17
ingested_by: scholar
topics: [package-manifest, node-packaging]
status: current
---

Abstract: npm's reference for the fields that decide what ships in the published tarball and how the package is entered. `files` is an allowlist of `.gitignore`-style patterns (defaults to `["*"]`); certain files are always included (`package.json`, `README`, `LICENSE`/`LICENCE`, the `main` file, the `bin` file(s)) and certain files are always ignored (`.git`, `node_modules`, all lockfiles including `package-lock.json`/`pnpm-lock.yaml`/`yarn.lock`/`bun.lockb`, and a fixed list), some of which can never be re-included. `main` is npm's default entry (`index.js` when unset); `exports` and `type` are documented here but delegated to the Node.js docs (npm notes `type` is "not used by npm"). `bin` maps command names to files linked onto PATH on install (string shorthand = the package name; the target must start with `#!/usr/bin/env node`). `man` is retained for metadata but no longer installs man pages (npm v12+). `directories` (`.bin`, `.man`) and `repository` (object with `type`/`url`/optional `directory`, or a `github:`/`gitlab:`/etc. shorthand npm normalizes on publish) round it out.

## files (and always-included / always-ignored)

`files` is an array of file patterns describing what is included when the package is installed as a dependency; the syntax is like `.gitignore` but reversed (a matching pattern includes). Omitting it defaults to `["*"]` (all files). A `.npmignore` (or, absent it, `.gitignore`) can exclude files; at the package root `.npmignore` does not override `files`, but in subdirectories it does. Always included regardless of settings: `package.json`, `README`, `LICENSE`/`LICENCE`, the `main` file, and the `bin` file(s) (`README` and `LICENSE` in any case/extension). Always ignored by default: `*.orig`, `.*.swp`, `.DS_Store`, `._*`, `.git`, `.hg`, `.lock-wscript`, `.npmrc`, `.svn`, `.wafpickle-N`, `CVS`, `config.gypi`, `node_modules`, `npm-debug.log`, `package-lock.json`, `pnpm-lock.yaml`, `yarn.lock`, `bun.lockb`. Most ignored files can be force-included via `files` globs, except `.git`, `.npmrc`, `node_modules`, and the four lockfiles, which cannot be included.

## exports, main, type, browser

`exports` is the modern alternative to `main` for multiple entry points, conditional resolution, and encapsulation (npm defers detail to the Node.js docs on package entry points). `main` is the primary entry module ID relative to the package root; if unset it defaults to `index.js`. `type` defines how Node interprets `.js` files and "is not used by npm" (see the Node.js docs). `browser` should be used instead of `main` when the module is meant for client-side use and may rely on browser primitives such as `window`.

## bin

`bin` maps a command name to a local file. On a global install the file is linked into the global bins directory (or a `.cmd` shim on Windows); as a dependency it is linked so it is available to `npm exec` or by name in `npm run` scripts. A single-executable package can supply `bin` as a string, which is equivalent to a map from the package name to that path. The referenced file(s) must start with `#!/usr/bin/env node` or they run without the node executable. Executables can also be set via `directories.bin`.

## man, directories, repository

`man` (npm v12+ note: man pages are no longer registered with the system `man` program; retained for metadata; use `npm help <pkgname>`) is a single filename or an array; a single file maps to `man <pkgname>` regardless of filename, and filenames not starting with the package name are prefixed. Man files must end with a section number (optionally `.gz`). `directories` is a CommonJS-spec object indicating package structure; `directories.bin` adds all files in a bin folder (mutually exclusive with a `bin` path), and `directories.man` sugar-generates the `man` array by walking a folder. `repository` specifies where the code lives, as an object `{ "type": "git", "url": "..." }` (optionally `"directory"` for a monorepo subpath) or a shorthand (`"npm/example"`, `"github:npm/example"`, `"gist:..."`, `"bitbucket:..."`, `"gitlab:..."`); npm normalizes shorthand to the full object form on publish (with a warning), and `npm pkg fix` converts it.

Source: [docs/lib/content/configuring-npm/package-json.md](https://github.com/npm/cli/blob/ce7681fe7dbcc20abb5f1379558e14ddd069654f/docs/lib/content/configuring-npm/package-json.md) at commit `ce7681f`.
