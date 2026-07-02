# garden-infra: fix inaccuracies in the README "Build and enter the container" section

**Garden-infra doc change on `main2`.** Isolated worktree off `origin/main2` per the hard rule
(`garden/roles/COMMON.md` § Per-subagent worktrees); the root checkout is read-only. Land with an
explicit-pathspec commit on `README.md`, push `HEAD:main2` via a rebase CAS loop.

## Directive (kriskowal, 2026-07-02)

The just-rewritten README's **"Build and enter the container"** section (under `## 1. Getting started`)
has inaccuracies: <https://github.com/kriskowal/garden#build-and-enter-the-container>. Verify every
command, flag, env var, and filename in that section against the **actual sources of truth** and correct
what does not match. Do not guess — run/read the real thing.

## Ground truth to check against (verify, do not assume)

- The **`garden`** launcher script at the garden root (`<garden-root>/garden`). Confirm the real
  subcommands: does `./garden build` exist, or does the image build happen another way? What does
  `./garden` with no args do, and `./garden reset`? What env vars does it actually read at container
  creation — `GARDEN_CONTAINER`, `GARDEN_HOSTNAME`, and the shard-identity var?
- **`scripts/jobs/common.sh`** host-identity precedence (the `GARDEN` / `.garden` / `hostname -s`
  resolution, around the "Host identity" comment). The README currently calls the shard var
  **`GARDEN_SHARD`**; confirm whether the code's canonical env var is `GARDEN_SHARD` or **`GARDEN`**
  (common.sh reads `GARDEN` and the `.garden` file). If the README's `GARDEN_SHARD` does not match the
  code, either fix the README to the real var name, or (if `GARDEN_SHARD` is intended as a new alias)
  confirm the code actually honors it before documenting it. The doc and the code must agree.
- The **`.garden`** identity file: how it is seeded, its precedence, and the note about a second
  follower pool on one host needing a unique identity.

## Known suspects (confirm each before editing)

- `./garden build` as a subcommand — verify it exists in the `garden` script.
- `GARDEN_SHARD` vs `GARDEN` — the deployed `common.sh` resolves `GARDEN` (env) → `.garden` (file) →
  `hostname -s`. If `GARDEN_SHARD` is not read by the code, the README is wrong.
- `GARDEN_HOSTNAME` / `GARDEN_CONTAINER` semantics as described.

## Definition of done

Every command/var/filename in the "Build and enter the container" section matches the real `garden`
script and `common.sh`; each correction is grounded in a cited read/run of the actual source (name the
file+line or the command output per `garden/roles/COMMON.md` § Reporting). Land on `main2` from an
isolated worktree; journal a `result` entry listing each inaccuracy found and the correction. If a
described feature genuinely does not exist in the code, either remove the claim or (if it should exist)
flag it as a follow-up rather than documenting a fiction.

---
claim:
  host: endolinbot
  gardener: 68
  claimed_at: 2026-07-02T10:33:30Z
