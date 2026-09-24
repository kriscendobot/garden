# An export-name index and a build-vs-buy check: one detector, three callers

| Created | 2026-09-24 |
| Author  | designer   |
| Status  | Proposed. The builder job `build-export-index-build-vs-buy` implements it. |

## Origin

@kriskowal's inline comment `4098097692` on `endojs/endo-but-for-bots` PR #1336
(review `5307103246`, `packages/agent-tools/test/mcp-adapter.test.js`) flagged a
copied promise-kit helper that `@endo/promise-kit` already exports in a more
rigorous form. The comment also suggested the garden improvement this design
covers. In paraphrase (the comment is untrusted external text):

- add a library section that indexes which module exports a function of a given name;
- add an automated check the jury can run. It extracts each changed file's
  export and declaration surface with Babel (or `@endo/module-source`) and flags
  functions whose names duplicate a function exported elsewhere;
- for each hit, a low-tier model subagent decides between build and buy: is
  the local function close enough to the export that the code should import it?

Commit `096c055fc18` already made the PR #1336 fix at the narrowest level:
`prefer-endo-primitives` now fails on a local `makePromiseKit`, on a
`let resolve`/`let reject` deferred, and on a bare `Far(`. That approach needs
one hand-written regex for every primitive a reviewer catches. This design
builds the general mechanism and turns the narrow catalog into data that the
general mechanism reads.

## Scope

In scope: the index generator, the library section it publishes, one detector
engine, and its three callers: a pre-push probe, a cost-gated jury seat, and
authoring-time lookup. It also covers the low-tier dispatch, its cost bound,
false-positive handling, and moving `prefer-endo-primitives` onto the engine.

Out of scope: third-party npm ecosystems other than the listed Endo provider
repos, and cross-package *type* duplication. The curator's canonical-option-type
lens already owns type duplication; a later extension of the index could serve
it (to be filed).

## Design

### 1. The index: `scripts/jobs/export-index/build-export-index.sh`

`build-export-index.sh <repo-root> <commit>` is a deterministic, no-LLM
generator. It reads the tree at `<commit>` with `git archive`, not a checkout,
so the caller's worktree is left alone. For every workspace package, meaning
every `package.json` reached from the root `workspaces` globs, including
`private` ones (their rows are marked, since a private package can still be a
workspace dependency), it:

1. resolves the package's public entry points from `package.json` `exports`
   (falling back to `main`), per condition, dropping `types`-only conditions;
2. parses each entry module with the **vendored `@babel/parser`** already in
   `skills/re-export-deprecation-policy/vendor/`. It follows `export ... from` and
   `export *` transitively inside the package, so each exported name is
   attributed to its **defining** declaration, not a barrel;
3. emits one row per exported value binding.

Row format: sorted TSV, header `# repo=<owner/repo> commit=<sha> generator=<version>`.

| Column | Meaning |
| --- | --- |
| `name` | exported identifier (`makePromiseKit`) |
| `specifier` | import specifier a consumer writes (`@endo/promise-kit`, or `@endo/foo/bar.js` for a subpath export) |
| `package` | package name (a subpath specifier can differ from it) |
| `def` | `path:line` of the defining declaration at `<commit>` |
| `kind` | `function`, `class`, `const-function` (arrow or function expression), or `const` |
| `arity` | declared parameter count (functions only) |
| `shape` | hash of the body's AST node-type sequence with identifiers and literals alpha-normalized |
| `tokens` | normalized token count of the body |
| `private` | `1` if the package is `private: true` |

Only `function`, `class`, and `const-function` rows take part in duplicate
detection. `const` rows stay in the index for lookup.

**Why Babel rather than `@endo/module-source`.** `ModuleSource` reports the
export *names* of a module, but not the declarations behind them, their bodies,
or the *non-exported* declarations in a changed file. The precipitating copy
was a non-exported helper in a test file. Using `ModuleSource` would also mean
installing Endo at run time, and the garden deliberately never does that
(`designs/reexport-deprecation-policy-gauntlet.md`, Decision 4). The Babel bundle
is already vendored and already trusted by `no-plain-reexport`. Considered and
rejected: `@endo/module-source`. Reason: it has no declaration surface and
needs a run-time install.

