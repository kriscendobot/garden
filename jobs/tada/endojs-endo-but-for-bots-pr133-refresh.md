## Completion report — `endojs-endo-but-for-bots-pr133-refresh`

**Directive (kriskowal, PR #133 comment, re-fetched and treated as data):** two asks — "we migrated the Chat app to preact. Please refresh. Also, refresh the title and description of the PR per the github template."

### Done — PR title & description refreshed per the template
Rewrote PR #133's title and body under the bot identity (`kriscendobot`):
- **Title:** `feat(chat): pending-commands region with non-blocking command bar` (dropped the non-conventional `(re-opened from #43 under the bot)` parenthetical; #43 provenance moved to `Refs:`).
- **Body:** now conforms to `endojs/endo-but-for-bots/.github/PULL_REQUEST_TEMPLATE.md` — Refs, Description (feature + files-most-critical-to-review), and all six Considerations sections (Security / Scaling / Documentation / Testing / Compatibility / Upgrade), plus a dated **Refresh status** note. Verified applied via `gh pr view`.

### Not done — branch NOT rebased; blocked on a maintainer design decision (surfaced)
The branch was **not** re-synced onto `llm`. What a mechanical rebase would have been is now a **re-implementation**, and it collides with a design decision I won't make unilaterally:

- The preact confinement migration **relocated** `packages/chat/chat-bar-component.js` → `packages/spaces-util/src/chat-bar-component.js` (the imperative `chatBarComponent` survived and is consumed only by `packages/chat/chat.js`), and moved the new file's `pending-commands.js` home with it.
- The migration re-architected error surfacing: `showError` routes a failure to the new **rich stack-trace bubble** (message + stack + clickable worker chip) *only while* `mode === 'inline'`. The feature's core move — unlock the bar immediately on dispatch (leave `inline` mode) — means a failed inline `/js`/`/eval` would fall back to the bare send-mode toast and **lose the new rich trace**, the exact regression that migration was built to prevent. Yet the 2026-03 design (`designs/chat-pending-commands.md`, still on `llm`) sketches `/eval` *as* a pending card owning its own error UX. Genuine conflict.

I messaged the maintainer (via the liaison) with a decision-ready summary and three options, recommending **(a)** the conservative port (pending-card + immediate-unlock for all non-modal commands except inline `/js`/`/eval`, which keep the rich inline-error path). The reply routes back to this job's inbox / dead-letters into a fresh job.

Verification was not attempted for the port: the worktree has no `node_modules` and no `yarn` on PATH, and the change spans `packages/spaces-util` with `ava`/`vite`/`playwright` component tests — a full monorepo bootstrap + browser run this refresh pass isn't equipped for, so per the reporting norm I did not land a UI port I couldn't verify.

### Follow-up
Once the maintainer picks an option, post a **builder/fixer "port #133 to preact" job** to: relocate `pending-commands.js` into `packages/spaces-util/src/`, re-apply the non-blocking dispatch onto the relocated `chat-bar-component.js` per the chosen reconciliation, add the `#pending-commands-region` mount to `packages/chat/chat.js` + card CSS to `packages/chat/index.css`, then rebase onto a fresh frozen base (`llm-7870da1`) and run `packages/chat` + `packages/spaces-util` suites and the playwright component tests before un-drafting.

Note: an earlier `message-user.sh --help` probe delivered one near-empty message to the maintainer inbox before the real message — harmless noise, flagging it for transparency.

No project-repo commits or pushes were made (clean detached checkout, nothing to tear down beyond the framework-managed worktrees). No garden-library (`main2`) changes were needed.
