---
ts: 2026-05-15T03:26:31Z
kind: dispatch
role: liaison
project: endo
to: "*"
refs:
  - entries/2026/05/15/000521Z-result-liaison-02ccd8.md
  - entries/2026/05/15/013945Z-result-builder-d613df.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 258
    role: source
---

First-time ferry: `endojs/endo-but-for-bots#258` ("ci(ocapn-guile-interop): cache the Guix runtime store across runs (iteration III)") opens as a new **draft** PR on `endojs/endo`. Defaulting to draft (no user ask either way; matches the iteration-II ferry pattern, which the user explicitly chose).

Prior context: iteration II (#255) was ferried as draft `endojs/endo#3262` earlier this session (`entries/2026/05/15/000521Z-result-liaison-02ccd8.md`); the user then merged #3262 into master (currently at `0ec70c6dd`). Iteration III adds a `actions/cache` step that caches `/gnu/store` and `/var/guix/db` across runs so a both-substitute-servers-degraded day no longer blocks the workflow.

**Source**: `endojs/endo-but-for-bots#258`, branch `ci/ocapn-guile-interop-resilience-iii`, head `5b38857d57b1b85a30e3bbaaccbae1f04580dadb` (head was `19959e99` at first check ~5 min ago and was force-pushed to `5b38857d` in the meantime — same source-auto-sync pattern observed on #244 and #109). State OPEN, non-draft on source side. Base on `master` at `c2fc02eb8`. CI: 24 SUCCESS / 0 FAILURE.

The only new commit on the bot side (above the merged iteration II) is:

- `5b38857d ci(ocapn-guile-interop): cache the Guix runtime store across runs` (endolinbot, 2026-05-15T01:38:55Z)

**Upstream**: new branch on `endojs/endo` (boatman picks; sensible default `kriskowal-ocapn-guile-interop-cache-store` or `kriskowal-ocapn-guile-interop-resilience-iii`). Target base: `master` (`0ec70c6dd`, which already includes merged iteration II).

**Human**: `Kris Kowal <kris@cixar.com>`. **identity_switch_authorized: true**.

**Dispatch root**: `/Users/kris/garden/dispatches/boatman--ferry-guile-cache-258--20260515-032622--2757e1/`. Project worktree on `endojs/endo:master`.

**Boatman direction**:

- Cherry-pick **just** `5b38857d` onto current `origin/master`. The diff against the source's own base `c2fc02eb8` is huge (includes everything merged into the bot's `llm` since); only the one new commit at the source tip is in scope.
- Apply the `cherry-pick + commit --amend --reset-author --no-edit` pattern (set local `user.name='Kris Kowal'` / `user.email='kris@cixar.com'` first).
- Strip bot trailers; verify with `git interpret-trailers --parse` and `git log origin/master..HEAD --pretty=fuller`. The source commit's subject is already upstream-native (no `(#258)` suffix, no bot-specific framing); no subject rewrite needed.
- Push to a fresh upstream branch.
- **Open the upstream PR as DRAFT** via `gh pr create --draft -R endojs/endo --base master --head <new-branch> --title <new> --body <new>`. Compose per `pr-formation`:
  - Title: source title `ci(ocapn-guile-interop): cache the Guix runtime store across runs (iteration III)` — drop the `(iteration III)` parenthetical if it reads bot-internal, or keep it if `pr-formation` framing supports a follow-up-to-merged-PR reference. The merged iteration II's title used the same pattern; the boatman judges.
  - Body: endo PR template sections (Description / Security / Scaling / Documentation / Testing / Compatibility / Upgrade). Behavior over diff. **Drop fork-only references**: the source body's `Refs: #82` and `Refs: #255` are both bot-internal; translate `#255` to the now-merged `#3262` (or to the underlying commit `0ec70c6d`) if the boatman judges that adds context. The iteration-history framing (iteration I introduced X, iteration II reordered Y, iteration III caches Z) is substantive and useful for the upstream reviewer — keep it.
- Source-side cross-link comment on `endo-but-for-bots#258`: post under kriskowal (only authenticated identity on `kmkmbp2021`). Name the upstream PR URL and head SHA.
- Identity discipline: no direct comments on the new upstream PR.

**Expected report** (≤300 words): upstream PR number + URL + head SHA, draft confirmed, attribution verified, source-side cross-link URL, new title + body-per-`pr-formation` confirmation, one-line `Self-improvement: ...`. If blocked, `message`-to-liaison and stop.
