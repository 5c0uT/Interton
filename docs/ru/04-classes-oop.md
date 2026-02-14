# Interton: классы и OOP

Целевая версия: `Interton beta-v_.6.1`

## 1. Когда вообще нужен класс

Класс в Interton используйте, когда вам нужно:

1. хранить состояние между вызовами,
2. объединить связанные операции в одном типе,
3. описать предметную сущность (счетчик, сессия, конфиг, модель).

Если состояние не нужно, обычно достаточно `pure call`/`call`.

## 2. Базовая структура класса

```interton
class Counter {
    int value;

    public call init(start: int) -> void {
        this.value = start
    }

    public call inc() -> int {
        this.value = this.value + 1
        return this.value
    }

    public call add(delta: int) -> int {
        return this.value + delta
    }
}
```

Смысл частей:

1. поле `value` хранит внутреннее состояние,
2. `init` задает начальное состояние,
3. методы читают/меняют `value` через `this`.

## 3. Полный пример создания и использования

```interton
adding std.io

class Counter {
    int value;

    public call init(start: int) -> void {
        this.value = start
    }

    public call inc() -> int {
        this.value = this.value + 1
        return this.value
    }

    public call add(delta: int) -> int {
        return this.value + delta
    }
}

call main() -> int {
    Counter c = new Counter(5)
    inscribe("init:", c.value)
    inscribe("inc:", c.inc())
    inscribe("add 10:", c.add(10))
    inscribe("final:", c.value)
    return 0
}
```

Ожидаемый вывод:

```text
init: 5
inc: 6
add 10: 16
final: 6
```

## 4. `this`: зачем нужен и как применять

`this` указывает на текущий объект.

Используйте `this`, когда:

1. обращаетесь к полям экземпляра,
2. хотите явно показать изменение состояния,
3. нужно избежать путаницы между параметром и полем.

Пример:

```interton
class UserSession {
    string user;

    public call init(user: string) -> void {
        this.user = user
    }

    public call who() -> string {
        return this.user
    }
}
```

## 5. Два объекта одного класса

Важно понимать, что каждый объект хранит собственное состояние.

```interton
adding std.io

class Counter {
    int value;

    public call init(start: int) -> void {
        this.value = start
    }

    public call inc() -> int {
        this.value += 1
        return this.value
    }
}

call main() -> int {
    Counter a = new Counter(1)
    Counter b = new Counter(10)

    inscribe("a:", a.inc())
    inscribe("b:", b.inc())
    inscribe("a:", a.inc())
    return 0
}
```

Ожидаемый вывод:

```text
a: 2
b: 11
a: 3
```

## 6. Практические правила проектирования классов

1. Один класс - одна роль.
2. Поля по возможности меняются через методы.
3. Чистую математику выносите в `pure call`.
4. I/O и системные вызовы держите за пределами модели.
5. Имена методов делайте глагольными (`load`, `save`, `calculate`).

## 7. Что документировать для каждого класса

Минимум:

1. назначение класса,
2. список полей и их смысл,
3. какие методы меняют состояние,
4. какие методы только читают состояние,
5. пример создания объекта и ожидаемый вывод.

## 8. Частые ошибки

1. Прямо менять поля из разных мест проекта без контроля.
Решение: централизовать изменения в методах.

2. Делать "божественный" класс со всем подряд.
Решение: делить на несколько маленьких классов.

3. Смешивать доменную модель и логирование.
Решение: вывод делать в `procedure`/service-слое.

4. Пропускать инициализацию сложных объектов.
Решение: явно задавать стартовые значения в `init`.

## 9. Мини-чеклист OOP-качества

1. У класса понятная зона ответственности.
2. Состояние меняется предсказуемо.
3. Пример использования воспроизводим.
4. Есть ожидаемый вывод для smoke-проверки.
