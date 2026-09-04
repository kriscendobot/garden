# Finding: why the gauntlet panel/fix loop does not converge

| | |
| --- | --- |
| Created | 2026-08-17 |
| Author | researcher (gardener, job `garden-gauntlet-panel-fix-nonconvergence`) |
| Status | Report — awaiting maintainer choice (extended 2026-09-04, see Follow-up) |
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

---

## Follow-up (2026-09-04): item-level discrimination — is it a churning fixer or a nondeterministic panel?

| | |
| --- | --- |
| Author | builder (gardener, job `diagnose-panel-fix-loop-oscillation`) |
| Status | Report — refines the verdict above with per-item evidence |
| Question | The `must_fix_total` **counts oscillate** (dip then bounce, never reach 0). Two explanations with opposite remedies: **(1) the fixer creates genuinely new must-fix material** each round (remedy: constrain the fixer's blast radius); **(2) the panel is nondeterministic** — the same items resurface against a barely-changed head because seat verdicts vary run to run (remedy: stabilise the seats; more rounds would never converge). |

The measured trajectories the job posed, per-round `must_fix_total` from
`journal2 panel-runs/` (both are **design** panels — prose docs, not code):

    endojs/endo-but-for-bots#1018 (designs/ironhorse-panic.md):  14 -> 14 -> 17 -> 14 ->  3 ->  5
    endojs/endo-but-for-bots#231  (designs/familiar-release.md): 17 -> 16 -> 16 ->  7 -> 14 ->  7

(Heads #1018: `be17297e c06d614b 87e0d79a 87573751 6815f03f fd4c5a49`; #231:
`e6912e4a 64eed591 07c19a83 5257f9fb f354fa99 09fb85c7`. The one extra record per
PR is the `disposition: error` retried `panel-1`, confirmed and excluded.)

### Verdict: explanation (2) dominates — nondeterminism — and the count itself lies

The oscillation is driven by three mechanisms, **in decreasing order of contribution**, none of which is chiefly "the fixer creates new must-fix material":

**A. `must_fix_total` is not a must-fix count (measurement artifact, code-confirmed).**
`scripts/jobs/panel-run-record.sh` computes the total in `seat_titles()`: for any
seat whose *overall* Verdict line reads `request-changes`/`must-fix`, it counts
**every** bullet line in that seat's block — including that seat's own
`[should-fix]` and `[comment-only]` bullets — and, via its `END { if (!found …) emit(fallback) }`
branch, emits the seat's **first non-blank line as a title when the seat wrote no
bullets**, which captures section headers and "None" lines. The raw item dumps
show this directly: `- decomplector: ## Per-juror block: decomplector` (#1018 R1,R2),
`- critic: ## Critic block — PR #1018` (#1018 R2), `- copyeditor: None — the mermaid diagrams…` (#1018 R3),
`- critic: None — this is a design-only PR…` (#1018 R4), `- skeptic: ## Per-juror block: skeptic` (#1018 R5,R6),
`- decomplector: None — the design's other modeling choices…` (#231 R2),
`- skeptic: ## Per-juror block — skeptic` (#231 R6), plus many self-labeled
`**[should-fix]**` / `**[comment-only]**` bullets counted as must-fix throughout.
So the number the maintainer is staring at when deciding "raise `max_iterations`?"
overcounts true must-fix findings by roughly a third, and a single seat crossing
into a must-fix *verdict* injects that seat's **entire** bullet-set at once — a step
change in the total unrelated to any real blocking finding. Much of the "bounce"
is this. (Note: the loop's actual halt/continue decision keys off `decide_disposition`
= "any must-fix seat blocks," **not** off this count — so this is an
observability/decision-support defect, not a control-flow bug. But the job's whole
premise, "the counts oscillate," is partly an artifact of this miscount.)

**B. Seat verdicts are nondeterministic on a barely-changed surface (the discriminator, git-confirmed).**
The job named category 3 — *reappearing after having been absent* — as the
discriminator. The cleanest instance is objective and reproducible with `git grep`,
needing no subjective item-matching. The `pedant` seat blocks on em-dashes (a hard
project style override). Em-dash count in `designs/ironhorse-panic.md` versus the
pedant's round verdict, #1018:

| round | head | em-dashes in doc (`git show <h>:… | grep -o — | wc -l`) | pedant verdict |
| --- | --- | --- | --- |
| R2 | `c06d614b` | 17 | **must-fix** ("em-dash violated 17 times") ✓ |
| R4 | `87573751` | **30** | comment — **not flagged** ✗ |
| R5 | `6815f03f` | **53** | comment — **not flagged** ✗ |
| R6 | `fd4c5a49` | 65 | **must-fix** ("em-dash … 63 times") ✓ |

An objectively-countable, **monotonically worsening** violation (17→30→53→65) is
blocked in R2 and R6 but silently passed in R4 and R5. Whether the seat's verdict
lands `must-fix` vs `comment` on essentially the same (worse) condition is
unstable — and because of mechanism **A**, that one verdict flip swings the total
by the seat's whole bullet-set. This is explanation (2) in its purest form, proven
without re-running anything. (Corroborating counterpoint, honestly reported: on
**#231** the em-dash detection was *deterministic* — em-dashes present only at R3
(10), flagged there, fixed to 0, and stayed 0. So the seat is not uniformly
random; it is unreliable, which is worse for convergence than uniformly noisy.)

Beyond the em-dash proof, the **thematic recurrence** is pervasive: substantially
the same clusters are re-litigated round after round by *different seats at
shifting severities*, not retired. Representative carried/reappearing clusters:

- **#1018** — Formal `Panic` Category "never-match discipline" (critic/ergonomist, R4·R5·R6);
  host-function classification vocabulary "mixes parts of speech" (ergonomist, R1 *comment-only* → R2 → *absent R3* → R4);
  "CAS" used undefined (novice, R1 → *absent R2·R3* → R4);
  WAL-transcript cost/complexity (critic, R1·R3·R6);
  Verification section gaps (skeptic, R2·R3·R4).
- **#231** — G4 Linux `chrome-sandbox` suid / severity understatement (critic·skeptic·ergonomist·decomplector, R1 → *absent R2* → R3·R4·R5);
  `Severity`/`MVR-disposition` field complecting (decomplector·skeptic·pedant, R2·R3 → *absent R4* → R5);
  credential flow "functional and user-tested, zero evidence" (skeptic, R1 → *absent R2* → R3);
  Node-pin staleness (skeptic, R1·R2).

Each `absent → present` transition above is a category-3 reappearance against a
head that did **not** newly introduce the issue — the finding was equally true the
round it went unraised.

**C. Genuinely-new, fixer-attributable material exists but is the minority.**
The largest single new block is **#231 R6**, where the `critic` pivoted from the
design doc's gap analysis to reviewing **`model.js` code** (`resolveModelString:197-231`,
`resolveModel:277-293`, `buildOllamaModel`) — three real findings the five prior
rounds' doc-focused critique never looked for. This is real new must-fix material,
but it is itself a symptom of nondeterministic **surface selection** (the seat chose
a different part of the PR to scrutinise), not the fixer spraying new defects. The
system also demonstrably *works* when a finding is objective and specific: #231's
dead cross-references (`endo-gateway.md`, `skills/verify-upstream-state.md`,
`daemon-node.js`, R1) were fixed and never returned; #231's em-dashes were fixed
and stayed fixed.

**Proportion (of the movement in `must_fix_total`, estimated from the item sets):**
~30–40 % is measurement artifact (A); ~40–50 % is seat nondeterminism — verdict
flips + surface-selection churn on recurring themes (B); ~15–20 % is genuinely-new
material (C), most of it the #231 code-surface shift. **Explanation (2) dominates;
explanation (1) is real but secondary.** Raising `max_iterations` therefore cannot
converge the loop (it re-confirms the report above), and constraining the *fixer's*
blast radius addresses only the ~15–20 %.

### On the identical-head re-run

The job offered a paid identical-head panel replicate as "the cleanest possible
evidence." It was not run, deliberately: the em-dash table above is *stronger and
cheaper* — an objective, `git`-reproducible condition whose seat verdict flips
`must-fix → comment → comment → must-fix` while the condition only worsens, i.e. an
identical-class comparison without the subjectivity of judging item-set
equivalence. A full 7-seat design-panel replicate (≈$4–6, driving the gauntlet
against a pinned head) remains the natural next step **only** if the maintainer
wants to quantify the *subjective* seats' run-to-run variance numerically; it would
not change this verdict.

### Recommended remedy (proportionate to the cause; refines options above)

Do **not** raise `max_iterations`. In priority order:

1. **Make `must_fix_total` count only true must-fix findings (cheapest; fixes A).**
   In `panel-run-record.sh`, parse each bullet's own severity tag
   (`[must-fix]`/`[should-fix]`/`[comment-only]`) and count only must-fix bullets;
   drop the header/`None` `fallback` emission. This alone removes a large share of
   the *apparent* oscillation and makes any future convergence signal honest.
2. **Route objectively-checkable finding classes to a deterministic gate, not an
   LLM seat (sharpest fix for B).** Em-dashes, stray glyphs/arrows, and dead
   intra-repo cross-references are mechanically decidable; a linter/`local-verify`
   gate that either passes or fails them removes the single largest nondeterminism
   source (the em-dash verdict flip) entirely, and stops style nits from
   intermittently forcing a full re-panel round.
3. **Reinforce the two structural fixes this report's parent already named** —
   a **severity floor at the disposition boundary** (cause #4 above: don't let a
   style/polish `request-changes` block as hard as a correctness one) and
   **cross-round memory** (cause #2: carry the prior round's must-fix ledger so a
   seat must mark each prior item resolved/unresolved rather than re-deriving from
   scratch, which is where the verdict and surface-selection nondeterminism enter).
   These are the antidote to the *subjective* recurrence (B) that a linter cannot
   cover; both are policy changes for the maintainer to calibrate, not unilateral
   edits.

Commands cited (run from a `endojs/endo-but-for-bots` worktree and the
`journal2` clone):

    # per-round item sets and verdicts
    for f in journal2 panel-runs/endojs-endo-but-for-bots-1018/*.md; do awk '/verdicts \(7\)|^- /' "$f"; done
    # objective em-dash count per head (the discriminator)
    for h in be17297e c06d614b 87e0d79a 87573751 6815f03f fd4c5a49; do \
      printf '%s %s\n' "$h" "$(git show $h:designs/ironhorse-panic.md | grep -o — | wc -l)"; done
    # the counting defect
    sed -n '105,190p' scripts/jobs/panel-run-record.sh   # seat_titles(): counts all bullets of must-fix seats
