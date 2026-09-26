Implemented and pushed `e66d640c0` to `endo-registry-capability`.

- Split registry backend/powers; injected fetch, gunzip, and hash dependencies.
- Removed `globalThis.fetch` fallback and dynamic Node imports.
- Threaded `ENDO_REGISTRY_URL` through daemon config.
- Added scoped-name encoding regression coverage.
- Replied via PR fallback comments (inline endpoint returned 404 for stale threads).
- Posted `design-endor-registry-transport` for missing Rust Endor transport powers.

Verified:
- Registry backend tests: 4 passed.
- Daemon TypeScript check: passed.
- Touched-file ESLint: no errors.

Not verified: XS parity, because `target/release/endor` is absent.
