/*Deklarasi Fakta*/
:- dynamic(player/9).
:- dynamic(infoLoc/9).
/* Format:
player(Player, Username, Location, Money, PropertiesValue, Asset, Properties, Buildings, Cards) */
player(v,'V',0,2000,0,0,[],[],[]).
player(w,'W',0,2000,0,0,[],[],[]).

/*================================================================================================*/
/*Mekanisme Menampilkan Informasi Player*/

/*Menampilkan informasi bangunan*/
printBuilding(A) :- A == 0,!, write('Tanah').
printBuilding(A) :- A == 1,!, write('Bangunan 1').
printBuilding(A) :- A == 2,!, write('Bangunan 2').
printBuilding(A) :- A == 3,!, write('Bangunan 3').
printBuilding(A) :- A == 4,!, write('Landmark').

/*Menampilkan informasi properti*/
printListProperties([],[],_) :- !.
printListProperties([X|Y],[A|B],P) :-
    write(P),write('.'),
    P1 is P +1,
    write(X),write(' - '), printBuilding(A),nl,
    printListProperties(Y,B,P1).

/*Menampilkan informasi lokasi*/
printLocation(X) :- 
    coor(X,Y), write(Y).

/*================================================================================================*/
/*Mekanisme perubahan keterangan player*/
/*Mekanisme penambahan uang*/
addMoney(X,A) :-
    player(X,Username,Location,Money,PropertiesValue,Asset,Properties,Buildings,Card),
    MoneyUpdated is Money+A,
    retractall(player(X,Username,Location,Money,PropertiesValue,Asset,Properties,Buildings,Card)),
    assertz(player(X,Username,Location,MoneyUpdated,PropertiesValue,Asset,Properties,Buildings,Card)),
    write('Uang '), write(A), write(' berhasil ditambahkan ke rekening '), write(X), write('!'), nl. 

/*Mekanisme pengurangan uang*/
subtractMoney(X,A) :-
    player(X,Username,Location,Money,PropertiesValue,Asset,Properties,Buildings,Card),
    MoneyUpdated is Money-A,
    MoneyUpdated >=0, !,
    retractall(player(X,Username,Location,Money,PropertiesValue,Asset,Properties,Buildings,Card)),
    assertz(player(X,Username,Location,MoneyUpdated,PropertiesValue,Asset,Properties,Buildings,Card)),
    write('Maaf, uang '), write(A), write(' diambil ke rekening '), write(X), write('!'). 

subtractMoney(X,A) :-
    player(X,Username,Location,Money,PropertiesValue,Asset,Properties,Buildings,Card),
    MoneyUpdated is Money-A,
    MoneyUpdated <0, !,
    write('Maaf, uang anda tidak cukup untuk dikurangi'),nl,
    bankrupt(X), retractall(isExit(_)), assertz(isExit(1)).

/*Mengganti username*/
changeUsername(Y):-
    nowPlayer(X),
    player(X,Username,Location,Money,PropertiesValue,Asset,Properties,Buildings,Card),
    retractall(player(X,Username,Location,Money,PropertiesValue,Asset,Properties,Buildings,Card)),
    assertz(player(X,Y,Location,Money,PropertiesValue,Asset,Properties,Buildings,Card)),
    write('Username '), write(X), write(' berhasil diganti menjadi '), write(Y).

/*================================================================================================*/
/*Mekanisme pembelian*/

/*Pembelian Properti*/
/*Memeriksa harga properti*/
checkPropertyValue(Property,Value) :-
    harga(Property,_,_,X,_,_,_,_), Value is X.

/*Mengecek apakah properti terdapat di dalam list properti*/
check(_,[]).
check(Property,[H|T]) :-
    H \= Property,
    check(Property,T).

/*Mengecek apakah properti sudah dimiliki orang lain*/
isNotIn(Property)  :- 
    player(X,_,_,_,_,_,Properties,_,_),
    player(Y,_,_,_,_,_,Properties2,_,_),
    X \= Y,
    check(Property,Properties),
    check(Property,Properties2).

