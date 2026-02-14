# Interton: модули, подмодули, `adding` и `using` (расширенный гайд)

Целевая версия: `Interton beta-v_.6.1`

## 1. Зачем нужна модульность в Interton

Модульная модель Interton решает три задачи:

1. разделить код по зонам ответственности,
2. переиспользовать общий стек функций,
3. контролировать область имен (namespace), чтобы не ловить коллизии.

Важно: в Interton есть два разных этапа подключения — `adding` и `using`. Новички часто путают их.

## 2. `adding` и `using`: точная разница

`adding`:

1. делает модуль/пространство имен доступным,
2. может назначить alias через `as`.

`using`:

1. говорит компилятору, как разрешать короткие имена в текущем файле,
2. для `mermaid.*` дополнительно включает runtime-конфигурацию Mermaid.

Коротко:

1. `adding` = "подключить источник символов",
2. `using` = "разрешить короткие вызовы/активировать режим".

## 3. Формы `adding`

## 3.1 Подключение стандартного модуля

```interton
adding std.io
adding std.math.basic
```

## 3.2 Подключение с alias

```interton
adding std.math.basic as mb
```

После этого можно обращаться через `mb.*`.

## 3.3 Межъязыковой блок (foreign function)

```interton
adding <cpp> cpp_scale(value: int, factor: int) -> int {
    return value * factor;
}
```

Это не "модуль" в классическом смысле, но подключение идет через тот же `adding`-механизм.

## 4. Формы `using`

## 4.1 Обычный alias-режим

```interton
adding std.math.basic as mb
using mb;
```

Теперь вызовы `sum(...)`, `max(...)` разрешаются через `mb`.

## 4.2 Mermaid-режим (с конфигурацией)

```interton
using mermaid.struct;
using mermaid.cluster(1);
using mermaid.deep(retry=2 failover=true cache=true);
```

Или блочно:

```interton
using mermaid {
    struct,
    cluster(1),
    deep(retry=2 failover=true cache=true)
};
```

## 5. Пример без `using` (полные имена)

Файл: `examples/basic/module_using_alias_variants2.it`

```interton
adding std.io
adding std.math.basic

call main() -> int {
    float[] nums = [1, 2, 3, 4]
    inscribe("sum:", std.math.basic.sum(nums))
    inscribe("min:", std.math.basic.min(nums))
    inscribe("max:", std.math.basic.max(nums))
    inscribe("sorted:", std.math.basic.sorted(nums))
    return 0
}
```

Фактический вывод:

```text
sum: 10
min: 1
max: 4
sorted: [1, 2, 3, 4]
```

Когда выбирать такой стиль:

1. критична максимальная явность,
2. в файле много похожих alias,
3. код будет читать новая команда.

## 6. Пример с `using` (короткие имена)

Файл: `examples/basic/module_alias_using.it`

```interton
adding std.io
adding std.math.basic as mb

using mb

call main() -> int {
    int[] data = [3, 1, 4, 1, 5]
    std.io.inscribe("sum:", sum(data))
    std.io.inscribe("sorted:", sorted(data))
    std.io.inscribe("max:", max(data))
    return 0
}
```

Фактический вывод:

```text
sum: 14
sorted: [1, 1, 3, 4, 5]
max: 5
```

Когда это лучше:

1. частые короткие вызовы одного и того же стека,
2. хотите уменьшить визуальный шум.

## 7. Базовые стеки и подмодули

## 7.1 `std.io`

1. `inscribe`,
2. `enter`/`input`.

## 7.2 `std.system.files`

1. `read_file`, `read_lines`,
2. `write_file`, `append_file`,
3. `read_json`, `write_json`,
4. `open_file`, `read_chunk`, `eof`, `close`.

## 7.3 `std.system.memory`

1. `used_bytes`,
2. `page_size`,
3. `gc_collect`.

## 7.4 `std.system.threads`

1. `sleep`,
2. `yield`,
3. `hardware_concurrency`.

## 7.5 `std.math.*`

1. `std.math` (база: `sqrt/pow/sin/cos/log/random`),
2. `std.math.basic`,
3. `std.math.statistics`,
4. `std.math.linear`,
5. `std.math.advanced`.

## 7.6 Доменные стеки

1. `quantum.*`,
2. `interf.*`,
3. `interference.*`,
4. `rendering.ray.*`.

## 8. Mermaid как особый случай `using`

Для обычных модулей `using` — это только резолвер имен. Для Mermaid — это еще и runtime-конфиг.

Проверка:

Файл: `examples/basic/mermaid_config_demo.it`

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

Фактический вывод:

```text
mermaid_config: {"struct": true, "cluster_mode": 1, "cluster": true, "deep": true, "deep_force_no_cache": false, "deep_failover": true, "deep_retry_count": 0, "deep_config": "custom_rules"}
```

## 9. Конфликты имен и как не ошибиться

Риск: одинаковые имена функций в разных модулях.

Практика:

1. для часто пересекающихся API не включайте `using`,
2. оставляйте вызовы через полный путь,
3. вводите alias только для 1-2 реально активных стеков.

## 10. Рекомендуемый порядок подключений

1. `adding std.*`,
2. `adding domain.*`,
3. `adding project.*`,
4. `using ...`.

Шаблон:

```interton
adding std.io
adding std.math.basic as mb
adding quantum.core
adding modules.analytics as an

using mb
using an
```

## 11. Частые ошибки новичков

1. писать `using` без соответствующего `adding` для обычных модулей,
2. включать много alias в одном файле,
3. ожидать, что `using` сам «импортирует» модуль,
4. смешивать Mermaid-профили (`cluster(0)` и `cluster(1)`) без фиксации причин.

## 12. Диагностический чеклист

1. каждый модуль реально подключен через `adding`,
2. `using` используется только там, где повышает читаемость,
3. Mermaid-профиль проверяется через `mermaid_config_json()`,
4. фактический вывод примеров совпадает с документацией.
