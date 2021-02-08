﻿///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

Перем мЭтоКопирование;

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	лСписокВыбора = Новый СписокЗначений;
	Для каждого КлючЗначение Из гТипыЗначенийПараметров() Цикл
		лСписокВыбора.Добавить(КлючЗначение.Значение, КлючЗначение.Ключ);
	КонецЦикла; 
	ЭлементыФормы.ПараметрыСписок.Колонки.Тип.ЭлементУправления.СписокВыбора = лСписокВыбора;
	
	мЭтоКопирование = Ложь;
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНДНЫХ ПАНЕЛЕЙ ФОРМЫ

Процедура КоманднаяПанельФормыЗаполнитьПараметрыИзЗапроса(Кнопка)
	гОбработкаДействийЗаполнитьПараметрыИзЗапроса();
КонецПроцедуры

Процедура КоманднаяПанельФормыОчиститьПараметры(Кнопка)
	Если ПараметрыСписок.Количество()>0 и Вопрос("Удалить ВСЕ параметры?", РежимДиалогаВопрос.ОКОтмена) = КодВозвратаДиалога.ОК тогда
		ЭлементыФормы.ПараметрыСписок.Значение.Очистить();    
	КонецЕсли;
КонецПроцедуры

Процедура КоманднаяПанельФормыДобавитьПараметрИзБуфера(Кнопка)
	гДобавитьПараметрИзБуфера();
КонецПроцедуры // КоманднаяПанельФормыДобавитьПараметрИзБуфера()

Процедура КоманднаяПанельФормыВычислитьИПодставить(Кнопка)
	текТекущаяСтрока = ЭлементыФормы.ПараметрыСписок.ТекущаяСтрока;
	лСтрокаСАлгоритмом = "";
	Если ВвестиСтроку(лСтрокаСАлгоритмом, "Введите алгоритм для расчета значения параметра", ,Истина) Тогда 
		Попытка
			лВычисленноеЗначение = Вычислить(лСтрокаСАлгоритмом);
			текТекущаяСтрока.Тип = гТипыЗначенийПараметров().Значение;
			текТекущаяСтрока.Значение = лВычисленноеЗначение;
		Исключение
			Сообщить("Ошибка расчета значения параметра: " + ОписаниеОшибки());
		КонецПопытки; 
	КонецЕсли;
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЧНОГО ПОЛЯ ПараметрыСписок

Процедура ПараметрыСписокЗначениеНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	лСтрокаСПараметром = ЭлементыФормы.ПараметрыСписок.ТекущаяСтрока;
	лТипПараметра      = лСтрокаСПараметром.Тип;
	
	Если лТипПараметра <> гТипыЗначенийПараметров().Список И 
		лТипПараметра <> гТипыЗначенийПараметров().Значение Тогда
		СтандартнаяОбработка = Ложь;
		ПоказатьПредупреждение(, "Значения данного типа не редактируются вручную.", 10);
	КонецЕсли;
		
КонецПроцедуры

// Обработчик события при начале редактирования строки параметров
//
Процедура ПараметрыСписокПриНачалеРедактирования(Элемент, НоваяСтрока)
	Если НоваяСтрока Тогда 
		Элемент.ТекущаяСтрока.Тип                 = гТипыЗначенийПараметров().Значение;
		Элемент.ТекущаяСтрока.ИдентификаторСтроки = Новый УникальныйИдентификатор;
	КонецЕсли;
КонецПроцедуры // ПараметрыСписокПриНачалеРедактирования()

// Обработчик события при окончании редактирования строки параметров
//
Процедура ПараметрыСписокПриОкончанииРедактирования(Элемент, НоваяСтрока)

	ВладелецФормы.Модифицированность = Истина;
	мЭтоКопирование                  = Ложь;

КонецПроцедуры // ПараметрыСписокПриОкончанииРедактирования()

// Обработчик события перед удалением строки параметров
//
Процедура ПараметрыСписокПередУдалением(Элемент, Отказ)

	ВладелецФормы.Модифицированность = Истина;

КонецПроцедуры // ПараметрыСписокПередУдалением()

