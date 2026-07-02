# Replicate #594's lint fix onto llm and MERGE IMMEDIATELY (unblock llm shepherds)
Repo: endojs/endo-but-for-bots (bot direct push; bot identity). **Urgent unblock.**
Source: PR #594 — *chore(lint): lint per package to avoid the typescript-eslint project-service ceiling*
(base `master`) — https://github.com/endojs/endo-but-for-bots/pull/594. The lint / project-service-ceiling
problem it fixes is **blocking shepherds working on the `llm` branch** (their lint/CI fails).
Task:
1. **Replicate #594's diff AS-IS** (the per-package lint config change) onto a new branch off current **`llm`**
   (e.g. `chore/lint-per-package-llm`), adapting only as needed for any llm↔master differences. Do NOT
   redesign it here — this is the quick unblock.
2. Open a PR with base **`llm`**, confirm the lint change actually works on llm (lint passes), then
   **MERGE IT IMMEDIATELY** (conductor — do not name the merge method; do NOT run the full
   design/build/judge gauntlet — this is a deliberate fast unblock authorized by the maintainer).
3. Post a summary comment: this is the **llm-side unblock replica** of #594; the **master-based #594 stays
   open** for the perf verification + bucketing + eventual upstream ferry (tracked separately —
   `ebfb-pr594-verify-lint-perf-and-bucket`). "Changes based on master need further consideration and ferrying."
Scope: bot fork, base `llm`, bot identity, no upstream contact.
