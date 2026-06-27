Done.

**What I did**
- Fixed `scripts/jobs/handlers/proxy-claude.sh` lines 56–58 in `answer_question()`. Each `printf '- …%s\n'` was being aborted by bash's `printf` builtin as `printf: - : invalid option`, making the proxy handler FATAL (exit 1) on every proxied question. All three lines carry a `%s` conversion, so per the job's guidance I used the end-of-options marker form: `printf -- '- … %s\n' "$arg"`.
- Verified with a smoke test reproducing the exact report block — it now renders the header plus the three bullet lines (`- gardener:`, `- question (msgid …)`, `- tentative answer:`) instead of dying.

**What changed**
- Committed on an isolated worktree off `origin/main2` (shared tree is concurrently mutated by the fleet) and pushed: `6ff2f8caa proxy-claude: guard leading-dash printf formats with -- so answer_question renders`. Worktree torn down.

**Scope/follow-ups**
- Only the three specified lines changed; no other handler has a leading-dash format (the other `printf 'awaiting maintainer …'`, `printf 'proxy answered …'`, etc. begin with normal text). No follow-ups.
