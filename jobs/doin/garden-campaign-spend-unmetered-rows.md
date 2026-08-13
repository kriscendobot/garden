---
tier: mentor
priority: urgent
fallback-tier: minion
dispatch: automatic
---
# Fix: campaign-spend.sh must tolerate unmetered engagement rows

Repository: **the garden itself** (`kriscendobot/garden`, branch `main2`, pushed
directly — no PR; see CLAUDE.md § Conventions). Work in a per-job worktree; never
run git in `$GARDEN_ROOT`.

## The bug

`scripts/jobs/campaign-spend.sh` **fatals** on any usage row that carries no token
accounting, which kills the whole campaign it is metering. This just stopped the
Ironhorse campaign at child 2 of 18 with `orchestration-status: budget-meter-incomplete`
and `campaign-spend-tokens: unknown`:

```
[campaign-spend] FATAL: usage/ironhorse-js-11-strings.jsonl line 1
                 is an unmetered or invalid campaign row
```

The offending row is a perfectly ordinary successful engagement by a **cleric**
worker (`provider: openai`), which emits no token counts:

```json
{"ts":"2026-08-13T22:24:59Z","base":"ironhorse-js-11-strings","host":"endolin-garden-ece02cb4","outcome":"tada","source":"none","elapsed_s":842}
```

The child itself **succeeded** (+182 covered cases, 0 failures). Only the meter failed.

## Why it is a bug, not a policy

The row-level guard at `campaign-spend.sh:79` `die`s when `.source == "none"` or
when every token field is null. But the aggregator immediately below it (`:86`)
already seeds its reduce with an **`unmetered:0` counter that nothing ever
increments** — because the guard fatals before any row can reach it, and the
counter is surfaced in the output object at `:140`. The intended design is plainly
*count unmetered engagements and carry on*; the guard is stricter than the schema
it feeds.

As written, **any** budgeted campaign wedges the moment a non-Anthropic worker
claims a child — the cleric/minion fallback tiers and the campaign meter are
mutually exclusive today.

## What to do

Make an unmetered row **counted, not fatal**:

- A row that is well-formed but carries no token accounting (`source: "none"`,
  and/or all four token fields null) increments `unmetered` and contributes zero
  tokens — it must not `die`.
- Genuinely **malformed** rows must still fail loudly: non-object JSON, missing or
  invalid `ts`, a token field that is present but negative / non-integer / not a
  number, a present-but-invalid `total_cost_usd`. Do not weaken those checks.
- Propagate `unmetered` through to the campaign summary and into whatever
  `orchestrate.sh` writes into the orchestration report, so an under-metered
  campaign is **visibly** under-metered rather than silently cheap. A campaign
  whose spend excludes N unmetered engagements should say so.
- Check whether `orchestrate.sh` needs a matching change to report the count; if it
  reads the summary object, surface the field rather than inventing a second path.

Add regression tests alongside the existing campaign-spend tests: an unmetered row
is counted and not fatal; a mixed ledger sums only the metered rows; each malformed
shape still fails.

## Definition of done

`campaign-spend.sh` returns a real total for a ledger containing unmetered rows,
reports how many were unmetered, still rejects malformed rows, tests pass, and the
change is pushed to `main2`. This blocks the Ironhorse relaunch
(`ironhorse-resume-6-launch`), so report the pushed commit SHA in your completion
report — the launch job checks for it in the deployed root.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 3
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-08-13T22:42:53Z
