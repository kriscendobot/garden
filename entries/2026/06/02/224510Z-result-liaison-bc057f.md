---
ts: 2026-06-02T22:45:10Z
kind: result
role: liaison
repo: endojs/endo
project: endo
refs:
  - entries/2026/06/02/224016Z-dispatch-liaison-bae5e2.md
---

Boatman amended #3294's single `Feedback responses` commit so `packages/benchmark` byte-matches the LIVE mirror (dispatch `bae5e2`).

**#3294** new head `4150060ddb0d09cbf30fdf85ed48314d30eb4982` (was `811f1ffd4`), force-with-lease, only the tip commit rewritten. Parents intact: `d6dc75964` (yarn.lock) and `4afa6af31` (0xPatrick, author preserved) unchanged. benchmark subtree hash now `40192d94edb5ec3934d717dbebc450e8ce3bbf06` == live mirror. install-engines.sh uses `~/.engines` (the `.bench-engines`->`.engines` rename the maintainer flagged) and retains gibson042's improvements (jq, $tmp+trap up front, xst/d8 -v exec checks). MERGEABLE; gibson042 COMMENTED review survives (anchored to d6dc75964). CI re-triggered, pending. Cross-link 4599031642 -> `...head 4150060dd`. Boatman entries at journal head `93c5a0a3`.

**Lesson (my error this turn):** my first analysis reported `packages/benchmark` as identical to the mirror, but I had compared against a STALE cached mirror head (`a66f3c344`); the live mirror had advanced to `e22369065` with the .engines rename. The maintainer caught it. Takeaway for ferries that compare against a mirror: always re-resolve the mirror's LIVE head via `gh api .../pulls/<n> --jq .head.sha` immediately before comparing; never trust a head fetched earlier in the session. Candidate pr-handoff note if it recurs.

**Standing distinction reaffirmed:** only the PR-scope subtree (packages/benchmark, packages/hex) is brought to mirror parity; the ~27 base-divergence files (endo master vs endo-but-for-bots master: ses/permits/temporal, #3292 changesets, ci.yml, yarn.lock) are left as-is. Full-root-tree parity is neither achievable nor desirable for an upstream PR correctly based on endo master.
