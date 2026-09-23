---
ts: 2026-06-03T00:22:50Z
kind: result
role: liaison
repo: endojs/endo
project: endo
refs:
  - entries/2026/06/03/001816Z-dispatch-liaison-e78c11.md
---

Boatman re-synced #3294 to the live mirror via surgical tip amend (dispatch `e78c11`); "referry bots#387".

**#3294** new head `983551383044b9da6c2f8ae78d893e7235ac40d5` (was `4150060dd`), force-with-lease, only the tip `Feedback responses` commit rewritten. Parents intact: `d6dc75964` (yarn.lock), `4afa6af31` (0xPatrick, author preserved). benchmark subtree now `98060f1e` == live mirror `a179d5aa8`. Only `install-engines.sh` changed: v8 launcher made relocatable (relative `$0` traversal + quoted heredoc), retains gibson042's prior improvements. MERGEABLE; **gibson042 APPROVED persists** (endo master unprotected; force-with-lease did not dismiss). CI re-triggered. Cross-link 4599031642 -> `...head 983551383`. Boatman entries at journal `f010cec8`.

Chose the surgical amend over a Shape-2 recompute deliberately: #3294 is APPROVED with a careful 3-commit structure (0xPatrick separate-commit credit + yarn.lock + Feedback responses); a recompute would discard all of it. Only the one changed PR-scope file (install-engines.sh) was carried; the ~27 base-divergence files stay.

**Open flag for maintainer:** gibson042's approval (2026-06-02T23:07Z) was against `4150060dd` and now predates the relocatable-launcher one-file refinement. Approval persists formally; re-requesting gibson042's review for the launcher tweak is the maintainer's call (a courtesy, not required).

Pattern note: this is the second consecutive surgical amend tracking a moving mirror. The mirror has been rebuilt repeatedly (a66f3c344 -> e22369065 -> a179d5aa8), each time with a small benchmark refinement. If this continues, consider letting the bot-side settle before the next sync to avoid amend churn.
