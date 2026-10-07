---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Ingest oh-my-pi's Rust core (pi-iso, pi-ast, pi-shell, pi-natives, pi-vfs) and its vendored brush shell into the library

Role: scholar. Ingest per roles/scholar/AGENT.md and journal/library/conventions.md.
Requested by jcorbin on garden issue #121 ("OMP's Been Cooking A Rusty Shell").

----- ISSUE NOTE (copy this block VERBATIM into every follow-on job) -----
issue_spine: issue-kriscendobot-garden-121
issue_url: https://github.com/kriscendobot/garden/issues/121
submitter: jcorbin
----- END ISSUE NOTE -----

## Sources (in priority order)

1. **Primary: the actual oh-my-pi source**, https://github.com/can1357/oh-my-pi (default branch `main`;
   `crates/pi-shell` last touched at 53f253fb709fe890adf1fa37f0bc69cf02a5d86c when this job was posted).
   Ingest the crate-level module docs (`lib.rs` headers) of `crates/pi-iso`, `crates/pi-shell`
   (incl. `src/minimizer/`), `crates/pi-ast`, `crates/pi-vfs`, `crates/pi-builtins`, and the
   `crates/pi-natives` NAPI surface (`grep.rs`, `glob.rs`, `fd.rs`, `shell.rs`, `iso.rs`, `ast.rs`).
   Anchor each source on its per-file commit sha (repo-doc source kind; a scratch clone outside the
   garden root, `--filter=blob:none`, is fine).
2. **Secondary: the third-party explainer** the issue linked,
   https://yeluo45.github.io/oh-my-pi-design/en/docs/01-rust-core (web page; fetched 2026-10-07,
   sha256 ae1a74c3c049f0f27fbc465e74b65cd311e2fbc67c0b980321dcdca4e2649098). Treat it as a
   *description*, not ground truth: run fetch-source.sh + classify-foreign-content.sh as usual,
   and record a content caveat that it diverges from the source (below).
3. **brush** (https://github.com/reubeno/brush, MIT, bash/POSIX shell in Rust): the README and the
   brush-core / brush-parser crate docs. oh-my-pi vendors it under `crates/vendor/brush-core` and
   `crates/vendor/brush-parser`.

## Known divergences between the explainer and the source (verified 2026-10-07; record them)

- The explainer describes `pi-shell`'s minimizer as a safety gate (a `MinimizerWarning` enum
  flagging `rm -rf /`, `curl | sh`, `sudo`, unpinned `npm install`). The real
  `crates/pi-shell/src/minimizer.rs` is an **opt-in OUTPUT minimizer** that compresses a command's
  stdout/stderr before it reaches the agent (per-program filters, e.g. git, gradle), stashing the
  original as an `artifact://` reference. No `PrivilegeEscalation` symbol exists in the repo.
  The escalation guard the issue mentions lives in a JS **example hook**,
  `packages/coding-agent/examples/hooks/permission-gate.ts` (regex on rm -rf / sudo / chmod 777;
  blocks when non-interactive). Check the minimizer `filters/`/`plan.rs` for any install-command
  handling before concluding either way.
- The explainer puts brush at `crates/brush-core-vendored/`; it is actually `crates/vendor/`.
- Real `pi-iso` backends: macOS clonefile (APFS), Linux kernel overlay with a `fuse-overlayfs`
  fallback (plus btrfs/zfs/reflink modules), Windows ProjFS, and an `Rcopy` fallback that uses
  `git worktree` when the lower tree is a git repo. Diff delegates to `git diff` for git trees.
- `pi-vfs` (not mentioned by the explainer) is an injectable async filesystem shared by the
  embedded shell and its coreutils, with URL-scheme providers, so virtual files never
  materialize on the host. That is the "virtualized bash" story.
- `pi-natives` has a ripgrep-backed `grep.rs` (grep-searcher/pcre2), plus glob/fd, all over N-API.

## Cross-references to make (with honest boundaries)

- endo-but-for-bots `designs/endopi.md` (journal/plan/designs/endo-but-for-bots/endopi.md and
  its library sections): Pi vs Endo lal/fae/genie. oh-my-pi is a Pi fork, so link it in.
- `packages/sandbox` (podman/bwrap drivers) in endo-but-for-bots: compare to pi-iso.
- `designs/cli-edit-verb` / hashline (already in the library): oh-my-pi's hashline sits on pi-ast.
- The garden's own fleet isolation: per-job git worktrees (WORKTREES.md), the bot `gh` wrapper,
  `GIT_CEILING_DIRECTORIES`. Name where the analogy breaks.

Budget: 3 to 5 sources or ~25 sections per cycle; post a `scholar-ingest-oh-my-pi-*` follow-on
for any remainder (copy the ISSUE NOTE into it). When done, comment a short digest on
https://github.com/kriscendobot/garden/issues/121 (do NOT close the issue).

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-07T15:37:39Z
