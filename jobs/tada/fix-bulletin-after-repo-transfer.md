Implemented and pushed `2a78688de5` to `main2`.

- Canonicalized the remaining current PAT-scope reference to `kriscendobot/garden`.
- Verified the transfer fix already present: current Pages URL, owner-scoped PAT setup guidance, and clear 401/403/404 save errors.
- Preserved the sole old Pages URL as explicit transfer history; retained ~176 old-owner references that are historical links, migration aliases, or test fixtures. Replaced 6 current-fact references.
- Live HTTP checks passed: bulletin 200, deployed design canonical, unauthenticated `journal2` Contents read 200.
- `node --check`, save-error mapping test, `bash -n`, and workflow shellcheck passed. Full checks had 2 unrelated pre-existing failures (`maintainer_inbox_information_hiding`, `run_all`).
- Browser UI run not verified: PinchTab and Chrome are unavailable.

Self-improvement: nothing this time.
