The work is complete. Draft PR #668 is open and handed off for the panel stage.

---

## Completion report

**Job:** Build the `endopi-edit-tool` M3 design in `endojs/endo-but-for-bots` — add an `edit` tool to the Lal and Fae agents with `oldText`/`newText` replacement semantics and optional multi-edit batching, modeled on Pi's `coding-agent/src/core/tools/edit.ts`.

**Draft PR:** [endojs/endo-but-for-bots#668](https://github.com/endojs/endo-but-for-bots/pull/668) — draft, base `llm-08f5acc` (frozen snapshot of the `llm` tip), head `endopi-edit-tool`. Base is `llm` because all three touched packages (`agentry`, `fae`, `lal`) exist only on the roadmap branch, not `master`.

**Affected packages:** `@endo/agentry`, `@endo/fae`, `@endo/lal`.

**What I built:**
- **`@endo/agentry/edit-text`** (new pure, dependency-free module + new subpath export): `applyEdits`, `computeUnifiedDiff`, `normalizeEdits`. Enforces unique-match per `oldText` (zero/multi-match → structured error), rejects overlapping batched edits (including duplicate `oldText`), matches against LF-normalized text while restoring the file's original CRLF ending and leading BOM, and returns a unified diff. This is the shared core the design called for ("reuse the byte-level helpers… algorithm is small and well-defined").
- **Fae** — replaced the weaker first-occurrence `editFile` (`oldString`/`newString`) with the `edit` tool (`makeEditTool`; caplet renamed `edit-file.js` → `edit.js`, result name `edit`), accepting a single pair or an `edits` array and returning a confirmation + diff. Updated `setup-fs-tools.js`, `README.md`, `FAE-ARCHITECTURE.md`.
- **Lal** — added the `editText` tool def (`tools/fs.js`) and dispatch case (`tool-dispatch.js`), operating on a tree capability through the landed `readText`/`writeText` shape (rather than a bare `File`, which hasn't landed), returning `{ applied, diff }`.
- **Docs** — moved the design to **In Progress** with an implementation note; updated `designs/README.md`.

**Verification:**
- New tests all pass: agentry `edit-text.test.js` (18) + `exports.test.js`, fae `edit-tool.test.js` (6), lal `edit-text-tool.test.js` (4). Full fae (49 pass, 2 pre-existing known-failures) and lal (38 pass) suites green.
- `tsc` clean on agentry (the lal `tsc` env errors — undici-types/genai/gaxios — are pre-existing, from the failed optional `better-sqlite3` build, not my files); eslint 0 errors across all changed files; Prettier clean.
- Two commits: `feat(agentry): …` and a separate `chore: Update yarn.lock`.

**Follow-ups / notes:**
- The design's Chat-UI render-side diff preview and a dedicated `File`-capability surface (`Dir.lookup(name) → File`) remain open, noted in the design.
- Compatibility: prompts/agents that named Fae's `editFile` must move to `edit`; re-run `yarn setup-fs-tools` to provision the renamed caplet. This is Lal-additive.
- Handing off to the panel stage (the gardener's gauntlet drives review; the PR stays draft until the panel un-drafts it).
