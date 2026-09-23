Addressed PR #852 review feedback in commit `73f3d1b395`.

- Clarified `makeBufferedReader` as a push-fed, unbounded producer kit, distinct from iterator adapters and backpressured pipes.
- Posted the inline reply and required top-level PR summary.
- `git diff --check` and direct Prettier check passed.
- Full local suite could not run because cached dependency runners returned permission denied; CI is now running. Review was not re-requested.
