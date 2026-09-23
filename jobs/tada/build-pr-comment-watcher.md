## Completion report — `build-pr-comment-watcher`

**Outcome: done.** The PR/issue comment watcher is built, tested, authorized, armed for `endojs/endo-but-for-bots`, and live. Notably, the bulk of the code had already landed in commit `51030653` (HEAD of `main2`, pushed); my work was to verify it end-to-end and complete the **arming + authorization** steps, which write to `journal2` and were the missing piece.

### What I found already built (commit `51030653`, working tree clean)
- `scripts/jobs/comment-watcher.sh` — per-repo comment watcher (sibling to `triager.sh`).
- Handlers: `comment-source-gh.sh` (polls issue comments / inline review-comments / review bodies, enumerates *all* comments tied to a review, prefixes `[CHANGES_REQUESTED]`), `comment-reactji-gh.sh` (👀 by surface; review bodies are no-op), `comment-claude.sh` (ambiguity-only fallback wearing the triager role).
- `scripts/systemd/garden-comment-watcher@.{service,timer}`, `install-units.sh` registration, and `repo-watcher.sh` reconciling a **separate** `comment-repos/` set.
- `roles/triager/AGENT.md` documents the watcher + the journal-recorded-auth norm.
- `scripts/jobs/test/comment-watcher-test.sh`.

### What I verified
- **Tests: 12/12 pass** — rebase directive → job + eyes reactji + cursor advance (A); non-directive → nothing, cursor still slides (B); re-poll idempotent, no dup job/reactji (C); **lost post → cursor does NOT advance** (D).
- **`bash -n` clean** on all five scripts. `shellcheck` reports only advisory info/warnings (SC1091 source-not-followed, SC2034 `GARDEN_TAG` consumed by `common.sh`'s logger, intentional `A && B || C` in test asserts) — identical to every sibling script in the repo.

### What I did to finish (the arming, on `journal2`)
1. **Recorded the maintainer authorization** as a journal `message` entry (canonical `journal-entry.sh`, isolated producer clone, CAS push): `entries/2026/06/24/221426Z-message-gardener-30f2af.md`. It states the 2026-06-24 authorization, why `endojs/endo-but-for-bots` meets the monitoring-safety bar, and that widening to any other repo requires the same journal-recorded step first.
2. **Armed the repo**: added `comment-repos/endojs-endo-but-for-bots` to `journal2` (same isolated-clone CAS pattern) — **confirmed present on `origin/journal2`**.
3. **Triggered the repo-watcher**, which reconciled the new set and **armed `garden-comment-watcher@endojs-endo-but-for-bots.timer`** (enabled; first tick 22:16:54Z). No code touched `main2` — that was already committed/pushed.

### Shape chosen / cursor
- **Shape:** a dedicated sibling watcher (not a comment-path bolt-on to the triager) — the commit triager watches a ref range; this watches typed comment endpoints. Deterministic verb mapping lives **in** `comment-watcher.sh` (so the test exercises it directly), `claude -p` is the **ambiguity-only** fallback. Pipeline: poll → classify (verb table) → reactji 👀 → post → **verify the post reached `origin/journal2`** → advance cursor.
- **Cursor:** durable in the journal at `comments/<slug>` (`last_seen: <created_at ISO>`), distinct from the triager's `activity/<slug>`. Advances only over the successfully-handled, verified prefix; a lost post halts advance so the next tick re-polls.
- **Idempotency:** deterministic basename `<slug>-pr<N>-<verb>` (or `-<shorthash>`); a re-poll whose job already exists on the board skips both reactji and post.

### Shared hazard flagged (as requested)
`post-job.sh` has been observed to print "posted" while the push did **not** land on `origin/journal2` under contention — a silent directive loss on the producer path. This watcher defends against it with `verify_posted()` (re-fetch + `cat-file -e` across todo/doin/tada before advancing the cursor), and test D proves the cursor stays put on a lost post. **Recommend auditing other producers** (triager, scheduler, watchman) for the same verify-after-post gap.

### Follow-ups
- Operational: the watcher's first ticks need the bot's `gh` auth for `endojs/endo-but-for-bots`; if absent, `comment-source-gh.sh` fails closed (cursor not advanced, quiet retry) — worth a one-time confirm that bot `gh` auth is present on this host.
- Consider extending `verify_posted`-style confirmation to the other journal producers per the hazard above.
