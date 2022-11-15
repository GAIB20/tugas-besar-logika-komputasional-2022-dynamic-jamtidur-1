:- dynamic(player/9).

harga(a1,'ITB','Institut Tidak Bobo', 200, 1000, 2000,3000, 3000).
player(v,'V',go,20000,0,0,[],[],[]).
player(w,'W',go,20000,0,0,[],[],[]).

printListProperties([],[],_) :- !.
printListProperties([X|Y],[A|B],P) :-
    write(P),write('.'),
    P1 is P +1,
    write(X),write(' - '), write(A),nl,
    printList(Y,B,P1).

printList([],_).
printList([A|B],P) :-
    write(P),write('.'),
    P1 is P +1,
    write(A),nl,
    printList(B,P1).

buyProperties(X,Property,Building) :-
    player(X,Username,Location,Money,PropertiesValue,Asset,Properties,Buildings,Card),
    isNotIn(Property,Properties),
    checkPropertyValue(Property,Value),
    Money > Value,!,
    PropertiesValueUpdated is PropertiesValue + Value,
    MoneyUpdated is Money - Value,
    AssetUpdated is MoneyUpdated + PropertiesValueUpdated,
    retractall(player(X,Username,Location,Money,PropertiesValue,Asset,Properties,Buildings,Card)),
    assertz(player(X,Username,Location,MoneyUpdated,PropertiesValueUpdated,AssetUpdated,[Property|Properties],[Building|Buildings],Card)).

buyProperties(X,Property,Building) :- 
    player(X,Username,Location,Money,PropertiesValue,Asset,Properties,Buildings,Card),
    \+isNotIn(Property,Properties), !, 
    write('Properti sudah dimiliki').

buyProperties(X,Property,Building) :-
    player(X,Username,Location,Money,PropertiesValue,Asset,Properties,Buildings,Card),
    checkPropertyValue(Property,Value),
    Money > Value, !,
    write('Uang tidak cukup').

check(_,[]).
check(Property,[H|T]) :-
    H \= Property,
    check(Property,T).

isNotIn(Property,Properties)  :- 
    player(X,Username,Location,Money,PropertiesValue,Asset,Properties,Buildings,Card),
    player(Y,Username2,Location2,Money2,PropertiesValue2,Asset2,Properties2,Buildings2,Card2),
    X \= Y,
    check(Property,Properties),
    check(Property,Properties2).

checkPlayerDetail(X) :- 
    player(X,Username,Location,Money,PropertiesValue,Asset,Properties,Buildings,Card),
    write('Informasi Player '), write(Username), nl, nl,
    write('Lokasi                        : '), write(Location),nl,
    write('Total Uang                    : '), write(Money),nl,
    write('Total Nilai Properti          : '), write(PropertiesValue),nl,
    write('Total Aset                    : '), write(Asset),nl,nl,
    write('Daftar Kepemilikan Properti   :'),nl,
    printListProperties(Properties,Buildings,1),nl,
    write('Daftar Kepemilikan Card       :'),nl,
    printList(Card,1).

addMoney(X,A) :-
    player(X,Username,Location,Money,PropertiesValue,Asset,Properties,Buildings,Card),
    MoneyUpdated is Money+A,
    retractall(player(X,Username,Location,Money,PropertiesValue,Asset,Properties,Buildings,Card)),
    assertz(player(X,Username,Location,MoneyUpdated,PropertiesValue,Asset,Properties,Buildings,Card)). 

subtractMoney(X,A) :-
    player(X,Username,Location,Money,PropertiesValue,Asset,Properties,Buildings,Card),
    MoneyUpdated is Money-A,
    retractall(player(X,Username,Location,Money,PropertiesValue,Asset,Properties,Buildings,Card)),
    assertz(player(X,Username,Location,MoneyUpdated,PropertiesValue,Asset,Properties,Buildings,Card)). 

checkPropertyValue(Property,Value) :-
    harga(_,_,_,X,_,_,_,_), Value is X.


