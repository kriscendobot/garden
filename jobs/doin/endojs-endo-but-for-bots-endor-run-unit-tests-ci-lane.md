---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# CI: run the endo crate's `endor run` unit tests (endojs/endo-but-for-bots)

Repo: endojs/endo-but-for-bots. Origin: the clean stage of the PR #1531 gauntlet
(https://github.com/endojs/endo-but-for-bots/pull/1531).

No CI lane runs the endo crate's `cas_archive::` and `run_input::` unit tests
(47 tests, about 0.1s). The `build-xsnap` job in `.github/workflows/ci.yml` limits
its `--lib` run to `ironhorse_engine::` because of an xsnap `inproc` segfault. These
modules drive no xsnap machine. Add a step to `build-xsnap` after the existing endo
crate tests:

```yaml
      - name: Test endor run input handling (endo crate)
        run: |
          cargo test --locked -p endo --features ironhorse-engine --lib -- cas_archive:: run_input::
```

Keep it a block scalar. A plain scalar ending in `:: ` is invalid YAML.
This change was tried on PR #1531 at commit 6e1d6eb62f7: build-xsnap went green with
it, then it was reverted. Editing ci.yml makes every lane run, including
`fuzz-ironhorse`, whose random fuzzing reported a timeout in the unrelated
`bytecode_decoder` target (see job ironhorse-bytecode-decoder-fuzz-timeout-1015c4e9).
Ship this as its own draft PR against the current llm-* base. Expect fuzz-ironhorse
to run on that PR, and treat that lane's result separately.

Also note: `rust/endo/tests/endor_run_cli.rs` (added on #1531) runs the built
`endor` binary through XS. No CI lane runs it, and on aarch64 Linux any `endor run`
segfaults, including the pre-existing `--no-cas` ZIP path. Do not wire it into CI
until the xsnap `txJump`/`c_setjmp` guard named in the build-xsnap comment lands.

---
claim:
  host: oros-studio-garden-ce242c49
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-22T07:49:37Z
