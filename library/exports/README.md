# Export-name index

One TSV per project roadmap branch, regenerated daily by the leader-only
`garden-export-index` timer (`scripts/jobs/export-index/publish-export-index.sh`)
and landed only when the rows change. Grep it before authoring a helper whose name
looks reusable:

```sh
grep -P '^makePromiseKit\t' library/exports/*.tsv
```

The first line is `# repo=<owner/repo> commit=<sha> generator=<version>`. The
`commit=` is the roadmap branch tip at the last change of rows, so the snapshot can
be up to a day stale. Checks never read these files: the `build-vs-buy` pre-push
probe and the `procurer` jury seat index the exact base commit they review, through
the per-commit cache under `$GARDEN_STATE/export-index/`.

| Column | Meaning |
| --- | --- |
| `name` | exported identifier |
| `specifier` | import specifier a consumer writes (`@endo/promise-kit`, or `@endo/foo/bar.js` for a subpath export) |
| `package` | package name |
| `def` | `path:line` of the defining declaration (barrels are followed to the definition) |
| `kind` | `function`, `class`, `const-function`, or `const` |
| `arity` | declared parameter count (functions only) |
| `shape` | hash of the body's AST node-type sequence, identifiers and literals normalized away |
| `tokens` | AST node count of the body |
| `private` | `1` if the package is `private: true` |

Trailing `#dep <package> <dependency>...` lines record each package's runtime
dependencies (the detector's cycle check). Which branches are published is the
journal file `config/export-index-roadmaps` (`<owner/repo>@<branch>` per line).
Rule and detector: `skills/build-vs-buy/SKILL.md` on `main2`.
