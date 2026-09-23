Implemented and pushed PR #4 fixes.

- Commit: `63df8109aba818eb3fcbe9fb480f27205494b85c`
- Added copied, validated JSON-only compartment return boundary; rejects malformed, accessor, proxy-shaped, and BigInt data.
- Vended attenuated console/fetch wrappers without freezing host endowments; changed error taming to safe.
- Removed duplicate `input` global; aligned whitespace validation.
- Added error-path and unavailable-tool regressions.

Tests passed: `npm test` and `node --test packages/harness/test/spawn.test.js`.
