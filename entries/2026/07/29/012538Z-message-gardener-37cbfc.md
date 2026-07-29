---
kind: message
role: gardener
host: endolin-garden-ece02cb4
at: 2026-07-29T01:25:40Z
---
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
prs:
  - https://github.com/endojs/endo-but-for-bots/pull/868

# Dependabotany ledger: endojs/endo-but-for-bots — 2026-07-29 backstop sweep, no row due

Backstop recheck sweep of 2026-07-29T01:20Z (job
`dependabotany-recheck-endo-but-for-bots-20260729-012002`). Appends to the
`endojs/endo-but-for-bots` dependabotany ledger seeded at
`entries/2026/05/13/000050Z-message-steward-e08492.md`. Recover the cumulative
posture with:

```sh
grep -rl '^project: endo-but-for-bots$' journal/entries/ | xargs grep -il '^# *dependabotany'
```

(The `-i` is new as of this sweep; see *Ledger recoverability defect* below.)

## Sweep result

The open embargoed set holds exactly **one** row, PR #868, unchanged since the
2026-07-28T01:14Z embargo. Its maturity floor is **2026-08-02T16:39:39Z**, four
days out, so **no row was due** and no verdict was owed. No terminal
disposition taken; the embargoed set is unchanged.

## Open embargoed rows (unchanged)

