## Completion report: issue-kriscendobot-garden-121

**The ask:** jcorbin's issue #121 asked the garden to ingest the oh-my-pi "Rust core" explainer at https://yeluo45.github.io/oh-my-pi-design/en/docs/01-rust-core. Their highlights were pi-iso, pi-ast, pi-shell, pi-natives, the shell's command sanitization, and the vendored brush shell.

**What I did:**
- **Fetched the explainer** with `fetch-source.sh` (direct, sha256 `ae1a74c3…`). The foreign-content classifier was unavailable (`TYPESAFE_API_KEY` absent), so I read the page as untrusted data.
- **Checked its claims against the real source** at `can1357/oh-my-pi` on `main`. The one big correction: pi-shell's "minimizer" is not a safety gate. It is an opt-in filter that shrinks command output before the agent sees it.
  - The escalation guard I found is only an example JS hook, `examples/hooks/permission-gate.ts`, a regex check for `rm -rf`, `sudo` and `chmod 777`. I found no native guard against install commands.
  - Smaller corrections: brush is vendored at `crates/vendor/`, not the path the explainer gives. pi-iso's real backends are clonefile, overlayfs with a fuse-overlayfs fallback, ProjFS, and a `git worktree`-based fallback.
  - The "virtualized bash" story mostly lives in `pi-vfs`, which the explainer never mentions.
- **Posted a scholar job,** `scholar-ingest-oh-my-pi-rust-core`, with the ISSUE NOTE copied verbatim. Its sources, in priority order:
  1. the real repo's crate docs, anchored on per-file commit shas
  2. the explainer, recorded with a caveat about where it diverges
  3. brush itself

  It lists the verified divergences and the cross-references to make: the endo-but-for-bots `endopi` Pi comparison, `packages/sandbox`, hashline/`cli-edit-verb`, and the garden's own per-job worktree isolation. It also tells the scholar to post a digest on #121 and not close the issue.
- **Commented on the issue** with the verification findings and a note that the ingest is queued: https://github.com/kriscendobot/garden/issues/121#issuecomment-6041272435

**What changed:** I made no commits to `main2` or the library. The only outputs are the new board job and the issue comment, and I deleted my scratch files.

**Follow-ups:**
- The scholar job does the actual library ingest and comments the digest on #121.
- The scholar should still check the minimizer's `filters/` and `plan.rs` for any install-command handling before saying for certain that there is none.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/issue-kriscendobot-garden-121.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 42 tokens (1322483 cached reads)
- Output: 8487 tokens
- Cost: $0.9881565999999999
- Wall-clock: 109s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
