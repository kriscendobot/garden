Retconned PR #169 and force-pushed `f371b4dfc9`.

- Wove the branch onto current `llm`, resolving README bookkeeping.
- Replaced eight design/fixup commits with one `docs: add pass-style promise design` commit.
- Preserved the net diff exactly; `git diff` against the pre-retcon tree was empty and `git diff --check` passed.
- Posted the required PR completion summary. Local format/lint/build/test/docs were not runnable because dependencies are not installed in the isolated worktree.

Self-improvement: nothing this time.
