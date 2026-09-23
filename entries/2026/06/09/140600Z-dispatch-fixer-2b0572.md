---
ts: 2026-06-09T14:06:00Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: fixer
dispatch_root: /home/kris/dispatches/fixer--2b0572
prs:
  - repo: endojs/endo-but-for-bots
    pr: 75
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/75
  - https://github.com/endojs/endo-but-for-bots/issues/75#issuecomment-4660579708
---

# dispatch: fixer — simple retcon to absorb fixups on PR #75 per kriskowal directive

Maintainer directive on PR #75 (kriskowal at 2026-06-09T14:05:07Z,
issue comment `4660579708`):

> Thank you, please absorb fixups (simple retcon)

Per orchestrator vocabulary: **retcon** is the
`skills/retcon/SKILL.md` discipline — reset branch + restage
per-package, separate `chore: Update yarn.lock`, implementation
+ tests combined; net diff invariant.

The "fixups" are the two most recent commits on the branch:
- `e627f7b13` (`fix(random,chacha12): address gibson042 final
  review on endo#3232`): the carry of 7 gibson042 upstream
  suggestions + 1 mirror-sweep ask.
- `4a879634e` (`fix(chacha12-fast-check-test): restore
  package.json exports block per kriskowal commit-comment`): the
  surgical revert of the package.json exports collapse.

The 👀 reactji is on the maintainer's directive comment
(`reactions/367643019`).

## State at dispatch time

- **PR** `endojs/endo-but-for-bots#75`, OPEN (not DRAFT), base
  `master`, head `kriskowal-random-chacha12` at `4a879634e`.
- **Retcon target**: absorb `e627f7b13` and `4a879634e` into the
  earlier substantive commits so the net diff stays the same but
  the commit structure no longer carries the maintainer-asked-
  for-revert as its own commit (and any other fixups become
  part of the implementation they belong to).

## Task

Per `garden/skills/retcon/SKILL.md`:

1. **Read** the skill in full. Internalize: reset --mixed to
   base, restage per-package, implementation + tests combined,
   separate `chore: Update yarn.lock` commit, net diff invariant.
2. **Verify the base**: PR #75's base is `master`. `git merge-base
   HEAD origin/master` reports the merge base; everything past
   that merge base on `kriskowal-random-chacha12` is in scope of
   the retcon.
3. **Compute the package decomposition**: enumerate which
   packages have unstaged-after-reset changes. Likely:
   - `packages/chacha12/` (the ChaCha12 cipher + ponyfill)
   - `packages/chacha12-fast-check-test/` (the fast-check
     integration test)
   - `packages/random/` (the @endo/random factoring)
   - Possibly other packages downstream.
   Each package gets its own commit (implementation + tests
   combined). The `chore: Update yarn.lock` is its own commit
   at the end.
4. **Apply the retcon**: per the skill's procedure. The net diff
   between the pre-retcon HEAD and the post-retcon HEAD MUST be
   zero (`git diff <pre> <post>` empty). This is the invariant
   that protects the retcon from accidentally dropping or
   adding substance.
5. **Force-with-lease push** with lease anchor `4a879634e` (the
   pre-retcon head; use the full 40-char SHA).
6. **Reply on kriskowal's directive comment** (`4660579708`)
   confirming the retcon: name the pre/post head SHAs and the
   per-package commit summary (e.g., "now N commits: chacha12,
   chacha12-fast-check-test, random, yarn.lock"). Keep it short.

## Authorizations (per-action, forwarded by steward)

- **Force-with-lease push** to `kriskowal-random-chacha12` with
  lease anchor `4a879634e` (full 40-char SHA). The retcon
  rewrites history; this is the canonical retcon shape per the
  skill.
- **Reply on the directive comment** on PR #75. Standing
  `endo-but-for-bots` broad-comment authorization.
- Do NOT re-request review (retcons are cosmetic; the
  maintainer touched the PR recently and pulls when ready).

## Out of scope

- Do NOT add new substance. The net diff invariant is
  load-bearing.
- Do NOT drop substance. Even small "wouldn't this be cleaner"
  edits during restaging are off-limits in a retcon.
- Do NOT touch the upstream endojs/endo#3232 PR.
- Do NOT mark the PR DRAFT.

## Deliverable

A `result` entry under `journal/entries/2026/06/09/` naming:

- Pre/post branch tip SHAs.
- The per-package commit decomposition (SHA + scope per commit).
- The net-diff-zero verification (`git diff <pre> <post>` output;
  must be empty).
- The reply URL on kriskowal's directive comment.
- A `Self-improvement: ...` line.

End your turn with a concise summary back to the orchestrator. The
orchestrator tears down your dispatch root on return.
