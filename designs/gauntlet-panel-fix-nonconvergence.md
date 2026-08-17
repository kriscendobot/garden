# Finding: why the gauntlet panel/fix loop does not converge

| | |
| --- | --- |
| Created | 2026-08-17 |
| Author | researcher (gardener, job `garden-gauntlet-panel-fix-nonconvergence`) |
| Status | Report — awaiting maintainer choice |
| Scope | `scripts/jobs/gauntlet.sh`, `scripts/jobs/gardening/panel.sh`, the juror seats |

## The pattern

Four independent PRs halted with the identical signature inside ~30 hours:

| gauntlet | halted | max_iterations |
| --- | --- | --- |
| `endojs-endo-but-for-bots-pr995-gauntlet`             | 2026-08-16T10:35Z | 6 |
| `endojs-endo-but-for-bots-pr997-gauntlet`             | 2026-08-16T14:26Z | 6 |
| `endojs-endo-but-for-bots-pr286-cli-verb-rework-gauntlet` | 2026-08-17T17:35Z | 6 |
| `endojs-endo-but-for-bots-pr1019-gauntlet`            | 2026-08-17T20:05Z | 6 |

Halt reason, verbatim in all four: *"the panel/fix loop did not converge in 6
rounds (fix round 6 done, would start panel round 7 > max_iterations=6)."*

Four PRs hitting the same ceiling is a property of the **loop**, not of four
coincidentally hard changes. The evidence bears that out.

## Verdict: this is (a) — the panel keeps moving the target

Of the three hypotheses the job posed:

- **(a) the panel keeps moving the target** — **SUPPORTED, primary.** Each round
  raises a *different* set of findings rather than converging on a shrinking fixed
  set. No finite iteration cap would suffice.
- **(b) the cap is simply low** — **NOT supported.** Findings do not converge to
  zero; the request-changes count is roughly flat/noisy round over round, not
  monotonically shrinking. Raising `max_iterations` to 7 or 8 would burn two more
  ~$4–6 rounds and halt again.
- **(c) a specific unsatisfiable finding** — **partially, as a mechanism, not a
  single item.** Whole *classes* of finding recur (style nits, stale-base
  artifacts) because the loop's own actions regenerate them each round.

### Evidence: the finding set is different every round

Round-by-round on **PR #995** (a 2-file design-doc PR, `design(endo-claude)`):

| round | panel kind / seats | headline must-fixes (disjoint from neighbors) |
| --- | --- | --- |
| 1 | design / 7 | unanimous request-changes; convergent must-fixes |
| 2 | **code / 28** | 8 convergent must-fixes over a **17-file** diff |
| 3 | design / 7 | `infer` export shape stated 3 ways; 51 em-dashes |
| 4 | design / 28(?) | `ENDO_SOCK` scrub not a boundary; argv invariant unsatisfiable |
| 5 | design / 7 | `eval`/`define` deny only client-side; README.md:9 markdown break |
| 6 | **code / 28** | argv equality self-falsifying; `types.d.ts` omitted; CapTP-unpassable error |

The round-5 and round-6 must-fix lists share **no items**. Round 6 is a 28-seat
*code* panel that raised findings the seven design seats of round 5 never look
for. This is not a loop closing on a fixed point; it is a fresh critique each
round.

The other three show the same shape. **PR #1019** ran a *consistent* 7-seat
design panel every round (no kind-flip) and *still* did not converge: the
`copyeditor`/`pedant` seats flagged em-dashes and glyphs in round 1, `pedant`
approved in round 4, and both flagged **newly introduced** em-dashes again in
round 6 — because fix round 6 rewrote the doc **+207/−113 lines**. The fixing
regenerates the very nits the style seats block on.

## The three mechanical causes

**1. The disposition rule is a single-blocker over a large jury, with no severity
floor.** `decide_disposition()` (panel.sh) applies: *"any concrete
request-changes finding is 'must-fix' and blocks the panel."* One seat out of
7–35 is enough to force another fix+panel round. The seats return
`approve` / `request-changes` / `comment-only` with **no must-fix vs should-fix
severity gate at the disposition boundary** — a `copyeditor` requesting changes
over em-dashes blocks exactly as hard as a `critic` finding arbitrary code
execution. With a fresh fan-out of many independent critics each round, the
probability that *all* of them approve is ≈0, so the loop is structurally
near-non-terminating regardless of the cap.

**2. No cross-round memory.** Nothing in `panel.sh` or the panel skills carries a
"previously raised / deferred / do not re-raise" ledger between rounds (confirmed
by grep — no such mechanism exists). Every round is a stateless re-review of the
whole diff. A finding deferred as should-fix in round 3 can resurface as a
blocking request-changes in round 5 from a different seat, and a section rewritten
to satisfy round *N* is fair game for a brand-new critique in round *N+1*.

