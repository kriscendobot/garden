---
title: History — from C.js and Montage Require to System
source: README.md
source_repo: gutentags/system
source_commit: 91508059e8241a53bb029592a7f0700e37bba513
source_date: 2017-06-27
source_authors: [Kris Kowal]
ingested: 2026-07-06
ingested_by: scholar
topics: [module-loader]
status: current
---

Abstract: System's lineage. The project began at Motorola Mobility with Tom Robinson's (@tlrobinson) work, originally called *C.js*, which became the module-loading foundation for Motorola Mobility's MontageJS web application framework — hence the name Montage Require, or *Mr*. Kris Kowal (@kriskowal) took over maintenance, converted it to use promises internally, and added support for loading npm-installed packages. Stuart Knightley (@stuk) took over when MontageJS work resumed at Montage Studio. System is a further iteration from that lineage with a more focused scope, targeting npm packages more precisely and adding the per-package (in `package.json`) configurable translators, compilers, and dependency analyzers.

This project started at Motorola Mobility with the work of Tom Robinson (@tlrobinson), originally called C.js. This became the foundation for module loading in Motorola Mobility's MontageJS web application framework, thus the name Montage Require, or Mr. Kris Kowal (@kriskowal) took responsibility for maintaining the library, converted it to use promises internally, and added support for loading packages installed by npm. Stuart Knightley (@stuk) took over responsibility for maintaining the library when work on MontageJS resumed at Montage Studio.

The System module loader is an iteration from that lineage, with a more focused scope, targeting npm packages more precisely, and adding support for configurable (per package in package.json) translators, compilers, and dependency analyzers.

Source: [README.md](https://github.com/gutentags/system/blob/91508059e8241a53bb029592a7f0700e37bba513/README.md) at commit `9150805`.
