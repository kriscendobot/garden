---
ts: 2026-06-09T02:18:00Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: fixer
dispatch_root: /home/kris/dispatches/fixer--5bcc77
prs:
  - repo: endojs/endo-but-for-bots
    pr: 430
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/430
  - https://github.com/endojs/endo-but-for-bots/pull/430#issuecomment-4641694062
  - https://github.com/endojs/endo-but-for-bots/pull/430#issuecomment-4655393379
---

# dispatch: fixer — implement premise-2 (export only the shim) per erights's direction on PR #430

erights answered the prior premise-2 question on PR #430 at
2026-06-09T02:16:31Z:

> @kriscendobot, please do option (a), but have @endo/bytes
> itself also import the immutable-arraybuffer shim to preserve
> the current ergonomics. The shim's race to install will avoid
> any eval twin problem among multiple shim importers.

erights is the senior contributor on this topic per the endo
project README; kriskowal's RSVP on the original experiment-
premise comment is the authorization chain.

## State at dispatch time

- **PR #430**, source-touching, DRAFT, base `master-4a04d07`,
  head `experiment/no-spackle-immutable-arraybuffer-417` at
  `740259d2b871fe02359d49f534155bed080d4c45`.
- **CI**: 3 SUCCESS / 12 FAILURE (pre-existing from premise-2
  deferral). This dispatch resolves the deferral; CI should
  trend green after.

## Task

In your `project/` worktree:

1. **Modify `packages/bytes/src/to-immutable.js`**:
   - Remove the import of `sliceBufferToImmutable` from
     `@endo/immutable-arraybuffer`.
   - Add an import of `@endo/immutable-arraybuffer/shim` at the
     top of the file (whichever subpath imports the shim's
     auto-install side-effect — read the package's existing
     structure).
   - Use `arrayBuffer.sliceToImmutable(...)` (shim'd method)
     where `sliceBufferToImmutable(arrayBuffer, ...)` was called.
2. **Modify `packages/immutable-arraybuffer/package.json`
   exports** to remove the pony `.` entry. The package's
   public surface becomes only the shim entry (premise 2).
3. **Grep for other importers** of
   `@endo/immutable-arraybuffer`'s pony exports across the
   workspace. Migrate each similarly OR document non-migration
   in the result.
4. **Verify**: `corepack yarn workspaces foreach -A --from
   '@endo/immutable-arraybuffer' run test` and `--from
   '@endo/bytes' run test` should pass.
5. **Commit** (separate conventional-commit messages per
   logical change):
   - `refactor(bytes): use shim'd sliceToImmutable for premise
     2 (#430)`
   - `refactor(immutable-arraybuffer): restrict exports to
     shim only per premise 2 (#430)`
6. **Push** to the experiment head branch (regular append).
7. **Reply** on PR #430 acknowledging erights's direction,
   citing the commit SHAs.

## Authorizations (per-action, forwarded by steward)

- **Push** to the experiment head branch.
- **Modify packages outside `immutable-arraybuffer`** (specifically
  `@endo/bytes`; erights's direction explicitly authorizes).
- **Reply on the comment thread** (`endo-but-for-bots` standing
  broad-comment authorization).
- **NOT re-request review**: erights or kriskowal sets the pace.

## Out of scope

- Do NOT shepherd CI to green; if CI surfaces NEW failures
  beyond the pre-existing 12, surface to liaison.
- Do NOT touch other PRs.
- Do NOT trigger panel/judge.

## Deliverable

A `result` entry under `journal/entries/2026/06/09/` per the
standard fixer deliverable: pre/post head SHAs, per-commit SHA
+ description, files touched, test verification, reply-comment
URL, `Self-improvement: ...`.

End your turn with a concise summary back to the orchestrator.
The orchestrator tears down your dispatch root on return.