**3. Panel-kind flips from a stale base ref, inflating cost and spurious
findings.** `sense_panel_kind()` calls the panel *design* when every changed path
is under `designs/`, else *code*. It reads the diff against the base ref. The
gauntlet dispatches the base as the bare branch `llm`; `panel.sh` normalizes that
to `origin/llm` — but in the warm-cache fork clone **`origin/llm` is itself
stale** (PR #997 round 6: `origin/llm` lagged upstream by ~502 commits →
3431-file diff → mis-sensed as a code panel producing false must-fixes against
files not in the PR; PR #995 rounds 2 and 6 likewise ran 17-file/28-seat code
panels over a 2-file design PR). The already-landed
`fix(panel): normalize a bare local base branch` maps `llm`→`origin/llm` but the
true base is **`upstream/llm`**; the fix is insufficient. Effect: the same PR is
reviewed by *different juries on different diffs* across rounds, which alone
guarantees the finding set churns.

## What a halt actually costs (the load-bearing observation)

**A halt does not leave the PR worse — it leaves it improved but unfinished.**
Every fix stage in all four gauntlets reported `fix=done` with fixes committed,
pushed to the PR head, and CI green (e.g. PR #1019 fix-4 and fix-6: "rc 0,
GREEN"). The branch is not dirty or half-applied. Decisively,
**PR #995 MERGED on 2026-08-17T05:23:32Z, after its gauntlet halted** — the halt
did not block the PR; a human simply merged the (by-then well-hardened) result.

So the halt is **mostly harmless to the PR** and its per-round fixes carry real
value. The cost is **tokens and a false-alarm**:

| gauntlet | stages | total cost |
| --- | --- | --- |
| pr995  | 13 | **$61.72** |
| pr997  | 13 | **$47.13** |
| pr286  | 13 | **$59.08** |
| pr1019 | 13 | **$35.54** |

~$51 per gauntlet, ~**$203 across the four**, each ending in a maintainer-inbox
*HALTED* alert classified as a **failure** (`orchestration-status: halted`). Under
the active budget pause (`jobs/plan/ironhorse-campaign-paused-20260816`), twelve
model-backed rounds that end in a failure-flagged halt are the expensive part —
not the PR outcome. The last two rounds especially add marginal hardening over a
PR that was already mergeable by round ~4 (see #995).

## Recommendation: make the halt cheaper and quieter — do NOT lengthen the loop

Because the evidence supports (a), raising `max_iterations` cannot fix it and only
raises the cost of the inevitable halt. The high-value, low-risk moves, in order:

1. **Reframe the terminal halt as a near-success, not a failure, when fixes
   landed and CI is green.** After the final fix round the PR is improved and
   CI-green; that is the #995 state that a human merged. Change `halt_gauntlet`'s
   non-convergence path to emit a **quiet, INFO-level "review budget reached —
   PR left improved and CI-green, N rounds applied, ready for human merge
   decision"** notice rather than an `orchestration-status: halted` failure. This
   is the "make the halts quieter" outcome the job flagged as valid. *(Cheapest
   change; addresses the actual cost, which is the false alarm.)*

2. **Lower the default `max_iterations` from 6 to ~3–4.** Since findings do not
   converge, the marginal rounds mostly re-harden an already-mergeable PR at
   ~$4–6/round. Stopping at 3–4 captures most of the value for roughly half the
   spend and reaches the "hand to a human" state sooner. *(Trades a little
   hardening for ~40–50% cost reduction per gauntlet.)*

3. **Fix the base-ref sensing so a design PR is never mis-panelled as code.**
   Resolve the base against the *upstream* remote's branch (or the PR's actual
   GitHub base ref via `gh pr view --json baseRefName` + the upstream remote),
   not `origin/<base>` in a stale fork clone. This removes the 17-to-3431-file
   spurious diffs, the wasted 28-seat code panels on 2-file design PRs, and a
   large share of the round-to-round finding churn. *(A real bug regardless of the
   convergence policy; the prior `origin/llm` fix is documented-insufficient.)*

4. **Add a severity floor to the disposition (optional, larger change).** Gate
   `must-fix` on a request-changes finding the deciding `claude -p` classifies as
   genuinely **blocking** (correctness / security / API-contract), letting
   style-and-polish request-changes (em-dashes, grammar, glyphs) ride as
   should-fix that do not force another round. This is the direct antidote to the
   single-blocker structural non-termination, but it changes what "passes" means
   and overlaps the `evaluation-epochs-panel-calibration.md` rubric-versioning
   surface, so it wants maintainer calibration, not a unilateral edit.

Options 1–3 are safe and clearly indicated by the evidence. Option 4 is the
deepest fix but a policy change the maintainer should choose and calibrate. This
report stops here rather than implementing, per the job's "report and let the
maintainer choose" instruction, because the choice among cheaper-vs-quieter-vs-
stricter is a budget/quality tradeoff only the maintainer should set.

## Aside: the fifth gauntlet is unrelated

`kriscendobot-minion.town-pr39-gauntlet` halted for a **different** reason — its
`panel-1` stage was requeued to exhaustion and doomed
(`doomed-…-pr39-gauntlet-panel-1-requeue-exhausted`), i.e. the panel stage never
completed a round, not a non-convergence over six. A panel stage dooming is an
infrastructure/flake concern (seat `claude -p` failures, handler budget), tracked
separately from the loop-convergence question above.
