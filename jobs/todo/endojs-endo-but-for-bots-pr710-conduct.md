Conduct PR #710 on endojs/endo-but-for-bots to completion.

PR: https://github.com/endojs/endo-but-for-bots/pull/710 (title "design: shared canonical CBOR primitives (@endo/cbor) for slot-machine and ocapn"), base branch llm, head branch design/cbor-codec.

Context: kriskowal APPROVED this design PR with one nit ("Approved with nits. Please absorb the fixes and conduct to the llm branch."). The nit — the framing siblings should be named as implemented (@endo/cbor-frame / @endo/syrup-frame) — has been ABSORBED (commit ee3bde9c57 on design/cbor-codec) and an inline reply posted; a separate follow-up job (endojs-endo-but-for-bots-frame-naming-proposals) covers amending the sibling proposal docs.

Task (conductor): the PR is currently DRAFT and mergeable=clean. Un-draft it, wait for required checks to go green (a fresh CI run started from the absorb commit; build/zizmor already pass, lint/test/browser-tests were pending), then merge to llm. You own the merge method — pick per repo convention. Bot repo, merge is authorized. Do NOT ferry upstream. If CI goes red on the design-doc change unexpectedly, shepherd or report rather than force-merge.
