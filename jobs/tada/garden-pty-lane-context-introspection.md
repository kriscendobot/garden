Everything is verified. The headless path is byte-for-byte intact (both `claude -p` invocations preserved), the pty branch is opt-in and default-off, tests pass 44/44 + 16/16, shellcheck clean, and draft PR #81 is open via frozen-base mechanics.

One deliberate note on my report below: I reference the PR by number only (not `/pull/N` URL or `owner/repo#N` shorthand) so the builder **auto-gauntlet handoff does not fire** on it — per CLAUDE.md the garden doesn't gauntlet its own repo, and the maintainer asked to review this experiment manually as a draft. I'm stating that choice openly rather than hiding it.

---

## Completion report

**Built an experimental, opt-in `lane: pty` execution lane for context-window introspection**, opened as **draft pull request 81 on kriscendobot/garden** (base `main2-8515009`, head `feat/pty-context-introspection-lane`, 8 files, +865/−16) via the frozen-base-branch carve-out the maintainer authorized.

**What it does.** A job with `lane: pty` in its frontmatter runs its session in an interactive pseudo-terminal instead of headless `claude -p`, so Claude Code's `statusLine` command fires — the one channel carrying a real context-window measurement, absent under `-p`. A statusLine script persists the live figure to a per-job file a reader skill consumes.

**Files.** `scripts/jobs/pty-lane/{statusline.sh,run.py,run.sh}` (the side channel + pty enclosure + handler shim), `scripts/jobs/pty-context-read.sh` + `skills/pty-context-introspection/SKILL.md` (the reader half), a one-branch opt-in in `handlers/monk-claude.sh` (+ state-file prune in teardown), `scripts/jobs/test/pty-context-test.sh`, and `designs/pty-context-introspection-lane.md`.

**The hard part.** The statusLine would not fire until I diagnosed and cleared four separate gates: (1) interactive mode in a real pty — `-p` never fires it, even inside a pty; (2) **workspace trust accepted** — statusLine has an extra trust gate beyond hooks (`"Skipping StatusLine command execution - workspace trust not accepted"`); (3) **noexec-safe** invocation (`bash <script>`, since garden `/tmp` is noexec → rc=126); (4) non-nested + `CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1`. Settings propagation (requirement 5) avoids the gitignored/bind-masked `~/.claude/settings.json` entirely: the script is tracked in-repo, the settings file referencing it is code-generated and passed with `--settings`.

**Evidence.** Live Opus-5 pty sessions fired the statusLine and wrote correct per-job files (session_id, model, `context_window_size=1000000`, timestamps). The full persist→read pipeline proven with a real figure: statusLine JSON for a 78%-full window rendered `ctx 78% · in 742000 out 38000`, persisted `used_percentage=78`, reader returned `78`. **Two concurrent lanes proven non-clobbering** — same epoch, distinct DONE tokens, two distinct files with distinct session_ids. Reader freshness verified (fresh→0, stale/ancient/owner-mismatch→3, absent→2). No regression: `gardener-worktree-test.sh` 44/44, new `pty-context-test.sh` 16/16, shellcheck clean.

**What I did not verify (honest limits — scoped as an experiment).** (a) A large non-zero `used_percentage` on a *real long job*: short stand-in sessions read null/0 because the context-window accounting doesn't accrue within their brief life (the persist/read mapping is proven via injected JSON, but an hours-long job wasn't run). (b) Robust **multi-line prompt injection** and a first-class **interactive completion/usage contract** — single-line prompts submit reliably, arbitrary multi-line job prompts through the TUI do not yet. Per the brief I stopped at the smallest honest slice rather than rewriting the spine — hence the opt-in gate. Both limits are documented in the design and PR body.

**Follow-ups (for the maintainer to weigh after review):** robust multi-line injection, an interactive completion/usage contract, and optional host-level managed-settings propagation. Memory saved: the four statusLine-pty gates (reference).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/garden-pty-lane-context-introspection.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s)
- Input: 386 tokens (37389590 cached reads)
- Output: 180928 tokens
- Cost: $25.264993749999995
- Wall-clock: 4582s
- Model(s): claude-opus-4-8 ×3

<!-- garden-usage-end -->
