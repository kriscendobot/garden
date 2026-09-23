---
kind: message
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-08-05T16:13:36Z
---
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
prs:
  - https://github.com/endojs/endo-but-for-bots/pull/868

# Dependabotany ledger: endojs/endo-but-for-bots — 2026-08-05 backstop sweep, PR #868 matured → terminal MERGE-NOW

Daily backstop sweep (job `dependabotany-recheck-endo-but-for-bots-20260805-160502`).
Recovered the ledger newest-first with the case-insensitive heading match. The
sole open embargoed row was **PR #868** (`eslint-plugin-unicorn` 56.0.1 → 72.0.0),
maturity floor **2026-08-02T16:39:39Z**. At this 2026-08-05T16:1xZ sweep the floor
is ~3 days past, so the row was **due**. Re-ran the full botany workflow against
the live head and rendered the now-due terminal verdict.

## PR #868 → MERGE-NOW (terminal; row removed from the embargoed set)

Head `d48bde2fbbcc789cdd36264abe79b55c997126e2` — **byte-identical** to the
embargoed head (dependabot did not force-push a regenerated lockfile; the moved
set and floor stand). All gate legs re-verified live:

- **Maturity satisfied.** Freshest moved version confirmed `globals@17.8.0`
  published `2026-07-26T16:39:39.297Z` (max over the 27-version moved set; the
  headline `eslint-plugin-unicorn@72.0.0` is 2026-07-14, older). Floor +7d =
  `2026-08-02T16:39:39Z`, now past.
- **Advisories clean.** OSV batch over the incoming moved set → zero; no GHSA on
  any moved version; none deprecated/yanked. Publishers `sindresorhus` (globals,
  unicorn) and GitHub Actions trusted-publishing (baseline-browser-mapping). No
  CVE closed → rests on maturity.
- **Not superseded.** Base `llm` still resolves `eslint-plugin-unicorn@56.0.1`
  (root spec `^56.0.1`); genuine forward major bump. Group PR #923 is
  minor-patch-only and does not carry this major; no sibling PR moves the package.
- **CI green.** 24/24 `check-runs` success at head, 0 failed, 0 pending, `lint`
  among them. `MERGEABLE` / `CLEAN`.
- **Changeset present.** `.changeset/eslint-plugin-unicorn-72.md`
  (`@endo/eslint-plugin: major`), documenting the downstream-visible peer bump.

**Disclosure — green rests on a migration.** The bump alone was `lint`-RED with 7
`unicorn/numeric-separators-style` errors from v72's new `fractionGroupLength`
default. Fixer commit `d48bde2fbb` set `fractionGroupLength: 3` in
`packages/eslint-plugin/src/configs/shared.js` + added a regression test and the
changeset, driving CI green. The merge carries this consuming-code edit.

**Disposition.** Verdict comment posted:
https://github.com/endojs/endo-but-for-bots/pull/868#issuecomment-5194294557 .
Conducted through `ci-wait-merge.sh`: CI terminal-green, merge **blocked at the
maintainer-approval gate** (no current APPROVED review on the head,
`reviewDecision` empty), exit 1 — the gate holding as designed. PR left OPEN,
`MERGEABLE`/`CLEAN`, not stranded. On a maintainer approval it conducts onto `llm`.
This is a terminal MERGE-NOW; the only outstanding item is the human approval,
which is not a schedulable recheck. **#868's row is removed from the embargoed set.**

## The embargoed set is now EMPTY

#868 was the last embargoed row. No open `endo-but-for-bots` row now carries a
future maturity date, so no precise recheck one-shot is owed. Per the daily
schedule's termination clause the backstop heartbeat may be retired; a future
embargo verdict re-creates it idempotently.

**Note — both recheck schedules are currently PAUSED** (`paused-schedules/`):
the daily backstop (`last_dispatched: 2026-08-01`) and #868's precise one-shot
(`once: 2026-08-02T17:15:00Z`). #868's one-shot therefore never fired at its
floor — this is exactly the lost-one-shot rot the daily backstop exists to
catch, and this manually-dispatched sweep caught it. The stale #868 one-shot is
now moot (its PR is terminal). Left the paused files untouched (they are inert);
flagging for the operator in case the pause was unintended.

## Adjacent state (open dependabot PRs that are NOT embargoed ledger rows)

- **#923** (`all-minor-patch` group, 36 updates + a `kriscendobot` migration
  fixup `d2635dcead`): **actively owned by a live peer** —
  `endojs-endo-but-for-bots-pr923-dependabot` in `jobs/doin/` (gardener 3, claimed
  2026-08-05T15:36Z). Explicitly named in this sweep's brief, but I did **not**
  touch it to avoid colliding with the in-flight worker; messaged the peer to
  carry it to a terminal verdict + ledger row. Not an embargoed row.
- **#867** (`@noble/curves` 1.9.0 → 2.2.0), **#915** (`actions/setup-python`
  6.2.0 → 7.0.0), **#916** (`softprops/action-gh-release` 3.0.1 → 3.0.2): all
  hold **terminal MERGE-NOW** verdicts from prior runs, blocked **solely** on a
  maintainer approval (`ci-wait-merge.sh` GREEN, gate refuses). Not embargoed;
  no recheck owed. They wait on a human.
- **#912** (`actions/setup-node` 6.2.0 → 7.0.0), **#913** (`dorny/paths-filter`
  4.0.1 → 4.0.2), **#914** (`actions/cache` 5.0.5 → 6.1.0): opened 2026-08-02,
  **no ledger row and no live job found on the board**. Outside this sweep's
  scope (they are not embargoed rows), but flagged: their auto-posted
  dependabot-watcher jobs appear not to have been claimed/completed. A watcher
  re-post or manual `botanist` post is warranted so they reach a terminal verdict.

Self-improvement: nothing this time.
