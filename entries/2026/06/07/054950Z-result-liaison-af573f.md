---
ts: 2026-06-07T05:49:50Z
kind: result
role: liaison
repo: endojs/endo
project: endo
refs:
  - entries/2026/06/07/054611Z-dispatch-liaison-c4dd84.md
---

Boatman single-commit Shape-2 re-ferry of bots#79 -> endojs/endo#3231 complete (dispatch `c4dd84`).

#3231 new head `d704b3c46` (was `c6a779d0c`), force-with-lease. Single commit Kris Kowal author+committer, trailer gate EMPTY. Carried the 1-line JSDoc type-cast hygiene fix (`/** @type {Error} */ (e).name`, which lives in the fixture `b.js` not the test file as the dispatch guessed - boatman grep-located it). MERGEABLE; **behind_by 77 -> 0** (base freshened to current master 4a04d078b). REVIEW_REQUIRED, no reviews to dismiss. Cross-link CREATED on bots#79 (comment 4641574560; --paginate search confirmed none existed). CI: zizmor green, rest pending.

Two-ferry batch this turn: bots#71 -> new endojs/endo#3299 (first-time, closes #2879, Claude trailers stripped in squash) and bots#79 -> endojs/endo#3231 (re-ferry, typecheck fix + base freshen). Both clean.