Процедура ПараметрыСписокТипПриИзменении(Элемент)
	
	лСтрокаСПараметром = ЭлементыФормы.ПараметрыСписок.ТекущаяСтрока;
	лТипПараметра      = лСтрокаСПараметром.Тип;
	лЗначениеПараметра = лСтрокаСПараметром.Значение;
	лЗначениеОбновлено = Ложь;
	
	Если лТипПараметра = гТипыЗначенийПараметров().Список Тогда
		Если Не ТипЗнч(лЗначениеПараметра) = Тип("СписокЗначений") И 
			Не ТипЗнч(лЗначениеПараметра) = Тип("ТаблицаЗначений") И 
			Не ТипЗнч(лЗначениеПараметра) = Тип("Граница") Тогда
			
			лСтрокаСПараметром.Значение = Новый СписокЗначений;
			лЗначениеОбновлено          = Истина;
			
			Если лЗначениеПараметра <> Неопределено Тогда
				лСтрокаСПараметром.Значение.Добавить(лЗначениеПараметра);
			КонецЕсли;
		КонецЕсли; 
	ИначеЕсли лТипПараметра = гТипыЗначенийПараметров().ТаблицаЗначений Тогда
		лСтрокаСПараметром.Значение = "";
		лЗначениеОбновлено          = Истина;
	ИначеЕсли лТипПараметра = гТипыЗначенийПараметров().Значение Тогда
		Если ТипЗнч(лЗначениеПараметра) = Тип("СписокЗначений") Тогда
			Если лЗначениеПараметра.Количество() > 1 Тогда
				лСтрокаСПараметром.Значение = лЗначениеПараметра[0].Значение;
				лЗначениеОбновлено          = Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если лЗначениеОбновлено Тогда 
		лСтрокаСПараметром.Значение = Неопределено;
	КонецЕсли;
	
КонецПроцедуры // ПараметрыСписокТипПриИзменении()

Процедура ПараметрыСписокПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	Перем ЭлементСписка;
	
	ЭлементСписка = Элемент.Колонки.Тип.ЭлементУправления.СписокВыбора.НайтиПоЗначению(ДанныеСтроки.Тип);
	
	Если ЭлементСписка <> Неопределено Тогда 
		ОформлениеСтроки.Ячейки.Тип.Текст = ЭлементСписка.Представление;
	КонецЕсли;
	
	ОформлениеСтроки.Ячейки.ГлобальныйПараметр.ОтображатьТекст = Ложь;
	
КонецПроцедуры

Процедура ПараметрыСписокПередНачаломДобавления(Элемент, Отказ, Копирование)
	мЭтоКопирование = Копирование;
КонецПроцедуры

Процедура ПараметрыСписокЗначениеПриИзменении(Элемент)
	лТекущиеДанные = ЭлементыФормы.ПараметрыСписок.ТекущиеДанные;
	Если ТипЗнч(лТекущиеДанные.Значение) = Тип("Дата") Тогда 
		Если лТекущиеДанные.Значение = НачалоДня(КонецМесяца(лТекущиеДанные.Значение)) Тогда 
			ПоказатьВопрос(Новый ОписаниеОповещения("ПослеЗакрытияВопроса", ЭтаФорма, Новый Структура("Режим, ТекущиеДанные", "УстановитьКонецДня", лТекущиеДанные)), "Изменить дату на конец дня?", РежимДиалогаВопрос.ДаНет);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ЗавершенияАсинхронныхВызовов

&НаКлиенте
Процедура ПоказатьПредупреждениеЗавершение(ДополнительныеПараметры) Экспорт
КонецПроцедуры // ПоказатьПредупреждениеЗавершение()

&НаКлиенте
Процедура ПослеЗакрытияВопроса(Результат, Параметры) Экспорт
	Если Параметры.Режим = "УстановитьКонецДня" Тогда 
		Если Результат = КодВозвратаДиалога.Да Тогда
			Параметры.ТекущиеДанные.Значение = КонецДня(Параметры.ТекущиеДанные.Значение);
	    КонецЕсли;
	КонецЕсли;
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ПРОЧИЕ ПРОЦЕДУРЫ И ФУНКЦИИ

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ РАБОТЫ С ПАРАМЕТРАМИ ЗАПРОСА

Процедура гОбработкаДействийЗаполнитьПараметрыИзЗапроса() Экспорт
	
	лТекстЗапроса = ВладелецФормы.гТекстЗапроса();
	
	Если ПустаяСтрока(лТекстЗапроса) Тогда 
		ПоказатьПредупреждение(,"Не заполнен текст запроса!", 10);
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос(лТекстЗапроса);
	
	Попытка
		лПараметрыЗапроса = Запрос.НайтиПараметры();
	Исключение
		Сообщить("Некорректный запрос: " + ОписаниеОшибки(), СтатусСообщения.Важное);
		Возврат;
	КонецПопытки;
	
	СписокПараметров = Новый СписокЗначений;
	Для Каждого ПараметрЗапроса Из лПараметрыЗапроса Цикл
		
		лСтруктураПараметра = Новый Структура();
		лСтруктураПараметра.Вставить("Имя"     , ПараметрЗапроса.Имя);
		лСтруктураПараметра.Вставить("Тип"     , гТипыЗначенийПараметров().Значение);
		лСтруктураПараметра.Вставить("Значение", ПараметрЗапроса.ТипЗначения.ПривестиЗначение(Неопределено));
		
		гДобавитьПараметр(лСтруктураПараметра);
		
	КонецЦикла; 
	
	Если Не Открыта() тогда
		Открыть();
	КонецЕсли;
	
	Активизировать();
	
