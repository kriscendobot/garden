---
slug: capability-hardening-attenuation
category: security-hardening
status: improvement-dispatched
count: 5
members:
  - endojs-endo-but-for-bots-pr874-review-fd62e60e
  - endojs-endo-but-for-bots-pr881-review-5111ec6e
  - endojs-endo-but-for-bots-pr881-review-b8bb5665
  - endojs-endo-but-for-bots-pr881-review-baf7087b
  - endojs-endo-but-for-bots-pr881-review-d23c8dbf
prs: [874, 881]
improvement_job: review-improve-capability-hardening-attenuation
improved_by: main2 37b04ec909: roles/builder/AGENT.md (structural-hardening directive) + roles/jurors/locksmith/AGENT.md (runtime-flag-attenuation finding)
---






An exported client/exo capability reaches review unhardened — no interface guards, runtime-flag (if(readOnly)) attenuation instead of structural POLA, or ambient authority (setTimeout) implying an unconfined module — that the locksmith/warden seats did not flag.

**Threshold rationale:** # Dispatch rationale — cluster `capability-hardening-attenuation`

**Floor met:** count=5, prs={874, 881} — K≥3 misses across ≥2 distinct PRs.

**Judgment above the floor — improvement landed (not held):** the contributor dckc
repeatedly flagged exported capability surfaces that reached review unhardened — no
interface guards and an unhardened API surface (#874), runtime `if (readOnly)`
attenuation instead of structurally denying write authority, and a `setTimeout` in a
facet implying an unconfined module (#881). #874 ran a full gauntlet (pr874-gauntlet)
and the locksmith/warden lens still did not flag the unhardened exported client; the
locksmith brief carried the attenuation lens in the abstract but not these concrete
shapes.

**Improvement shipped at the seat + directive tier** (main2 37b04ec909):
- Prevention: `roles/builder/AGENT.md` gains a "harden an exported exo/client
  capability structurally" directive (interface guards, structural attenuation over
  `if(readOnly)`, no ambient authority).
- Sensing: `roles/jurors/locksmith/AGENT.md` gains "runtime-flag attenuation and
  unhardened exported capabilities are the second recurring locksmith finding."

**Note on #881:** no panel job is recorded for #881 (it reached dckc's review with no
gauntlet) — part of the broader gauntlet-coverage gap reported in the consolidated
pass. The seat sharpening only binds when the panel runs.
