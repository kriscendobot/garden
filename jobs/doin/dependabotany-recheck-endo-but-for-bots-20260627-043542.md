# Daily dependabotany recheck: endojs/endo-but-for-bots

Fires daily. Dispatches a gardener wearing the
[botanist](../../roles/botanist/AGENT.md) role to re-evaluate every embargoed
Dependabot PR in the `endojs/endo-but-for-bots` dependabotany ledger whose
maturity date has arrived (recover the ledger with
`grep -rl '^project: endo-but-for-bots$' journal/entries/ | xargs grep -l '^# Dependabotany'`).

For each ledger row whose `EMBARGO-YYYY-MM-DD` maturity date is on or before
today and whose PR is still OPEN: re-run the botanist workflow against the PR's
current head (re-enumerate the lockfile moved set, re-run OSV/GHSA, re-confirm
the resolved version is now >=7 days mature and nothing fresher slipped in,
shepherd CI to green), then execute the now-due terminal verdict (MERGE-NOW =
conduct onto `llm`; REJECT = close with the verdict comment). A terminal verdict
removes that PR's ledger row. When the ledger holds no embargoed endo-but-for-bots
rows, this schedule may be deleted.

The maturity date in the ledger is the gate; this daily sweep is only the
heartbeat that guarantees no embargoed PR rots.

---
claim:
  host: endolinbot
  gardener: 82
  claimed_at: 2026-06-27T04:35:55Z
