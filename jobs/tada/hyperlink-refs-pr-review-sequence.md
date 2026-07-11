The work is complete and verified on the remote.

## Completion report

**Job:** Hyperlink every PR/issue reference in `journal2:pr-review-sequence.md`.

**What I did:**
- Synced a producer clone of `journal2` (never the live `journal/` worktree) and inspected the report. Found all references live inside inline code spans (e.g. `` `endojs/endo-but-for-bots#678` ``, `` `#617` ``); there are no fenced code blocks and no bare/full GitHub URLs.
- Wrote a Markdown-aware transform (`link_refs.py`) that wraps **only** reference-shaped code spans in a hyperlink, **preserving the backticks** so the diff is link-wrapping only:
  - `owner/repo#N` → `[`owner/repo#N`](https://github.com/owner/repo/issues/N)`
  - bare `#N` → resolved to `endojs/endo-but-for-bots` → `[`#N`](https://github.com/endojs/endo-but-for-bots/issues/N)`
  - Used the `/issues/N` URL form, which GitHub 302-redirects to `/pull/N` for PRs — correct for both PRs and issues without classifying each.
  - Left every non-reference span untouched (branch/snapshot names like `` `llm` ``/`` `llm-08f5acc` ``, identifiers like `` `EndoMount.glob` ``, garden job names like `` `resume-lint-ceiling-shepherds` ``).
  - Skips spans already serving as a link's text (idempotent).

**Verification:**
- Stripping all link wrappers from the result reproduces the original file **byte-for-byte** (diff is link-wrapping only; prose/table/ordering unchanged).
- Spot-checked live resolution: `#678` → 302 `…/pull/678`, `#617` → 302 `…/pull/617`.
- Confirmed non-reference spans (`` `llm` ``, `` `llm-08f5acc` ``, `` `EndoMount.glob` ``) remain bare; no double-links.

**Changed / landed:**
- **98 references** promoted to working hyperlinks.
- CAS-pushed to `origin/journal2` as commit **`f6f038e1a17ad878bfe140d0456675e5021d09d0`** (`docs(pr-review-sequence): hyperlink every PR/issue reference`); re-fetched `origin/journal2` confirms tip = `f6f038e1a` and the remote file carries all 98 linked refs.

**Follow-ups:** none. The `link_refs.py` helper lived only in the job worktree (torn down); the report change is fully landed on `journal2`.
