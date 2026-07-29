---
role: gardener
model: gpt-5.6-terra
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-29T21:46:04Z cleared=none -->

---
model: gpt-5.6-terra
role: gardener
---
# Make dispatch pins tier-native

Repository: kriscendobot/garden. Land directly on main2, no PR.

Correct the model-tier implementation landed in e402b90483 and 2311255c46 before it is deployed. The durable job dispatch contract must pin capability tiers, not concrete providers or model ids.

Implement first-class leading frontmatter fields tier: mentat|mentor|minion|myrmidon and fallback-tier: <ordered tier chain>. Automatic producers must emit tier: mentor for the present quota policy, never model: kimi-k3. Manual high-tier dispatch emits tier: mentat with dispatch: manual. Claim eligibility must resolve a tier against the closed model inventory, current provider availability, host capabilities, routing policy, price/reputation signals where applicable, and the manual-only mentat boundary, then record the actual selected provider/model separately as claim or award metadata. A job remains pinned to its tier even when the concrete model selected for that tier changes.

Retain legacy model: parsing only as a bounded compatibility/migration surface; new automatic post-job, post-plan, scheduler, watcher, follow-up, auction, role-default, and reaper output must use tier fields. Replace concrete fallback-model routing with fallback-tier. Ensure the weekly model-tier-effectiveness-review schedule is tier: mentor, not model: kimi-k3. Unknown tiers and models fail closed. Update the executable inventory, model-selection skill, producer documentation, migrations, and regression tests. Tests must prove: producers contain no concrete model pin; mentor currently selects Kimi; minion can select Opus or Codex according to availability/policy; mentat is manual-only; changing a tier-to-model assignment does not rewrite job intent; legacy concrete jobs migrate deterministically.
