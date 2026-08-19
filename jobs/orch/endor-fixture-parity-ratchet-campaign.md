---
order: serial
children: endor-parity-oracle-scaffold endor-walker-cjs-require endor-walker-exports-resolution endor-walker-dep-classification endor-walker-dynamic-import endor-walker-nested-resolution endor-walker-language-extensions endor-walker-host-hooks
on-child-failure: halt
state: pending
created_by: designer
created_at: 2026-08-19T05:40:25Z
---

# Orchestration — endor↔node fixture-parity ratchet campaign

Carries `designs/endor-fixture-parity-ratchet.md` forward: advances the
compartment-mapper fixture-parity manifest from 7-of-40 exercised toward parity,
one walker capability per child. Serial, halt-on-child-failure — each increment
depends on the prior's capability and the ratcheting exercised floor. Child 0
(oracle scaffold) must land first; every later child consumes its golden mechanism
and two-tier exclusion split.
