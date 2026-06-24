# scholar-ingest-cask-8 → cask library ingest cycle 9 complete

Ingested the cask `doc/design/` **protocol family** (3 docs, 7 sections), completing the protocol picture.

- **protocol.md** (casksock, the current plaintext local `cask/sock` protocol) → 3 sections, `current`.
- **protocol2.md** (CASK Network Protocol v2) → 3 sections, `superseded` — self-declares SUPERSEDED, never implemented; shipped as casksock + Noise-IK casknet. Retained for the Layer 0-4 vision (→ architecture.md) and the dual trace+priority cohort idea (→ TrafficClass/Priority).
- **protocol2-arch.md** (the design brief that requested v2) → 1 section, `superseded`; genesis of the cohort field name.

New concepts: `casksock-local-protocol`, `cask-protocol-v2-abandoned` (with a Common-confusions note vs Endo's `cohort-destruction`). Indexes: networking +7 (28), content-addressed-storage +2 (40), sources/README +3, concepts/README +2, keywords +19, cohort-destruction disambiguation. Pushed to journal2 (ed7b9dc1).

Follow-on **scholar-ingest-cask-9** posted for the ~17 remaining docs (data-structure cluster, dir v1/v2 supersession judgment, status/style/todo, comment fragments).

Self-improvement: nothing this time.
