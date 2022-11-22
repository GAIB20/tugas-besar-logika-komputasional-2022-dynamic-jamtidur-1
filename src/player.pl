:- dynamic(player/9).

/*Deklarasi Fakta*/
player(v,'V',go,20000,0,0,[],[],[]).
player(w,'W',go,20000,0,0,[],[],[]).

printBuilding(A) :- A == 0,!, write('Tanah').
printBuilding(A) :- A == 1,!, write('Bangunan 1').
printBuilding(A) :- A == 2,!, write('Bangunan 2').
printBuilding(A) :- A == 3,!, write('Bangunan 3').
printBuilding(A) :- A == 4,!, write('Landmark').

printListProperties([],[],_) :- !.
printListProperties([X|Y],[A|B],P) :-
    write(P),write('.'),
    P1 is P +1,
    write(X),write(' - '), printBuilding(A),nl,
    printListProperties(Y,B,P1).

printList([],_).
printList([A|B],P) :-
    write(P),write('.'),
    P1 is P +1,
    write(A),nl,
    printList(B,P1).

buyProperties(X,Property) :-
    player(X,Username,Location,Money,PropertiesValue,Asset,Properties,Buildings,Card),
    isNotIn(Property,Properties),
    checkPropertyValue(Property,Value),
    Money > Value,!,
    PropertiesValueUpdated is PropertiesValue + Value,
    MoneyUpdated is Money - Value,
    AssetUpdated is MoneyUpdated + PropertiesValueUpdated,
    retractall(player(X,Username,Location,Money,PropertiesValue,Asset,Properties,Buildings,Card)),
    assertz(player(X,Username,Location,MoneyUpdated,PropertiesValueUpdated,AssetUpdated,[Property|Properties],[0|Buildings],Card)).

buyProperties(X,Property) :- 
    player(X,_,_,_,_,_,Properties,_,_),
    \+isNotIn(Property,Properties), !, 
    write('Properti sudah dimiliki').

buyProperties(X,Property) :-
    player(X,_,_,Money,_,_,_,_,_),
    checkPropertyValue(Property,Value),
    Money < Value, !,
    write('Uang tidak cukup').

getIndex(A,[A|_],1) :- !.
getIndex(A,[_|T],Idx1) :-
    getIndex(A,T,Idx), Idx1 is Idx + 1.

getValue([H|_],1,H) :- !.
getValue([_|T],Idx,Value) :-
    Idx1 is Idx-1,
    getValue(T,Idx1,Value).

setValue(A,[_|T],1,[A|T]):-!.
setValue(A,[H|T],Idx,[H|L1]):-
    Idx1 is Idx - 1,
    setValue(A,T,Idx1,L1).

getHarga(A,Value,Harga) :- Value == 0, !, harga(A,_,_, _,X,_,_,_), Harga is X.
getHarga(A,Value,Harga) :- Value == 1, !, harga(A,_,_, _,_,X,_,_), Harga is X.
getHarga(A,Value,Harga) :- Value == 2, !, harga(A,_,_, _,_,_,X,_), Harga is X.
getHarga(A,Value,Harga) :- Value == 3, !, harga(A,_,_, _,_,_,_,X), Harga is X.

upgradeBuilding(X,A) :-
    player(X,_,_,_,_,_,Properties,Buildings,_),
    getIndex(A,Properties,Idx),
    getValue(Buildings,Idx,Value),
    Value >= 4, !,
    write('Bangunan sudah terupgrade sampai Landmark!').

upgradeBuilding(X,A) :-
    player(X,Username,Location,Money,PropertiesValue,Asset,Properties,Buildings,Card),
    getIndex(A,Properties,Idx),
    getValue(Buildings,Idx,Value),
    Value <4,
    getHarga(A,Value,Harga),
    Value2 is Value + 1,
    MoneyUpdated is Money - Harga,
    PropertiesValueUpdated is PropertiesValue + Harga,
    setValue(Value2,Buildings,Idx,Updated),
    retractall(player(X,Username,Location,Money,PropertiesValue,Asset,Properties,Buildings,Card)),
    assertz(player(X,Username,Location,MoneyUpdated,PropertiesValueUpdated,Asset,Properties,Updated,Card)).

downgradeBuilding(X,A) :-
    player(X,_,_,_,_,_,Properties,Buildings,_),
    getIndex(A,Properties,Idx),
    getValue(Buildings,Idx,Value),
    getHarga(A,Value-1,_),
    Value >0,
    !, write('Tidak bisa dijual lagi').
downgradeBuilding(X,A) :-
    player(X,Username,Location,Money,PropertiesValue,Asset,Properties,Buildings,Card),
    getIndex(A,Properties,Idx),
    getValue(Buildings,Idx,Value),
    Value2 is Value - 1,
    getHarga(A,Value2,Harga),
    Value >0,
    MoneyUpdated is Money + Harga,
    PropertiesValueUpdated is PropertiesValue - Harga,
    setValue(Value2,Buildings,Idx,Updated),
    retractall(player(X,Username,Location,Money,PropertiesValue,Asset,Properties,Buildings,Card)),
    assertz(player(X,Username,Location,MoneyUpdated,PropertiesValueUpdated,Asset,Properties,Updated,Card)).

check(_,[]).
check(Property,[H|T]) :-
    H \= Property,
    check(Property,T).

isNotIn(Property,Properties)  :- 
    player(X,_,_,_,_,_,Properties,_,_),
    player(Y,_,_,_,_,_,Properties2,_,_),
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
    harga(Property,_,_,X,_,_,_,_), Value is X.


