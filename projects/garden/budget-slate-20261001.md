---
created: 2026-10-03
author: gardener (job accountant-budget-slate-20261001-apply, role accountant)
authorized_by: kriskowal
approval: journal inbox accountant-budget-conversation-20260930-resume/20261002T043717Z-c66a59 (2026-10-02T04:37Z)
proposal: inbox/maintainer/read/msg-accountant-budget-conversation-20260930-resume-636d6d525ffa.md
---

# Budget slate approved 2026-10-02, applied 2026-10-03

## What was applied

The slate went in through `scripts/jobs/set-apportionment.sh --authorized-by kriskowal --message-id 20261002T043717Z-c66a59`. One journal CAS commit wrote `config/apportionment`, `config/arc-budgets/*`, and `config/foreman-mandate` together. The week is 2026-10-03T03:00Z (the Sat 03:00Z reset), and the total for foreman-drawn work is **500M** meter-tokens. That figure is about 90% of the calibrated Claude weekly caps in `config/budget-pools` (endolin1 256M + endolin2 121M + oros 180M = 557M). codex-endolin counts as zero while it is paused.

| rank | arc | approved share | slice |
| ---: | --- | ---: | ---: |
| 1 | `minion-town-mcp-ocapn`: minion.town over MCP + OCapN | 30% | 142.5M |
| 2 | `minion-town-git-remote`: capability git remote, incl. kriscendobot/minion.town#86 | 20% | 95M |
| 3 | `minion-town-ui`: clip gutter, clip iframe, clips on ocap.site | 15% | 71.25M |
| 4 | `endo-ocapn-background`: SturdyRef (retire the formula-id/locator guest API), byte arrays, streams, OCapN | 20% | 95M |
| 5 | `moonshots`: endor, ironhorse, thixotrope, slot machine | 8% | 38M |
| 6 | `garden-upkeep`: self-heal, watchdog fixes, deploys | 5% | 23.75M |
| 7 | `endo-backlog`: staged gauntlets only; the 2026-08 weaves stay parked | 2% | 9.5M |
| 8 | `unallocated`: reserve | n/a | 25M |

**One accountant adjustment, disclosed.** The approved shares sum to 100%, so a literal apply left the `unallocated` reserve at 0. The tool charges every unarced foreman-drawn plan to the reserve, so that apply immediately held **31 already-staged plans**. They included the sturdyref-stack gauntlet fix-loops, staged endo gauntlet panels, garden fixes, and review retros. The approved proposal itself says in-flight work is never cancelled and the staged gauntlets should drain, so a zero reserve contradicted it. I re-applied about a minute later. The arc slices keep the exact approved 30/20/15/20/8/5/2 ratios over 95% of the total, and the remaining 5% (25M) funds the reserve. After that, nothing was held except the pre-existing `ironhorse-test262-press` (an `arc-budget-untrusted` ledger issue on its schema-1 arc, which this slate leaves alone). To drop the reserve, the maintainer can re-slice.

The schema-1 rolling arc `ironhorse-test262-ratchet` is not in the slate. `set-apportionment.sh` therefore leaves it as it was, and it is not one of the `moonshots` slices.

## Why

- **The maintainer's ranking.** The maintainer's 10-01 answers reordered priorities: minion.town over MCP+OCapN first, then the capability git remote, then the minion.town UI. Endo SturdyRef, byte arrays, streams, and OCapN keep progressing in the background for security reasons. The moonshots trail behind, and the off-mandate Endo backlog gets a sliver.
- **Spend was running near the inverse of that ranking.** The ledger since the 09-30 endolin1 reset (21M notional) showed Endo backlog 42%, sturdyref+petname 36%, minion.town 10%, garden upkeep 5%, ironhorse 3%, other 4%. This slate is a real correction, not a trim.

## Mandate change

`config/foreman-mandate` is now generated from the slate. Its preamble carries the adjusted mandate, which replaces the 2026-09-26 list and keeps its framing:

1. FIRST: minion.town operational over MCP and OCapN.
2. SECOND: minion.town operational as a capability git remote.
3. THIRD: the minion.town UI, especially the clip gutter and the clip iframe, with clips hosted under ocap.site.
4. BACKGROUND (must keep progressing): Endo SturdyRef (security: retire the formula-identifier/locator guest API surface), byte arrays, streams; OCapN progress.
5. TRAILING MOONSHOTS (alive, behind everything above): endor (metering, explorative), ironhorse, thixotrope, slot machine.
6. SLIVER: the off-mandate endo-but-for-bots backlog, staged gauntlets only.

This is discretionary guidance for step selection, not a hard gate. It supersedes no safety or review discipline.

## Separate arcs

The maintainer chose **three separate minion.town arcs**, not one combined arc. Separate arcs make the foreman follow the order (the selector draws by rank), at the cost of not moving budget between the three slices automatically as readiness changes. Moving budget between them takes a re-slice.

## Standing per-reset directive

kriskowal, 2026-10-02: "Going forward, keep distributing tokens to this ranking as capacity becomes available each reset, not just as a one-time apportionment."

How this is mechanized:
- The armed `accountant-weekly` schedule (`weekly-at-Sat-09:00-America/Los_Angeles`, 6h after the Claude endolin reset) runs `set-apportionment.sh --carry-forward` first. That rolls this exact slate (ranking, shares, authorization) to each new week, so the ranking never lapses while waiting on a human. The schedule body quotes this directive and points at this record.
- **Limit:** `--carry-forward` rolls the **total unchanged** (500M). Re-sizing the total to each week's actual capacity (calibrated caps, reset credits, a paused or unpaused codex) is the weekly accountant's judgment step. Under this standing directive it may re-apply the same ranking at a new total with `authorized_by: kriskowal`. The tool has no mid-week trigger on the off-cycle resets (claude-oros Tue 04:00 America/Denver; codex-endolin rolling 7 days). Capacity those resets free is spent through the admission and backoff layer, inside the existing slices, until the next weekly roll or a re-slice.

## Policies in force

- Spend each subscription to **90%, never 100%**. The last 10% is the maintainer's discretion (`planning_ceiling: 0.9`).
- Use **reset credits mid-week, before they expire** (inventory: `projects/garden/reset-credits.md`).
- **Hold the claude-endolin2 credit (expires 2026-10-22) for mid-week** use.
- Exhausted slices hold. No borrowing across arcs or weeks, and in-flight work is never cancelled.
