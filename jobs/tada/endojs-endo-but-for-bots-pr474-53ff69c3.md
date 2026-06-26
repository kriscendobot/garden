Inbox empty. Work complete.

---

## Completion report

**Job:** attention directive from erights on endojs/endo-but-for-bots PR #474 (comment 4805600465). Re-fetched the comment and treated its body as data; it is a four-bullet review-response directive from a trusted senior contributor. Did the in-PR parts directly, routed the cross-PR part.

**What I did** (3 commits on the PR branch `chore/retire-function-keyword`, `f4ce64058` → **`eb5522e19`**, pushed fast-forward):

1. **`15f1e4797` — constructor rename.** Renamed `baseHandledPromise` → `BaseHandledPromise` (declaration + 4 internal refs in `eventual-send/src/handled-promise.js`) and the reference in `docs/house-style/function-keyword.md`. Scanned every `new.target` site and `function`-keyword declaration in `packages/*/src`+`lib`; `baseHandledPromise` was the **only** lower-case-named constructor — all others are already initial-capital. Flagged `web-page.js`'s `bindWrapperFn` as a considered-but-excluded dual-purpose wrapper.
2. **`bb2b63a03` — descriptor form** in `init/src/node-async-local-storage-patch.js`: replaced four per-property assignments with `defineProperties(prototype, getOwnPropertyDescriptors(patches))` (and dropped the now-unneeded `@ts-expect-error`). Did it as asked and **flagged the one nuance** (it makes `enterWith`/`run`/`getStore` enumerable on the prototype) rather than silently deviating.
3. **`eb5522e19` — "See function-keyword.md" comments** at the non-constructor exception sites the doc enumerates: `getThis`, captp `convertValToSlot`/`convertSlotToVal`, ocapn `serializeAndSendMessage`, eslint-plugin `safeRequire`, and the trampoline/ses generator sentinels. Deliberately skipped the vendored whole-file cases and the bundler template-literal cases (a comment there would land in consumers' bundles), noting both in the summary.

**Routed (Part 4):** verified **no existing PR** on endo-but-for-bots or endojs/endo covers the `harden(evadeCensorSync)` / harden-all-exported-literals work, then parked it as a **go-ahead plan job** `endo-but-for-bots-harden-exported-literals-followup` (kriskowal was pinged; scope narrow-vs-repo-wide needs his decision before a builder opens the separate PR).

**Communication:** posted a top-level summary comment on PR #474 (issue-comment 4805664773) mapping each addressing SHA, the scan result, the enumerability nuance, and the Part-4 status — per the standing completion-summary norm (authorized on this repo).

**Verification:** `node --check` + `prettier --check` clean on all 10 changed files. Full eslint/tsc/ava deferred to PR CI — the work was prepared in a fresh worktree without `node_modules`, and the changes are a mechanical rename, comment-only additions, and one idiomatic descriptor swap.

**Follow-ups for the liaison:**
- erights's **second** comment (4805614249, posted ~3 min after the directive) asks "What is the rationale for the `object-shorthand` `avoidQuotes` lint rule?" — a separate question still awaiting an answer. The GitHub-wide mention-watcher (erights is a trusted sender) likely already spawned its own job for it; check before answering to avoid a double-post.
- The parked plan job needs a kriskowal scoping decision (narrow vs repo-wide harden) before promotion.

Self-improvement: nothing this time.
