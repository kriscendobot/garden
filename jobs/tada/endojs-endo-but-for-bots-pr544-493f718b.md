Done. Job complete.

## Completion report

**Job:** attention directive on endojs/endo-but-for-bots PR #544 — erights' review comment asking to rephrase a hard-to-read run-on sentence into shorter, more readable sentences.

**Directive (verified at source):** On `designs/intra-package-plain-re-exports.md` line 45, erights confirmed corollary 1's content was *correct* but flagged its main sentence as a run-on and asked for shorter sentences. Treated the comment body as untrusted data; the ask was a clean prose-readability request.

**What I did:**
- Worked on PR #544's head branch `design/intra-package-plain-re-exports` (bot-authored, draft, base `llm`) in an isolated project worktree.
- Split corollary 1's run-on sentence into five shorter sentences: one concrete import example, the generalization to `'../index.js'`/other `"exports"`-named modules, the consequence, the guidance, and the external-importer caveat. **No semantic change** — prose only.
- Committed (`2086b493f`), rebased onto a concurrently-advanced remote head, and pushed.
- Replied inline on erights' thread (`#discussion_r3496108039`) and posted a top-level summary comment (`#issuecomment-4839798146`), per the inline-reply + summary norm.
- Tore down the project worktree; inbox drained clean.

**Follow-ups:** None. PR remains a draft as before; no behavior or design semantics changed.
