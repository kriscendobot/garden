Implemented and pushed `a2ae7cebd8` to `main2`.

- Correlated preflight evidence to feedback timestamps and reviewed HEAD SHAs.
- Generic acknowledgments now require a post-feedback commit that advances and names the reviewed SHA.
- Added deterministic JSON fixtures for review bodies, old/unrelated acknowledgments, head changes, direct replies, ID citations, and fail-open behavior.
- Ran focused suite: 10 passed.
- Live check for endojs/endo-but-for-bots#722 now returns `PROCEED` / exit 0.

Self-improvement: nothing this time.
