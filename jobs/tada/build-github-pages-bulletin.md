Build complete. Completion report follows.

---

## Completion report: `build-github-pages-bulletin` (issue-kriskowal-garden-10)

**Done.** Built and pushed a static, pure-client-side GitHub Pages bulletin to `main2` (commit `6454719ec`, under `docs/bulletin/`), and commented the build summary + setup/validation steps on https://github.com/kriskowal/garden/issues/10.

**What I built**
- `docs/bulletin/{index.html,app.js,github.js,markdown.js,style.css,config.js}` — renders the live `journal2:README.md` bulletin and, per maintainer-inbox message, shows a text input + button. Reads go through the GitHub Contents API (`?ref=journal2`, works unauthenticated since the repo is public). A reply builds **one atomic commit** via the Git Data API (blob → tree on `base_tree` with the `read/` add and `unread/` delete-by-`sha:null` → commit → fast-forward ref update, retried as a CAS against a moved ref).
- `docs/bulletin/DESIGN.md` — the required 1-page note resolving the three constraints.
- `docs/bulletin/SETUP.md` — click-by-click for Pages + token / OAuth-App ("repository plugin") registration.
- `docs/index.html` redirect and `docs/.nojekyll`.

**Design decisions (justified in DESIGN.md)**
- **Auth:** GitHub's no-secret OAuth (device flow) can't run from a pure browser page — its token endpoints are on `github.com`, which sends no CORS headers, and OAuth Apps don't support PKCE. The only genuinely pure-client path is a pasted **fine-grained PAT** (localStorage, sent only to `api.github.com`, scope = Contents:write on this repo) — implemented as the default. An optional device-flow "Sign in with GitHub" is wired behind `config.deviceFlow` for when a tiny CORS shim is deployed (the only non-pure-client part), off by default.
- **Pages layout:** served from `main2` `/docs`, not the orphan `journal2`; JS pulls `journal2` at runtime.
- **Reply routing:** routes to the message's `reply_to` doer (like `maintainer-reply.sh`), falls back to the **liaison's inbox** when no `reply_to` is present (the current `liaison:follow-up` message has none — honoring the maintainer's "liaison's inbox" phrasing), dead-letters if the doer is gone; reply file matches the bus format byte-for-byte and the original is archived in the same commit.

**Verified:** all JS passes `node --check`; the markdown renderer and the bus-message frontmatter parser were tested against the live `journal2:README.md` and a real inbox message (headings/links/lists render, no sentinel/`undefined` leaks, `"top 10 of 28"` not mangled, frontmatter parses correctly). I deliberately did **not** push a live test reply to avoid polluting `journal2`.

**Follow-ups (require a human; documented + commented on the issue):**
1. Enable Pages: Settings → Pages → branch `main2`, folder `/docs` → live at `https://kriskowal.github.io/garden/bulletin/`.
2. Mint a fine-grained PAT (Contents: read & write on `kriskowal/garden`) and paste it into the page; then run the end-to-end reply validation.
3. Optional: register a GitHub App + deploy the CORS shim to enable click-based OAuth (SETUP.md step 3).

Worktree torn down; inbox drained (empty).

Self-improvement: nothing this time — a one-off static-site build with no recurring pattern that warrants a role or skill change.
