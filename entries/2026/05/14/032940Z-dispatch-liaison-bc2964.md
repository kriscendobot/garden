---
ts: 2026-05-14T03:29:40Z
kind: dispatch
role: liaison
project: garden
to: "*"
---

# Dispatch: gardener automates pr-creation-flow chaining (systemic repair)

Dispatch root: `dispatches/gardener--automate-pr-creation-flow-chaining--20260514-032940--bc2964/`.

The maintainer flagged that PR #243 didn't trigger the usual PR-creation-flow workflow after the builder opened it — no jury, no fixer, no cleaner. Same pattern on #240 (turbo amendment), #238 (rps demo), #242 (syrup-framing consumer), #239 (endo#1967 mirror), #236 (Gateway), #237 (Lal/Jessie/Blocky design), #241 (Familiar VFS design). Every recently-opened garden draft PR is orphaned in the flow.

> "That seems like a systemic failure of the garden I would like to see repaired."

## Root cause analysis (start from this hypothesis)

`skills/pr-creation-flow/SKILL.md` describes the four-stage flow (builder → jury → fixer → cleaner) and says the cleaner un-drafts. But nothing in the active library *automatically drives* a PR from one stage to the next:

- The orchestrator (liaison or steward) has to remember to dispatch the jury after a builder return. In practice the in-session liaison forgets, especially when a builder dispatch is one of many concurrent dispatches.
- The steward has the standing-monitors and the inbox-drain, but nothing telling it "scan garden-authored draft PRs and dispatch the next missing stage."
- No state tracker says which stage a PR is at; the `state:building` / `state:in-review` / `state:fixing` / `state:cleaning` / `state:ready` labels the skill mentioned are advisory and unused in practice.

## Tasks

Pick whichever shape (one or more) reads cleanest after you survey the existing role files:

### A. Make the orchestrator responsibility explicit

Update `skills/pr-creation-flow/SKILL.md` so the orchestrator's role in chaining is the load-bearing rule (currently the discipline is described but the responsibility is unclear). The orchestrator (steward, primarily; liaison when in-session) is responsible for the chain: after a builder dispatch returns with a draft PR, dispatch the jury before the cycle closes; after the jury returns with reviews, dispatch the fixer if there are in-scope complaints; after the fixer returns, re-dispatch the jury; loop until clean; then dispatch the cleaner; when the cleaner un-drafts, the chain is done.

Word it strongly: "every garden-authored draft PR has an open ticket until it leaves draft or is closed."

### B. Add a per-cycle scan to the steward

Update `roles/steward/AGENT.md` § Per-cycle procedure with a new step: scan garden-authored open draft PRs across the standing-monitored repos (today: `endojs/endo-but-for-bots`). For each, identify the next stage owed (no jury review yet → dispatch jury; jury complaints exist but no fixer in flight → dispatch fixer; fixer returned + CI not yet green → re-dispatch shepherd or wait; CI green + jury satisfied → dispatch cleaner).

The detection can be cheap:
- "no jury review yet" = `gh pr view <N> --json reviews -q '.reviews[] | select(.author.login=="kriscendobot")' | wc -l == 0`.
- "jury complaints exist" = reviews from kriscendobot with `state: COMMENTED` whose body indicates complaints (heuristic; the simpler form is "every juror/saboteur review has either resolved its threads or not, and unresolved threads warrant fixer").
- "CI green" = `statusCheckRollup` all SUCCESS or NEUTRAL.

For each PR in flight, the steward writes one `dispatch` entry and invokes one `Agent` per stage owed.

### C. Optional: PR-label state tracking

The skill's `state:<stage>` labels could become load-bearing rather than advisory. Each dispatched role sets the label on entry (`state:in-review` when jury starts) and unsets on exit. The steward's scan becomes a label query, not a review-history scan. Tradeoff: more PR-side state to maintain; cleaner semantics.

Pick (C) if the heuristics in (B) feel fragile; otherwise (B) is simpler.

### D. Inventory + documentation

Update `roles/liaison/AGENT.md` to say: when the liaison dispatches a builder, it shares the chaining responsibility with the steward; if the steward is autonomously running, the liaison may delegate by writing a `message` to steward naming the PR; otherwise the liaison drives the chain itself.

## Out of scope

- Do NOT retroactively dispatch jury / fixer / cleaner for the orphaned PRs (#240, #238, #242, #239, #236, #237, #241) — the in-session liaison can clean those up after the systemic fix lands.
- Do NOT modify the existing per-role behavior (juror's discipline, fixer's discipline, etc.) beyond what the chaining requires.
- Do NOT add a new role; the chaining lives in the steward (and the liaison's `message`-to-steward path).

## Style + flow

Em-dash sweep, frontmatter, relative paths.

## Commits

Suggested split:
- `pr-creation-flow: make orchestrator chaining responsibility load-bearing`
- `steward: per-cycle scan for orphaned garden draft PRs + chain dispatches`
- (optional) `pr-creation-flow: state:<stage> labels become load-bearing`
- `liaison: chaining responsibility shared with steward`

Push at end. One result entry on journal.

## Report

Skill / role file paths edited, the detection heuristic chosen (review-history vs label-based), the orphan-PR list you noted but did NOT retroactively remediate, one-line verdict: "does the next builder dispatch trigger the full flow without the in-session liaison remembering?"