| PR | Verdict | Maturity floor | Precise recheck | Base | Live state at sweep |
|---|---|---|---|---|---|
| [868](https://github.com/endojs/endo-but-for-bots/pull/868) | **EMBARGO-2026-08-02** | 2026-08-02T16:39:39Z (`globals@17.8.0` published 2026-07-26T16:39:39Z + 7d) | `dependabotany-recheck-endo-but-for-bots-pr868` at 2026-08-02T17:15:00Z | `llm` | OPEN, `mergeable: MERGEABLE`, `mergeStateStatus: CLEAN`, head advanced to `d48bde2fbbcc789cdd36264abe79b55c997126e2` |

## Terminal-state check

Per the sweep's precondition, #868 was checked for a terminal state it might
have reached on its own: `state: OPEN`, `mergedAt: null`, `closedAt: null`,
`updatedAt` 2026-07-28T16:51:16Z. Neither merged nor closed as superseded, so
the row stays open.

## The head moved, and the floor did not — the distinction is the point

The head advanced since the 2026-07-28 sweep, from
`f8cf6acf688cff25033412355d2047609d2e9cc2` to
`d48bde2fbbcc789cdd36264abe79b55c997126e2`. A moved head is the one event that
can **reset** a maturity floor, so it was resolved rather than assumed:

- The branch still carries dependabot's original commit `f8cf6acf68`
  (2026-07-26T20:05:59Z) as its first commit — no force-push, no regenerated
  lockfile.
- The new commit `d48bde2fbb` (2026-07-28T16:50:36Z, `kriscendobot`, "fix(eslint-plugin):
  group fractional numeric separators under unicorn 72") touches exactly three
  paths: `.changeset/eslint-plugin-unicorn-72.md` (added),
  `packages/eslint-plugin/src/configs/shared.js`,
  `packages/eslint-plugin/test/internal-numeric-separators.test.js`. It does
  **not** touch `yarn.lock` or any `package.json`.

So the moved-version set is byte-identical to the one the embargo was derived
from, and the floor stands at 2026-08-02T16:39:39Z. That is the check the
one-shot's own body asks the next reader to perform; recording it here means
2026-08-02 does not have to re-derive it.

## The standing blocker is CLEARED

The reason #868 could not have merged even at maturity was `lint` RED with 7
real `unicorn/numeric-separators-style` errors from v72's new
`fractionGroupLength` default. The fixer job
`endojs-endo-but-for-bots-pr868-lint-fix` has **completed** (now in
`jobs/tada/`) and its commit is the `d48bde2fbb` above.

CI at the live head, read from `/commits/<sha>/check-runs` (never the legacy
combined-status endpoint, which is vacuous on this repo): **24 of 24
`completed`/`success`, zero failed, zero pending — `lint` among them.** At the
2026-07-28 sweep this was 21 of 22 with `lint` red.

**The remaining distance is one maintainer approval.** `reviewDecision` is
empty, so the conductor spine (`ci-wait-merge.sh`) will refuse at
`pr-maintainer-approval-gh.sh` exactly as it did for #556, #869 and #870. That
is not this sweep's to resolve — the maturity leg is genuinely unmet until
2026-08-02 — but it means the 2026-08-02 one-shot's likely outcome is
MERGE-NOW-held-at-the-gate rather than a landed merge, joining the three pull
requests already queued behind an approval.

## Backstop verification (the reason this sweep exists)

Both legs of #868's recheck wiring verified present rather than assumed:

- Precise one-shot: `schedules/dependabotany-recheck-endo-but-for-bots-pr868.md`
  present, `once: 2026-08-02T17:15:00Z`, prefix
  `dependabotany-recheck-endo-but-for-bots-pr868`, full re-evaluation brief
  intact. Left unedited — its instruction to verify `lint` green before
  MERGE-NOW is still the right instruction, and this entry is where the
  now-green answer lives.
- Daily backstop: `schedules/dependabotany-recheck-endo-but-for-bots.md`
  present (it dispatched this job). Retained; the embargoed set is non-empty,
  so the termination clause does not apply.

## Ledger recoverability defect, found and fixed by this sweep

The canonical recovery command matched `'^# Dependabotany'` **case-sensitively**.
Against the live journal it recovers **25 of 27** tagged entries. The two it
drops both carry a lowercase `# dependabotany …` heading:

- `entries/2026/07/28/073334Z-message-gardener-e27989.md` — PR 556, MERGE-NOW
- `entries/2026/07/28/073552Z-result-botanist-94e416.md` — PR 562, REJECT (superseded)

Both are terminal, so **no embargoed row was actually lost** and the set above
is correct. But the failure mode is precisely the one this backstop exists to
catch: a sweep reconstructs the ledger *only* by grep, so an EMBARGO row hidden
by heading case would be a PR resting entirely on a one-shot no backstop could
verify — silent until the PR rotted. Fixed in two places:

1. `roles/botanist/AGENT.md` step 11 (landed on `main2` as `42987ba244`) now
   states both halves of the recovery contract an entry must satisfy — a
   `project:` line and a `# Dependabotany` heading — and gives the
   case-insensitive form to write against.
2. The daily schedule body
   (`schedules/dependabotany-recheck-endo-but-for-bots.md`) now carries the
   `grep -il '^# *dependabotany'` form, so every future sweep is dispatched
   with the robust instruction. The same edit adds the head-SHA check above to
   the sweep's terminal-state precondition, since distinguishing a fixer's
   commit from a dependabot force-push is what decides whether a floor resets.

## Adjacent state, not ledger rows

Recorded because a reader reconstructing "what is open on this repo" from the
ledger alone would otherwise miss it. Six dependabot pull requests are open;
only #868 is an embargoed row. #556, #558, #869 and #870 all hold terminal
MERGE-NOW verdicts and are **blocked solely on a maintainer approval** —
including #869, whose upgrade closes a CRITICAL advisory (GHSA-37j7-fg3j-429f)
that the version in the tree is exposed to. #867 (`@noble/curves` 1.9.0 to
2.2.0) has **no verdict at all**: its job
`endojs-endo-but-for-bots-pr867-dependabot` is parked in `jobs/plan/`. Neither
is this sweep's to act on; both are named so the next reader does not mistake
ledger silence for absence.

## Next sweep

The set remains non-empty, so the daily heartbeat stays. The next
terminal-verdict opportunity for #868 is its precise one-shot at
2026-08-02T17:15:00Z; intervening daily sweeps continue to no-op until then,
which is the intended division of labour between the precise leg and the
backstop.
