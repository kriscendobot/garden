Implemented and pushed `a31a27558b` to `main2`.

- Corrupt journal clones now atomically re-clone under the clone lock, including stale `gc.log`.
- Added/updated regression coverage for zeroed remote refs plus `gc.log`.
- Verified with shell syntax checks and a focused real clone-corruption recovery test.
