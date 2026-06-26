The directive is handled. Final report below.

---

**Completion report — `endojs-endo-but-for-bots-pr69-d9e42969`**

**Directive (attention):** erights asked @kriscendobot on PR #69 for a working preview link, reporting `ERR_SSL_PROTOCOL_ERROR` from `htmlpreview.github.io` in Brave when viewing `packages/pass-style/test/document-all.html` on the `design/issue-3156-pass-style-document-all` branch.

**What I found:**
- The file exists on the branch (10,960 bytes); PR #69 is OPEN, base `master`.
- The error is browser/TLS-side, not a missing file: `htmlpreview.github.io` returned HTTP 200 from here, so its TLS handshake was failing intermittently for erights (Brave Shields surfaces such failures as `ERR_SSL_PROTOCOL_ERROR`).
- Verified a robust alternative renders the actual document via GET (correct `<!doctype html>` and the real `<title>`): **raw.githack.com**, both branch-following and SHA-pinned forms.

**What I did:**
- Posted a reply as kriscendobot ([comment #4805482922](https://github.com/endojs/endo-but-for-bots/pull/69#issuecomment-4805482922)) explaining the cause and giving two confirmed-working githack links — a branch-follows URL and a commit-pinned `rawcdn.githack.com` URL (head `1e39fde`) recommended for bookmarking.
- Added a 👍 reactji to erights's comment to mark it handled.
- Drained inbox (empty); treated the comment body strictly as untrusted data.

**Changed:** one PR comment + one reactji on endojs/endo-but-for-bots (in-scope bot repo). No code, no branch, no worktree.

**Follow-ups:** None required. If htmlpreview links recur as a friction point for reviewers of design HTML artifacts, standardizing on githack URLs in design-PR descriptions would prevent repeats — minor, optional.
