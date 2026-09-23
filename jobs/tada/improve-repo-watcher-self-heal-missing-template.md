Work complete. Landed on `main2` as `8788b24bf`.

## Completion report

**Problem.** `scripts/jobs/repo-watcher.sh`'s `reconcile_set()` arms `<prefix>@<slug>.timer` per journal file and, on failure, only logs `WARN: could not arm ...`. When the *template* unit (`<prefix>@.service`) was never rendered into the user manager, `enable --now` fails `"Unit file ... does not exist"` on **every tick forever** — the live state for `garden-ci-watcher@*` on endolinbot (templates shipped in `1a9448720` but `install-units` was never re-run), so the auto-shepherd CI watch never armed and the WARN spam drowns real warnings in the `journalctl -p warning` tail. The existing pre-arm `daemon-reload` (lines 77–84) covers a not-yet-*loaded* template but not one that was never *installed*.

**Fix (`scripts/jobs/repo-watcher.sh`).**
- Added `template_installed <prefix>` — cheap authoritative `$DEST/<prefix>@.service` file test (`$DEST` derived identically to `install-units.sh`), with a `unit_ctl list-unit-files` cross-check so a template rendered elsewhere isn't re-installed.
- Added `ensure_template_installed <prefix>` — when the template is absent, runs `install-units.sh install` to render+daemon-reload the missing templates, then re-checks. Guarded by a script-level `_TEMPLATE_INSTALL_DONE` flag so the heavy install runs **at most once per tick** even though three prefixes (triager/comment-watcher/ci-watcher) reconcile — and never on the common no-drift path (present template → one file stat, no install).
- Called it in `reconcile_set` before the arming loop, gated on a non-empty want-set. The return is advisory/swallowed (`|| true` inside an `if`) so a genuinely-unrenderable template can't abort the tick under `set -e` — we still fall through to arm.

**Test (`scripts/jobs/test/run-test.sh`, SUBTEST 3).** Made the existing arm/disarm cases hermetic (controlled `XDG_CONFIG_HOME`, pre-seeded triager template = no-drift path) and added a self-heal case against a fresh empty render dir: asserts both `garden-ci-watcher@` and `garden-comment-watcher@` templates get rendered, the instance arms after the heal, `install-units` is invoked **exactly once** despite two missing templates, and a second no-drift tick does not re-run the install. Validated in an isolated harness (clean exit, one install on drift, zero on no-drift, all three reconciles complete); `bash -n` clean, no new shellcheck findings.

**Follow-up (optional, not done — out of the code-fix scope and a live-host systemd mutation).** The fix self-heals on the next `repo-watcher` tick once deployed. To stop the *current* endolinbot WARN spam before the deploy propagates, an operator could run `scripts/jobs/install-units.sh install` once on that host to render `garden-ci-watcher@` immediately; I left this to the deliberate deploy path rather than mutating the live host from this job.

<<<GARDEN-JOB-COMPLETE>>>
