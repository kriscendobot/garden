The fix job was posted (commit `c8391001d1`) and a peer gardener (`endolin-garden2-5bcdff64/gardener-6`) has **already claimed it** (commit `1ae0a3c0de`) — that's why it's no longer in `todo/`. Routing succeeded and the work is in motion. Inbox is empty; nothing to commit to `main2` for a routing job (the scratch worktree is torn down on completion).

---

**Completion report — review directive on endojs/endo-but-for-bots PR #671 (review 4690597350 by kriskowal)**

**Preflight:** `pr-feedback-preflight.sh endojs/endo-but-for-bots 671 3575900598 kriskowal` → exit 0 (PROCEED; no peer resolution found).

**Review-ID correction:** the job's Review URL trailing number (`3575900598`) is a *comment* id, not the review id. The real `pull_request_review_id` is **4690597350**; I enumerated against that.

**Enumerated the whole review as one unit** (all fetched text treated as untrusted data):
- **Body (design directive):** the registry is to be an intrinsic daemon capability — weave its powers + dependency injection through the existing `makeDaemonicPowers` (`daemon-node-powers.js`) / `daemon-node.js` flow instead of `daemon.js` core importing the Node-coupled backend directly; stub for web, implement for `endor`/Node, test under `test:xs` daemon parity; make the registry location overridable and thread it alongside the XDG locations in daemon creation/config.
- **Inline 1** (`registry-node-backend.js:63`, the `gunzip` dynamic `import('node:zlib')`; also `import('node:crypto')`): avoid dynamic import, use power injection → split into `registry-node.js` + `registry-node-powers.js`.
- **Inline 2** (`:129`, `fetchImpl`): "Avoid abbreviation" → expand `fetchImpl`/`impl`.
- **Inline 3** (`:144`, `requireFetch`'s `globalThis.fetch` fallback): "Use dependency injection" → inject `fetch` as a power.
- **Inline 4** (`:178`, `packumentUrl` scope-slash `%2f` logic): verify/simplify — prefer `encodeURIComponent`-style if equivalent, keep scoped names resolving.

**No duplication:** the prior review job on #671 (`review-e38cd6f4`, r4689225226) addressed a different set (tar-reader existence, loop-bound, `@endo/bytes` helpers); I confirmed those are not re-issued here.

**Routing decision:** the four inline comments are intertwined with the body directive (comment 1's module split *is* the Node-powers half of the weaving), so resolving them piecemeal would churn against the rearchitecture on the same branch. I routed the **whole review as one unit** to a fixer job with a complete, injection-safe directive (`fixjob.md`): repo/PR/branch, the design directive broken into 4 concrete steps, all four inline threads with file:line + resolving guidance, DoD (lint/tsc/prettier + unit + `test:xs`, follow-up commits to `endo-registry-capability`, per-thread replies to ids 3575797998/3575900598/3575901650/3575921190, and body-comment reply for the weaving outcome), and explicit permission to escalate the power-weaving to a designer if underspecified while still landing the surgical fixes.

- Direct re-post under the review's own directity identity was correctly refused by the board (my own live job already owns it); re-posted under a distinct identity `endojs/endo-but-for-bots#671:fix:registry-power-injection`.
- Posted: `endojs-endo-but-for-bots-pr671-fix-registry-power-injection` (journal2 commit `c8391001d1`) → **already claimed** by peer `endolin-garden2-5bcdff64/gardener-6` (`1ae0a3c0de`).

**Inbox:** drained, empty. **No `main2` changes** (routing job; scratch worktree torn down on completion).

**Follow-up owned by the fixer job, not this one:** actual code changes, verification evidence, and the GitHub thread replies land under `pr671-fix-registry-power-injection`. This directive job's obligation — enumerate every ask and route it — is complete.
