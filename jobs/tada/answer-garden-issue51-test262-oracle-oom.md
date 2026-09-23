Investigated and posted the source-grounded reply on garden issue #51: https://github.com/kriskowal/garden/issues/51#issuecomment-5024023385

Findings: oracle process-RSS accumulation across fresh C-XS machine cycles; not test262 or GTT/computron budget; no evidence yet distinguishing leak from retained allocator/shared state; no like-for-like RSS comparison with Node/V8, SpiderMonkey, or JSC. Proposed measurement to settle it.

No repository changes required. Removed the isolated project worktree.
