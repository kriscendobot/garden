---
order: serial
children: endojs-endo-but-for-bots-pr800-conduct endojs-endo-but-for-bots-pr802-retarget-conduct
on-child-failure: halt
state: pending
created_by: gardener
created_at: 2026-07-21T03:14:16Z
---

# Land the collapsed endor-npm-registry-proxy stack on `llm`

Serial landing of the two remaining approved stack PRs after the 2026-07-21
collapse stalled: the PR #799 conductor's branch deletion auto-closed the
approved PR #800 (repaired: reopened, retargeted to `llm`, llm merged in),
and PR #802's follow-up conduct never got posted after the shepherd turned
it green.

Children (serial, halt on failure):
  1. endojs-endo-but-for-bots-pr800-conduct — merge #800 (Phase 4 execution
     half + #801 hardening) into `llm`.
  2. endojs-endo-but-for-bots-pr802-retarget-conduct — retarget #802
     (exports resolution + #803 offline/.npmrc) to `llm`, then merge.

After both land, `llm` holds the design's Phases 1–5 end to end. The tail
(top-level await branch `feat/endor-run-top-level-await`, ex-#805, and
draft #812 relative resolution) is the press schedule's next assessment,
not this orchestration's.

Source: press tick endo-npm-cas-registry-press-20260721-030507
