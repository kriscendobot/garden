---
role: builder
tier: mentor
---
<!-- garden-promoted-from-plan: gate=blocked priority=normal at=2026-10-03T06:46:10Z cleared=none -->

---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Retool the garden-book generator in portable JavaScript

Repo: [kriscendobot/garden-book](https://github.com/kriscendobot/garden-book).
Read `journal/projects/garden-book/README.md` for the project's rules of
engagement, and `build/README.md` in the repo for how the current Python
generator (`build/build.py` + `build/publish.py`) works and what it produces,
before starting. This job runs after the illustrations-integration work has
landed, so port the generator's final, illustration-aware form — don't port
an older version and lose that work.

## Why JavaScript, and why "portable"

Maintainer directive (kriskowal, 2026-10-01): retool the generator in
JavaScript, "ideally portable JavaScript that can aspire to run in an Endo
environment with a virtual file system, like the daemon's environment, when
mounting the content on git becomes more feasible."

This is a forward-looking **structural** requirement, not a demand that it
actually run under Endo/SES today: write and run it as an ordinary Node.js
program for now (this job's own acceptance bar is normal Node execution),
but shape the code so that swapping its file-access layer for an Endo guest's
capability-based filesystem later is a small, contained change rather than a
rewrite. Concretely:

- **Separate the pure logic from file I/O.** The markdown-to-HTML rendering,
  heading-anchor assignment, cross-chapter link resolution, and HTML template
  assembly should be pure functions over strings/data structures (chapter
  text in, HTML string out) with no direct file-system calls inside them.
  Isolate every `readFile`/`writeFile`/directory-listing call behind a small,
  explicit interface (a handful of functions or a single object: "list
  chapter files," "read a file's text," "write the output"). That interface
  is what a future Endo-backed implementation would re-implement against a
  readable-tree capability instead of Node's `fs` — it should not leak
  Node-specific path/fs semantics into the logic that calls it.
- **Ground the target shape in Endo's own filesystem abstraction**, so the
  interface you design is actually compatible with where this is headed, not
  just abstractly "pluggable." Read `designs/npm-registry-as-directory-tree.md`
  and `designs/fs-interface-consolidation.md` /
  `designs/fs-interface-reconciliation.md` in `endojs/endo-but-for-bots`
  (`llm` branch) for Endo's consolidated readable-tree shape (`lookup`,
  `has`, `list`, `EndoReadableTree`/`SnapshotTree`) — this is the kind of
  capability surface a daemon-mounted git content tree would eventually
  present, and your abstraction boundary should look like it could be
  satisfied by that shape (a name-based `lookup`/`has`/`list` walk) even
  though today's concrete implementation just wraps Node's `fs`.
- **Avoid gratuitous Node-only surface** in the logic layer: no reliance on
  Node-specific globals or modules beyond the explicit I/O boundary above
  (plain ECMAScript, standard library where possible — e.g., prefer the
  platform `fetch`/`URL`/string methods over Node-only helpers when either
  would do). This repo has no SES/`lockdown()` requirement today — don't
  add one — the point is just not making future portability harder than it
  needs to be.
- Use the actual **`markdown-it`** npm package (the JavaScript library the
  current `markdown-it-py` was itself ported from) plus
  `markdown-it-anchor` (or equivalent) for heading anchors — this should
  make the port more direct than translating Python idioms by hand, since
  the current implementation already mirrors markdown-it's own API.

## Acceptance bar

- `node build/build.mjs <chapters-dir> <out-dir>` (or whatever entry-point
  name fits; keep the two-positional-argument CLI shape the Python version
  has) produces **byte-identical or functionally-equivalent** HTML to the
  current Python generator against the same chapter set — diff the two
  outputs and account for every difference (a difference is fine if it's a
  genuine improvement you call out, not fine if it's silent drift).
- `build/publish.py`'s role (driving the minion-town MCP bridge to publish
  `out/`) should get a JS equivalent too, for the same portability reason,
  calling `scripts/jobs/minion-mcp-bridge.py` the same way (or, if a pure-JS
  path to the same bridge is cleaner, use your judgment and explain the
  choice).
- Update `build/README.md`'s build/publish instructions for the new
  JS-based commands. Keep the Python version only if you have a specific
  reason not to delete it (note that reason); otherwise retire it cleanly
  once the JS version is proven equivalent, rather than leaving two
  generators to drift out of sync.

## Output

Open a draft PR against `main` on `kriscendobot/garden-book` (one PR per
job). Report the equivalence-check results and any deliberate output
differences in your completion report.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-03T07:06:32Z
