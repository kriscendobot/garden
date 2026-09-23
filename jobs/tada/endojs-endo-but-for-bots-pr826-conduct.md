orchestration-failed: true

Un-drafted PR #826, rebased it onto current `llm`, and force-pushed head `1aa98234b5de32d98a2c180c9d30de2d093a0321`. Posted the required PR summary comment.

Merge is blocked: the prior approval is stale after the rebase (`reviewDecision` is empty). Fresh CI is also still running (browser-tests and test); lint, build, and zizmor have passed. A maintainer must approve the rebased head before a conductor can merge.

Follow-up: post the maintainer-requested design job for ReadableBlob `lines()`.
