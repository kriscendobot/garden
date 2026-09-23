Done. PR verified as draft against `llm`; inbox empty. Here is my completion report.

---

**Job complete: design for `endo store` to drive `writeFile` on ordinary `EndoDirectory`.**

**What I did**
- Traced the originating directive (PR #658 comment 4977137707): PR #658 landed `endo write <mount>` via the mount exo, and the maintainer wants the byte-write to be a first-class `EndoDirectory` method so mounts stop being special as name hubs.
- Mapped the actual daemon/CLI code (via an Explore sweep plus direct reads). Key ground truth: `EndoDirectory.writeText` **already exists** as the exact template (single-segment creates a `readable-blob` + `storeIdentifier`; multi-segment delegates to the tail name hub), and its wiring spans a checkable mirror set (`interfaces.js` guards, `directory.js`, `host.js`/`guest.js` agent delegation, the `disallowedMutation` read-only mirrors in `daemon.js`, help-text, types). `storeBlob` on the agent is the same single-segment blob path.
- Wrote `designs/store-write-file.md` (project conventions: metadata table, problem, background, design, behavior/error cases, compatibility/migration, dependencies, verification plan, open questions, captured prompt). Core proposal: add `writeFile(petNameOrPath, readable)` as the byte-stream sibling of `writeText`, and rewire `endo store`'s `--path`/`--stdin` modes to drive it — so the same command transparently writes into a mount when the name path is rooted at one, with no mount-specific verb.
- Surfaced unresolved choices as explicit open questions (method name `writeFile` vs `writeBytes`, `storeBlob` deprecation, auto-creating intermediate directory segments, agent-surface exposure, ordering against the `cli-store-verb-text-modes` reshape, accepting raw byte arrays).
- Added the `designs/README.md` summary-table row.

**Verification**
- Mermaid fence validated parse-only per the mermaid-validation skill: `mm-1.mmd OK flowchart-v2` (real execution).
- PR state confirmed via `gh pr view 739`: `isDraft:true`, `baseRefName:llm`, `headRefName:design/store-write-file`, `state:OPEN`.

**What changed**
- New file `designs/store-write-file.md` and a README row, on branch `design/store-write-file` pushed to `origin` (endojs/endo-but-for-bots).
- Draft PR **#739** opened against `llm`: https://github.com/endojs/endo-but-for-bots/pull/739 — body cites the originating #658 comment.

**Follow-ups**
- Implementation is a separate builder job (base inferred from touched packages: `packages/daemon`, `packages/platform`, `packages/cli` all exist on `master`, so a `master`-base build is likely — the builder confirms per the project README's base-inference rule). Not posted; awaiting maintainer review/un-draft of the design first.
- The design flags an ordering dependency with the Proposed `cli-store-verb-text-modes` reshape; the maintainer should confirm whether to land the daemon `writeFile` method first or wait on the CLI-flag reshape.

Self-improvement: nothing this time. The designer brief says "commit on a `design/<slug>` branch in the bot fork," but for endo-but-for-bots the working convention (matching PR #658 and the project README) is pushing the branch directly to `origin`; that is already documented in `journal/projects/endo-but-for-bots/README.md`, so no role edit is warranted.