/*Pembelian properti berhasil*/
buyProperties(X,Property) :-
    player(X,Username,Location,Money,PropertiesValue,Asset,Properties,Buildings,Card),
    infoLoc(Property,Type, Nama, Deskripsi, Pemilik, CurRent, CostSpend, PropertyLevel,Color),
    isNotIn(Property),
    checkPropertyValue(Property,Value),
    Money > Value,!,
    PropertiesValueUpdated is PropertiesValue + Value,
    MoneyUpdated is Money - Value,
    AssetUpdated is MoneyUpdated + PropertiesValueUpdated,
    sewa(Property,RentOut,_,_,_,_),
    SpendUpdate is Value*2,
    retractall(player(X,Username,Location,Money,PropertiesValue,Asset,Properties,Buildings,Card)),
    assertz(player(X,Username,Location,MoneyUpdated,PropertiesValueUpdated,AssetUpdated,[Property|Properties],[0|Buildings],Card)),
    retractall(infoLoc(Property,Type, Nama, Deskripsi, Pemilik, CurRent, CostSpend, PropertyLevel,Color)),
    assertz(infoLoc(Property,Type, Nama, Deskripsi, X, RentOut, SpendUpdate, 0,Color)).

/*Pembelian properti gagal karena sudah dimiliki*/
buyProperties(X,Property) :- 
    player(X,_,_,_,_,_,Properties,_,_),
    \+isNotIn(Property), !, 
    write('Properti sudah dimiliki').

/*Pembelian properti gagal karena uang tidak cukup*/
buyProperties(X,Property) :-
    player(X,_,_,Money,_,_,_,_,_),
    checkPropertyValue(Property,Value),
    Money < Value, !,
    write('Uang tidak cukup').

/*Menentukan harga bangunan*/
getHarga(A,Value,Harga) :- Value == 0, !, harga(A,_,_, _,X,_,_,_), Harga is X.
getHarga(A,Value,Harga) :- Value == 1, !, harga(A,_,_, _,_,X,_,_), Harga is X.
getHarga(A,Value,Harga) :- Value == 2, !, harga(A,_,_, _,_,_,X,_), Harga is X.
getHarga(A,Value,Harga) :- Value == 3, !, harga(A,_,_, _,_,_,_,X), Harga is X.

/*Peningkatan bangunan*/
sewaBuilding(A,1,RentOut) :- sewa(A,_,RentOut,_,_,_).
sewaBuilding(A,2,RentOut) :- sewa(A,_,_,RentOut,_,_).
sewaBuilding(A,3,RentOut) :- sewa(A,_,_,_,RentOut,_).

/*Upgrade buiding gagal karena sudah sampai landmark*/
upgradeBuilding(X,A) :-
    player(X,_,_,_,_,_,Properties,Buildings,_),
    getIndex(A,Properties,Idx),
    getValue(Buildings,Idx,Value),
    Value >= 4, !,
    write('Bangunan sudah terupgrade sampai Landmark!').

/*Upgrade building berhasil*/
upgradeBuilding(X,A) :-
    player(X,Username,Location,Money,PropertiesValue,Asset,Properties,Buildings,Card),
    getIndex(A,Properties,Idx),
    getValue(Buildings,Idx,Value),
    Value <4,
    infoLoc(A,Type, Nama, Deskripsi, Pemilik, CurRent, CostSpend, PropertyLevel,Color),
    getHarga(A,Value,Harga),
    Value2 is Value + 1,
    Value2 == 4,!,
    MoneyUpdated is Money - Harga,
    sewa(Property,_,_,_,_,RentOut),
    PropertiesValueUpdated is PropertiesValue + Harga,
    setValue(Value2,Buildings,Idx,Updated),
    SpendUpdate is CostSpend + Harga*2,
    retractall(player(X,Username,Location,Money,PropertiesValue,Asset,Properties,Buildings,Card)),
    assertz(player(X,Username,Location,MoneyUpdated,PropertiesValueUpdated,Asset,Properties,Updated,Card)),
    retractall(infoLoc(A,Type, Nama, Deskripsi, Pemilik, CurRent, CostSpend, PropertyLevel,Color)),
    assertz(infoLoc(A,Type, Nama, Deskripsi, X, RentOut, SpendUpdate, 'L',Color)).

