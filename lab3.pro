implement main
    open core, stdio, file

domains
    activeSub = ибупрофен; будесонид; парацетамол.
    pharmacyList = string*.
    buyersList = string*.

class facts - pharmacyDb
    лекарство : (string ID, string Name, integer Price, activeSub ActiveSub).
    аптека : (string ID, string Name, string Address, string Phone).
    цена_в_аптеке : (string ID, string Name, integer Price, integer Balance).
    бонусная_карта : (string ID, string Name, integer Sum, string Level).
    склад : (string ID, string Address, buyersList BList, pharmacyList PList).

class predicates  % Вспомогательные предикаты
    длина : (A*) -> integer N.
    сумма_элем : (integer* List) -> integer Sum.
    среднее_списка : (integer* List) -> real Average determ.

class predicates
    данные_аптеки : (string Name) -> string* determ.
    уровень_карты : (string Id) -> string* determ.
    прайс_лист_по_адресу : (string Address) -> integer* nondeterm.
    прайс_лист_лекарства : (string Name) -> integer* nondeterm.
    количество_по_адресу : (string Address) -> integer* nondeterm.
    средняя_цена_в_аптеке : (string Address) -> real N nondeterm.
    количество_лекарств_в_аптеке : (string Address) -> integer N nondeterm.

clauses
    длина([]) = 0.
    длина([_ | T]) = длина(T) + 1.

    сумма_элем([]) = 0.
    сумма_элем([H | T]) = сумма_элем(T) + H.

    среднее_списка(L) = сумма_элем(L) / длина(L) :-
        длина(L) > 0.

clauses
    данные_аптеки(NAME) = List :-
        List = [ ADDRESS || аптека(_, NAME, ADDRESS, PHONE) ].

    уровень_карты(CARD_ID) = List :-
        List = [ LEVEL || бонусная_карта(CARD_ID, _, SUMMA, LEVEL) ].

    % стоимость всех лекарств в аптеке
    прайс_лист_по_адресу(ADDRESS) = List :-
        аптека(ID, _, ADDRESS, _),
        List = [ PRICE || цена_в_аптеке(ID, NAME, PRICE, OSTATOK) ].

    % стоимость лекарства во всех аптеках
    прайс_лист_лекарства(NAME) = List :-
        аптека(ID, _, ADDRESS, _),
        List = [ PRICE || цена_в_аптеке(ID, NAME, PRICE, OSTATOK) ].

    количество_по_адресу(ADDRESS) = List :-
        аптека(ID, _, ADDRESS, _),
        List = [ OSTATOK || цена_в_аптеке(ID, NAME, PRICE, OSTATOK) ].

    средняя_цена_в_аптеке(ADDRESS) = среднее_списка(прайс_лист_по_адресу(ADDRESS)).

    количество_лекарств_в_аптеке(ADDRESS) = сумма_элем(количество_по_адресу(ADDRESS)).

class predicates
    write_list : (string* Str).
    write_list_int : (integer* Int).

clauses
    write_list(L) :-
        foreach Elem = list::getMember_nd(L) do
            write(Elem, '; ')
        end foreach,
        write("\n").

    write_list_int(L) :-
        foreach Elem = list::getMember_nd(L) do
            write(Elem, '; ')
        end foreach,
        write("\n").

clauses
    run() :-
        consult("../pharmacy.txt", pharmacyDb),
        fail.

    run() :-
        write("_________________________________________________\n"),
        N = "Аптека.ру",
        write("Аптеки сети ", N, "\n"),
        Lst = данные_аптеки(N),
        write_list(Lst),
        fail.

    run() :-
        write("_________________________________________________\n"),
        Lst = уровень_карты("19350"),
        write("Уровень карты id=19350: "),
        write_list(Lst),
        fail.

    run() :-
        write("_________________________________________________\n"),
        Addr = "ул. Карамзина, 4",
        write("Аптека по адресу:  ", Addr, "\n"),
        Lst = прайс_лист_по_адресу(Addr),
        write_list_int(Lst),
        nl,
        fail.

    run() :-
        write("_________________________________________________\n"),
        Lek = "Нурофен",
        write("Цены на лекарство в разных аптеках:  ", Lek, "\n"),
        Lst = прайс_лист_лекарства(Lek),
        write_list_int(Lst),
        nl,
        fail.

    run() :-
        write("_________________________________________________\n"),
        Addr = "ул. Карамзина, 4",
        write("Средняя цена лекарств в аптеке по адресу  ", Addr, "\n"),
        write(средняя_цена_в_аптеке(Addr)),
        nl,
        fail.

    run() :-
        write("_________________________________________________\n"),
        Addr = "ул. Ломоносова, 35/1",
        write("Количество лекарств в аптеке по адресу  ", Addr, "\n"),
        write(количество_лекарств_в_аптеке(Addr)),
        nl,
        fail.

    run().

end implement main

goal
    console::runUtf8(main::run).
