---
title: npm specifiers and package.json Node projects
source: runtime/fundamentals/node.md
source_repo: denoland/docs
source_commit: 7bf31909d9e417277e1ccf4de150221ecfc9e0b4
ingested: 2026-07-17
ingested_by: scholar
topics: [package-manifest]
status: current
---

> Abstract: Deno can address an npm package explicitly with `npm:` or use a Node-style `package.json` plus local `node_modules`; in the latter mode it reads dependencies, scripts, `type`, and selected `engines` constraints.

The explicit npm specifier grammar is `npm:<package-name>[@<version-requirement>][/<sub-path>]`. Deno downloads it into its global cache; a dependency can instead be named in `package.json` or mapped from a bare specifier in `deno.json` `imports`.

For an existing Node project, `deno install` reads `package.json`, creates `node_modules`, and makes bare dependency imports resolve as in Node. `deno task` runs package scripts and finds `node_modules/.bin` tools. Deno also honors `type` for module classification and warns when `node` or `deno` engine requirements are unsatisfied, but ignores other engine keys. A project with `package.json` defaults to manual node_modules management.

Source: [runtime/fundamentals/node.md](https://github.com/denoland/docs/blob/7bf31909d9e417277e1ccf4de150221ecfc9e0b4/runtime/fundamentals/node.md) at commit `7bf3190`.
