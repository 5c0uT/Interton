# Interton: справочник стандартной библиотеки и встроенных функций

Целевая версия: `Interton beta-v_.6.2`

## 1. Как пользоваться этим файлом

Это reference-документ:

1. какие функции доступны из коробки,
2. как их вызывать,
3. где применять,
4. что важно проверять в runtime.

Для обучения с нуля сначала: `00-quick-start.md` -> `01-language-basics.md`.

## 2. Built-ins: ввод/вывод

## 2.1 `inscribe(...)`

Назначение: вывод аргументов в одну строку через пробел.

Пример:

```interton
adding std.io

call main() -> int {
    inscribe("sum:", 2 + 3)
    return 0
}
```

Вывод:

```text
sum: 5
```

## 2.2 `enter(...)` и `input(...)`

Текущее поведение (`beta-v_.6.2`): это синонимы в runtime.

1. оба читают строку из `stdin`,
2. оба принимают prompt,
3. оба возвращают `string`.

Пример:

```interton
adding std.io

call main() -> int {
    string name = enter("Имя: ")
    string city = input("Город: ")
    inscribe("name:", name)
    inscribe("city:", city)
    return 0
}
```

Пример диалога:

```text
Имя: Alex
Город: Kazan
name: Alex
city: Kazan
```

## 3. Built-ins: преобразования типов

Поддерживаемые базовые преобразования:

1. `int(x)`,
2. `float(x)`,
3. `string(x)`,
4. `bool(x)`,
5. `to_string(x)`.

Пример:

```interton
adding std.io

call main() -> int {
    int a = int("42")
    float b = float("3.5")
    string c = to_string(99)
    bool ok = bool(1)
    inscribe(a, b, c, ok)
    return 0
}
```

Вывод:

```text
42 3.5 99 true
```

## 4. Built-ins: optional и массивы

1. `some(value)` — создать optional со значением,
2. `new_array(size)` — создать массив фиксированного размера.

Пример:

```interton
adding std.io

call main() -> int {
    var maybe = some(123)
    var arr = new_array(3)
    arr[0] = 10
    arr[1] = 20
    arr[2] = 30
    inscribe("maybe:", maybe)
    inscribe("arr0:", arr[0])
    return 0
}
```

Вывод:

```text
maybe: 123
arr0: 10
```

## 5. `std.system.files` (файлы и JSON)

Основные функции:

1. `read_file(path)`,
2. `read_lines(path)`,
3. `write_file(path, data)`,
4. `append_file(path, data)`,
5. `read_json(path)`,
6. `write_json(path, obj)`,
7. `open_file(path, mode?)`.

Потоковые функции:

1. `read_chunk(stream, size?)`,
2. `eof(stream)`,
3. `close(stream)`.

Правило:

1. небольшие файлы — `read_file/write_file`,
2. большие файлы — `open_file + read_chunk`,
3. всегда закрывайте поток через `close`.

## 6. `std.system.memory`

Доступно:

1. `used_bytes()`,
2. `page_size()`,
3. `gc_collect()`.

Применение:

1. диагностика памяти,
2. контроль нагрузки,
3. сервисные отчеты.

## 7. `std.system.threads`

Доступно:

1. `sleep(milliseconds)`,
2. `yield()`,
3. `hardware_concurrency()`.

Пример:

```interton
adding std.io
adding std.system.threads

call main() -> int {
    inscribe("threads:", hardware_concurrency())
    return 0
}
```

Вывод (пример):

```text
threads: <platform-dependent>
```

## 8. `std.math` и подмодули

## 8.1 База `std.math`

Часто используемые функции:

1. `sqrt`, `pow`,
2. `sin`, `cos`,
3. `abs`, `log`,
4. `random`.

## 8.2 `std.math.basic`

Утилиты:

1. `sum`, `min`, `max`,
2. `sorted`, `reversed`.

Проверочный пример: `examples/basic/module_alias_using.it`

Фактический вывод:

```text
sum: 14
sorted: [1, 1, 3, 4, 5]
max: 5
```

## 8.3 `std.math.statistics`

Типовые функции:

1. `mean`, `variance`, `standard_deviation`,
2. `median`, `mode`,
3. `correlation`, `probability`.

## 8.4 `std.math.linear`

Типовые функции:

1. `dot`, `cross`, `normalize`,
2. `transpose`, `determinant`, `rank`, `inverse`.

## 8.5 `std.math.advanced`

Типовые функции:

1. `derivative`,
2. `integral`,
3. `limit`.

## 9. Domain stacks: быстрый справочник

## 9.1 Quantum

Часто используемые имена:

1. `H`, `X`, `Y`, `Z`,
2. `Rx`, `Ry`, `Rz`,
3. `CNOT`, `CX`, `CZ`, `CRz`,
4. `measure`.

## 9.2 Interf

Пространства:

1. `interf.math.*`,
2. `interf.wave.*`.

Примеры функций из runtime:

1. `interf.wave.interfere`,
2. `interf.wave.fourier_transform`,
3. `interf.math.mean`, `interf.math.variance`.

## 9.3 Interference

Пространства:

1. `interference.light.*`,
2. `interference.sound.*`,
3. `interference.quantum.*`,
4. `interference.advanced.*` (алиас-уровень к подфункциям).

## 9.4 Rendering

1. `rendering.ray.*`.

## 10. Mermaid runtime API

Доступные точки:

1. `mermaid_config` / `mermaid.config`,
2. `mermaid_status` / `mermaid.status`,
3. `mermaid_config_json`,
4. `mermaid_status_json`.

Что смотреть в первую очередь:

1. `cluster_mode`,
2. `deep_retry_count`, `deep_failover`, `deep_force_no_cache`,
3. `cache_hits/cache_misses/failures/last_error`.

## 11. `get_tunnel_stats`

Синонимы:

1. `get_tunnel_stats`,
2. `std.system.get_tunnel_stats`,
3. `tunnel.get_stats`.

Проверочный пример: `examples/all_examples/14_tunnel_cache.it`

Фактический вывод:

```text
mix: 2.28571 2.28571
tunnel stats: 1
```

## 12. Минимальный smoke-набор перед релизом

1. `inscribe`,
2. `enter/input`,
3. type conversions,
4. `std.system.files` read/write,
5. `hardware_concurrency`,
6. один math-пример,
7. `mermaid_config_json`,
8. `get_tunnel_stats`,
9. один `interference` или `quantum` сценарий.

