Pushed cleanly to `main2`. Job complete.

---

**Completion report**

**Problem:** `ensure_clone()` in `scripts/jobs/common.sh` (~L992) FATAL-looped forever when its destination directory existed but was a broken/partial clone (populated without `.git`). It only cloned `if [ ! -d "$dir/.git" ]`, but `git clone` refuses a non-empty destination — so once an interrupted clone (SIGKILL at TimeoutStop, an aborted `sync_clone` reset, disk hiccup) left `$dir` populated without `.git`, every subsequent tick hit `die`. Evidence: 145 identical `[unblock] FATAL` entries over ~12h plus one `[orchestrate]`, with the remote reachable the whole time — the unblock and orchestrate watchers stayed dead.

**What changed (`scripts/jobs/common.sh`, `ensure_clone`):**
- When `$dir` exists but lacks `.git`, it is now treated as a poisoned partial clone: logged with a single `WARN` and cleared (`rm -rf`).
- The fresh clone now goes into a **sibling temp path** (`${dir}.tmp.$$`, same parent → same filesystem) and is **atomically renamed** into place with `mv`. So the destination only ever appears fully cloned or absent — never half-populated — meaning a future interruption can never re-wedge the retry.
- On clone failure the temp is removed and the original `die` message preserved; a failed rename cleans up and dies too.
- All of this stays under the `clone_lock "$dir"` the function already holds, so no concurrent producer races the destination.

**Scope:** Shared code — `unblock.sh`, `orchestrate.sh`, and every other watcher that self-provisions its journal via `ensure_clone` inherit the fix with no per-caller change, as the job specified.

**Verification:** `bash -n` clean. Ran an isolated harness against a real local git remote covering three cases: (1) fresh clone (dir absent) → correct branch checked out; (2) idempotent re-entry on a healthy dir → no re-clone, no leftover temp; (3) poisoned dir (populated, no `.git`, with junk files) → self-healed, junk gone, real clone present. All passed.

**Delivered:** committed and pushed as `effb9d062` to `main2` (first-attempt CAS, clean rebase).

**Follow-ups:** None required. One minor note: a peer process that crashes *between* `git clone` into the temp and the `mv` would leave a `${dir}.tmp.<oldpid>` orphan (harmless — it does not wedge the retry, which was the whole point), and our own `$$`-named temp is always cleaned. Left as-is to keep the change minimal per the single-script rule.
