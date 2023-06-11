# Метрика приложения

## ListScreen
- loaded - данные загружены
- error - ошибка загрузки
- reload - клик пользователя по повторной загрузке
- selectTicker - выбран tiker-а
    - ticker - заголовок tiker-а
    - searchString - строка поиска tiker-а

## DetailedTickerScreen
- loaded - данные загружены
- error - ошибка загрузки
- changeTimePeriod - изменён период свечи:
    - period - новое значение
- selectedPatterns - выбор паттернов
    - patterns - выбранные патерны
    - ticker - заголовок tiker-а
    - source - источник выбора паттернов (chart/list)
