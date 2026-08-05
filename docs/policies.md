# Runtime drift policies

MonkeyLens 0.2.0 can preserve a complete runtime diff while waiving changes that have been explicitly reviewed.

Create `.monkeylens-policy.yml`:

```yaml
waivers:
  - type: method_added
    target: MyApp::LegacyAdapter
    method: "MyApp::LegacyAdapter#instrumented_*"
    reason: temporary observability instrumentation
    expires_on: 2026-10-01
```

Evaluate a diff:

```ruby
policy = MonkeyLens::Policy.load(".monkeylens-policy.yml")
decision = MonkeyLens.evaluate(result, policy:, threshold: "high")

abort JSON.pretty_generate(decision.to_h) if decision.failure?
```

Waiver fields accept shell-style wildcards:

- `type` matches change types such as `owner_changed` or `method_added`;
- `target` matches the class or module name;
- `method` matches identifiers such as `String#upcase` or `Time.now`;
- `reason` is mandatory;
- `expires_on` is optional and uses ISO `YYYY-MM-DD` format.

Expired waivers never match. The decision keeps waived changes separate from effective changes so approvals remain auditable instead of disappearing from the report.
