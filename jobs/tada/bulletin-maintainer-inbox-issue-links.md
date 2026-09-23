All work is committed and pushed to `origin/main2`, and the worktree is clean. Here is my completion report.

---

## Completion report: `bulletin-maintainer-inbox-issue-links`

**What I did.** Made GitHub issue/PR references in the bulletin's maintainer inbox render as working hyperlinks, resolving bare `#N` to the *originating project* repo.

**Commits pushed to `main2`:**
- `4858ade79` — hyperlink issue/PR refs in the maintainer inbox
- `88dd7d5ea` — don't linkify refs inside inline `` `code` `` spans (fix caught during live-data verification)

**Files changed:**
- `scripts/jobs/bulletin.sh` — the linking lives server-side (where the doer→project mapping is known), so it works on **both** the GitHub-rendered `journal2:README.md` and the gh-pages client (both render `[label](url)`); `docs/bulletin/markdown.js` needed no change.
  - New `resolve_doer_repo()`: maps a message's originating doer (`reply_to`, falling back to `from`, minus a `gardener:` prefix) to `owner/repo` by matching the job base against the bare fork clones under `worktrees/*.git` (longest match wins), split at the first `-`. Returns empty when no clone matches — the caller then leaves a bare `#N` plain.
  - Rewrote `msg_body_quote()` to linkify each non-fence body line via a sentinel-protected multi-pass `linkify`: (0) hold inline `` `code` `` spans verbatim, (1) full `github.com/.../issues|pull/N` URLs → `[url](url)`, (2) `owner/repo#N` → `.../owner/repo/issues/N`, (3) bare `#N` → the resolved repo *only when known*. Fenced code blocks and inline code spans are never rewritten, and formed links are held aside so nothing double-links.
- `scripts/jobs/test/run-test.sh` — extended SUBTEST 10 (5b) with a fake `GARDEN_WORKTREES`, a resolvable fixture, and 4 assertions: owner/repo#N + bare #N (resolved) + full URL link; fenced refs stay plain; inline-code-span ref stays plain; an unresolvable doer leaves its bare `#N` plain.

**Repo-resolution rule implemented:** `owner/repo#N` and full issue/PR URLs link syntactically (repo-independent); a bare `#N` links to the repo resolved from the message's doer base against the bare clones, and is **left as plain text when unresolvable** (a wrong link is worse than none).

**Verification:**
- `bash -n` clean on both files; `shellcheck -S warning` clean on `bulletin.sh` (only the pre-existing `SC2034 GARDEN_TAG` at line 81 remains, untouched by me).
- Drove the **real `bulletin.sh` end-to-end** (seed journal → `bulletin.sh` with the journalist/parked stubs → rendered README): all 4 new assertions pass.
- **Live-data check:** rendered the *actual* current live maintainer message `20260709T202811Z-53aebd.md` (fetched from `origin/journal2`) through the new code against the **real production `worktrees/`**. Its doer resolves to `endojs/endo-but-for-bots`; the output links `endojs/endo-but-for-bots#652`, and bare `#650`/`#652` to that repo, while inline spans like `` `deniedSegments` `` and `` `rebase #652` `` stay verbatim. Confirmed the current live README shows those same refs as dead plain text (the before-state).

**Live-bulletin caveat / follow-ups:**
- I could **not** restart `garden-bulletin.service` or sync into the deployed tree myself: this host (`endolin-garden2-…`) is a **follower**; the bulletin is a leader-only singleton and the leader marker names a different host (`endolin-garden-ece02cb4`). The change reaches the live public bulletin through the normal deliberate-deploy of `main2` (garden-upgrade-monitor → `deploy-garden.sh` on the leader), which will re-render the maintainer inbox with hyperlinks on its next journal2 push after deploy. My live-data render above is the faithful preview of that output.
- **Pre-existing, unrelated test failure:** `run-test.sh` aborts at **SUBTEST 6** (`maintainer-reply FATAL: … has no reply_to`) under `set -e`, before reaching SUBTEST 10. I confirmed this reproduces **identically on the pristine baseline** (my changes stashed) — same stop point, 44 PASS. It is independent of this change (SUBTEST 6 runs before and touches none of my code); worth a separate look by the maintainer, as it currently blocks the full suite from completing.
