All gates re-verified — the stack is fully green and every next motion remains maintainer-gated; no directive has landed, so this dispatch took no mutating action.

**Gate check (the important finding this dispatch):** the #705 merge-directive ask `20260717T002451Z-cb5a1b` now sits in `inbox/maintainer/read/`, but it was moved there by the **inbox-omnibus consolidation job** (199 unread entries folded into the still-unread digest `20260721T171232Z-297e3f.md`), **not** read by the maintainer. The ask survives inside that unread omnibus (topic: authorize the #705 → #707 git-stack merge), so the directive is still pending and the no-re-send rule still applies. Future dispatches must not interpret cb5a1b's presence in `read/` as maintainer acknowledgment. No maintainer directive appears on any stack PR either — kriskowal's latest repo comments (2026-07-21) touch #777, #812, and #651, all other lanes.

**CI re-verified live (`gh pr view`/`gh pr checks`, 2026-07-21T21:3xZ):**
- **#705** (Phase 1, the stack's next merge): 24/24 checks pass, un-drafted, MERGEABLE/CLEAN at head 84f68180 — one directive away, unchanged.
- **#707** (Phase 3, M3 exit criterion): 23/23 pass at a0f4eca4 (the 2026-07-17 CI-repair amend, single commit on the frozen #705-snapshot base), un-drafted, CLEAN. Still needs the post-#705 weave onto `llm` before its closing merge.
- **#708**: 26/26 pass (guile-interop included this round, no rerun needed). **#691**: 5/5. **#740**: 5/5. **#626**: 22/22, still DRAFT as required.

**Actions taken:** none beyond verification and this report — merges stay directive-gated, the moot parked jobs (`#707` gauntlet, `#626` weave copy) were left parked, nothing was re-sent to the maintainer.

**Follow-up for the next dispatch:** watch the omnibus digest `297e3f` (its move to `read/` or a reply is now the likeliest directive vehicle) alongside PR comments; act in stack order (merge #705 → weave #707 onto `llm` → merge #707 closes M3) the moment authorization lands.
