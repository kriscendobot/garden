---
gate: orchestrated
orchestrated_by: orch-endo-inspect
priority: normal
posted_by: producer
posted_at: 2026-07-12T16:46:29Z
---

---
role: builder
---

# Build: implement @endo/inspect per the landed design

**This is the BUILD step of a serial orchestration** (`orch-endo-inspect`) that runs
**after** the conduct child (`conduct-endo-inspect-design`) lands the design on `llm`.
**Read the landed design (`endojs/endo-but-for-bots` @ `llm`) and the conduct child's
`tada` report first** — implement against the design, do not re-derive it.

**Repo:** `endojs/endo-but-for-bots`, base per the builder base-inference rule (the
design lives on `llm`; implement on the project's implementation base — read the
design, then infer the base from where the touched packages exist, per
`roles/builder/AGENT.md`). Draft PR; the build **auto-runs the gauntlet**.

## What to build

Implement **`@endo/inspect`** + **`@endo/inspect/shim.js`** as the landed design
specifies:
- the package and its `-C` conditional-exports so the shim can be incorporated in the
  base of SES, resolving the right inspector per target;
- the per-environment behavior: **browser** (rich console), **node** (VT-100 on a
  tty, bare text otherwise), **xs** (no console);
- **non-triggering inspection** to the extent the design establishes is achievable
  under SES's missing Proxy brand check — respect the design's stated limits; do NOT
  invent a Proxy brand check the design says does not exist. If the design left the
  Proxy-stamping dependency unresolved (awaiting `@erights`/`@mhofman`), build only
  the parts the design marks as ready and **surface the still-blocked parts** rather
  than guessing.

## Norms
- Load-bearing tests ([regression-evidence](../../skills/regression-evidence/SKILL.md))
  for each environment behavior and the non-triggering guarantee.
- [worktree-per-pr](../../skills/worktree-per-pr/SKILL.md),
  [local-verify](../../skills/local-verify/SKILL.md),
  [pre-push-gates](../../skills/pre-push-gates/SKILL.md),
  [yarn-lock-separate-commit](../../skills/yarn-lock-separate-commit/SKILL.md),
  [self-improvement](../../skills/self-improvement/SKILL.md).
- Fully-qualify issue/PR references; ASCII prose (house style).

## Done
A draft `feat` PR implementing `@endo/inspect` + `shim.js` per the landed design (SES-base
`-C` incorporation, the browser/node/xs behavior matrix, non-triggering inspection
within the design's limits), with load-bearing per-environment tests, auto-gauntleted.
The `tada` report links the PR and notes anything held pending the Proxy-stamping
dependency.
