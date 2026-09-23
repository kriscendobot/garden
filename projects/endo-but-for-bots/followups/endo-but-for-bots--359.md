---
project: endo-but-for-bots
pr_repo: endojs/endo-but-for-bots
pr_number: 359
upstream_mirror_repo: null
upstream_mirror_pr: null
created_at: 2026-05-23T00:10:00Z
last_appended_at: 2026-05-23T00:25:55Z
status: parked
---

# Follow-ups for endojs/endo-but-for-bots#359

Created from the design-panel verdict (seven seats, in-band fallback) on the design-only PR landing `endoclaw-pinchtab` and `endoclaw-browser-interfaces`. The PR is two design docs plus a README sync; round 1 surfaced five `must-fix-loop` items, twenty `summary-fix` items, three `follow-up` items, and two `acknowledge` items. Round 2 (post-fixer-30209b at head `24e5fdfc9`) terminated with 0 must-fix-loop, 21 summary-fix (1 new round-2 added), 3 follow-up (no new round-2), 4 acknowledge, 5 drop (round-1 must-fix items second-read verified). The three follow-ups below revisit at this PR's merge or its upstream mirror's merge.

## Items

- [ ] **Allowlist contract alignment with `endoclaw-network-fetch`.**
  **Source juror(s)**: ergonomist.
  **Round**: 1.
  **Recommended action**: when `endoclaw-network-fetch` is built (separate design PR or implementation PR), ensure the origin-allowlist contract (wildcards yes, arbitrary regex no, host-readable patterns) matches the shape this design commits to in `endoclaw-pinchtab.md` § Auth and Trust Posture § Origin allowlist. The two docs claim "identical" allowlist idiom; the implementation must enforce that identity.

- [ ] **`help()` strings reflect documented cost asymmetries.**
  **Source juror(s)**: ergonomist.
  **Round**: 1.
  **Recommended action**: when the implementation PR for `endoclaw-pinchtab` lands, the `help()` strings on `Browser` / `Page` / `BrowserControl` should reflect the cost asymmetry between `click({ref})` (one round trip) and `click({role, name})` (snapshot + resolve on PinchTab), and any other asymmetries the design documents. The `help()` text is the agent's runtime read on capability shape; today's design says nothing about it. Open as an issue on `endojs/endo-but-for-bots` (or amend the design with a § help() Strings section) before phase 2 begins.

- [ ] **Revise `endoclaw-browser.md` per the unified-shape recommendation.**
  **Source juror(s)**: critic.
  **Round**: 1.
  **Recommended action**: `endoclaw-browser-interfaces.md` § Recommendation: Revise `endoclaw-browser.md` proposes a separate follow-up PR that renames the doc to "EndoClaw: Browser Capability (Playwright Backend)," replaces the `Capability Shape` section with a one-line reference to the unified shape, moves the per-method signatures into the unified-shape mapping table, and adds a `## Backend Differences` section. Open this as a designer dispatch on `endojs/endo-but-for-bots` once #359 merges (or its upstream mirror merges, whichever comes first).
