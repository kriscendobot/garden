---
role: gardener
tier: mentor
fallback-tier: minion
dispatch: automatic
handler-timeout: 7200
token-budget: 250000
---
# Fix misleading spend/cap units in codex-endolin's budget-live snapshot

Repository: `kriscendobot/garden`, branch `main2` — land direct, no PR.
Isolated project worktree (`ensure-project-worktree.sh <base>
kriscendobot/garden main2`); never git against `$GARDEN_ROOT`.

## The confusion, found live

`scripts/jobs/usage-meter.sh`'s modern per-pool budget-live publisher (the
loop around the `openai:percent` case, near the `commit_and_push
"budget-live($GARDEN) $status spend=$spend/$cap"` line, roughly line 730)
correctly computes `used_percent` for a `percent`-kind pool (codex-endolin)
and correctly gates on it (`meter_verdict "$used_percent" 100`) — the
`status: backoff` decision itself is right; confirmed live,
`budget/live/codex-endolin/endolin-garden-ece02cb4` currently shows
`used_percent: 95.0`, a genuine near-exhaustion, correctly triggering
backoff.

But the commit message and the persisted snapshot's `spend:`/`cap:` fields
print the RAW `$spend` (a codex-scan token/request count, e.g. 48285769) next
to `cap=100` (the percent ceiling) — units that don't correspond to each
other. Read side by side (`budget-live(endolin-garden-ece02cb4) backoff
spend=48285769/100`) this reads as catastrophic over-cap when it is actually
a correctly-gated 95%-of-quota state; it cost real investigation time to
confirm this wasn't a claim-blocking bug (it wasn't — `used_percent` was
right all along, only the label was misleading).

## What to do

Make the commit message and the persisted `spend:`/`cap:` fields honest for
BOTH pool kinds: for `anthropic:weekly-tokens` (`spend=<tokens>/<cap-tokens>`
is already correct, leave it), and for `openai:percent`, print something
that pairs correctly — e.g. `spend=<used_percent>%/100%` in the commit
message, and consider whether the persisted file should keep the raw codex
count under a differently-named field (e.g. `raw_spend:`) rather than
`spend:`, so a reader comparing `spend:`/`cap:` together never gets
mismatched units again. Check every other reader of
`budget/live/<pool>/<host>`'s `spend:` field (`meter_remote_snapshot_total`
and its callers in `budget-level.sh`) before renaming anything — if code
depends on the field name/shape, change it carefully with matching test
updates, not just the display line.

## Tests

Extend whatever test already covers this publisher (find it — likely a
usage-meter test) with a case asserting the openai:percent branch's
commit-message and persisted-field units are self-consistent. Run the full
relevant suite before completing.

## Report

Confirm the fixed output for a live example (re-derive it, don't just quote
this job body) and name the landed commit.
