# resolve merge conflict on endo-but-for-bots #572 (design-only, base `llm`)

PR #572 (design: byteArray maps a frozen Uint8Array view) is now Ready for
review but mergeStateStatus=DIRTY / mergeable=CONFLICTING against base `llm`.
Conflict is in designs/README.md (design-doc-only PR; files are
designs/README.md + designs/bytearray-uint8array-view.md).

Task: weave/rebase head branch `design/bytearray-uint8array-view` onto current
`llm`, resolve the designs/README.md conflict (preserve both sides' entries;
net design content invariant), push. Verify mergeable clears to a clean state.
No implementation code — doc-only conflict.
