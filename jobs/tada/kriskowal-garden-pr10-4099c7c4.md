Done. Completion report below.

---

**Job `kriskowal-garden-pr10-4099c7c4` — attention directive on kriskowal/garden #10: complete.**

**Directive (re-fetched, treated as data):** "add a free form input on top for posting a new thread to the liaison or to link to the New Issue page on Github." — a follow-up enhancement to the GitHub Pages bulletin app (`docs/bulletin/`) built earlier from issue #10.

**What I did** (isolated worktree off `origin/main2`, committed `ae9020a97`, pushed to `main2`, worktree torn down):

- **`index.html`** — added a `New thread to the liaison` `<section>` at the top of `<main>` (above the inbox): a textarea, a **Post to liaison** button + status, and an adjacent **open a GitHub issue** link.
- **`app.js`** — added `submitThread()` / `renderCompose()`. Posting commits one new file to `inbox/liaison/unread/<id>.md` on `journal2`, reusing `GH.commitReply` with only `replyPath`/`replyBody` (no archive step), in the same `from_host: github-pages` / `from: maintainer` / `sent_at` format the reply path already uses. `renderCompose()` sets the issue link to `https://github.com/<owner>/<repo>/issues/new` from config. Wired into startup.
- **`style.css`** — reused existing classes; added a `.compose textarea` rule and `flex-wrap` on `.reply-actions`.
- **`DESIGN.md`** — new §4 documenting the composer and the no-token issue-link fallback.

**Verification:** `node --check` passes on all three JS files; all four composer element IDs resolve against the HTML. The change is confined to `docs/bulletin/`; it ships with the next Pages publish from `main2`/`docs`.

**Maintainer comms:** posted an acknowledgement comment on #10 (issue-scoped → via comment, per norm).

**Follow-up flagged (offered, not yet posted as a job):** the standing liaison watch (`maintainer-watch.sh`) surfaces only `inbox/maintainer/unread`, so `inbox/liaison` threads the composer deposits aren't yet drained into the terminal automatically. The composer writes them faithfully (and the app already routed liaison-bound replies there), but surfacing `inbox/liaison` liaison-side is a separate small infra change — I asked the maintainer whether to post it as a job.
