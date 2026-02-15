# Interton Mermaid Guide: что это, как работает, что уже реализовано

Целевая версия: `Interton beta-v_.6.2`

## 1. Что такое Mermaid в Interton

Mermaid в Interton — это подсистема конфигурации межъязыкового выполнения (polyglot runtime).

Пользовательская модель (цель):

1. `struct` — структурировать межъязыковую модель данных и вызовов,
2. `cluster` — управлять политикой исполнения задач,
3. `deep` — задавать retry/failover/cache-правила.

Критично: это **не** mermaid-диаграммы. Это runtime-настройка поведения.

## 2. Синтаксис подключения

## 2.1 Отдельные директивы

```interton
using mermaid.struct;
using mermaid.cluster(1);
using mermaid.deep(retry=2 failover=true cache=true);
```

## 2.2 Блочная форма

```interton
using mermaid {
    struct,
    cluster(1),
    deep(retry=2 failover=true cache=true)
};
```

Блочная форма парсером разворачивается в несколько `UsingNode`.

## 3. Параметры `cluster(mode)`

`cluster(1)`:

1. консервативный режим,
2. в текущем runtime включает кеш foreign-результатов.

`cluster(0)`:

1. более агрессивный режим,
2. в текущем runtime отключает foreign-кеш (`shouldUseForeignCache() = false`).

`cluster` без аргумента:

1. `cluster_enabled=true`,
2. `cluster_mode=-1` (авто/не задан явно).

## 4. Параметры `deep(...)`

Поддерживаемые ключи в `beta-v_.6.2`:

1. `retry` / `retries` / `retry_count`,
2. `failover=true|false`,
3. `cache=true|false`,
4. `no_cache=true|false` / `force_no_cache=true|false`.

Что реально делают ключи:

1. `retry` — количество повторов foreign-вызова,
2. `failover` — разрешение на повтор при ошибке,
3. `cache=false` или `no_cache=true` — принудительное отключение foreign-кеша.

## 5. Что значит `struct`

Пользовательская цель `struct`:

1. задать межъязыковой каркас обмена,
2. фиксировать роли данных и путь прохождения между языками,
3. стандартизировать схему взаимодействия в одном запуске.

В текущем runtime `struct` фиксируется как конфигурационный флаг (`mermaid_config.struct=true`) и участвует в общей Mermaid-конфигурации.

## 6. Проверка конфигурации (обязательно)

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

Файл: `examples/mermaid/mermaid_cluster_struct_variants3.it`

Фактический вывод:

```text
mermaid: {"struct": true, "cluster_mode": 0, "cluster": true, "deep": true, "deep_force_no_cache": false, "deep_failover": true, "deep_retry_count": 0, "deep_config": ""}
```

## 7. Что уже реализовано в исходниках (проверено)

В `compiler/cli/interton_compiler.cpp` реализовано:

1. парсинг и активация `using mermaid.struct|cluster|deep`,
2. хранение Mermaid-конфига,
3. `mermaid_config(_json)` и `mermaid_status(_json)`,
4. счетчики `foreign_calls`, `cache_hits`, `cache_misses`, `retry_attempts`, `failures`,
5. `last_error`, `last_language`,
6. влияние `cluster(0)` и `deep(...cache...)` на foreign-кеш,
7. retry/failover-логика для foreign-вызовов.

## 8. Что НЕ реализовано как полноценный runtime-планировщик (важно)

В `beta-v_.6.2` **не реализован** полноценный движок:

1. автоматического распределения CPU/GPU,
2. ручного pinning ядра/потоков через Mermaid,
3. миграции упавшей задачи между ядрами/потоками как системный scheduler.

Иными словами: Mermaid уже дает конфигурацию и политику для foreign-пайплайна, но не является отдельным low-level OS scheduler.

## 9. Пример мультиязычного вызова с Mermaid

Файл: `examples/mermaid/mermaid_multilang_cpp_only.it`

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

Фактический вывод:

```text
cpp scale: 21
```

## 10. Рекомендованные профили

## 10.1 Production-safe

```interton
using mermaid {
    struct,
    cluster(1),
    deep(retry=1 failover=true cache=true)
};
```

## 10.2 Диагностика без кеша

```interton
using mermaid {
    struct,
    cluster(0),
    deep(retry=0 failover=false cache=false)
};
```

## 11. Типовые ошибки

1. включить Mermaid и не смотреть `mermaid_config_json()`,
2. ожидать от `cluster` полноценного CPU/GPU scheduler в текущем релизе,
3. сравнивать результаты без фиксации `cluster_mode` и `deep`-параметров,
4. смешивать production и diagnostic профиль в одном прогоне.

## 12. Чеклист перед релизом

1. Mermaid-профиль зафиксирован в коде,
2. в CI логируется `mermaid_config_json()` и `mermaid_status_json()`,
3. проверены `cache_hits/misses` и `failures`,
4. поведение `cluster(0)` и `cluster(1)` проверено на одном и том же тесте,
5. документация проекта совпадает с фактическим выводом runtime.

