# Ironhorse test262 coverage — 2026-10-24 quota week (report at 2026-10-31T03:00Z)

Job `ironhorse-coverage-report-20261031`, written 2026-10-31. Requested by kriskowal (liaison session 2026-10-30).

## Bottom line

**Coverage did not increase. No ratchet crank landed in the window.** The arc was already blocked before the tokens were released and **halted** (delegation `paused`) at 2026-10-30T04:20Z, about an hour after the release. The blocker is **floor resolution**, which shows up as `wrong base` on the only crank PR. It is not budget, the gauntlet, or CI.

| | Baseline (2026-10-30T03:09Z) | End (2026-10-31T03:00Z) | Delta |
| --- | --- | --- | --- |
| Enforced floor | `refresh-20260904/covered.txt` @ `47f6965d88` (sha256 `322ca2ba…0d994f`) | same file, same sha256 | none |
| Covered cases | **30,233** | **30,233** | **0** |
| Share of corpus (51,976 cases, test262 `be13516fb644`) | 58.17% | 58.17% | 0.00 pp |
| endo-but-for-bots `llm` head | `9a14ddf660` (2026-10-28T15:23Z) | `9a14ddf660` | no commits to `llm` in the window |

The latest merged baseline refresh at or before the baseline moment is `refresh-20260904` (merged with `a462050bf4`, 2026-09-07). No later refresh is on `llm`. `refresh-20260928` exists only on draft PR #1359.

## Movement by test262 area

The floor did not change, so every area moved by **0**. The enforced floor's covered cases by area:

| Area | Covered |
| --- | --- |
| language | 20,030 (expressions 9,184; statements 8,549; literals 526; …) |
| built-ins | 9,831 (Object 2,232; Array 1,660; RegExp 1,441; String 541; DataView 458; TypedArrayConstructors 382; …) |
| annexB | 370 |
| intl402 | 2 |

The floor's `baseline.json` gives the other corpus categories only as whole-corpus totals: unsupported 13,711, skipped 7,414, infrastructure 618, ironhorse-failure 0. There is no per-area denominator, so per-area shares can't be computed from the baseline files.

## Cranks

**Landed in window: none.**

**In flight / blocked:**

- **Crank 3: https://github.com/endojs/endo-but-for-bots/pull/1359** — `fix(ironhorse): preserve numeric intrinsic constant attributes`. Draft and open. Base is frozen `llm-47f6965`. Head `f6a8388bf1c`, last updated 2026-09-28. Builder `ironhorse-test262-ratchet-round3-20260928`.
  - *Aborted-reason cluster it addresses:* the installation attributes of Math/Number numeric constants and TypedArray `BYTES_PER_ELEMENT`. Its candidate measurement (`refresh-20260928`) moves whole-corpus covered from 36,599 to 36,673 (+74; 74 failures become covered; zero losses against its branch point). That figure uses the *current* runner verdict policy, so it isn't directly comparable to the 30,233 floor. It is unmerged, so **no coverage is counted from it**.
  - *Why blocked:* the PR is based on frozen `llm-47f6965` and not on live `llm`, which the delegation scope requires. The ratchet driver refuses it with `wrong base`. Underneath that is a floor-resolution question: current `llm` already lost 906 of the 30,233 floor paths under current verdict and resource policy. The PR repairs 5. The remaining 901 are 443 `ironhorse-aborted-limit`, 397 `shared-positive-test-failure`, and 61 other outcomes. `refresh-20260928` is marked `supersedes: null`, a candidate rather than a superseding floor.
  - *Owner:* parked successor `ironhorse-test262-ratchet-round3-floor-resolution-20260928` (gate `awaiting-maintainer`). It asks: *reconcile the historical floor with current verdict/resource policy, or restore all 901 under unchanged pins and policy?* (https://github.com/kriscendobot/garden/issues/51#issuecomment-5877917421). That question was still unanswered at window end.
- No other ratchet-marked PR was opened or merged in the window. #1548 (`perf(ironhorse-vm)…`) is open against `llm` but carries no arc marker and is not a crank.

## Press engagements and spend

| Press job | Ran (completed) | Outcome |
| --- | --- | --- |
| `ironhorse-test262-press-20260929-173306` | 2026-10-30, journal step `7f625e9a8f` 03:16Z | `retry-next-tick` / `wrong base`: first failure tick |
| `ironhorse-test262-press-20261030-031712` | 2026-10-30, journal step `a255155b5b` 04:20Z | second distinct tick on the same criterion → **halt**. Delegation `paused`, maintainer notice `ironhorse-ratchet-halted-ironhorse-test262-press-20261030-031712` |

These two presses are the only engagements. The halt left no press successor parked, so the hourly cadence did not run again in the window.

- `scripts/jobs/arc-spend.sh --now-epoch <2026-10-31T02:59:59Z> ironhorse-test262-ratchet`: **125,605 tokens**, 2 engagements, 2 completions, 0 unmetered, window 2026-10-24T03:00Z → cutoff. Stamped job costs were $1.74 + $1.70 (claude-fable-5; the cost includes ~671k cached-read tokens that the arc metric does not count).
- **Tokens per newly covered case: undefined (0 cases gained).** Nearly all of the released headroom went unspent.
- Budget note: the job brief says 20M tokens. The arc-budget record in effect shows `token_cap` 356,960,121 (re-set by `accountant` at 2026-10-30T04:35:59Z). Either way, budget did not bind.

## To unblock

1. The maintainer answers the floor question on kriscendobot/garden#51 (comment above). That releases the parked floor-resolution successor, which re-lands crank 3 on live `llm` or otherwise resolves the 901.
2. Then explicitly `scripts/jobs/ironhorse-ratchet.sh resume` (per `context/operations/ironhorse-ratchet.md`). Until then, released ratchet tokens cannot buy coverage.
