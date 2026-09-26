Implemented, committed, and pushed `80b59b5c8d9` to `main2`.

- Added precedence: environment > journal `config/token-backoff-fraction` > `0.85`, with validation and WARN fallback.
- Added optional multi-line `priority_mandate:` from `config/foreman-mandate`.
- Confirmed `foreman-claude.sh` passes the complete digest verbatim.
- Added all requested present/absent/malformed/empty regression cases.
- Verified 466 relevant tests passed with zero failures.
- Confirmed the deployed checkout contains both changes and has no pending upgrade marker.

Deployment is complete and ready for the maintainer/liaison to write the two configuration files. Neither file was created by this job.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/foreman-budget-ramp-and-mandate.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (2 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (2 engagement(s) unpriced)
- Wall-clock: 1539s

<!-- garden-usage-end -->
