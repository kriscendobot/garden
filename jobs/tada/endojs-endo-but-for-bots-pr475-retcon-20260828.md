Retcon complete.

## Completion report

**Job:** Retcon endojs/endo-but-for-bots PR #475 (`feat/narrow-bytearray-to-uint8`), base `llm-e22e67a` (`e22e67a`).

**What I did**
- Set up an isolated per-job project worktree via `ensure-project-worktree.sh`.
- Confirmed base `e22e67a` is a direct ancestor of the head (branch up to date; no weave needed). Pre-retcon tip: `98cba429a`.
- Tagged the pre-retcon tip, `git reset --mixed` to the base, and restaged the entire net diff (285 files across 28 packages) as a sensibly grouped, conventional-commit history.
- Force-pushed with `--force-with-lease`. New head: **`16656d8d6`**.

**New commit shape (33 commits, was 34)**
- One commit per affected package (28): base64, bytes, capn-web, cbor, chat, cli, daemon, git, harden, hardened262, hex, immutable-arraybuffer, marshal, mem-cas, ocapn, ocapn-noise, pass-style, patterns, platform, relay-server, ses, ses-test, spaces-util, stream-node, tar, test262-runner, thixotrope, utf8. Each carries implementation + tests together with a conventional-commit scope.
- `chore: add immutable byte array changesets` — all `.changeset/*` files.
- `ci: update Moddable to version 9` — `.github/workflows/ci.yml`.
- `fix(ci): use GNU mirror redirect for Guix download` — `.github/workflows/ocapn-guile-interop.yml`.
- `build: update composite project references` — root `tsconfig.composite.json`.
- `chore: Update yarn.lock` — separate lockfile commit.

**Grouping decisions worth noting**
- The two visible `fixup!` commits (`9a4fdb1b2` → bytes, `d4c308872` → immutable-arraybuffer) were absorbed into their per-package commits, as directed — no fixups remain.
- The former single `fix(spaces-util)` commit spanned two packages (`spaces-util/src` + `chat/test`); per-package discipline split it into a `fix(spaces-util)` commit and a `test(chat)` commit.
- CI changes kept as two commits (two distinct concerns: Moddable bump vs. Guix mirror) rather than folded into one.

**Net-diff invariance (verified)**
- `git diff pre-retcon-475 HEAD` → empty.
- Tree hashes identical: both `1223c8f23b91f3de5959567163f8f07cb1392442`.

**Follow-ups:** none from the retcon. The maintainer directive was "retcon and conduct" — the conduct half is a separate job and not part of this base.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr475-retcon-20260828.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (971701 cached reads)
- Output: 13600 tokens
- Cost: $1.4599655000000002
- Wall-clock: 214s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
