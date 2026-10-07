# scholar-ingest-oh-my-pi-rust-core-4: completion report

**This cycle closes the issue-121 oh-my-pi Rust-core ingest.** I added 12 sections from 9 new sources and appended one section to a source that was already in the library. I posted no follow-on job.

issue_spine: issue-kriscendobot-garden-121 (https://github.com/kriscendobot/garden/issues/121, submitter jcorbin)

## What was ingested
All sources are from can1357/oh-my-pi `main` at `53f253fb`, each recorded at the commit that last changed that file.

1. **`crates/pi-natives/src/shell/vfs.rs`** (`7dc2ef90`), 2 sections:
   - **Wire protocol:** the 34 operations, positional handles, errors passed back as errno names, and redirects to a host path (optionally read-only).
   - **Routing, lifetime and consumers:** the existing distinction holds. Virtual files never need to exist on the host. `nativeLocalPaths` sends only URL paths to the JavaScript handler. Shell, `grep`, `glob` and `ast` accept the injected filesystem; `fuzzyFind` stays host-path-only, because `fd.rs` has no filesystem option.
2. **`pi-iso`:**
   - `rcopy.rs` (`7f6974c3`), 1 section: a detached `git worktree` that replays the source tree's staged, unstaged and untracked changes, or a plain recursive copy.
   - `overlayfs.rs` (`5b5b65ec`), 1 section: a kernel overlay mount, falling back to `fuse-overlayfs` when the kernel refuses.
   - `lib.rs` (`e58c443c`): its recorded commit still matches, so the existing section was not rewritten. I appended one new section with the `resolve` priority rules and `clone_candidates`, and its source page now counts 2 sections.
3. **`pi-ast`:**
   - `language/mod.rs` (`11f3a262`), 1 section: 57 languages, all compiled-in tree-sitter grammars, and no WASM anywhere in `pi-ast`. The explainer's "50+ languages" is roughly right; "per-language WASM" is wrong.
   - `ops.rs` (`e4517e15`), 1 section: what it adds beyond the earlier `pi-natives` `ast` sections, mainly a retry for JSON patterns that parse as several nodes, the rules for duplicate and overlapping edits, and re-parsing after each rewrite rule.
4. **`pi-shell`:**
   - `process.rs` (`d93fb847`), 2 sections: process references that stay valid when a PID is reused, and the `terminate_tree` / `kill_tree` shutdown (polite signal, grace period, then hard kill), which never kills the host process or its children.
   - `cancel.rs` (`257c0acf`), 1 section.
   - `shell.rs` (`53f253fb`), 1 section covering only its documented contracts, including the stripping of Git variables like `GIT_DIR`. I left the ~7k undocumented lines unread on purpose rather than queuing them.
5. **Optional item, done:** `packages/natives/native/loader-state.js` (`d6262173`), 1 section. **It disproves the explainer's "native loader falls back to JS" claim:** if no native `.node` file loads, the loader throws an error; there is no JavaScript implementation behind it. I left the divergence ledger unedited, since it is append-only. The answer lives in the new section and on the explainer concept page.

The known divergences already in the ledger are unchanged.

## Index and page updates
- **New concept page:** `pi-shell`.
- **Rows added to existing concepts:** `pi-vfs`, `pi-native-search`, `pi-iso`, `pi-ast-grep`, `oh-my-pi-design-explainer`.
- **Topic rows added to:** virtual-filesystems, file-systems, agent-workspaces, tooling, sandbox-platforms, programming-language-design, shell-runtimes, agent-fleet-durability, llm-agent-frameworks.
- **Indexes:** `keywords.md` (+5 lines), `concepts/README.md`, and `sources/README.md` (9 new rows; the pi-iso entry now counts 2 sections).

## Checks and landing
- **Link check:** `library-link-check.sh --changed` passed.
- **Topic counts:** the `topics/README.md` counts were stale beforehand, which is expected, and no topic page was missing. Both `sections/README.md` and `topics/README.md` were regenerated and landed.
- **Landing:** all 41 content files landed through `land-journal-edit.sh` with no refusals.
- **Foreign-content check:** not needed, since everything came from the upstream repo through a scratch clone and nothing was fetched from the web.
- **Journal and maintainer:** the result entry is `entries/2026/10/07/162129Z-result-gardener-756c36.md`, and the maintainer digest was delivered. My inbox was empty at the end.

## Follow-ups
None. This closes the issue-121 Rust-core ingest.

Self-improvement: `land-journal-edit.sh` takes about 10 seconds per file, so landing 41 files one at a time overran the 120-second command limit and had to be waited on in a polling loop. A batch mode that lands a whole staged commit in one CAS push would make multi-file scholar cycles much faster. I'm reporting this as a lesson only, not changing it myself.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/scholar-ingest-oh-my-pi-rust-core-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 144 tokens (10096795 cached reads)
- Output: 54690 tokens
- Cost: $4.762007
- Wall-clock: 1022s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
