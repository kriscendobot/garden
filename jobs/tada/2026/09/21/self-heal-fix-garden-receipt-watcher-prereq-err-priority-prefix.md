Pushed to `main2` (commit `eee600976bb`).

## Completion report

**What the job asked:** Fix the `sed 's/^/  <label>: /'` stderr-relay pattern across the watcher fleet, which inserted its label *before* any leading journald syslog-priority tag (`<3>`/`<4>`/`<6>`) that the relayed subshell's own `log()`/`die()` wrote at column 0 (common.sh `SyslogLevelPrefix` convention). That corrupted the tag, so journald could no longer classify the relayed line's severity — silently hiding the real root-cause diagnostic behind the generic outer FATAL (reproduced by `garden-receipt-watcher@kriscendobot-endo`, rc=1).

**What I did:** Changed each relay-of-subshell-stderr site to `sed -E 's/^(<[0-9]>)?/\1  <label>: /'`, which keeps a leading priority tag at column 0 (verified at runtime: `<3>…FATAL…` → `<3>  prerequisite: …FATAL…`; a tagless line just gets the label). Fixed all 16 sites:

- `receipt-watcher.sh:89` (prerequisite) **and `:166` (source)** — the same-class bug in the same file, not enumerated in the spec but identical shape; fixed for consistency
- `ci-watcher.sh`, `dependabot-watcher.sh`, `mention-watcher.sh`, `issue-inbox-watcher.sh`, `approval-reconciler.sh`, `dependabotany-preflight.sh`, `backfill-dropped-review-comments.sh` (source)
- `comment-watcher.sh` ×5 (source + source(retry))
- `pages-watcher.sh` ×2 (source + source(retry))

**Out of scope, left untouched:** the data-list `sed 's/^/  /'` sites (`brake-foreman.sh`, `pause-project.sh`, `library-link-scan.sh`, `ironhorse-fuzz-migrate-backlog.sh`, `rerecord-reputation-arm.sh`, `regenerate-sections-index.sh`) — they relay plain indented lists, not subshell stderr, so carry no priority tag.

**Verification:** all 10 modified scripts pass `bash -n`; runtime behavior confirmed for both tagged and tagless input; no old-form relay sites remain.

**Follow-ups:** none. Line numbers in the spec were slightly stale (script drift) but all named sites were located and fixed.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/self-heal-fix-garden-receipt-watcher-prereq-err-priority-prefix.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 16 tokens (342350 cached reads)
- Output: 7385 tokens
- Cost: $0.7731279999999999
- Wall-clock: 113s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
