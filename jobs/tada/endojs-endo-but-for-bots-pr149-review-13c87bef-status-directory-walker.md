Investigation complete. All evidence corroborated across the three reports and freshly verified against current `origin/llm`.

---

# Feature-disposition analysis — `walkDirectory` (generic Endo directory walker)

**Job:** read-only disposition of the hardened async-generator directory walker from [endojs/endo-but-for-bots#149](https://github.com/endojs/endo-but-for-bots/pull/149). Read-only: no project files, branches, pushes, or GitHub posts were made.

## Freshly observed SHAs (this run)
- **Current `origin/llm`:** `a54c3adbebf18fd837770d467433e480de498e8d` (unchanged since discovery)
- **PR #149 head** (`pull/149/head`, branch `jcorbin-exp-genie-bottle`, DRAFT/OPEN): `e0c8accb3235a340ce2b4e4307138429a7d1e5f3` (unchanged since discovery)
- No merge base between the histories; PR base is the obsolete `llm` snapshot `33311ae9a`.

## Feature scope
`walkDirectory(powers, dirName, maxDepth = Infinity)` in [`packages/genie/src/directory-walk.js`](https://github.com/endojs/endo-but-for-bots/blob/e0c8accb3235a340ce2b4e4307138429a7d1e5f3/packages/genie/src/directory-walk.js) — an async-generator depth-first traversal over *any* Endo directory. Behavior I read directly at the PR head:
- `E(powers).list(path)` to enumerate; yields `{ name, depth, path }` per entry.
- Recursion decision by **method-name probing**: `E(entry).__getMethodNames__()` and recurse only if the interface `includes('list')` — i.e. the child is itself a directory.
- Honors `maxDepth` (guard `depth + 1 < maxDepth`), defaulting to `Infinity`.
- **Graceful lookup-error handling**: the per-entry `lookup`/probe is wrapped in `try/catch {}` that skips inaccessible or non-directory entries.
- `harden(walkDirectory)`; sole dependency is `@endo/eventual-send`. Module docstring explicitly states "Not agent-specific — works on any endo directory."
- Introduced by commit [`1abfe4b7f`](https://github.com/endojs/endo-but-for-bots/commit/1abfe4b7f). Test suite [`test/directory-walk.test.js`](https://github.com/endojs/endo-but-for-bots/blob/e0c8accb3235a340ce2b4e4307138429a7d1e5f3/packages/genie/test/directory-walk.test.js) — I confirmed **5 AVA tests**: flat directory, nested recursion, `maxDepth` respect, empty directory, and lookup-error tolerance.

**Orphaned/export status (verified):** not exported from [`packages/genie/src/index.js`](https://github.com/endojs/endo-but-for-bots/blob/e0c8accb3235a340ce2b4e4307138429a7d1e5f3/packages/genie/src/index.js) (no `walk`/`directory` reference). `git grep walkDirectory` at the PR head returns only the module, its test, and one prose reference in [`TADA/genie/21_genie_main_scoped_agent.md`](https://github.com/endojs/endo-but-for-bots/blob/e0c8accb3235a340ce2b4e4307138429a7d1e5f3/TADA/genie/21_genie_main_scoped_agent.md) — **no runtime consumer** in `src/`, `main.js`, or `setup.js`. Complete and tested, but dead code on the branch. This matches the deployment-prompts discovery report's F16 ("Orphaned but complete") and the sandbox-subagents report's explicit note that directory-walk is unrelated to sandboxing.

## Comparison with current `origin/llm`
- No `directory-walk.js` (or any renamed equivalent) exists on `origin/llm`: `git ls-tree -r origin/llm` under `packages/genie/src/` shows **no** tree/directory/walk module.
- `git grep -i walkDirectory origin/llm` → **zero matches** across the whole repo.
- The only `origin/llm` file matching "walk" is [`packages/capn-web/src/walk-path.js`](https://github.com/endojs/endo-but-for-bots/blob/a54c3adbebf18fd837770d467433e480de498e8d/packages/capn-web/src/walk-path.js) — an **unrelated** primitive: it walks a *property path on a single value* (resolving promises, dispatching pipelined `["pipeline", id, [...], [...]]` ops via `HandledPromise`). It is not a directory-tree traversal and shares no behavior with `walkDirectory`. Not an equivalent.

The feature is therefore **wholly absent from `origin/llm`**.

## Disposition — (3) NOT HONORED; recommend integration into **`agentry`**

`origin/llm` carries nothing equivalent, so this is not "already honored." The feature is a genuinely generic, dependency-light (`@endo/eventual-send` only), hardened, well-tested capability-traversal primitive with no genie coupling — the strongest reusable-code candidate in the walker's cluster.

**Destination: `agentry`.** Among the three named targets (lal / fae / agentry), `agentry` is the correct home: it owns the reusable authority/provisioning primitives, and directory enumeration over Endo pet-store/agent directories is exactly the kind of capability-graph traversal `agentry` consumers need (e.g. the open sub-agent-directory arc — [`TODO/54`](https://github.com/endojs/endo-but-for-bots/blob/e0c8accb3235a340ce2b4e4307138429a7d1e5f3/TODO/54_endo_genie_agent_directory.md) `agentDirectory` tracking and [`TODO/56`](https://github.com/endojs/endo-but-for-bots/blob/e0c8accb3235a340ce2b4e4307138429a7d1e5f3/TODO/56_endo_genie_list_child_agents.md) `listChildAgents` are its natural first consumers). It does **not** belong in `lal` (no bearing on provider/model/transcript/agent-round duties) or `fae` (fae is named-agent guest lifecycle, not generic tree traversal).

Adoption notes for whoever lifts it:
- Lift it as a standalone module (it needs only `@endo/eventual-send` and `harden`); port the 5 AVA tests alongside — they transfer verbatim since the walker takes an injected `powers` cap.
- The `__getMethodNames__().includes('list')` directory-probe is a reasonable duck-type but is a structural (not nominal) check; a consumer wanting stricter typing could tighten it, but as-is it is correct and defensive.
- An even-more-general home is **`@endo/*` upstream** (the deployment-prompts F16 report suggested endo-upstream/agentry) since the primitive is not agentry-specific either; but of the destinations this job enumerates, `agentry` is the actionable one.

## History worth leaving behind / migrating
- No TODO/TADA kernel is *dedicated* to the walker; it surfaces only as a supporting mention in [`TADA/genie/21_genie_main_scoped_agent.md`](https://github.com/endojs/endo-but-for-bots/blob/e0c8accb3235a340ce2b4e4307138429a7d1e5f3/TADA/genie/21_genie_main_scoped_agent.md) and as a candidate consumer of the open sub-agent-directory arc ([`TODO/54`](https://github.com/endojs/endo-but-for-bots/blob/e0c8accb3235a340ce2b4e4307138429a7d1e5f3/TODO/54_endo_genie_agent_directory.md), [`TODO/56`](https://github.com/endojs/endo-but-for-bots/blob/e0c8accb3235a340ce2b4e4307138429a7d1e5f3/TODO/56_endo_genie_list_child_agents.md)). Nothing here needs migration into the garden journal beyond this disposition record itself; the durable artifact is the code + tests, which route to `agentry`, not a prompt kernel.

## Follow-ups
- If a coordinator accepts the `agentry` disposition, the integration is a clean lift (module + 5 tests); no dependency on the PR's blocked sandbox cluster (F0 build-breaker in `packages/sandbox/src/factory.js`) and no dependency on genie glue.
- The feature will remain dead code on PR #149 unless the sub-agent-directory arc (TODO/53–61) lands a consumer; that arc is unimplemented on the branch.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr149-review-13c87bef-status-directory-walker.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 17 tokens (457738 cached reads)
- Output: 7326 tokens
- Cost: $0.934906
- Wall-clock: 126s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
