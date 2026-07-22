Reviewed and reported issue #58: https://github.com/kriskowal/garden/issues/58#issuecomment-5047543752

Found B2 deployed successfully, but B3 is closed unmerged while B4 is active. Alerted B4 worker. No deployment attempted.

Follow-up: rebase, validate, and land B3 before B4 relies on daemon wiring.