**Keying and caching.** The canonical artifact is content-addressed at
`$GARDEN_STATE/export-index/<owner>-<repo>/<commit>.tsv`, keyed on the full
commit sha. `ensure-export-index.sh <repo-root> <commit>` returns that path and
builds the file on a cache miss. The build writes to a temp file and renames it
into place, so a concurrent peer never reads a partial index. GC keeps the 20
most recent files per repo. The GC is mandatory: unpruned per-id journal
clones under `$GARDEN_STATE` have already used up a host's inodes twice. A check always
indexes the **base commit it reviews against**: the PR's `baseRefOid` in the
panel, and `--base-ref` at pre-push. It never uses a floating tip, because a
moving index would make verdicts irreproducible.

**Provider repos.** A project can import from Endo packages that live in
another repo. For example, minion.town consumes `@endo/*` from npm. The journal
file `config/export-index-providers` maps a project repo to the extra repos
whose index it consults: `<owner/repo> <provider-owner/repo>@<ref>`. A provider
index is built at the ref's resolved sha from that provider's bare clone. For
`endojs/endo-but-for-bots` the list is empty, since the repo is its own
provider. A provider row is a hit only when the consuming package's
`package.json` already lists the provider package as a dependency, or when the
project allows new dependencies. v1 treats the second case as comment-only.

### 2. The library section: `journal/library/exports/`

The authoring-time half is for people and agents to grep, not read, like
`keywords.md`. The leader-only timer `garden-export-index` runs daily and uses
no LLM. For each project with a roadmap branch in `journal/projects/*/README.md`
(today `endojs/endo-but-for-bots@llm`), it builds the index at the branch tip
and lands `library/exports/<owner>-<repo>.tsv` through the existing library
lander (`library/` is already allowlisted). It lands only when the rows change.
A `library/exports/README.md` states the columns and the header's `commit=`
semantics: the snapshot can be up to a day stale, and the checks do not read
it, because they use the per-commit cache. The builder brief gains one norm
(`roles/builder/AGENT.md`): before authoring a helper whose name looks
reusable, `grep -P '^<name>\t' library/exports/*.tsv`.

### 3. The detector engine: `skills/build-vs-buy/detect.cjs`

This follows the re-export pattern: one detector with several callers. Given a
diff (`base`, `head`, changed files) and the index path(s), the engine runs two
passes over each changed `.js/.mjs/.cjs/.jsx/.ts/.tsx` file. It skips `.d.ts`,
`node_modules/`, `references/`, `dist/`, and bundles.

- **Name pass (the general mechanism).** Parse the *head* version with Babel and
  collect every function-valued declaration whose declaring line is an added
  line: `function` declarations, `const x = () => ...` / `function` expressions,
  and `class` declarations, at any nesting depth. Look up each name in the
  index or indexes. A local declaration whose name equals an indexed function
  row is a **hit**.
- **Idiom pass (the absorbed narrow catalog).** Regex signatures over
  comment- and string-stripped added lines, read from the data table
  `skills/build-vs-buy/idioms.tsv`:
  `<id> <regex> <provider-specifier> <provider-export> <waiver>`. The
  `waiver` column is `import`, meaning the finding is waived when the file
  imports from the provider, or `none` (bare `Far`).

Each hit carries a **strength**, computed deterministically:

- `strong`: the name is *distinctive*, meaning it has at least two
  camelCase/snake segments, is not on the generic stoplist, and is exported by
  exactly one package in the index. The provider is also *reachable*, and one
  of these holds: `shape` is equal, the normalized-token Jaccard is at least
  0.6, or the idiom row names it.
- `weak`: any other name hit that is reachable.
- `blocked`: the provider is not reachable. Either importing it would create a
  workspace dependency cycle (the provider's transitive dependencies include
  the local package), or the provider is `private` and not already a dependency.

The generic stoplist is **derived**, not curated. It holds any name exported by
three or more packages in the index (such as `makeError`, `parse`, and
`format`), plus a short fixed floor (`main`, `run`, `init`, `setup`, `test`,
`get`, `set`, `make`).

Output: one JSON line per hit
`{file, line, name, strength, provider:{specifier,export,def}, local_src, provider_src, waiver}`,
where `local_src` and `provider_src` are each capped at 120 lines.

### 4. Caller A: the pre-push probe `build-vs-buy`

