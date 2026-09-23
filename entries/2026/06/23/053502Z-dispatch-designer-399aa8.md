---
kind: dispatch
role: designer
host: endolinbot
posture: liaison
short_id: 399aa8
dispatch_root: dispatches/designer--399aa8
repo: endojs/endo-but-for-bots
branch: llm
pr_number: null
model: opus
---

RSVP kriskowal's comment on PR #500 (id 4775973308,
2026-06-23T05:34:05Z): "Please dispatch designers to produce a
pair of competing plans to address the same problem." This is
designer 2 of 2 — the **ocap-kernel-leaning** plan.

Problem: pass-style support for sturdy-refs (opaque objects, like
presences, registered with HandledPromise, corresponding to OCapN
locators). Daemon agent methods accepting pet-name-paths should
also accept sturdy-refs. The retention dilemma.

This designer's axis (Option B + maintainer's middle-path):
**Workers cannot retain ephemeral references to formulas; the
endor worker protocol provides a "syscall" for retaining and
releasing references.** The daemon ephemerally retains any
reference returned by an agent method until collected, and
compensates by revealing the ephemeral worker retention roots.

Designer 1 (short_id 711789) is producing the parallel petname-
daemon-leaning plan (FinalizationRegistry-tracked worker
retention). The two designs share the pass-style + locator
parsing + boxing/unboxing scaffold; they differ on retention
semantics.