КонецПроцедуры // гОбработкаДействийЗаполнитьПараметрыИзЗапроса()

Функция гПолучитьПараметрПоИмени(ИмяПараметра) Экспорт
	
	лСтрокаСПараметром = ПараметрыСписок.Найти(ИмяПараметра, "Имя");
	
	Если лСтрокаСПараметром = Неопределено Тогда 
		Возврат Неопределено
	КонецЕсли;
	
	Если ВладелецФормы.мЭтоНестандартныйТип(лСтрокаСПараметром.Тип) Тогда 
		Возврат гДопСтруктураСПараметрами[лСтрокаСПараметром.ИдентификаторСтроки];
	Иначе
		Возврат лСтрокаСПараметром.Значение;
	КонецЕсли;	
КонецФункции // гПолучитьПараметрПоИмени()

Процедура гДобавитьПараметрИзБуфера() Экспорт
	
	лТекстИзБуфера = Новый ТекстовыйДокумент;	
	лТекстИзБуфера.УстановитьТекст(гПолучитьТекстИзБуфера());

	Если лТекстИзБуфера.КоличествоСтрок() = 0 Тогда 		
		ПоказатьПредупреждение(, "Нет данных в буфере");		
		Возврат;
	Иначе
		
		лТекстПервойСтроки = лТекстИзБуфера.ПолучитьСтроку(1);
		
		Если лТекстИзБуфера.КоличествоСтрок() = 1 Тогда 
			
			лСтруктураПараметра = Новый Структура();
			лСтруктураПараметра.Вставить("Имя"     , гПолучитьСледующееУникальноеИмя("Параметр", ПараметрыСписок, "Имя"));
			лСтруктураПараметра.Вставить("Тип"     , гТипыЗначенийПараметров().Значение);
			лСтруктураПараметра.Вставить("Значение", лТекстПервойСтроки);
			
			гДобавитьПараметр(лСтруктураПараметра);
			
		Иначе
			
			лКоличествоКолонок = гРазложитьСтрокуВМассивПодстрок(лТекстПервойСтроки, Символы.Таб);
			
			Если лКоличествоКолонок = 1 Тогда 
				
				лЗначениеПараметра = Новый СписокЗначений;
				Для сч = 1 По лТекстИзБуфера.КоличествоСтрок() Цикл
					лЗначениеПараметра.Добавить(лТекстИзБуфера.ПолучитьСтроку(сч));
				КонецЦикла;
				
				лСтруктураПараметра = Новый Структура();
				лСтруктураПараметра.Вставить("Имя"     , гПолучитьСледующееУникальноеИмя("Список", ПараметрыСписок, "Имя"));
				лСтруктураПараметра.Вставить("Тип"     , гТипыЗначенийПараметров().Список);
				лСтруктураПараметра.Вставить("Значение", лЗначениеПараметра);
				
				гДобавитьПараметр(лСтруктураПараметра);
				
			Иначе
				гДобавитьТаблицуВПараметр(гТекстВТаблицуНаСервере(Новый Структура("Текст", лТекстИзБуфера.ПолучитьТекст())));
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры // гДобавитьПараметрИзБуфера()

Функция гДобавитьПараметр(СтруктураПараметров) Экспорт
	
	лИдентификаторСтроки = Строка(Новый УникальныйИдентификатор);
	
	СтруктураПараметров.Вставить("ИдентификаторСтроки", лИдентификаторСтроки);
	СтруктураПараметров.Вставить("Имя"                , гПолучитьСледующееУникальноеИмя(СтруктураПараметров.Имя, ПараметрыСписок, "Имя"));
	
	Если ВладелецФормы.мЭтоНестандартныйТип(СтруктураПараметров.Тип) Тогда 
		
		гДопСтруктураСПараметрами.Вставить(лИдентификаторСтроки, СтруктураПараметров.Значение);
		
		СтруктураПараметров.Вставить("Значение", гПредставлениеЗначения(СтруктураПараметров.Значение))
		
	КонецЕсли;
	
	лНовыйПараметр = ПараметрыСписок.Добавить();
	
	ЗаполнитьЗначенияСвойств(лНовыйПараметр, СтруктураПараметров);
	
	лНовыйПараметр.Значение = ПараметрыСписок.Колонки.Значение.ТипЗначения.ПривестиЗначение(лНовыйПараметр.Значение); // #рефакторинг упростить
	
	Возврат Новый Структура("Имя, ИдентификаторСтроки", СтруктураПараметров.Имя, СтруктураПараметров.ИдентификаторСтроки);
	
