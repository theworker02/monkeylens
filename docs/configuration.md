# Configuration

MonkeyLens reads `.monkeylens.yml` unless another path is supplied.

```yaml
targets:
  - String
  - MyApp::User
ignore_methods:
  - MyApp::User#generated_attribute_methods
fail_on: high
format: text
```

## `targets`

A required list of constant names. Each constant must resolve to a `Module` or `Class` after all requested application files are loaded.

## `ignore_methods`

Optional fully qualified method identifiers. Instance methods use `Target#method`; singleton methods use `Target.method`.

## `fail_on`

The minimum severity that causes `monkeylens check` to exit with status 1: `low`, `medium`, `high`, or `critical`.

## `format`

Default report format: `text`, `json`, or `sarif`.
