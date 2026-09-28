The job is complete. Here is the completion report.

---

**Completion report: mentat-minion-town-endor-ironhorse-snapshot-platforms (designer)**

**Design file:** `designs/process-snapshot-persistence-by-platform.md` on `kriscendobot/minion.town`, delivered as **draft PR https://github.com/kriscendobot/minion.town/pull/123** (head `design/process-snapshot-persistence-by-platform`, frozen base `main-f69bf87`; the diff is the design file and nothing else). Left draft per the manual-gauntlet regime; promote with "run the gauntlet #123". The PR carries the durable job marker and was recorded on the job's work file. A journal `result` entry was posted (`entries/2026/09/28/061337Z-result-designer-4e2c27.md`).

**What the design says.** It separates the two Endo engine mechanisms — whole-heap `XS_M` blob snapshots streamed into a SHA-256 CAS (`daemon-xs-worker-snapshot`), and Iron Horse's database-backed heap behind the `HeapStore` trait with incremental checkpoints, lazy wake (0.41 ms vs 15.3 ms eager on the 120k-slot fixture), and `(epoch, seal)` succession (`ironhorse-snapshot-store-seam`) — and states the engine-versus-platform contract with an ownership map: the engine owns format, determinism (`deterministic-math` + ICU profile for cross-host), refusal semantics, idle-only quiescence, and meter-state carriage; the platform owns only CAS, transactional metadata, compute, lease, and wake path. Per-platform (all vendor facts first-party-cited, fetched 2026-09-28, unverified items flagged): AWS = the incumbent (S3+DynamoDB per PR #637 seams, storage-scales-to-zero but compute does not); Cloudflare = two shapes (Containers+R2+Durable-Objects shipping, but ephemeral container disk degrades mechanism B to export-at-sleep; prospective Iron-Horse-on-wasm32 inside a DO is architecturally the best HeapStore fit anywhere); Hetzner/DigitalOcean = cheapest always-on with undocumented object-store consistency (harmless under content addressing); fly.io = the layered complement (platform Firecracker suspend for short idleness, explicitly non-durable and host-pinned; engine snapshots to Tigris for migration); exe.dev = developer preview, persistent-disk pooled-quota VMs with brokered external storage where credentials never enter the VM, idle semantics undocumented. It compares KaozKit (same mechanism, informal compatibility; Endo adds the CAS, journal/replay, metering, and explicit compatibility axes), marks the cross-repo Endo implications in their own section (finish PR #637 seams, daemon-side worker-engine integration, a snapshot compatibility manifest, a remote HeapStore probe, fan-out entropy hygiene, metering reservation identity #982-#984), and hooks sharding to the sibling plan.

**Open questions for the maintainer (section 11):** which platform is second (fly.io for economics vs Cloudflare for probe value); whether Iron-Horse-on-wasm32 is in scope; whether remote `HeapStore` backends are first-class or export-at-sleep is the permanent shape; the earliest minion.town increment (thixotrope probe beside the daemon vs waiting for daemon-integrated engines); whether fly platform-suspend is acceptable as an ops accelerator; exe.dev's intended role; snapshot GC/retention (superseded sleep images vs the metering design's keep-forever).

**Proposed build sequence (suggested basenames, not posted):** `design-endo-snapshot-compat-manifest`, `build-endo-daemon-platform-store-seams`, `probe-minion-town-thixotrope-sleep-wake`, `probe-ironhorse-wasm32-workerd`, `design-minion-town-fly-shard-machine`, `design-endo-remote-heapstore-backend`.

**Notes.** Sibling mentat plans (`aws-distributed-persistence`, `cloudflare-backend`, `alt-hosts-backend`, `per-principal-sharding`) had not landed (all still in `todo/`); the design's Companion header records the ownership boundary against their expected filenames. The mermaid diagram parse-validated; in-repo claims cross-verified against the checkout (`PINNED_ENDO_COMMIT`, the endo-daemon.service worker accounting, `ACCOUNT_STORE` adapter selection). No inbox messages arrived during the job (the inbox drain script's private clone was offline twice, but no inbox directory exists for this base, so nothing was pending). No cloud resources created, nothing deployed.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/mentat-minion-town-endor-ironhorse-snapshot-platforms.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 60 tokens (4317267 cached reads)
- Output: 47726 tokens
- Cost: $16.113849300000005
- Wall-clock: 1225s
- Model(s): claude-fable-5 ×1

<!-- garden-usage-end -->
