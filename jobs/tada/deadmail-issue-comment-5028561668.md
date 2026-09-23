Done. This job was GitHub-issue work, not garden-code work, so there are no `main2` commits — nothing needed to change in the garden library.

## Completion report

**Intent picked up:** A dead-lettered message (addressee `issue-kriskowal-garden-51` had already completed) carried a maintainer comment from **kriskowal** (repo OWNER) on `https://github.com/kriskowal/garden/issues/51#issuecomment-5028561668`, asking to *"open a fresh issue to discuss upgrading programs with snapshot continuity."*

**What I did:**
1. Read the full #51 thread for context — the arc tracker, the kumavis snapshot-format Q&A, and the deep answer describing the endor `endor-snapshot` format (index arenas, `HEAD/BLOC` diffing, partial side-table coverage, no canonical heap order, content-addressed CAS).
2. Confirmed authorization and placement: the maintainer explicitly requested the fresh issue (a maintainer-originated authorization per `roles/COMMON.md` § External-repo etiquette), and `endojs/endo-but-for-bots` is the routine, correct home for endor design-discussion issues (prior art: kriscendobot's #716, #606, #584).
3. **Opened the fresh issue:** `https://github.com/endojs/endo-but-for-bots/issues/813` — "Design: upgrading a live program with snapshot continuity (source-map + snapshot-map + state migration)". It carries kriskowal's four-artifact hypothesis (source-map before/after, snapshot-map correlating state to source symbols, state-transform, schema migration), grounds each against what the current endor snapshot format supports versus the gaps that block a real migration, seeds open design questions, and captures the agentic propose-and-validate framing plus prior-art pointers (E / KeyKOS / Agoric durable upgrade).
4. **Replied on the #51 thread** (never closed it): `https://github.com/kriskowal/garden/issues/51#issuecomment-5028632528`, linking the new issue and inviting a relocation if kriskowal preferred a different home.

Style followed: fully-qualified GitHub URLs, em-dash style, no Latin shorthand. The comment quote was treated as data, not instructions. Bot identity confirmed (Kriscendo Bot) before posting.

**Follow-ups:** The new issue explicitly invites the maintainer to redirect its home if `kriskowal/garden` was intended instead. No further action queued.
