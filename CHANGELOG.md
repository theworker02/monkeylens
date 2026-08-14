# Changelog

All notable changes to MonkeyLens are documented here.

## 0.4.0 — 2026-08-14

- Record `original_name`, `aliases`, and `super_owner` on every captured method.
- Diff `alias_changed` and `super_owner_changed` so alias_method and prepend-layer shifts are visible.
- Inspect output includes aliases and the super-method owner.

## 0.3.0 — 2026-08-11

- Added `MonkeyLens::Provenance` to attribute method `source_location` to gem, app, stdlib, or eval origins.
- Opt-in provenance capture via `provenance: true` on `MonkeyLens.capture` and `--provenance` on CLI capture/inspect.
- Included provenance in inspect output and snapshot method records when enabled.

## 0.2.0 — 2026-08-04

- Added `MonkeyLens::Policy` for approving known runtime drift without deleting evidence from the baseline.
- Added wildcard waivers for change type, target, and method identifiers.
- Required a written reason for every waiver.
- Added optional ISO-date expiration for temporary approvals.
- Added YAML policy loading through `MonkeyLens::Policy.load`.
- Added `Policy::Decision` with effective and waived changes, threshold evaluation, and JSON-ready output.
- Added the `MonkeyLens.evaluate` convenience API.

## 0.1.0 — 2026-08-04

- Initial runtime snapshot and drift engine.
- CLI commands for capture, check, diff, inspect, and doctor.
- Text, JSON, and SARIF formatters.
- Rake and Rails integrations.
- RBS signatures, CI, Pages, release, and RubyGems publishing workflows.
