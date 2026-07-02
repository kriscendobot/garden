State confirmed after the requeue: `HEAD == origin/main2`, working tree clean, self-provisioning code present, all 31 tests pass. The job's objective is genuinely satisfied and nothing is left to implement or commit.

## Completion report

**Objective:** Make `clone-keeper.sh` self-provision a missing tracked bare clone instead of warning on every ~30m tick forever (this host, endolinbot2, was never seeded with `worktrees/endojs-endo.git`).

**Status: complete — already landed on `origin/main2`** (which is `HEAD` in this worktree, `a89146728`). Two commits deliver it:
- `1bfbc1087` — repair a genuinely-missing tracked bare clone by re-cloning from the tracked source.
- `05a261e5e` — self-heal a missing clone by deriving its URL from the dir basename.

`keep_clone()` no longer warns-and-returns on a missing clone. On a genuinely-missing dir it picks a clone source (explicit URL/path in the tracked row, else a URL derived from the `<owner>-<name>.git` basename), runs `bounded_clone` (`timeout GARDEN_FETCH_TIMEOUT` + retry/backoff, offline-tolerant logging, partial-tree scrub on timeout), sets `remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'`, then falls through to the normal fetch/fast-forward. A present-but-corrupt dir stays `STALE` (never clobbered); an unreachable source leaves the host quietly un-provisioned for the next tick rather than aborting the loop. Tests cover the full matrix — **31/31 pass**, including `RECLONE`, `PROVISION`, `MISSING+UNREACHABLE`, and `MISSING+UNDERIVABLE`.

For endolinbot2 specifically: the default entry `worktrees/endojs-endo.git|https://github.com/endojs/endo.git|master` carries the explicit URL in the remote field, so the next timer firing re-clones directly and logs `REPAIRED:` — the warning loop resolves without a manual `git clone --bare`.

**Design divergence from the spec's literal proposal (transparency):** The job proposed an optional *fourth* field `<dir>|<remote>|<branch>|<clone-url>`. The landed design instead carries the explicit URL in the existing **second (remote) field** (`is_remote_location()` distinguishes a URL from a bare name), with first-`-` basename derivation as a fallback for bare-name entries. This is functionally equivalent for the endo case (zero ambiguity — the remote field is already the exact URL) and avoids a redundant second way to specify a URL, so I did not add the now-unnecessary fourth field.

**Changes this run:** none — verification only (re-fetched origin, confirmed clean tree and passing tests after the reaper requeue).

**Follow-ups:** none required. A literal fourth field would only matter for a future non-GitHub upstream that also can't put its URL in the remote field; trivial additive change if ever needed.
