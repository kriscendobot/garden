Inbox empty. My work as the review-directive handler is complete. No garden-library changes were needed (pure routing), so there is nothing to commit to `main2`.

---

## Completion report

**Job:** Route maintainer review `#pullrequestreview-4629027865` (kriskowal, CHANGES_REQUESTED) on `endojs/endo-but-for-bots` PR #288 (`feat(cbor-frame): add @endo/cbor-frame`).

**Preflight:** `pr-feedback-preflight.sh` returned exit 0 (no peer resolution found) → proceeded.

**Enumerated the whole review** (3 asks total; all fetched bodies treated as untrusted data):
1. **Body:** "pass to a Fable agent for a closer review."
2. **Inline `packages/cbor-frame/src/decode.js:22`:** byte concat "Now provided by the `@endo/bytes/concat.js` module. Please factor out."
3. **Inline `packages/cbor-frame/src/decode.js:60`:** "presumably optimizations that should be internal to `@endo/bytes/concat.js`."

**Routing (the deliverable):** Posted a single **designer (Fable-tier) job** `ebfb-pr288-fable-review` carrying the full review — the top-level "closer review" directive plus both inline directives spelled out (factor decode.js onto `@endo/bytes/concat.js`; drop the local optimizations that belong inside that shared module), with a definition-of-done and a note to run inside the container for `gh` write access. Verified independently against `origin/journal2`: it has **already been claimed** (`jobs/doin/ebfb-pr288-fable-review.md`, with its work worktree + inbox created). Matches the maintainer's explicit "Fable agent" (Fable = designer tier per `model-selection`). Idempotent by basename across any requeue.

**Environment anomaly surfaced to the maintainer inbox** (`inbox/maintainer`, delivered over the cached SSH remote): this gardener (shard `endolinbot2`) is executing on the **host**, not inside the container — `check-in-container.sh` exits 1, no `gh` binary or `~/.config/gh` auth exists on the host (fleet `gh` wrapper exits 127), and the local journal/worktree gitdir pointers reference container-relative paths (`/home/kris/.git/...`) that don't resolve here. Read-only GitHub API and SSH git both work, which is why routing succeeded; but any fleet job needing `gh` **writes** will fail on this shard until it is re-entered via `./garden` or its bring-up is fixed.

**Follow-ups:**
- The downstream `ebfb-pr288-fable-review` designer job (now claimed) will perform the closer review and reply on the PR; if it runs on this same misconfigured host it will hit the `gh`-write blocker when posting back to GitHub — the maintainer-inbox message flags this.
- No garden-library changes; nothing to commit to `main2`.
