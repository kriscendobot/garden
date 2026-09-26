Addressed PR #804 review in commit `3bb1d34c34`: renamed the framing design files and updated all local references. Posted the inline reply and top-level PR summary.

Verification: Prettier and staged-diff checks passed. Build, lint, and zizmor CI checks passed; browser-tests and test remain pending. Full local suite was blocked by `better-sqlite3` failing during immutable install.

Follow-up: re-request review after remaining CI checks pass.

Self-improvement: pre-push-gates driver was missing despite the skill reference; report this mismatch for repair.
