---
role: builder
tier: mentor
fallback-tier: minion
handler-timeout: 10800
dispatch: automatic
---
# Why do panel must-fix counts oscillate instead of descending?

18 gauntlets have halted with "the panel/fix loop did not converge in 6 rounds".
Before anyone raises `max_iterations`, establish WHY the loop does not converge —
the evidence says more rounds would mostly buy more expensive rounds.

## The measured trajectories (do not re-derive)

Per-round `must_fix_total` from `journal2` `panel-runs/`, in commit order:

    endojs/endo-but-for-bots#1018:  14 -> 14 -> 17 -> 14 ->  3 ->  5
    endojs/endo-but-for-bots#231 :  17 -> 16 -> 16 ->  7 -> 14 ->  7

Both dip and then BOUNCE BACK UP. Neither approaches zero. Each round ran against
a different head (#1018: be17297e, c06d614b, 87573751, 6815f03f, fd4c5a49), so
fixes were genuinely landing between rounds.

Ruled out already, do not redo: errored panel runs do NOT consume an iteration.
#1018 and #231 each ran exactly `clean` + `panel-1..6` + `fix-1..6`; the extra
panel-run record is a retried `panel-1`. The retry works as designed.

## The question

Two explanations fit the data and they have OPPOSITE remedies:

1. **The fixer introduces new findings.** Each fix round genuinely creates fresh
   must-fix material, so the panel is correctly reporting new problems. Remedy:
   constrain the fixer's blast radius, or re-panel only the changed surface.
2. **The panel is nondeterministic.** Substantially the same items resurface
   against a barely-changed head because seat verdicts vary run to run. Remedy:
   stabilise the seats or the disposition rubric — and more rounds would never
   converge.

Distinguish them by DIFFING THE ACTUAL ITEMS, not the counts. For #1018 and #231,
extract the must-fix items per round and classify each round's set:

- carried over unchanged from the previous round (fixer failed to address it),
- genuinely new and attributable to the previous fix's diff,
- reappearing after having been absent (nondeterminism, or a regression).

The third category is the discriminator. Report the counts in each category per
round; that number decides the remedy.

## Notes

- A mixed answer is plausible and fine — say what proportion is which.
- If nondeterminism dominates, quantify it: re-run one panel twice against an
  IDENTICAL head and compare the item sets. That is the cleanest possible
  evidence and worth the cost.
- Do NOT raise `max_iterations` as the deliverable. If the finding genuinely
  supports it, recommend it with the evidence and let the maintainer decide.

## Definition of done

A written finding naming which explanation dominates, with the per-round item
classification behind it, and a recommended remedy proportionate to the cause.
Cite the runs and the commands. A clear negative result ("cannot distinguish,
here is why and here is what would") is acceptable; a guess dressed as a
conclusion is not.

<!-- garden-transient-elapsed: kind=signature through=0 values=1 -->

<!-- garden-reaped: 1 -->
