---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Maintainer directive (kriskowal, 2026-09-08): backfill PR completion receipts
retroactively, extend the receipt schema for a cost-attribution nuance on
unsuccessful PRs, and use the completed corpus to answer a real question:
do PRs substantially carried by the local `hermit`/`qwen3.6` worker tend to be
more or less expensive overall than comparable PRs carried by other tiers —
a total dominated by the maintainer-review-effort (MRE) heuristic, not raw
tokens.

## What already exists (read `designs/pr-completion-receipts.md` and
`scripts/jobs/pr-receipt.sh` before starting — don't rebuild what's there)

- The generator (`pr-receipt.sh`) and its trigger (`receipt-watcher.sh` +
  `garden-receipt-watcher@<repo-slug>.timer`, one per repo in
  `config/comment-repos`) are already built and **already running** — 15
  timers are live across every comment-watched repo, ticking every ~5 min.
- **23 receipts already exist** under `journal/receipts/<repo>/<year>/<month>/`
  (kriscendobot/garden, kriscendobot/minion.town, endojs/endo-but-for-bots),
  spanning July-September — some from the original 10 backfilled examples,
  some auto-generated live since the watcher armed.
- **The watcher deliberately does NOT backfill history** — its own design
  seeds the cursor forward on first tick "no historical flood." That means
  the overwhelming majority of PRs closed/merged BEFORE each repo's watcher
  armed have no receipt at all. That gap is what "retroactively fill them in"
  means here.
- Per-engagement cost basis (notional vs. calibrated) reuses `cost-by-pr.sh`
  (see its `--base-map` mode, added for exactly this join). The MRE heuristic
  (`M = S·a + C·b + L/r`, priced at H $/hr) reads real `gh api` human-feedback
  endpoints — this is the number the maintainer's question above says should
  dominate the total; don't let a comparison get drowned by raw token cost
  when MRE is the bigger number.

## Part 1 — Retroactive backfill

Generate receipts (via `pr-receipt.sh --force`, or whatever backfill mode it
already supports — extend it minimally if it has no bulk/backfill mode yet)
for PRs that closed or merged before each repo's receipt-watcher armed and
still have no receipt under `journal/receipts/`. Prioritize, in order:

1. **Every PR `hermit`/`qwen3.6` had a real engagement on** — cross-reference
   `reputation/arms/hermit/local/qwen3.6/` and the underlying
   `reputation/events/*.md` records naming it, then trace each to its PR (via
   `cost-by-pr.sh`'s join). This set must be complete — it's the numerator for
   Part 3 below.
2. **A comparison sample of similar-shaped PRs NOT carried by hermit** (same
   repos, comparable work classes — `build:m`/`build:l`/`fix:*`/`weave:*` —
   carried by monk/cleric/mystic instead), sized to support a real comparison,
   not necessarily every historical PR in the repo.
3. Broader historical backfill beyond that (if budget allows) is a nice-to-have,
   not a blocker for Part 3 — the watcher now covers everything going forward,
   so an incomplete broad backfill only affects retrospective analysis depth,
   not future coverage.

## Part 2 — Extend the receipt schema/generator for unsuccessful PRs

Today's design treats "merged or closed" uniformly. Add a qualitative
dimension for a **closed-without-merge** PR specifically — the maintainer's
framing: most receipts are for the cost of successful designs and builds, but
an unsuccessful one still needs a receipt when either:

- it indicates the design/build was bad enough that its cost effectively
  **rolled forward** onto a later attempt (the failure taught nothing new and
  someone had to redo the work from a later, informed-by-nothing-here
  starting point), or
- it **genuinely helped** — a failed attempt that meaningfully redirected a
  later, successful design (the cost bought real information, even though
  this specific PR didn't land).

Define a concrete, evidence-based way to classify which of these applies (read
the closing comment/reason, whether a later PR explicitly cites or supersedes
this one, whether the later PR's approach differs materially from this one's)
— not a guess per PR. Add this as a field/section on the receipt for closed
PRs, and update `designs/pr-completion-receipts.md` to document the addition.

## Part 3 — The actual comparison

Once the backfill gives adequate coverage: compare the **total cost per PR**
(dominated by MRE, per the receipt's own numbers) for PRs substantially
carried by hermit/qwen3.6 versus the comparison sample. Substantially carried
means hermit did the primary design/build engagement, not an incidental
role. Report:

- Mean/median total cost per PR, hermit-carried vs. not, same work-class
  buckets where possible (don't compare a `build:l` against a `fix:s`).
- Whether hermit-carried PRs show a different MRE profile specifically (more
  review rounds / more maintainer comment volume needed to get to a mergeable
  state) — this is the maintainer's actual hypothesis: is a "free" local model
  secretly expensive because of the human attention it costs to shepherd,
  even when its own token cost is near zero?
- Fold in the Part 2 classification for any closed-without-merge hermit PRs —
  did any of hermit's failures roll cost forward, or did they redirect
  productively?

Write the findings as a report (a `designs/*.md` or a plain analysis doc —
your call on the right home for it) with the real numbers and PR citations,
not just a verdict. This feeds directly into the separate mentor-tier trial
job (`qwen-mentor-tier-trial`) — don't duplicate that job's scope, but flag
anything here that trial should account for.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-08T23:45:27Z
