---
kind: dispatch
role: designer
host: endolinbot
posture: liaison
short_id: 711789
dispatch_root: dispatches/designer--711789
repo: endojs/endo-but-for-bots
branch: llm
pr_number: null
model: opus
---

RSVP kriskowal's comment on PR #500 (id 4775973308,
2026-06-23T05:34:05Z): "Please dispatch designers to produce a
pair of competing plans to address the same problem." This is
designer 1 of 2 — the **petname-daemon-leaning** plan.

Problem: pass-style support for sturdy-refs (opaque objects, like
presences, registered with HandledPromise, corresponding to OCapN
locators). Daemon agent methods accepting pet-name-paths should
also accept sturdy-refs. The retention dilemma: the user must
retain agency to revoke access; a confined guest holding a sturdy-
ref must be visible enough that the user can disincarnate that
worker.

This designer's axis (Option A in the maintainer's framing):
**FinalizationRegistry-tracked worker retention**. Identify every
worker holding a SturdyRef that has not been garbage collected via
FinalizationRegistry. The user exercises agency by disincarnating
the worker that holds the SturdyRef or a live value.

Designer 2 (short_id 399aa8) is producing the parallel ocap-kernel-
leaning plan (endor-syscall-based retention). The two designs
share the pass-style + locator parsing + boxing/unboxing scaffold;
they differ on the retention semantics.