`scripts/jobs/gardening/pre-push-gates/probes/build-vs-buy.sh` runs the engine
against `--base-ref`. It **fails** on each unwaived `strong` hit, and on each
idiom hit whose waiver does not apply. It prints `file:line name -> import
{ export } from 'specifier' (def path:line)` or the waiver syntax. It is silent
on `weak` and `blocked` hits, which belong to the seat's judgment. Draft builds
run no gauntlet under the manual-gauntlet regime, so the pre-push gate is the
only check a draft PR gets. That is why the strong tier must be enforced there
(`096c055fc18` moved `Far` to pre-push for the same reason).

**Absorbing `prefer-endo-primitives`.** Every signature in the current awk
probe moves into `idioms.tsv`: Node/WebCrypto SHA-256, `TextEncoder`/`TextDecoder`,
`atob`/`btoa`/Buffer base64, the hex `padStart` loop, the `charCodeAt` ASCII
loop, `insist*` declarations, the `let resolve`/`let reject` deferred, and bare
`Far(`. The **`makePromiseKit` declaration signature is deleted outright**,
because the name pass already covers it: `@endo/promise-kit` exports
`makePromiseKit`, so a local declaration of that name is a strong hit. Any other
local copy of a distinctively named Endo export is caught the same way, with no
new regex. `prefer-endo-primitives.sh` becomes a thin shim that runs the engine
in idiom-only mode, so its probe name, its
`prefer-endo-primitives-exempt` marker, and its regression cases in
`review-convention-probes-test.sh` keep working unchanged. The rule for future
reviews: **a duplicated *named* export needs no catalog entry. Only a nameless
inline idiom earns an `idioms.tsv` row.** The `purist` panel-hints probe's
Endo-primitive regexes stay as they are, because they route ambiguous shapes to
a human-judgment seat, which is a different job.

### 5. Caller B: the jury seat `procurer` (cost-gated, haiku)

A new juror seat, `roles/jurors/procurer/AGENT.md`, handles build versus buy.
It is a new seat rather than an extension of `curator`, because the curator
reviews the PR's *own* public surface on a strong model, while this seat judges
*non-exported* local code against *other* packages on a low tier. Mixing the
two would either run the curator on haiku or run every hit on opus.

- **Routing:** `skills/panel-hints/probes/C-procurer.sh` fires on any added
  line in a changed JS/TS file. That is a broad trigger, but the seat
  cost-gates itself.
- **Gate:** `scripts/jobs/gardening/seat-gate-procurer.sh`, following the
  `seat-gate-reexport-auditor.sh` branches exactly. With no hits, the engine
  returns an APPROVE block and **no `claude -p`** is spent. If the engine or
  index is unavailable, the gate returns a COMMENT-ONLY block that names the
  reason; it never returns a silent approve. With hits, the gate runs the
  per-hit dispatch described next.
- **Per-hit low-tier dispatch.** Hits are ranked `strong` > `weak`, with waived
  hits after unwaived ones. `blocked` hits are listed deterministically and
  never dispatched. For the top **K = 8** hits, the gate runs one
  `claude -p --model <haiku>` each, resolved through `seat-model-tiers.tsv`
  (`procurer haiku`). At most 4 run concurrently. Each prompt contains only the
  seat brief's rubric plus `local_src` and `provider_src` (with the provider's
  JSDoc), fenced as **data**. The model must return strict JSON:
  `{"verdict":"buy|adapt|build","confidence":0-1,"reason":"<=2 sentences"}`.
  - `buy`: the export does what the local function does. Import it.
  - `adapt`: the export covers the need with a small call-site change.
  - `build`: the two differ in contract, semantics, or rigor in a way the
    caller depends on.
- **Deterministic disposition.** The model never writes a verdict level
  directly. The mapping is: `buy` on a strong hit is must-fix; `buy` on a weak
  hit is should-fix; `adapt` is should-fix with the reason; `build` is
  comment-only when the hit carried a waiver (reviewing the waiver's
  justification) and is dropped otherwise. Malformed JSON, a refusal, or
  `confidence < 0.5` falls back to a comment-only line that names the hit.
  Hits beyond K are listed as comment-only "not judged (cap)".
- **Verdict cache.** Verdicts are cached at
  `$GARDEN_STATE/build-vs-buy/<sha256(local_src_normalized)>-<provider shape>.json`,
  so a fix-loop re-round, or a sibling PR carrying the same copy, spends
  nothing. A cached `build` verdict is honored until either body changes.

