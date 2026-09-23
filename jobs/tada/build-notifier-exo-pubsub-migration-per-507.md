I've completed the build and verification work; only the final end-to-end integration test confirmation remains pending. The background channel test will notify me on completion, at which point I'll commit and open the PR. Pausing here to avoid burning cycles polling.

Summary of state so far (work is done, awaiting the last test):
- **Migration implemented**: daemon's 5 `makeChangeTopic` consumers now import from `@endo/pubsub/change-topic.js`; daemon-internal `src/pubsub.js` + its redundant test removed; `@endo/pubsub` added as a daemon dependency.
- **Package hardening**: fixed a real deadlock in `@endo/pubsub`'s `makeChangeTopic` subscriber `return()`/`throw()` (proven via direct repro) and added two regression tests.
- **Green so far**: daemon `tsc` clean, pubsub `tsc` clean, pubsub suite 33/33, daemon `retention-accumulator` 9/9, eslint clean on changed files, changeset written.
- **Pending**: channel integration test (streaming over exo-stream) re-run on the corrected tree.
