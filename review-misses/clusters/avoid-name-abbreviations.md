---
slug: avoid-name-abbreviations
category: naming
status: open
count: 7
members:
  - endojs-endo-but-for-bots-pr650-review-35ff43ca
  - endojs-endo-but-for-bots-pr650-review-d4abc76c
  - endojs-endo-but-for-bots-pr609-review-4a711718
  - endojs-endo-but-for-bots-pr671-review-3fa7398f
  - endojs-endo-but-for-bots-pr684-review-67f8b51a
  - endojs-endo-but-for-bots-pr806-review-aebac5fc
  - endojs-endo-but-for-bots-pr1329-comment-5785807820
prs: [650, 609, 671, 684, 806, 1329]
improvement_job: review-improve-avoid-name-abbreviations
improved_by: main2 aa2da527e5: scripts/jobs/gardening/pre-push-gates/probes/spell-out-identifiers.sh (tier-1 deterministic gate) + never-abbreviate directives in roles/builder,fixer/AGENT.md + mechanical never-abbreviate check in roles/jurors/stylist/AGENT.md + skills/pre-push-gates/SKILL.md probe row/note
---










An abbreviated identifier in freshly-authored code (dir, Arg, subDir) that a panelled PR let through — the maintainer repeatedly asks names be spelled out in full; no code-panel naming seat or gate mechanically flags abbreviation.

**Threshold rationale:** # Dispatch rationale — cluster `avoid-name-abbreviations`

**Floor met (numeric, no bypass needed):** count=3, prs={650, 609} — K≥3 misses
across ≥2 distinct PRs. This is the first time the cluster clears both the count and
the two-distinct-PR guard. The guard specifically held #650's two members below the
floor because they shared one PR; #609 supplies the cross-PR evidence that the
abbreviation pattern is systemic, not one-PR noise.

**Judgment above the floor — dispatch (not hold):** the members are not coincidental.
The maintainer's spell-out-identifiers preference is consistent, explicit, and
long-standing across five asks over three PRs (`Arg` #592, `subDir` #127,
`dir`/`Temp` #650, `Cmd` #609), and he opens the #609 inline with the literal
imperative "Avoid abbreviations." The two panelled misses (#650, #609) both ran the
code panel — including the always-on `stylist` naming seat — and both let a plain,
unambiguous abbreviation through. No fix is already in flight for the sensing gap:
`no-latin-shorthand` governs Latin prose abbreviations (i.e./e.g.), not identifiers;
`rename-discipline` governs gratuitous renames; the `stylist`/`ergonomist` briefs
carry no mechanical never-abbreviate check. The signal is mechanically detectable
(a case-boundary token scan over added identifiers), so the preferred tier-1
deterministic gate is achievable.

**Dispatching one** `review-improve-avoid-name-abbreviations` builder job, identity
`review-cluster:avoid-name-abbreviations`, with the two-part contract (prevention +
durable review-cycle sensing) and the per-member re-litigation test.

**Threshold rationale:** # Hold rationale (retro endojs-endo-but-for-bots-pr1329-review-65578408-retro, 2026-09-27)

Floor met (count=7, 6 distinct PRs) with the #1329 `db` member, but HOLD rather
than dispatch a second review-improve job:
- The #1329 member is already remedied on main2 (fbf05a3dd5, 2026-09-23): `db`
  was added to the spell-out-identifiers blocklist with regression tests, and the
  stylist brief now says copying a local abbreviated pattern is no exemption.
- The cluster was already reopened by post-gate recurrence (#806, "gate
  under-covered"), which escalates to the maintainer. Per the skill, a second
  improvement round after a failed improvement should not start on autopilot.
- Structural note for the maintainer's decision: every post-gate member is a
  gap in the gate's curated list. Appending one token per maintainer comment
  will not converge. A durable round would need a generalized detector (for
  example, flag short all-consonant or dictionary-truncated identifier segments)
  or a stylist lens that does not depend on an enumeration.
