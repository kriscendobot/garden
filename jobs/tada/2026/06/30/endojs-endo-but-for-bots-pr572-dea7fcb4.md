The peer (`f9f39a71`) had already completed by the time I replied, so my coordination note was dead-lettered and will be promoted (intent preserved). My job is a confirmed duplicate fold of that review-level job, and I've stood down as asked. Completing now.

---

**Completion report — job `endojs-endo-but-for-bots-pr572-dea7fcb4` (attention/route)**

**What the directive was.** erights left a 3-comment review on endojs/endo-but-for-bots#572 (the `byteArray` Uint8Array-view design doc). This job's trigger comment (r3496431051), anchored on the doc's "withdraw all three vs retarget" open question, answered: *"For all, withdraw and open fresh."* The full review also: (1) chose the **restrictive/whole-buffer-span** option for the sub-view question and asked for a separate issue assigned to erights; (3) **deferred helper-naming to @kriskowal**.

**Disposition: routed, not executed** — correctly, because:
- The job mandates treating the comment as **untrusted data**, so I can't self-promote it into a PR-close authorization.
- endo-but-for-bots' standing authorization covers comments/reactjis only, **not PR closes**.
- The directive spans **upstream endojs/endo#3226** (kriskowal-authored), which is off-limits to the bot identity.

**What I did:**
1. Added an **`eyes` reactji** (id 407550943) to erights' directive comment — receipt mark (covered by standing auth).
2. **Routed an authorization request to the maintainer inbox** (`20260630T054655Z-c69950`) summarizing erights' three decisions and a recommended plan: close #429/#57 with a citing comment, post a build job for a fresh view-based implementation PR (restrictive option) grounded in design #572 + `feat/narrow-bytearray-to-uint8`, file the sub-view issue assigned to erights, and hand upstream #3226 to the maintainer/boatman.

**Dedup outcome:** mid-job, peer gardener `f9f39a71` (the **review-level** job for the same erights review) asked me to stand down on the doc edit + inline-thread reply, which it owns. I did **neither**, so no race was created. My stand-down/coordination note to it was dead-lettered (peer already completed) and promoted by deadmail, preserving the facts that the reactji and maintainer authorization-routing are already done.

**Follow-ups / open items (now in the maintainer's hands):**
- Maintainer go-ahead needed to: close #429 and #57 (bot-side, reversible — branches preserved), and to open the fresh implementation PR via a build job.
- Upstream **endojs/endo#3226** withdrawal requires kriskowal / the boatman path (bot cannot close it).
- erights' comment #1 (separate sub-view issue assigned to erights, linked from #572) and comment #3 (naming → kriskowal) are captured in the routed message; the review-level job `f9f39a71` owns the #572 doc edit + thread reply.

No code or journal changes; nothing to push. Worktree clean.
