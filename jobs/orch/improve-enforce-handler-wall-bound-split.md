---
order: serial
children: improve-enforce-handler-wall-bound-watchdog improve-enforce-handler-wall-bound-regression
on-child-failure: halt
state: pending
created_by: producer
created_at: 2026-10-27T15:06:13Z
---

The original watchdog-hardening job decomposes into two ordered, independently claimable slices: first make handler-tree termination and failure evidence bounded and fail-closed; then add an adversarial descendant fixture and use it to validate and, if necessary, integrate-fix the wall-bound behavior. Serial order prevents the regression slice from duplicating or racing the production implementation. Halt on child failure so the final validation is never treated as satisfied after an incomplete watchdog change.
