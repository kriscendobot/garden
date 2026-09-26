Done. Final completion report below.

---

## Completion report: `bulletin-rearch-ci-from-journal2`

**Outcome: built, pushed, then reverted — the job was superseded mid-flight by a later maintainer steer, and net `main2` is unchanged from the blessed state.**

### What I built (and validated)
A complete CI-rendered re-architecture, faithful to the original directive:
- `.github/workflows/bulletin.yml` — Pages-from-Actions workflow on `main2` (the default branch), triggered by `repository_dispatch journal2-updated` + `workflow_dispatch` + a 6h `schedule` safety net; reads `journal2` read-only (sparse checkout), renders, deploys via configure/upload/deploy-pages. Committed nothing anywhere.
- `bulletin/` app **source** (build input, not deployed-from-branch): `build.mjs` (a dependency-free Node renderer baking `journal2:README.md` + the maintainer inbox into `data.js`), a reworked `app.js` rendering the baked snapshot while keeping the client-side PAT reply path (re-reads live state before the CAS commit), and `github.js`/`markdown.js`/`config.js`/`style.css` carried verbatim.
- `scripts/jobs/common.sh` `fire_pages_dispatch` + a call in `bulletin.sh` after each accepted journal2 push — the journal2→dispatch→rebuild trigger. Resolved both design constraints (trigger mechanics; where app source lives) in a revised `DESIGN.md`.
- Removed the crossed-in-flight `docs/` site. Build was validated end-to-end against live `journal2` (3 messages + 13KB README rendered; all JS syntax-checked). **Pushed as `33193fed4`.**

### Why it was reverted
Draining my inbox at the post-push checkpoint surfaced a **STAND DOWN**. Verifying against the source issue thread confirmed it: the maintainer's **16:13:48Z** comment reversed the premise my job was queued from — *"The pages are set up. An SPA on main2 is actually fine. The PAT workflow is also fine, for now, provided that it is captured in local storage."* The committed `docs/bulletin/` SPA (6454719ec) + PAT-in-localStorage flow are **blessed**; removing them undid exactly what the maintainer approved. A peer had already posted the authoritative resolution at 16:19:29Z.

### What I did about it
- `git revert` of `33193fed4`, rebased onto a concurrent gardener commit and pushed as **`00cffa8b4`**. Verified: the restored tree on `docs/bulletin/`, `bulletin/`, and the workflow path matches the blessed `6454719ec` **byte-for-byte** (`docs/bulletin/` + `docs/index.html` + `docs/.nojekyll` all back; `bulletin/` + workflow gone). An unrelated gardener commit (`07a518328`) is preserved.
- Posted a transparency note on issue #10 (`issuecomment-4826698860`) — the prior "nothing removed from main2" was true only after my revert, so I corrected the record. Did **not** close the issue.
- Notified the peer (dead-lettered, since it had already completed → promoted by `garden-deadmail`). Tore down the worktree.

### Net state
`main2` is at `00cffa8b4`; effective content equals the maintainer-blessed `6454719ec`. The only residue is two history commits (push + revert).

### Follow-ups
- **None required for the bulletin** — `docs/bulletin/` at `6454719ec` is the build to keep. The remaining human step (unchanged) is minting a fine-grained PAT to enable replies.
- Saved an operational lesson to memory: drain inbox + re-read the live issue thread *right before* the final push of infra work queued off a specific maintainer comment, since a later comment on the same thread can reverse it after you've already pushed.
