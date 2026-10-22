---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
requires: host=endolin-garden-ece02cb4
---

# Open the draft PR for the endor-run unit-test CI lane (endojs/endo-but-for-bots)

Relay from job `endojs-endo-but-for-bots-endor-run-unit-tests-ci-lane` (host
oros-studio-garden-ce242c49, whose bot PAT gets 403 on `createPullRequest` against
endojs). The work is done and pushed. This job only opens the draft PR.

- Repo: endojs/endo-but-for-bots
- Head: `llm-endor-run-unit-tests-ci-lane` at `a2157494c7f52940676e6753ab219b2d88ee7f13`
  (one commit: `ci(endo): run endor run input-handling unit tests in build-xsnap`)
- Base: frozen `llm-54d3d2a` (= `llm` tip `54d3d2a682e7b17fc06beadc52370d3e41283280`, already on origin)
- Locally verified on aarch64 Linux: 29 passed, 0 failed for
  `cargo test --locked -p endo --features ironhorse-engine --lib -- cas_archive:: run_input::`

Procedure: check out the head with `ensure-project-worktree.sh <this-base>
endojs/endo-but-for-bots llm-endor-run-unit-tests-ci-lane`, confirm HEAD is
a2157494c7, write the body below to a file, and from that project worktree run:

    ensure-pr.sh endojs-endo-but-for-bots-endor-run-unit-tests-ci-lane endojs/endo-but-for-bots \
      llm-endor-run-unit-tests-ci-lane llm-54d3d2a \
      --title "ci(endo): run endor run input-handling unit tests in build-xsnap" \
      --body-file <file>

Use the ORIGINAL job base as the first argument so the `garden-job` marker matches
the producing job. Name the PR URL in your completion report so the gauntlet is
staged. Expect `fuzz-ironhorse` to run on this PR because ci.yml changed. Its
`bytecode_decoder` timeout is tracked separately by
`ironhorse-bytecode-decoder-fuzz-timeout-1015c4e9`, so judge that result separately
from this change.

## PR body (verbatim)

Refs: #1531

## Description

No CI lane runs the endo crate's `cas_archive::` and `run_input::` unit tests. The `build-xsnap` job in `.github/workflows/ci.yml` limits its `--lib` run to `ironhorse_engine::` because of the `inproc` xsnap segfault. These two modules use xsnap's archive types but drive no xsnap machine, so this PR adds a separate `build-xsnap` step after the existing endo crate tests:

```yaml
      - name: Test endor run input handling (endo crate)
        run: |
          cargo test --locked -p endo --features ironhorse-engine --lib -- cas_archive:: run_input::
```

The step uses a block scalar because a plain scalar containing `:: ` is not valid YAML.

This comes from the clean stage of the #1531 gauntlet. The same step went green in `build-xsnap` on #1531 at 6e1d6eb62f7 and was then reverted, so it ships here as its own PR.

### Security Considerations

None. This change only adds a CI test step.

### Scaling Considerations

The step reuses the build that `build-xsnap` already does, and the tests run in under a second.

### Documentation Considerations

None. No user-facing behavior changes.

### Testing Considerations

On aarch64 Linux at base `llm-54d3d2a`, `cargo test --locked -p endo --features ironhorse-engine --lib -- cas_archive:: run_input::` reports 29 passed, 0 failed, in 0.17s. On this base the count is 29. #1531 adds more tests to these modules.

Editing `ci.yml` triggers every lane, including `fuzz-ironhorse`. That lane's random fuzzing has reported a timeout in the unrelated `bytecode_decoder` target (tracked separately). Judge a `fuzz-ironhorse` result here separately from this change.

Not included: `rust/endo/tests/endor_run_cli.rs` (from #1531) runs the built `endor` binary through XS, and any `endor run` segfaults on aarch64 Linux. It stays out of CI until the xsnap `txJump`/`c_setjmp` guard named in the build-xsnap comment lands.

### Compatibility Considerations

None. This is CI only.

### Upgrade Considerations

None.

🤖 Generated with [Claude Code](https://claude.com/claude-code)

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-22T10:23:17Z
