---
ts: 2026-05-14T22:44:00Z
kind: result
role: gardener
project: garden
to: liaison
refs:
  - entries/2026/05/14/224005Z-dispatch-liaison-f84909.md
  - entries/2026/05/14/223823Z-message-boatman-1a3202.md
  - entries/2026/05/14/223719Z-result-boatman-1a294d.md
---

Encoded the boatman host-precondition lesson from dispatch `1a294d` into three commits on `main`.

## Files updated

- `roles/boatman/AGENT.md` (commit `75262fd`): new **Host preconditions** bullet at the top of *Operating norms* with the boatman's verbatim proposal (`gh auth status` shows `kriskowal`, repo permissions show `push: true`, else message-to-liaison and stop; the role's anti-bot-push norm takes precedence over the dispatch's `identity_switch_authorized` flag). New *Notes from the field* section at the bottom with a 2026-05-14 row citing dispatch `1a294d` as the precipitating evidence.
- `CLAUDE.md` (commit `6647e12`): new **Boatman dispatches and host preconditions** subsection under *Dispatch contract*, immediately after the existing *Orchestrator vocabulary* subsection. Names `kmkmbp2021` as the credentialed host (as of 2026-05-14), names the liaison's refusal-and-re-issue behavior on `endolinbot`, cross-links to the boatman's own *Host preconditions* norm and to `journal/projects/endo/README.md` § Identity and credentials.
- `roles/liaison/AGENT.md` (commit `b6d0efc`): one-line norm **Ferry requests on the wrong host** in *Operating norms* (placed after *Don't dispatch what you can answer*, before *Translate user prompts to a role*). Names the trigger (user prompt says "ferry" and `hostname -s` is not `kmkmbp2021`), the action (surface the gap, ask the user to re-issue), and the rationale (boatman would block on its own precondition check anyway). Did not duplicate into the *Vocabulary* § Disambiguation notes: the ferry verb is already described there; the new norm is the routing rule it implies.

## Rebase

Push initially rejected: origin/main had advanced by 13 commits (Vocabulary sections on liaison and steward, understudy carve-out, library-lookup and design-to-pr-pipeline skills, *Orchestrator vocabulary* glossary in CLAUDE.md, others). Rebased onto `origin/main`: one conflict in `CLAUDE.md` where my *Boatman dispatches and host preconditions* H3 collided with the just-landed *Orchestrator vocabulary* H3 at the same insertion point. Resolved by keeping both, in order: *Orchestrator vocabulary* first (already-landed), then *Boatman dispatches and host preconditions*. The liaison-side commit rebased cleanly because the *Vocabulary* section added by `2e5ef9d` sits above *Operating norms* and my norm lands inside *Operating norms*, so no overlap.

## Confirmation that the next ferry-shape prompt on endolinbot surfaces the gap

Yes: a user prompt of the form "ferry endo#NNN" arriving at the liaison on this host (`endolinbot`) now lands the *Ferry requests on the wrong host* norm (`roles/liaison/AGENT.md` § Operating norms). The liaison reads it, checks `hostname -s` against `kmkmbp2021`, and on mismatch surfaces the host-precondition gap and asks the user to re-issue from `kmkmbp2021` rather than dispatching. The boatman's own *Host preconditions* norm is the second line of defense if a dispatch reaches the wrong host anyway.

Self-improvement: nothing this time. The structural lesson the boatman surfaced is exactly what this dispatch encoded; no second-order pattern emerged that warrants a follow-up rule.
