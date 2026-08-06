Design job complete. The diff is clean: the new design file plus the two README registration lines.

## Completion report

**Job:** designer follow-up to PR #124 review — design WAL checkpointing at shutdown across all supported daemon platforms.

**What I did:**
- Traced the maintainer's comment (`https://github.com/endojs/endo-but-for-bots/pull/124#discussion_r3548826725`, "WAL checkpointing on shutdown?", "Please post a job to design checkpointing at shutdown across all supported platforms") to its ground truth in the code, on the `llm` branch where the design lands.
- Grounded the design in the actual implementations: Node `manager-database.js` (`makeDaemonDatabase`, `journal_mode = WAL`, `close()` wired via `cancelled.catch(() => daemonDb.close())`); the Rust+XS shim `better-sqlite3-xs.js` (`XsDatabase.pragma` → `exec('PRAGMA …')`); and `rust/endo/xsnap/src/powers/sqlite.rs` (rusqlite `bundled`, `host_sqlite_open/close`, statements re-prepared per call so no zombie-close risk). Noted the `llm` names differ from PR #124's branch (`daemon-database.js`/`rust-xs-sqlite.js`) and cited symbols, not line numbers, to survive the rename.

**What changed (draft PR #934 against `llm`):**
- New `designs/daemon-sqlite-shutdown-checkpoint.md`. Core proposal: replace the incidental last-connection PASSIVE auto-checkpoint with an explicit `wal_checkpoint(TRUNCATE)` folded into the shared `close()`, uniform on both platforms, so a graceful shutdown leaves a self-contained `endo.sqlite`. This makes the file-level backup path and the cross-supervisor handoff (the companion kriskowal directive on the same PR) single-file-safe by construction, with **no new Rust host function**. Documents the crash path (SIGKILL) as recovery-on-open plus a cross-platform WAL-compat test, since a killed process cannot checkpoint. Extends `sqlite-parity.test.js` with four cases. Three open questions surfaced (suspend/resume checkpoint call, concrete `journal_size_limit`, defense-in-depth checkpoint in `host_sqlite_close`).
- `designs/README.md`: summary-table row + M11 (Rust Daemon `endor`) milestone-table row.

**Verified (real-execution evidence):**
- Mermaid sequence diagram parse-validated: `mm-1.mmd OK sequence` via `mermaid.parse()`. (First attempt PARSE-FAILed on `&lt;`/`&gt;` HTML entities in participant labels; fixed to plain ASCII labels and re-validated OK.)
- House-style checks: no em-dashes, no Latin shorthand, no difficult code points remaining (grep clean).
- PR state: `#934`, `isDraft: true`, `baseRefName: llm`; diff is the design file (343 lines) + 2 README lines only.

**Follow-ups / notes:**
- The PR body cites the PR #124 comment URL, which auto-creates a backlink on that thread; I did not post a separate comment on #124 (not in job scope, avoids cross-noise). If the maintainer wants an explicit "design posted as #934" reply on the #124 thread, that is a one-line follow-up.
- Design is draft; un-drafting is the maintainer's call after review.

**Self-improvement:** Mermaid `sequenceDiagram` participant `as` labels reject `<`/`>` and their HTML entities (`&lt;`/`&gt;`) — the parser errors, not just the renderer. Keep participant/note labels plain ASCII (no generics like `Promise<never>`, no arrow glyphs). Worth a one-line note in `skills/mermaid-validation/SKILL.md` § Notes for future designers.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-124-sqlite-shutdown-checkpoint.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 78 tokens (4554087 cached reads)
- Output: 34060 tokens
- Cost: $4.4368885
- Wall-clock: 590s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
