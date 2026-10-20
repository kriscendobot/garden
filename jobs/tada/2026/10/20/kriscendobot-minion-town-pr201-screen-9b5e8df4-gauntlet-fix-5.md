# Fix round 5: kriscendobot/minion.town PR #201 (New Clip)

I fixed the panel-5 must-fix code defects and pushed them as three follow-up commits. CI is green on the new head `37cadd6e` (2 of 2 runs passed). Several must-fix items are still open because they need a ruling from the maintainer rather than code, so the next panel will likely flag them again.

There was no deterministic pre-pass block, so I worked from the latest panel verdict on the PR (review 5590966582, submitted 2026-10-20 20:02Z).

## What I fixed (commits `b1e4fabd`, `2c08fd30`, `37cadd6e`)

- **Quota check fails closed (breaker):** if any part of the space can't be read while it is being measured, the write is now refused instead of being allowed against a size that left that part out. The next write measures again. Removals don't need a quota check, so they still work.
- **Cleanup after a lost reply (breaker):** setup now first writes a receipt containing a random token for that mint. If setup fails or the reply never arrives, cleanup checks the token first, so it only deletes names this mint created and never a name that already existed.
- **Strict reply check (wire-watcher):** a mint only goes ahead on one of two exact replies: `{taken:true}`, or a receipt naming this mint's space and power. Any other reply is cleaned up and rejected. Tests cover a missing marker, a false marker, mismatched names and extra keys.
- **Two mints racing for the same name (corner-prober):** mints for the same caller now set up one at a time (keyed on the caller's identity in `src/http.ts`). A deterministic test fails if this serialization is removed.
- **Independent test oracle (prover):** the minter's property test now checks against the gateway's own decoder (`labelToId`/`idToLabel`) instead of the predicate the minter itself uses. It includes pad-bit aliases and upper-case labels.
- **Two should-fix items:**
  - a new fast-check property test for `lacksSameOriginProof` in `test/fetch-metadata.test.ts` (fast-checker);
  - renamed `repo` to `repositoryRoot` in `tools/build-new-clip.mjs` (stylist).

The New Clip tests (54) and the fetch-metadata tests pass locally, and so does `tsc`. In the full local test run, two git-remote tests failed. This PR doesn't touch those files, and CI passed.

## Waiting on the maintainer

I sent the maintainer a message laying out both items.

- **Who gets write access:** the locksmith, purist, integrator and decomplector seats all object that anyone with the clip URL gets write access. This goes against the direction set on minion.town#85. The PR body and the "Open questions" section of `designs/new-clip.md` already say this needs the maintainer's sign-off. The choices are:
  - accept it for now;
  - make the New Clip read-only for visitors;
  - put the write access behind the #88 session nonce first.

  The decomplector also wants `NewClipPower` removed so the directory can be published directly.
- **Unbounded `list()` (saboteur, engine-realist):** the daemon has no paginated or length-limited list or read, so a very large directory is loaded in full before the size caps apply. Fixing that needs a new upstream Endo API, not a change in this PR.

Smaller should-fix items I didn't do: the Linux runner label (transplanter) and a top-level `browser-test/` case (coverage-auditor).

The first CI wait was killed by the background time limit. I reran it and it reported rc 0 (green).

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr201-screen-9b5e8df4-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 98 tokens (4978956 cached reads)
- Output: 33358 tokens
- Cost: $2.6724951999999993
- Wall-clock: 2425s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