**Cost bound.** Zero on the common PR, which has no hits. The worst case per
panel round is K = 8 haiku calls, each with roughly 3–5k input tokens and fewer
than 200 output tokens: about 40k haiku tokens per round, less than a single
opus seat's typical diff read. Re-rounds are close to free through the cache.
The seat's panel-level `claude -p` count stays at zero, because the gate owns
the block (the `coverage-auditor` shape). The per-hit calls are metered under
the seat's name through the existing panel seat metering
(`designs/panel-seat-metering-and-tiering.md`).

### 6. False-positive handling (summary)

| Source of noise | Handling |
| --- | --- |
| Generic names (`parse`, `format`) | Derived stoplist: exported by 3+ packages, or on the fixed floor. Demoted to weak, so they never fail pre-push. |
| The definition itself, or same-package internals | Skipped when the local file is in the same package as the provider row. |
| Importing would make a dependency cycle | `blocked`: listed, never failed, never dispatched. |
| Deliberate fork (such as a test double of an export) | Per-declaration waiver `// build-not-buy: <reason>` on the line above. It skips pre-push; the seat still reviews the reason as comment-only. Per-file `build-vs-buy-exempt` marker in the first five lines (the existing probe convention). |
| Same name, different contract | This is the low-tier judge's job (`build`), and the answer is cached. |
| Stale index | The index is keyed on the reviewed base commit; the library snapshot is never an input to a check. |

## Ownership map

| Boundary | Mechanism | Policy | Durable state | Commit authority | Value crossing |
| --- | --- | --- | --- | --- | --- |
| generator to cache | `build-export-index.sh` | none (pure function of repo, commit) | `$GARDEN_STATE/export-index/.../<sha>.tsv` | the atomic rename | the TSV rows |
| cache to library | `garden-export-index` timer | leader-only, land-on-change | `journal2 library/exports/` | the library lander's CAS push | a snapshot TSV at the roadmap tip |
| engine to callers | `detect.cjs` | strength rules plus `idioms.tsv` | none | none (a pure read) | hit JSON lines |
| pre-push probe | probe script | fails on strong or unwaived idiom hits | none | the gate exit code | pass/fail and messages |
| seat gate to model | `seat-gate-procurer.sh` | ranking, K cap, disposition map | the verdict cache | the gate (the model only returns JSON) | fenced source plus JSON verdict |

The engine *detects* and has no verdict authority. The low-tier model returns
data, and the gate script decides the panel verdict.

## Test plan

- `scripts/jobs/test/export-index-test.sh`: a fixture workspace with a barrel
  `export *`, a subpath export, a private package, and a cycle. It asserts
  deterministic, byte-identical output across two runs, attribution to the
  defining declaration, and the atomic cache fill.
- `scripts/jobs/test/build-vs-buy-probe-test.sh`: the PR #1336 shape (a local
  `makePromiseKit` in a test file) fails as a strong hit. The same file with
  `import { makePromiseKit } from '@endo/promise-kit'` passes. A local `parse`
  stays silent. A `// build-not-buy:` waiver passes. A cycle-blocked hit passes.
- `review-convention-probes-test.sh`: every existing `prefer-endo-primitives`
  case still passes through the shim. The `makePromiseKit` case now comes from
  the name pass, not an idiom row.
- `scripts/jobs/test/seat-gate-procurer-test.sh`, using the `GARDEN_PANEL_SEAT`
  stub: no hits means APPROVE and zero model calls; nine hits means eight
  dispatched and one capped; a malformed stub reply falls back to comment-only;
  a cache hit makes zero calls on the second run.
- Replay against PR #1336's head at its base, confirming the precipitating
  helper is caught at pre-push.

## Rollout

The builder lands the pieces in one PR-less `main2` change set: engine and
index, then the probe and shim, then the seat, its probe, and its
`seat-model-tiers.tsv` row. After that it updates `skills/pre-push-gates/SKILL.md`,
`skills/panel-hints/SKILL.md`, and the CLAUDE.md juror inventory, and adds a
new skill `skills/build-vs-buy/SKILL.md` that is the single home for the rule.
The `garden-export-index` timer is installed by `install-units.sh` and gated by
`is-main-host.sh`.