КонецФункции // гДобавитьПараметр()

Функция гДобавитьТаблицуВПараметр(Таблица) Экспорт
	
	лСтруктураПараметра = Новый Структура();
	лСтруктураПараметра.Вставить("Имя"     , "ТЗ");
	лСтруктураПараметра.Вставить("Тип"     , гТипыЗначенийПараметров().ТаблицаЗначений);
	лСтруктураПараметра.Вставить("Значение", Таблица);
	
	лНовыйПараметр = гДобавитьПараметр(лСтруктураПараметра);
	
	Возврат Новый Структура("Имя, лИдентификаторСтроки", лНовыйПараметр.Имя, лНовыйПараметр.ИдентификаторСтроки);
	
КонецФункции // гДобавитьТаблицуВПараметр()

Процедура гЗаполнитьГлобальныеПараметры() Экспорт
	гЗаполнитьПараметрыПоИДЗапроса("");
КонецПроцедуры

Процедура гЗаполнитьПараметрыПоИДЗапроса(ИДЗапроса) Экспорт
	
	лПараметрыТекущегоЗапроса = ВладелецФормы.мПараметрыЗапросов.НайтиСтроки(Новый Структура("ИдентификаторЗапроса", ИДЗапроса));
	
	ЭтоГлобальныйПараметр = ПустаяСтрока(ИДЗапроса);
	
	Для каждого лПараметрТекущегоЗапроса Из лПараметрыТекущегоЗапроса Цикл
		лПараметр = ПараметрыСписок.Добавить();
		ЗаполнитьЗначенияСвойств(лПараметр, лПараметрТекущегоЗапроса);
		
		Если лПараметр.Значение = Неопределено И гДопСтруктураСПараметрами[лПараметр.ИдентификаторСтроки] <> Неопределено Тогда 
			лПараметр.Значение = гДопСтруктураСПараметрами[лПараметр.ИдентификаторСтроки];
		КонецЕсли;
		
		лПараметр.ГлобальныйПараметр = ЭтоГлобальныйПараметр;
	КонецЦикла;	
	
КонецПроцедуры // гЗаполнитьПараметрыПоИДЗапроса()

Процедура ОчиститьПараметры() Экспорт
	ПараметрыСписок.Очистить();
КонецПроцедуры

Процедура гТекущиеПараметрыВГлобальныйСписок(ИдентификаторЗапроса) Экспорт 
	
	лПараметрыЗапроса = ВладелецФормы.мПараметрыЗапросов.НайтиСтроки(Новый Структура("ИдентификаторЗапроса", ""));		
	Для каждого лПараметрЗапроса Из лПараметрыЗапроса Цикл
		ВладелецФормы.мПараметрыЗапросов.Удалить(лПараметрЗапроса);
	КонецЦикла; 
	
	лПараметрыЗапроса = ВладелецФормы.мПараметрыЗапросов.НайтиСтроки(Новый Структура("ИдентификаторЗапроса", ИдентификаторЗапроса));
	Для каждого лПараметрЗапроса Из лПараметрыЗапроса Цикл
		ВладелецФормы.мПараметрыЗапросов.Удалить(лПараметрЗапроса);
	КонецЦикла; 
	
	Для каждого ПараметрЗапроса Из ПараметрыСписок Цикл
		
		лСтруктураПараметра = Новый Структура("Значение, ИдентификаторЗапроса, ИдентификаторСтроки, Имя, Тип");
		
		ЗаполнитьЗначенияСвойств(лСтруктураПараметра, ПараметрЗапроса);
		
		Если ПараметрЗапроса.ГлобальныйПараметр Тогда 
			лСтруктураПараметра.ИдентификаторЗапроса = "";
		Иначе
			лСтруктураПараметра.ИдентификаторЗапроса = ИдентификаторЗапроса;
		КонецЕсли;
		
		ВладелецФормы.мДобавитьПараметрВГлобальныйСписок(лСтруктураПараметра);
		
	КонецЦикла; 
	
КонецПроцедуры // гТекущиеПараметрыВГлобальныйСписок()


