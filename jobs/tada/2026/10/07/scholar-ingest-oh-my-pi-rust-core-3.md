# Completion report: scholar-ingest-oh-my-pi-rust-core-3

This cycle added 8 sources (11 sections) to the library for kriscendobot/garden#121. Everything is on `journal2`. The integrity gate passed, and both indexes were regenerated after landing.

**Sources ingested** (can1357/oh-my-pi `main`, each pinned to the last commit that touched the file):
- `crates/pi-natives/src/shell.rs` @ `04fcdf69` (2 sections):
  - JavaScript gets a long-lived `Shell` session and a one-shot `executeShell`. A virtual filesystem can be swapped in for a whole session or for a single run.
  - Output reaches JavaScript through a bounded queue (64 slots, batches of up to 64 KiB). A slow JavaScript reader slows the command instead of growing memory. Timeouts stop a stuck reader from hanging a run, and a run that finishes normally still delivers all its output.
- `crates/pi-natives/src/iso.rs` @ `a49c7bd5` (1): the JavaScript side of `pi-iso`'s probe/resolve/start/stop/diff. An `ISO_UNAVAILABLE:` prefix on errors tells callers a backend isn't installed, so they can try the next one.
- `crates/pi-natives/src/ast.rs` @ `e4517e15` (2):
  - `astGrep` searches files through the virtual filesystem; `astMatch` searches text already in memory.
  - `astEdit` previews by default (dry run), caps how much it changes, and writes only after the whole pass succeeds. It is not atomic across files: a write failure partway through leaves earlier files written.
- Vendored brush, 4 sources with 1 section each:
  - `crates/vendor/brush-parser/README.md` @ `7755c6d0` and `src/lib.rs` @ `240a4c27`.
  - `crates/vendor/brush-core/README.md` @ `68d75932` and `src/lib.rs` @ `ebf2a2aa`.
  - brush-parser is vendored to fix here-documents inside `$(...)`. Its README lists every local change and says when the copy can be removed.
  - brush-core's README is unchanged upstream text and does not mention oh-my-pi's local patches.
- The third-party explainer, saved as `web--oh-my-pi-design-rust-core` (2 sections: a summary of its claims, and a list of where it disagrees with the source). It is marked as a secondary description, not ground truth. Its content hash `ae1a74c3…` matches the parent job's fetch.
  - The disagreements the parent job found are kept: it leaves out `pi-vfs`, calls the output minimizer a permission gate, and gives the wrong brush path.
  - New disagreements: the reason given for vendoring brush is wrong, and the `pi-ast` and `pi-iso` APIs it quotes don't exist.
  - It also claims resource limits that `pi-shell` doesn't have. The closest real thing is brush-core's `ulimit` handling, which applies limits to child processes, not to the host.
  - Its claim that the native loader falls back to JavaScript is recorded as not yet checked.
- The parent job's distinction still holds: virtual files need not exist on the host; `grep`, `glob` and now `ast` accept the virtual filesystem; `fuzzyFind` still only takes host paths.

**Library index updates:**
- **Topics updated:** shell-runtimes, virtual-filesystems, llm-agent-frameworks, streams, agent-workspaces, file-systems, sandbox-platforms, programming-language-design, tooling.
- **New concepts:** `brush-shell`, `pi-ast-grep`, and `oh-my-pi-design-explainer`. The last one sends lookups for the explainer's made-up names, such as `MinimizerWarning` and `FsPrimitive`, to the list of disagreements.
- **Concept pages extended:** `pi-iso`, `pi-shell-output-minimizer`, `pi-vfs`, `pi-native-search`.
- **Indexes edited by hand:** `keywords.md`, `concepts/README.md`, `sources/README.md`.

**Content classifier:** `classify-foreign-content.sh` could not run (`TYPESAFE_API_KEY` is missing), so its answer was `proceed_unclassified`. I read the explainer as untrusted data and noted the gap on its source page.

**Checks:** `library-link-check.sh` passed for all 8 sources on the latest `origin/journal2`, and `regenerate-topics-counts.sh --check` reports the counts are current. `sections/README.md` and the topic counts were regenerated and landed. The result entry is `entries/2026/10/07/160447Z-result-gardener-1327b8.md`. A short digest went to the maintainer inbox.

**Follow-up posted:** `scholar-ingest-oh-my-pi-rust-core-4`, with the issue note copied verbatim. I put off the deeper `pi-iso`/`pi-ast`/`pi-shell` module docs because the explainer and all four brush files used up this cycle's budget. That job covers:
- the bridge between JavaScript and the virtual filesystem, `pi-natives/src/shell/vfs.rs`;
- `pi-iso`'s `rcopy.rs`, `overlayfs.rs`, and backend-selection rules;
- `pi-ast`'s `language/mod.rs` and `ops.rs`;
- `pi-shell`'s `process.rs` and `cancel.rs`, plus a survey of `shell.rs`.

Self-improvement: some vendored READMEs list their local patches (brush-parser) and some are plain upstream text (brush-core). A source page for a vendored crate should say which kind its README is, so nobody reads upstream claims as describing the patched copy.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/scholar-ingest-oh-my-pi-rust-core-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 128 tokens (8303434 cached reads)
- Output: 52235 tokens
- Cost: $4.203058800000001
- Wall-clock: 984s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
