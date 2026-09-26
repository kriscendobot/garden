All work complete and cleaned up. Final report follows.

---

## Completion report: `fix-comment-watcher-timer-and-classification`

**Pushed to `origin/main2`:** `fb7a73d6` (both bug fixes + tests) and `f757e17e` (timer integration test). Final tip: `f757e17e`. Worked in an isolated worktree off `origin/main2`, rebased twice over concurrent gardener pushes, committed explicit pathspecs.

### Bug 1 — timer never fired its `@`-instance service: root cause + fix
**Root cause (two compounding defects):**
1. **Fragile timer anchor.** `garden-comment-watcher@.timer` used a single `OnActiveSec=90s` first-elapse (relative to timer activation) plus `OnUnitActiveSec=90s`. Before the service has *ever* run, `OnUnitActiveSec` cannot anchor, so `OnActiveSec` is the *only* future trigger. If that one elapse is dropped across a `daemon-reload` issued between activation and the 90s mark, the timer is left `active` with **no next trigger** — exactly the reported "active, `LastTriggerUSec` empty, `-- No entries --`" state. A `.timer` restart alone doesn't recover it because only a `daemon-reload` reloads the bound *service* template the timer must resolve.
2. **Arming race.** `repo-watcher.sh` armed instances with `enable --now` and **no `daemon-reload`**, so a freshly-changed `@.service`/`@.timer` template might not be loaded when the instance is armed.

**Fix:** anchor the first elapse to `OnBootSec=30s` (a fixed monotonic reference — recomputed deterministically on every reload, already in the past on an up host, so a concrete next-trigger *always* exists), keep `OnUnitActiveSec` for the steady cadence, add an explicit `Unit=garden-…@%i.service` binding, and tighten `AccuracySec`. `repo-watcher.sh` now issues `daemon-reload` before every reconcile. Same hardening applied to `garden-triager@.timer` (shared the defect).

**Verified live (no manual service start):** deployed the hardened timer, `daemon-reload`, restarted only the `.timer`; the service ran at 22:59:02, then **again autonomously at 23:00:09** (~90s later), with `LastTriggerUSec` advancing. Journal shows successive timer-driven runs.

### Bug 2 — plain-language maintainer directives dropped: fix
`classify()` only acted on a verb, an `@kriscendobot` mention, or a `CHANGES_REQUESTED` body, so a trusted maintainer's "Please apply this feedback" (no verb, no mention) returned "none" and was dropped (the #503 / `issuecomment-4794208524` case). **Fix:** widened *only* the who-plus-imperative case — a comment routes to the `claude` triager fallback when **both** (a) its author passes the **same deterministic sender-trust gate the mention-watcher uses** (reused `mention-trust-gh.sh` + journal `trusted-senders/allowlist`, which already has 6 entries — endojs/Agoric org membership OR allowlist) **and** (b) the body reads as an imperative directive. The imperative check runs first (pure string, no I/O) so chatter never triggers a trust lookup. Deterministic verb table stays the fast path; untrusted senders and non-directives stay dropped; monitoring-safety posture unchanged (trust is an *additional* bar atop repo-gating). I chose the mention-watcher's existing trust mechanism over inventing a login list because it's already tested and is consistent with `endo-but-for-bots` README § Authority structure.

### Tests & verification
- `comment-watcher-test.sh`: added cases **E** (trusted plain directive → triager fallback + job posted), **F** (same comment, untrusted sender → dropped), **G** (non-directive from trusted sender → dropped). **20/20 pass.**
- New `timer-fire-test.sh`: STATIC (`systemd-analyze verify` of the rendered `@`-timer→service binding + asserts the `OnBootSec`/`Unit=` anchors are present) and DYNAMIC (installs a throwaway hardened `@`-timer, `enable --now` the timer *only*, asserts the service fires within 30s with `LastTriggerUSec` advancing). **6/6 pass.** Both layers skip-not-fail when systemd tooling is absent.
- `bash -n` + `shellcheck` clean (only the pre-existing `SC2015`/`SC2034`/`SC1091` informational idioms shared with the rest of the harness).

### Deployment state
- Timers: hardened templates copied into the live user manager, `daemon-reload`ed; comment-watcher timer confirmed firing on cadence.
- Scripts: `comment-watcher.sh` + `repo-watcher.sh` deployed live to `/home/kris` via plain file copy (content verified identical to `origin/main2`; my files don't overlap the concurrently-dirty set, so no git state or other gardeners' edits were touched). Live manual run exits 0.

### Follow-ups
1. **#503's actual directive is now behind the durable cursor** (`last_seen` = 22:14:51Z), so this fix prevents *future* drops but won't retroactively replay "Please apply this feedback." If the maintainer still wants that specific feedback applied, it needs a manual job post (or a cursor rewind) — flagging rather than rewinding the cursor unilaterally.
2. The shared `/home/kris` tree is independently dirty from other gardeners (`bulletin.sh`, `common.sh`, `post-job.sh`, `run-test.sh`, untracked `bin/`) — pre-existing, not from this job. Full convergence (HEAD→`origin/main2`) and `install-units.sh install` re-render will happen on the next clean watchman tick; the live behavior is already correct on this host via the targeted copies above.
