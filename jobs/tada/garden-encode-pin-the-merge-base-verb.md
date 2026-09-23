Done. Committed as `d6726999ea` and pushed to `main2`.

## Completion report

Encoded **"pin the merge base"** as first-class garden vocabulary across all three requested surfaces, with deterministic watcher recognition.

**What the verb means** (fixed by kriskowal's coinage, endojs/endo-but-for-bots#282 review 4945588548): repoint a PR's base onto a pinned `llm-<sha>` branch, rebase the head onto it, and resolve conflicts. The rebase and conflict resolution are implicit in the verb.

**Changes:**
1. **README.md § Key vocabulary** — added a star-recognized `pin the merge base #N` row (marked ★ like the other watcher-recognized verbs), noting it changes the base not just the head, and linking `frozen-base-branch` + `verify-upstream-state-before-pinning`. Also added it to the "Comment a verb" recognized list.
2. **CLAUDE.md § Orchestrator vocabulary** — added a watcher-recognized row (no `muster`-style liaison-session-only caveat), routing to the weaver and linking the two skills.
3. **scripts/jobs/comment-watcher.sh** — recognize the multi-word phrase in imperative/clause-initial position (reusing `imperative_verb_present`, like `run the gauntlet`) as a distinct `pinbase` branch op:
   - Detected **before** the single-word verb loop, so the canonical phrasing's trailing "and rebase" cannot shadow it into a plain `rebase` job.
   - Gated on imperative position, so declarative prose ("this will pin the merge base once #528 merges") does not mis-fire.
   - Wired through `verb_action`, `verb_role` (→ weaver), the mechanical-verb preflight skip, the stale-directive-on-merged-PR guard, and the base-derivation table (`$slug-pr$pr-pinbase`).

**Care taken:** `rebase`/`weave` are untouched and unshadowed; `pinbase` is a distinct base-changing op. No `pin` token was added to the verb-counting lists, so the implicit "and rebase" does not trip the multi-part-directive splitter. No em-dashes in the prose I authored.

**Tests:** Added regression cases **PMB** (plain imperative comment → `pinbase` job, asserting no plain-`rebase` shadow + correct body semantics) and **PMBR** (the review-body form from the coinage → a `review` job recording `pinbase` as the primary action, again no rebase shadow). Full `comment-watcher-test.sh` suite: **320 passed, 0 failed**, including after rebasing onto the latest `main2`.

Follow-ups: none required. The weaver role picks up `pinbase` jobs via `verb_role`; the how-to lives in the two referenced skills rather than being duplicated.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/garden-encode-pin-the-merge-base-verb.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 64 tokens (4101348 cached reads)
- Output: 28358 tokens
- Cost: $4.038071
- Wall-clock: 551s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
