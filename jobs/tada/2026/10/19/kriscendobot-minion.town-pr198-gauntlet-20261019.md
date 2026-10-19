gauntlet-status: review-budget-reached
pr: https://github.com/kriscendobot/minion.town/pull/198
repo: kriscendobot/minion.town
pr_number: 198
kind: feature
stage: fix
iteration: 3
max_iterations: 3
resumes: 1
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
created_by: gardener
created_at: 2026-10-19T02:26:44Z
# gauntlet kriscendobot-minion.town-pr198-gauntlet-20261019 — review budget reached

Applied 3 panel/fix round(s); fix round 3 completed with its changes pushed and CI green. The subjective review did not converge within max_iterations=3, so the PR is left improved for a human merge/review decision. To grant more rounds: scripts/jobs/gauntlet.sh --resume-from-stage kriscendobot-minion.town-pr198-gauntlet-20261019 panel --add-rounds N

## Unaddressed must-fix

**Unaddressed must-fix: 20** · verdict: moving target · rounds spent: 3/3 · cost so far: $6.56
Trend: r1 n/a; r2 n/a; r3 raised 20
Classes: 0 persistent, 20 new in last round, 0 addressed-then-reintroduced
```text
[new, since r3] archivist: (designs/closed-beta-waitlist.md:147) should-fix designs/closed-beta-waitlist.md:147: the doc names "(at)endo/http-confine's limiter" as an existing t...
[new, since r3] archivist: (src/waitlist/waitlist.ts:249) Rate limit (5/hour, /24 or /48 key, Retry-After: 3600): src/waitlist/waitlist.ts:249,258-259.
[new, since r3] archivist: (src/waitlist/stores/dynamodb.ts:42) Dedupe via conditional put (attribute_not_exists(email)): src/waitlist/stores/dynamodb.ts:42.
[new, since r3] archivist: (deploy/aws/caddy/conf.d/minion-town.caddy:181) Caddy 308 for /index.html, /guest.html, /shell.html: deploy/aws/caddy/conf.d/minion-town.caddy:181-183.
[new, since r3] archivist: Public handle / carries the full CSP with frame-ancestors 'none' and X-Frame-Options: DENY: same file, lines 16...
[new, since r3] archivist: (src/waitlist/waitlist.ts:24) Table name default and the PutItem-only grant with ReturnValues NONE: src/waitlist/waitlist.ts:24, deploy/aws/sc...
[new, since r3] archivist: (src/waitlist-cli.ts:31) list / remove CLI and the oldest-first sort: src/waitlist-cli.ts:31-44, src/waitlist/stores/dynamodb.ts:93.
[new, since r3] archivist: (deploy/aws/www/index.html:358) Honeypot is off-screen (deploy/aws/www/index.html:358-360).
[new, since r3] archivist: The "tab and CR are refused by the email grammar" claim in the csvField JSDoc holds: EMAIL_PATTERN excludes \s ...
[new, since r3] archivist: Cross-doc anchors resolve: invitation-only-guest-onboarding.md § 7, closed-beta-waitlist.md § The one landing.
[new, since r3] locksmith: comment-only: the waitlist writer facet is structural, as POLA asks.
[new, since r3] locksmith: src/waitlist/stores/dynamodb.ts makeDynamoWaitlistWriter builds a frozen { add } that never closes over ScanCo...
… and 8 more
```
Severity: this list is every request-changes seat bullet. The panel blocks only on real defects (wrong behavior, security or authority errors, data loss, broken contracts, failing or missing tests for changed behavior, comments false enough to invite an unsafe change); comment or JSDoc wording, identifier spelling or style, commit-history tidiness, PR-description completeness, and test-style items are should-fix and never block (skills/panel/SKILL.md § Finding severity).
