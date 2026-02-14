# Interton Mermaid Guide: what it is, how it works, what is implemented

Target version: `Interton beta-v_.6.1`

## 1. What Mermaid is in Interton

Mermaid in Interton is a polyglot runtime-configuration subsystem.

User model (target intent):

1. `struct` — structure cross-language data/call model,
2. `cluster` — control execution policy,
3. `deep` — define retry/failover/cache policy.

Critical note: this is **not** Mermaid diagram syntax. It is runtime behavior control.

## 2. Activation syntax

## 2.1 Separate directives

```interton
using mermaid.struct;
using mermaid.cluster(1);
using mermaid.deep(retry=2 failover=true cache=true);
```

## 2.2 Grouped block

```interton
using mermaid {
    struct,
    cluster(1),
    deep(retry=2 failover=true cache=true)
};
```

Parser expands grouped syntax into multiple `UsingNode` entries.

## 3. `cluster(mode)` parameters

`cluster(1)`:

1. conservative mode,
2. currently enables foreign-call cache usage.

`cluster(0)`:

1. aggressive mode,
2. currently disables foreign cache (`shouldUseForeignCache() = false`).

`cluster` without parameter:

1. `cluster_enabled=true`,
2. `cluster_mode=-1` (auto/unspecified).

## 4. `deep(...)` parameters

Supported keys in `beta-v_.6.1`:

1. `retry` / `retries` / `retry_count`,
2. `failover=true|false`,
3. `cache=true|false`,
4. `no_cache=true|false` / `force_no_cache=true|false`.

Current runtime behavior:

1. `retry` controls retry attempts for foreign calls,
2. `failover` enables/disables retry on failure,
3. `cache=false` or `no_cache=true` forces foreign-cache bypass.

## 5. What `struct` means

Target purpose of `struct`:

1. define cross-language interaction structure,
2. define role and path of exchanged data,
3. standardize interaction schema within one run.

Current runtime state: `struct` is stored as config flag (`mermaid_config.struct=true`) and participates in Mermaid config/status output.

## 6. Configuration validation (mandatory)

File: `examples/basic/mermaid_config_demo.it`

```interton
using mermaid {
    struct,
    cluster(1),
    deep(custom_rules)
};

call main() -> void {
    string cfg = mermaid_config_json();
    inscribe("mermaid_config:", cfg);
}
```

Observed output:

```text
mermaid_config: {"struct": true, "cluster_mode": 1, "cluster": true, "deep": true, "deep_force_no_cache": false, "deep_failover": true, "deep_retry_count": 0, "deep_config": "custom_rules"}
```

File: `examples/mermaid/mermaid_cluster_struct_variants3.it`

Observed output:

```text
mermaid: {"struct": true, "cluster_mode": 0, "cluster": true, "deep": true, "deep_force_no_cache": false, "deep_failover": true, "deep_retry_count": 0, "deep_config": ""}
```

## 7. What is already implemented in source (verified)

In `compiler/cli/interton_compiler.cpp`, implemented:

1. parsing/activation of `using mermaid.struct|cluster|deep`,
2. Mermaid config storage,
3. `mermaid_config(_json)` and `mermaid_status(_json)`,
4. counters: `foreign_calls`, `cache_hits`, `cache_misses`, `retry_attempts`, `failures`,
5. diagnostics: `last_error`, `last_language`,
6. `cluster(0)` and `deep(...cache...)` impact on foreign cache policy,
7. retry/failover execution logic for foreign calls.

## 8. What is NOT implemented as full runtime scheduler (important)

In `beta-v_.6.1`, there is **no** full Mermaid subsystem for:

1. automatic CPU/GPU scheduling,
2. explicit core/thread pinning through Mermaid directives,
3. process migration across cores/threads as an OS-level scheduler.

So Mermaid currently provides runtime policy/config for foreign-call flows, not a full low-level hardware scheduler.

## 9. Multilang example with Mermaid

File: `examples/mermaid/mermaid_multilang_cpp_only.it`

```interton
adding std.io

using mermaid.struct;
using mermaid.cluster(1);

adding <cpp> cpp_scale(value: int, factor: int) -> int {
    return value * factor;
}

call main() -> int {
    int out = cpp_scale(7, 3)
    inscribe("cpp scale:", out)
    return 0
}
```

Observed output:

```text
cpp scale: 21
```

## 10. Recommended profiles

## 10.1 Production-safe

```interton
using mermaid {
    struct,
    cluster(1),
    deep(retry=1 failover=true cache=true)
};
```

## 10.2 Diagnostic no-cache

```interton
using mermaid {
    struct,
    cluster(0),
    deep(retry=0 failover=false cache=false)
};
```

## 11. Common mistakes

1. enabling Mermaid but not checking `mermaid_config_json()`,
2. expecting full CPU/GPU scheduler behavior from current release,
3. comparing results without fixing `cluster_mode` and `deep` settings,
4. mixing production and diagnostic profile in the same run.

## 12. Release checklist

1. Mermaid profile is fixed in source,
2. CI logs include `mermaid_config_json()` and `mermaid_status_json()`,
3. `cache_hits/misses` and `failures` are validated,
4. `cluster(0)` and `cluster(1)` are tested on same workload,
5. project docs match actual runtime output.
