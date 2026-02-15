# Interton: language basics

Target version: `Interton beta-v_.6.2`

## 1. Program anatomy

A typical user file includes:

1. imports (`adding`),
2. optional `using` aliases,
3. functions/classes,
4. `call main() -> int` entrypoint.

```interton
adding std.io

call main() -> int {
    inscribe("start")
    return 0
}
```

Expected output:

```text
start
```

## 2. Imports

### Regular import

```interton
adding std.io
adding std.math.basic
```

### Alias import

```interton
adding std.math.basic as mb
using mb
```

What `using` does in practice:

1. activates previously declared alias/usage mode in the current file,
2. is applied after `adding`,
3. for special namespaces (for example `mermaid.*`), it enables runtime behavior rather than only short names.

### Grouped import

```interton
adding std { io, system.files, system.memory, system.threads }
```

## 3. Core types

Common user-facing types:

- `int`
- `float`
- `bool`
- `string`
- `void`

```interton
adding std.io

call main() -> int {
    int count = 3
    float ratio = 1.25
    bool ok = true
    string name = "interton"
    inscribe("hello:", name, "count:", count, "ratio:", ratio, "ok:", ok)
    return 0
}
```

Expected output:

```text
hello: interton count: 3 ratio: 1.25 ok: true
```

## 4. Arrays, tuples, slices

```interton
adding std.io

call main() -> int {
    int[] values = [10, 20, 30, 40, 50]
    inscribe("len:", |values|)
    inscribe("first:", values[0])
    inscribe("slice:", values[1..3].to_string())

    (int, string, bool) item = (7, "seven", true)
    inscribe(item.0, item.1, item.2)
    return 0
}
```

Expected output:

```text
len: 5
first: 10
slice: [20, 30, 40]
7 seven true
```

## 5. Optional values

```interton
adding std.io

call main() -> int {
    optional<int> maybe = none
    maybe = some(12)
    inscribe("value:", maybe.value)
    return 0
}
```

Expected output:

```text
value: 12
```

## 6. Control flow

```interton
adding std.io

call main() -> int {
    int total = 0
    for int i = 0; i < 5; i = i + 1 {
        total += i
    }

    int j = 0
    while j < 3 {
        inscribe("while:", j)
        j += 1
    }

    if total > 5 {
        inscribe("total is", total)
    } else {
        inscribe("small total")
    }

    return 0
}
```

Expected output:

```text
while: 0
while: 1
while: 2
total is 10
```

## 7. String forms

Interton supports regular strings, raw strings, f-strings, and multiline f-strings.

```interton
adding std.io

call main() -> int {
    string name = "Interton"
    int count = 3
    string msg = f"Hello {name}, count={count}"
    string raw = r"D:\\data\\file.txt"
    string multi = f"""Block:
{name}
{count + 1}
"""

    inscribe(msg)
    inscribe(raw)
    inscribe(multi)
    return 0
}
```

Expected output (sample):

```text
Hello Interton, count=3
D:\data\file.txt
Block:
Interton
4
```

## 8. Type aliases

```interton
type Result = success(value) | error(message);
type MaybeString = ok(value) | none();
```

Use aliases for stable inter-module contracts.


