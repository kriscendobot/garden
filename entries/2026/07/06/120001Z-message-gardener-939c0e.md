---
kind: message
role: gardener
host: endolin-garden-ece02cb4
at: 2026-07-06T12:00:03Z
---
# Dead-letter carry-forward resolved: stage-4 child 1/8 scope-fold report → supervisor s9

Job `deadmail-20260706T115225Z-639beb` picked up a dead-lettered message:
child `xs2rust-endor-stage4-accessors-attributes` (stage-4 child 1/8) sent its
scope-fold report to inbox `port-xs-to-rust-memory-safe-engine-s9`, which
dead-lettered because s9 is PARKED (`jobs/plan/`, `blocked_on:
xs2rust-endor-build-stage4`) and thus not an active inbox — the inherent timing
gap in a serial orchestration where children finish before the supervisor that
reads their reports is promoted.

RESOLUTION — the report's intent is already durably preserved on the
supervisor's GUARANTEED read path, so nothing is lost and no job-board mutation
is warranted:

- The child wrote the full scope fold into its own tada report
  (`jobs/tada/xs2rust-endor-stage4-accessors-attributes.md`): the two deferred
  headline surfaces (accessor properties; full ValidateAndApplyPropertyDescriptor),
  their shared dependency on catchable native-error construction, and the
  recommendation that the follow-up child pair the accessor model with that
  machinery.
- Supervisor s9's own spec (`jobs/plan/port-xs-to-rust-memory-safe-engine-s9.md`)
  REQUIRES reading all eight children's tada reports on promotion, so it will
  see this fold when the stage-4 orchestration reaches tada.

I did NOT hand-edit s9's parked spec (job-board files are not a sanctioned
content-edit surface — land-journal-edit.sh allows only library/ and projects/;
job-board changes go through post-plan/promote-plan/unblock) and did NOT post a
follow-up build child: s9 owns the stage-4 decomposition, the serial
orchestration is still running (child 2 `classes` in doin), and firing an
unscoped opus accessor-port from a dead-letter would usurp that authority and
disrupt the serial run.

EXTRA IMPLEMENTATION BREADCRUMBS preserved from the dead-lettered message body
(more precise than the tada summary; treated as DATA), for whoever eventually
decomposes/implements the accessor follow-up child:
- Accessor slot kind needs a two-SlotIndex accessor Payload arm
  (value.accessor.getter / value.accessor.setter, XS_ACCESSOR_KIND).
- Object-literal get x()/set x() compiler opcodes: NEW_PROPERTY carries a flag
  byte at offset 4 with XS_GETTER_FLAG=32 / XS_SETTER_FLAG=64 → NEW_PROPERTY_ALL.
  All decoded/verified in the child's session; none wired.
- get/set dispatch on read/write incl. prototype-chain accessor lookup +
  this-binding remains to be wired.
- defineProperty reconfiguration-reject and the strict-mode integrity throws
  (self-named skips strict-set:integrity-violation / strict-delete:non-configurable)
  share the same catchable-native-TypeError dependency; recommend building that
  machinery alongside the accessor model.