upgradeBuilding(X,A) :-
    player(X,Username,Location,Money,PropertiesValue,Asset,Properties,Buildings,Card),
    getIndex(A,Properties,Idx),
    getValue(Buildings,Idx,Value),
    Value <4,
    infoLoc(A,Type, Nama, Deskripsi, Pemilik, CurRent, CostSpend, PropertyLevel,Color),
    getHarga(A,Value,Harga),
    Value2 is Value + 1,
    MoneyUpdated is Money - Harga,
    sewaBuilding(A,Value2,RentOut),
    PropertiesValueUpdated is PropertiesValue + Harga,
    setValue(Value2,Buildings,Idx,Updated),
    SpendUpdate is CostSpend + Harga*2,
    retractall(player(X,Username,Location,Money,PropertiesValue,Asset,Properties,Buildings,Card)),
    assertz(player(X,Username,Location,MoneyUpdated,PropertiesValueUpdated,Asset,Properties,Updated,Card)),
    retractall(infoLoc(A,Type, Nama, Deskripsi, Pemilik, CurRent, CostSpend, PropertyLevel,Color)),
    assertz(infoLoc(A,Type, Nama, Deskripsi, X, RentOut, SpendUpdate, Value2,Color)).

/*================================================================================================*/
/*PENJUALAN*/

/*Penjualan bangunan gagal karena hanya memiliki tanah*/
downgradeBuilding(X,A) :-
    player(X,_,_,_,_,_,Properties,Buildings,_),
    getIndex(A,Properties,Idx),
    getValue(Buildings,Idx,Value),
    getHarga(A,Value-1,_),
    Value >0,
    !, write('Tidak bisa dijual lagi').

/*Penjualan bangunan berhasil*/
downgradeBuilding(X,A) :-
    player(X,Username,Location,Money,PropertiesValue,Asset,Properties,Buildings,Card),
    getIndex(A,Properties,Idx),
    getValue(Buildings,Idx,Value),
    Value2 is Value - 1,
    getHarga(A,Value2,Harga),
    Value >0,
    infoLoc(A,Type, Nama, Deskripsi, Pemilik, CurRent, CostSpend, PropertyLevel,Color),
    MoneyUpdated is Money + Harga,
    PropertiesValueUpdated is PropertiesValue - Harga,
    setValue(Value2,Buildings,Idx,Updated),
    retractall(player(X,Username,Location,Money,PropertiesValue,Asset,Properties,Buildings,Card)),
    assertz(player(X,Username,Location,MoneyUpdated,PropertiesValueUpdated,Asset,Properties,Updated,Card)),
    retractall(infoLoc(A,Type, Nama, Deskripsi, Pemilik, CurRent, CostSpend, PropertyLevel,Color)),
    assertz(infoLoc(A,Type, Nama, Deskripsi, X, CurRent, CostSpend, Value2,Color)).

/*================================================================================================*/
/*Menampilkan informasi dari player*/
checkPlayerDetail(X) :- 
    player(X,Username,Location,Money,PropertiesValue,Asset,Properties,Buildings,Card),
    write('Informasi Player '), write(Username), nl, nl,
    write('Lokasi                        : '), printLocation(Location),nl,
    write('Total Uang                    : '), write(Money),nl,
    write('Total Nilai Properti          : '), write(PropertiesValue),nl,
    write('Total Aset                    : '), write(Asset),nl,nl,
    write('Daftar Kepemilikan Properti   :'),nl,
    printListProperties(Properties,Buildings,1),nl,
    write('Daftar Kepemilikan Card       :'),nl,
    printList(Card,1).

/*Menampilkan informasi lokasi tempat player X berada*/
locationPlayer(X) :-
    player(X,_,Location,_,_,_,_,_,_),
    coor(X,Y),
    checkPropertyDetail(Y).
