Implemented and pushed `6f8501d8db` to `main2`.

- Corrupt journal-fetch failures now atomically re-clone once, retry once, and log the required repair message.
- Updated corruption tests to assert re-clone recovery and bounded failure behavior.
- Verified syntax/diff checks plus injected recovery and persistent-corruption scenarios.
