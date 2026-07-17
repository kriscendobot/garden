---
title: Deno's package.json and deno.json division
source: runtime/fundamentals/configuration.md
source_repo: denoland/docs
source_commit: 7bf31909d9e417277e1ccf4de150221ecfc9e0b4
ingested: 2026-07-17
ingested_by: scholar
topics: [package-manifest]
status: current
---

> Abstract: Deno can run a Node project directly from `package.json`, while `deno.json` configures Deno itself. The files compose rather than one replacing the other.

Deno treats both manifests as optional first-class configuration. A Node project needs no conversion: `deno install` reads `package.json` dependencies and `deno task <script>` runs a package script. `package.json` does not configure Deno's formatter, linter, TypeScript options, or lockfile behavior. Those settings belong only in `deno.json` or `deno.jsonc`.

When both files exist, dependencies may come from each while Deno-specific configuration comes from `deno.json`. Deno discovers that file from the current directory or an ancestor, with `--config` selecting another file. Its `imports` map is therefore a separate resolution surface from `package.json` dependencies.

Source: [runtime/fundamentals/configuration.md](https://github.com/denoland/docs/blob/7bf31909d9e417277e1ccf4de150221ecfc9e0b4/runtime/fundamentals/configuration.md) at commit `7bf3190`.
