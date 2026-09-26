Posted the reply: https://github.com/kriskowal/garden/issues/34#issuecomment-4928584815

## Completion report

**Job:** Dead-lettered message pickup — a maintainer comment on kriskowal/garden issue #34 ("CAS and DID") whose intended recipient (`issue-kriskowal-garden-34`) had already completed. I carried the intent forward as new work.

**What the comment asked (four questions on Endo's content-addressed `loadContent` locator design):**
1. What a magnet URL looks like with a Git connection hint.
2. Whether magnet extends to trees or just files.
3. Confirmation of a proposed OCapN-locator / magnet-locator layering.
4. A sensible variety of magnet source mechanisms for Endo CAS.

**What I did:**
- Read the full issue #34 thread for continuity with the two prior bot answers (DID-fit analysis, then magnet-URI prior art).
- Ran a focused research pass to ground the two factual load-bearing claims: `git+https`/`git+ssh` `@<oid>` prior art (pip, Go) and BEP-52's nested file-tree/merkle structure confirming magnet natively addresses trees.
- Posted a cited reply on the issue thread that: gives a concrete `x.git=` magnet example and flags that a Git OID is a *different, typed* content-address (a location hint re-hashed against `xt`, not the identity); confirms magnet extends to trees (v1 multi-file, BEP-52 file tree, IPFS UnixFS dir, git tree/commit oids) with an Endo blob→git-blob / tree→git-tree mapping table; confirms the layering (OCapN authenticates the *source*, magnet authenticates the *content*; a magnet locator is a witness of immutability, so blobs/trees are magnetizable but mounts/scratch are not); and recommends a tiered verify-on-load source set with a small core (OCapN + HTTPS + Git) plus the `x.` extension escape hatch. Surfaced the one real design dependency: Endo must define a canonical tree hash + git-tree/UnixFS→canonical mappings before any tree-capable source can be verified on load.

**Changed:** nothing in the garden repo — this was a research/consulting reply. No commit or push needed. Comment posted under the bot identity via the fleet `gh` wrapper. Did not close the issue (the submitter does that).

**Follow-ups:** none required; the maintainer may continue the thread, which would arrive as a fresh issue-comment job.
