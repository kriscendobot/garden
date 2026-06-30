Done. Both updates landed and the inbox is clear.

## Completion report

**Job:** agoric-sdk PR #7 — conform title + description to the GitHub PR template (kriskowal directive 2026-06-30T23:15Z).

**What I did:**
- Fetched PR #7 on `kriscendobot/agoric-sdk` (bot fork; no upstream contact) and the repo's `.github/PULL_REQUEST_TEMPLATE.md` (single-file template; no `PULL_REQUEST_TEMPLATE/` dir).
- Rewrote the **body** to fit the template's structure: a `refs:` line (pointing at kriskowal/garden#9, since this is fork-internal with no closeable issue), a **## Description** section, and the five template subsections — **Security / Scaling / Documentation / Testing / Upgrade Considerations** — each filled in substantively rather than left as placeholder comments.
- Preserved all substance: the XS-safe bounded-loop hex decoding table (byte-identical 484-entry map, commit `47b701c`), the Bufferish codec validation tightening (commit `f36fd16`), and the CI/portability/DRAFT-fork-internal notes — just restructured under the template headings.
- Kept the **title** in agoric-sdk's conventional-commit format (`fix(internal): …`); the template constrains the body, not the title, and the existing title was already accurate and conventional.
- Updated via `gh pr edit ... --body-file`.
- Posted the acknowledged-comment **reply** (issue comment 4848706424) confirming the restructure.

**Changed:** PR #7 body (now template-conformant). No code/worktree changes — this job was a PR-metadata edit, so nothing was committed to main2.

**Follow-ups:** none. PR remains DRAFT and fork-internal.
