Completion report — job `endojs-endo-but-for-bots-pr503-7822ef8a`

**Directive (review `4573212313`, kriskowal, CHANGES_REQUESTED on PR #503):** "Apply feedback about banners generally, and reinforce the garden to anticipate this feedback going forward, both at the site of generation and review." Treated as an attention directive and routed to two streams.

**What the directive resolved to.** Two inline comments anchor it: (1) `test/main.test.js:265` — the house-style rule forbidding banner horizontal rules in comments; (2) `src/to-genuine.js:58` — use `set` for native memcopy. The review was submitted on `daaf8ffe`, the exact SHA a prior round (`apply-503-feedback`) had just pushed, so this is a fresh round refining that work. I scanned `daaf8ffe` and found ~40 banner-rule comments (`// -----`) across six files — the existing garden gate missed them because `no-ascii-banners` matched only box-drawing chars and `+--+`/`|...|` boxes, not plain hyphen rules. That gap was the generation-site root cause.

**Stream A — reinforce the garden (done myself, on `main2`, commit `bbed94e2`).** Isolated worktree off `origin/main2` per the shared-tree contention rule; explicit pathspecs; pushed clean.
- New `skills/no-comment-banners/SKILL.md`: the single citeable rule (definition, non-banners, sweep recipe, provenance).
- `skills/pre-push-gates/SKILL.md`: widened the `no-ascii-banners` probe to catch comment horizontal rules (a comment-only line whose stripped body is `^[-=*~_]{4,}$`); added the match spec for when the executable probe is implemented, plus a notes-from-field entry. **This is the generation-site anticipation.**
- `roles/jurors/archivist/AGENT.md` (code panel, reads comments) + `roles/jurors/pedant/AGENT.md` (design panel, already owns the ASCII-diagram rule): added should-fix review-backstop norms. **This is the review-site anticipation.**
- `roles/builder/AGENT.md` + `CLAUDE.md` inventory: broadened the probe mention; registered the new skill. House-style clean (no em-dashes, no Latin shorthand).

**Stream B — apply the feedback generally on the PR (routed to a fixer).** The banner removal is mechanical but the `set` change is correctness-sensitive: the prior round deliberately used `.at()` because `result.set(emulatedWrapper)` silently reads zeros (the emulated frozen `Uint8Array` has no integer-indexed own properties). Reconciling the maintainer's `set` directive against that finding needs empirical work in the actual endo build with the package suite, so I posted a detailed `fix` job (`fix-ebfb-pr503-banners-and-set`) capturing both comments, the banner sweep recipe, the `set`/correctness tension, and the inline-replies + top-level-summary-comment requirement. It was claimed by gardener 37 one second after posting and is in flight.

**Follow-ups.**
- Gardener 37 is executing the PR-side fix (banner removal + `set` reconciliation + replies/summary + re-request review). No action from me.
- The `pre-push-gates` executable probe (`pre-push-gates.sh` + `probes/`) is still contract-only in `scripts/` — not yet implemented. I updated the contract; when the probe is built, the widened match spec is recorded for it. Not a blocker today, but the deterministic gate only truly bites once that script exists.

**Self-improvement:** the recurring lesson (already encoded this engagement) is that a deterministic probe defined too narrowly reads as "covered" while letting a whole shape of the same defect through — the box-only `no-ascii-banners` definition is why ~40 hyphen-rule banners reached the maintainer. Widened the definition and gave the rule a single citeable home both the gate and the review seats reference.
