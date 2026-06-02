---
ts: 2026-06-02T03:43:18Z
kind: tick
role: liaison
repo: endojs/endo
project: endo
refs: []
---

Ferry of endojs/endo-but-for-bots#345 (@endo/cancel, mirror of endojs/endo#3032) investigated and **disregarded** at the maintainer's direction. No boatman dispatched, no push.

Why it was not a clean re-ferry (recorded so a future session need not re-derive it): #345 is built on the **llm** roadmap frozen base `llm-5b1361d`, while its upstream namesake #3032 targets **master**, is APPROVED by rekmarks, and is CONFLICTING. endo's llm and master have diverged (llm +725 / -128 vs master). The infra differs by branch: master already carries the root/cli/daemon `tsconfig.composite.json` files; llm lacks them, so #345 carries an llm-only `regenerate composite tsconfig files` commit (plus extra changesets and a subpath-exports test) that would collide with / be redundant on master and that #3032 deliberately does not touch. A straight recompute onto master would drag llm-only adaptation artifacts onto the approved master PR.

The liaison asked the maintainer whether to land on endo's llm branch (new PR, preserving llm shape) or reconcile onto #3032 (master, needing a weaver/builder pass and rewriting an approved PR). The maintainer answered: disregard. Left for a later decision; #345, #3032, and both branches untouched.
