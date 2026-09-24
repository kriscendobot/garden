# Skill: build-vs-buy

## Purpose

The single home for the rule **don't re-author what a package already exports**.
When a change adds a local function whose name and body match a function another
workspace (or provider) package exports, the local code should import the export.
The rule is enforced by one deterministic detector with three callers: a pre-push
probe, a cost-gated jury seat, and an authoring-time library lookup.

Origin: @kriskowal's inline comment on `endojs/endo-but-for-bots#1336` (review
`5307103246`), which flagged a copied promise-kit helper in a test file that
`@endo/promise-kit` already exports in a more rigorous form. Design:
[designs/export-index-build-vs-buy.md](../../designs/export-index-build-vs-buy.md).

## Inputs

- A diff: `<base>...HEAD`, the staged diff, the worktree diff, or stdin.
- The export-name index at the base commit, from
  `scripts/jobs/export-index/ensure-export-index.sh <repo-root> <commit>`, plus any
  provider-repo indexes listed in the journal's `config/export-index-providers`
  (`<owner/repo> <provider-owner/repo>@<ref>` per line).

## State

- `$GARDEN_STATE/export-index/<owner>-<repo>/<sha>.tsv`: the per-commit index
  cache, filled atomically, newest 20 per repo kept.
- `$GARDEN_STATE/build-vs-buy/<sha256(local body)>-<provider shape>.json`: the
  procurer seat's verdict cache; entries unused for 30 days are pruned.
- `journal2 library/exports/<owner>-<repo>.tsv`: the daily snapshot for grep
  (the leader-only `garden-export-index` timer). No check reads it.

## Procedure

### Authoring time (every role that writes code)

Before writing a helper whose name looks reusable, grep the library:

```sh
grep -P '^<name>\t' journal/library/exports/*.tsv
```

A hit names the import specifier and the defining `path:line`. Import it.

### The detector (`detect.cjs`)

Two passes over each changed `.js/.mjs/.cjs/.jsx/.ts/.tsx` file (skipping `.d.ts`,
`node_modules/`, `references/`, `dist/`, and bundles):

- **Name pass.** Parse the head version with the vendored Babel parser
  (`skills/re-export-deprecation-policy/vendor/`) and collect every function-valued
  declaration on an added line (`function`, `const x = () => …`, function
  expressions, `class`, at any depth, `harden(...)`-wrapped too). A name equal to
  an indexed `function`/`class`/`const-function` row is a **hit**.
- **Idiom pass.** Regex rows from [idioms.tsv](idioms.tsv) over added,
  non-comment lines. An idiom is waived when the file imports the row's provider
  (waiver `import`); a `none` row (bare `Far`) is waived only by the per-file marker.

Strength of a name hit:

- `strong`: a *distinctive* name (two or more camelCase/snake segments, not on the
  derived stoplist, exported by exactly one package), a reachable provider, and one
  of: equal `shape`, node-type trigram Jaccard ≥ 0.6, or an idiom row naming the
  export inside the local body.
- `weak`: any other reachable hit.
- `blocked`: importing would create a workspace dependency cycle, the provider is
  `private` and not already a dependency, or (v1) a provider-repo package that the
  local package does not already depend on.

The stoplist is derived: any name exported by three or more packages, plus the
floor `main run init setup test get set make`. Hits in the provider's own package
are skipped.

### The callers

| Caller | Fails / flags | Silent on |
| --- | --- | --- |
| `pre-push-gates/probes/build-vs-buy.sh` | each unwaived `strong` name hit | `weak`, `blocked` |
| `pre-push-gates/probes/prefer-endo-primitives.sh` (idiom-only shim) | each idiom hit whose waiver does not apply | name hits |
| `seat-gate-procurer.sh` (jury seat [procurer](../../roles/jurors/procurer/AGENT.md), haiku) | judges the top 8 `strong`/`weak` hits, one low-tier call each | nothing: `blocked` and capped hits are listed as comment-only |

The seat's disposition is deterministic: `buy` on a strong hit is must-fix, `buy`
on a weak hit and any `adapt` are should-fix, `build` is dropped (comment-only when
the hit carried a waiver), and a malformed reply or confidence below 0.5 is
comment-only.

## Waivers

- Per declaration: `// build-not-buy: <reason>` on the line directly above. It
  skips pre-push; the procurer still reviews the reason.
- Per file: `build-vs-buy-exempt` in the first five lines (skips both passes);
  `prefer-endo-primitives-exempt` in the first five lines (skips the idiom pass).

## Adding to the catalog

A duplicated **named** export needs no entry: the index already covers it. Only a
**nameless inline idiom** (a `toString(16).padStart(2, …)` loop, a `let resolve`
deferred) earns an `idioms.tsv` row: `<id> <regex> <provider-specifier>
<provider-export or -> <import|none> <description>`, with a regression case in
`scripts/jobs/test/review-convention-probes-test.sh`.

## Output shape

`detect.cjs` prints one JSON object per hit; see the header of
[detect.cjs](detect.cjs). The pre-push probe prints
`fail: <file>:<line> <name> -> import { <export> } from '<specifier>' (def <path>:<line>); or waive with // build-not-buy: <reason>`.

## Notes

- Tests: `scripts/jobs/test/export-index-test.sh`,
  `scripts/jobs/test/build-vs-buy-probe-test.sh` (including a replay of the PR
  #1336 copy against its real base index), `scripts/jobs/test/seat-gate-procurer-test.sh`,
  and `scripts/jobs/test/review-convention-probes-test.sh`.
- Babel, not `@endo/module-source`: the name pass needs non-exported declarations
  and their bodies, and the garden never installs Endo at run time.
