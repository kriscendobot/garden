---
source_kind: repo-doc
source_repo: denoland/docs
source_path: runtime/fundamentals/configuration.md
source_commit: 7bf31909d9e417277e1ccf4de150221ecfc9e0b4
ingested: 2026-07-17
ingested_by: scholar
section_count: 1
status: current
---

Abstract: Deno's configuration guide establishes that `package.json` and `deno.json` are independent, first-class, optional inputs. `package.json` supplies Node-compatible dependencies and scripts; `deno.json` supplies Deno tooling configuration. When both exist, Deno reads dependencies from both but takes its formatter, linter, TypeScript, lockfile, task, and import-map configuration from `deno.json`.

| Section | Topics | Status |
|---------|--------|--------|
| [package-json-and-deno-json](../sections/deno--runtime-fundamentals-configuration-md--package-json-and-deno-json.md) | package-manifest | current |

Source: [runtime/fundamentals/configuration.md](https://github.com/denoland/docs/blob/7bf31909d9e417277e1ccf4de150221ecfc9e0b4/runtime/fundamentals/configuration.md) at commit `7bf3190`.
