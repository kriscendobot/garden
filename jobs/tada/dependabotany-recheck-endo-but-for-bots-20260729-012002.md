Backstop sweep complete. Report:

## Sweep result: one open embargoed row, none due

The `endojs/endo-but-for-bots` dependabotany ledger holds exactly **one** open embargoed row, PR **#868** (`eslint-plugin-unicorn` 56.0.1 → 72.0.0, base `llm`), **EMBARGO-2026-08-02**, maturity floor **2026-08-02T16:39:39Z** (`globals@17.8.0` + 7d). Four days out, so **no verdict was owed and none was rendered**. Terminal-state check first: `state: OPEN`, `mergedAt: null`, `closedAt: null` — not merged, not closed by dependabot.

Older rows confirmed terminal and correctly absent: #197 and #362 drained 2026-07-01; #268/#269/#557/#561/#562 REJECT-closed and #556/#558/#869/#870 MERGE-NOW on 2026-07-28.

## The head moved; the floor did not

Head advanced `f8cf6acf68` → `d48bde2fbb` since the last sweep. Resolved rather than assumed, since a force-push is the one event that resets a floor: dependabot's original commit is still the branch's first commit (no regeneration), and the new commit is the fixer's (`kriscendobot`, "group fractional numeric separators under unicorn 72") touching only a changeset, `shared.js`, and a test — **not `yarn.lock` or any `package.json`**. Moved-version set unchanged, floor stands.

## The standing blocker is cleared

The `lint` RED that would have blocked #868 even at maturity is fixed — job `endojs-endo-but-for-bots-pr868-lint-fix` completed and is that commit. CI at the live head is **24/24 success including `lint`** (read from `/commits/<sha>/check-runs`; was 21/22 with `lint` red yesterday), `mergeable: MERGEABLE`, `mergeStateStatus: CLEAN`. Remaining distance at maturity is **one maintainer approval** (`reviewDecision` empty) — the 2026-08-02 one-shot's likely outcome is MERGE-NOW-held-at-the-gate, joining #556/#558/#869/#870.

Both recheck legs verified present, not assumed: the one-shot `dependabotany-recheck-endo-but-for-bots-pr868` at 2026-08-02T17:15:00Z (intact, left unedited) and the daily backstop (retained; set non-empty).

## Defect found and fixed: the ledger was 2 entries un-recoverable

The canonical recovery command matched `'^# Dependabotany'` **case-sensitively** and recovers only **25 of 27** tagged entries — it silently drops `073334Z-…-e27989.md` (#556) and `073552Z-…-94e416.md` (#562), both written with a lowercase heading. Both are terminal, so no embargoed row was actually lost and the set above is correct, but a hidden EMBARGO row is exactly the rot this backstop exists to prevent: a sweep reconstructs the ledger *only* by grep. Fixed in both places:

- `roles/botanist/AGENT.md` step 11 — landed on `main2` as **`42987ba244`**; states both halves of the recovery contract an entry must satisfy and gives the case-insensitive form.
- The daily schedule body — now carries `grep -il '^# *dependabotany'`, plus the head-SHA check to its terminal-state precondition (`last_dispatched` preserved).

Ledger entry posted: `entries/2026/07/29/012538Z-message-gardener-37cbfc.md` (verified on `origin/journal2`; recovery grep now returns 28).

## Follow-ups (not this sweep's to act on)

1. **Four PRs blocked solely on a maintainer approval** — #556, #558, #869, #870. #869 is the one with teeth: its upgrade closes GHSA-37j7-fg3j-429f (CRITICAL, VM escape to RCE) that the in-tree happy-dom 15.11.7 is exposed to.
2. **#867 (`@noble/curves` 1.9.0 → 2.2.0) has no verdict at all** — its job `endojs-endo-but-for-bots-pr867-dependabot` sits parked in `jobs/plan/`. Promote it when quota allows.
3. Daily heartbeat stays; next terminal opportunity for #868 is its one-shot at 2026-08-02T17:15:00Z.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/dependabotany-recheck-endo-but-for-bots-20260729-012002.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 65 tokens (2771133 cached reads)
- Output: 19495 tokens
- Cost: $2.7501134999999994
- Wall-clock: 369s

<!-- garden-usage-end -->
