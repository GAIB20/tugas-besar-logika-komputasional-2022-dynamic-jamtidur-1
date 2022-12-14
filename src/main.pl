/* *** Include file *** */
/* Include util */
:- include('util_list.pl').

/* Include source */
:- include('chance_card.pl').
:- include('chance_card_acts.pl').
:- include('dadu.pl').
:- include('jail.pl').
:- include('player.pl').
:- include('property.pl').
:- include('Loc.pl').
:- include('world_tour.pl').
:- include('tax.pl').

/* Status permainan */
:- dynamic(isExit/1).
:- dynamic(nowPlayer/1).
isExit(1).
nowPlayer(v).
lawan(v,w).
lawan(w,v).

printNowPlayer :- 
    write('Sekarang adalah giliran pemain '),
    nowPlayer(X), player(X,Nama,_,_,_,_,_,_,_),
    write(Nama), write(', lempar dadu dengan mengetik throwDice.').

gantiPlayer :-
    nowPlayer(Now),
    Now == v, !,
    retract(nowPlayer(v)),
    assertz(nowPlayer(w)).
gantiPlayer :-
    nowPlayer(Now),
    Now == w,
    retractall(nowPlayer(w)),
    assertz(nowPlayer(v)).

/* map sudah diimplementasikan di file ... */
/* throwDice, dice1, dice2 sudah diimplementasikan di file ... */

/* bankrupt */
bankrupt(v) :-
    retractall(player(v,_,_,_,_,_,_,_,_)),
    assertz(player(v,'V',go,20000,0,0,[],[],[])),
    write('Player W menang! Omedetou!'),
    retractall(isExit(_)), assertz(isExit(1)).

bankrupt(w) :-
    retractall(player(w,_,_,_,_,_,_,_,_)),
    assertz(player(w,'W',go,20000,0,0,[],[],[])),
    write('Player V menang! Omedetou!'),
    retractall(isExit(_)), assertz(isExit(1)).

/* Mengecek kepemilikan */
belongsTo(X, Property) :-
    player(_,X,_,_,_,_,Properties,_,_),
    contains(Property, Properties).

/* Total harga yang dimiliki */
hargaSell(X, Buildings, Total) :- 
    Buildings == [0],
    harga(X,_,_,HT,_,_,_,_),
    Total is HT.

hargaSell(X, Buildings, Total) :- 
    Buildings == [0,1],
    harga(X,_,_,HT,H1,_,_,_),
    Total is HT+H1.

hargaSell(X, Buildings, Total) :- 
    Buildings == [0,1,2],
    harga(X,_,_,HT,H1,H2,_,_),
    Total is HT+H1+H2.

hargaSell(X, Buildings, Total) :- 
    Buildings == [0,1,2,3],
    harga(X,_,_,HT,H1,H2,H3,_),
    Total is HT+H1+H2+H3.

hargaSell(X, Buildings, Total) :- 
    Buildings == [0,1,2,3,4],
    harga(X,_,_,HT,H1,H2,H3,HL),
    Total is HT+H1+H2+H3+HL.

/* sellBuilding untuk membeli bangunan yang dimiliki */
askSellBuilding(X, Inp) :-
    nowPlayer(Player),
    belongsTo(Player, X),
    player(_,Player,_,_,_,_,_,Buildings,_),
    hargaSell(X, Buildings, Total),
    Harga is 0.8*Total,
    harga(X,Nama,_,_,_,_,_,_),
    write('Harga bangunan '), write(Nama), write(': '), write(Harga), nl,
    write('Jual bangunan '), write('? [y/n]'), nl,
    write('Command: '),
    read(Inp),
    sellFin(X,Inp).


/* PROGRAM UTAMA */
/* Pemain akan mengetik command start */
start :-
    retractall(isExit(1)), asserta(isExit(0)),
    retractall(nowPlayer(_)), asserta(nowPlayer(v)),
    retractall(player(_,_,_,_,_,_,_,_,_)),
    assertz(player(v,'V',0,2000,0,2000,[],[],[])),
    assertz(player(w,'W',0,2000,0,2000,[],[],[])),
    write('Welcome to isekai!1!1'), nl,
    write('Ketik map untuk melihat map.'), nl,
    write('Ketik help untuk melihat command tambahan.'), nl,
    write('Ketik checkPlayerDetail(<nama player>) untuk melihat detail pemain.'), nl,
    printNowPlayer,
    randomize.

help :-
    write('Command tambahan yang dapat digunakan: '), nl,
    write('1. map                      : untuk melihat map'), nl,
    write('2. ingfo(<nama player)      : untuk melihat pemain'), nl,
    write('3. checkPropertyDetail(X)   : melihat detail properti'), nl,
    write('4. checkLocationDetail(X)   : melihat detail lokasi').

/*Cek harga sewa*/
hargaSewa(Prop,0,Sewa) :- sewa(Prop,Sewa,_,_,_,_).
hargaSewa(Prop,1,Sewa) :- sewa(Prop,_,Sewa,_,_,_).
hargaSewa(Prop,2,Sewa) :- sewa(Prop,_,_,Sewa,_,_).
hargaSewa(Prop,3,Sewa) :- sewa(Prop,_,_,_,Sewa,_).
hargaSewa(Prop,4,Sewa) :- sewa(Prop,_,_,_,_,Sewa).

/* Mekanisme aksi di lokasi */
/* (fp) Parkir gratis */
aksi(Player, fp) :-
    write('Kamu sedang berada di: fp'), nl,
    write('Parkir gratis!'), nl,
    isExit(0), gantiPlayer, printNowPlayer, !.

/* (jl) Penjara */
aksi(Player, jl) :-
    write('Kamu sedang berada di: jl'), nl,
    isExit(0), gantiPlayer, printNowPlayer, !.

/* (wt) World Tour */
aksi(Player, wt) :-
    write('Kamu sedang berada di: wt'), nl,
    write('Kamu berkesempatan untuk melakukan world tour! Pilih destinasi: '),
    read(Inp),
    (worldTour(Player, Inp),
    isExit(0), gantiPlayer, printNowPlayer; 
    \+ worldTour(Player, Inp), aksi(Player, Loc)), !.

/* (cc) Chance Card */
aksi(Player, cc) :-
    write('Kamu sedang berada di: cc'), nl,
    pickChanceCard,
    isExit(0), gantiPlayer, printNowPlayer, !.

/* (tx) Tax */
aksi(Player, tx) :-
    write('Kamu sedang berada di: tx'), nl,
    write('Kena pajak!'), nl,
    tax(Player, Y), nl,
    subtractMoney(Player,Y), nl,
    isExit(0), gantiPlayer, printNowPlayer, !.

/* sisanya */
aksi(Player,X):-
    isProperties(X),
    \+isNotIn(X),
    belongsTo(T,X),
    player(U,T,_,_,_,_,_,_,_),
    U == Player,!,
    write('Kamu sedang berada di: '), write(X), nl,
    write('Properti ini sudah kamu miliki.'),nl,
    beliBangunan(Player,X,0),
    isExit(0), gantiPlayer, printNowPlayer.

/*Kondisi ketika properti sudah dimiliki orang lain*/
aksi(Player,X):-
    isProperties(X),
    \+isNotIn(X),
    belongsTo(T,X),
    player(U,T,_,_,_,_,_,_,_),
    U \= Player,
    infoLoc(X,_,_, _,_, Rent,_,P,_),
    /*calculateRent(U, Rent),*/
    P == 'L',!,
    write('Kamu sedang berada di: '), write(X), nl,
    write('Properti ini sudah dimiliki '), write(U), write(' ! Kamu harus membayar sewa sebesar '), write(Rent),nl,
    player(Player,_,_,_,_,Asset,_,_,_), bayarSewa(Player,Asset,Rent),
    isExit(0), gantiPlayer, printNowPlayer.

aksi(Player,X):-
    isProperties(X),
    \+isNotIn(X),
    belongsTo(T,X),
    player(U,T,_,_,_,_,_,_,_),
    U \= Player,
    infoLoc(X,_,_, _,_, Rent,_,P,_),
    /*calculateRent(U, Rent),*/
    P \= 'L',!,
    write('Kamu sedang berada di: '), write(X), nl,
    write('Properti ini sudah dimiliki '), write(U), write(' ! Kamu harus membayar sewa sebesar '), write(Rent),nl,
    player(Player,_,_,_,_,Asset,_,_,_), bayarSewa(Player,Asset,Rent),
    write('Apakah Anda ingin mengakuisisi Properti ini? [y/n] '),
    read(Inp),
    akuisisi(Player,X,Inp),
    isExit(0), gantiPlayer, printNowPlayer.

/*Kondisi ketika properti belum dimiliki orang lain*/
aksi(Player,X):-
    isProperties(X),
    isNotIn(X), !,
    write('Kamu sedang berada di: '), write(X), nl,
    write('Apakah kamu ingin membeli properti ini? [y/n] '),
    read(Inp),
    aksiInp(Player,X,Inp).

/* bayar sewa uang cukup */
bayarSewa(Player,Asset,Rent):-
    player(Player,_,_,Money,_,Asset,_,_,_),
    Money > Rent, !,
    subtractMoney(Player,Rent).

/* bayar sewa gak bangkrut */
bayarSewa(Player,Asset,Rent):-
    Asset < Rent, !,
    write('Uang dan aset tidak mencukupi!'),nl,
    bangkrut(Player).

/* bayar sewa tapi bangkrut */ 
bayarSewa(Player,Asset,Rent):-
    player(Player,_,_,Money,_,Asset,_,_,_),
    write('Uangmu: '), write(Money), nl,
    write('Daftar propertimu: '), nl,
    printListProperties(Properties,Buildings,1), nl,
    write('Properti yang ingin dijual: '),
    read(Inp),
    bayarSewaInp(Player,Asset,Rent,Inp),
    player(Player,_,_,MoneyN,_,Asset,_,_,_),
    bayarSewa(Player,Asset,Rent).

bayarSewaInp(Player,Asset,Rent,Inp):-
    downgradeBuildingAll(Player,X).

downgradeBuildingAll(Player,X):-
    \+ downgradeBuilding(Player,X).
downgradeBuildingAll(Player,X):-
    downgradeBuilding(Player,X),
    downgradeBuildingAll(Player,X).

/*Kondisi ketika tidak ingin membeli*/
aksiInp(Player,X,n) :-
    !, isExit(0), gantiPlayer, printNowPlayer.

/*Kondisi ketika ingin membeli*/
aksiInp(Player,X,y) :-
    buyProperties(Player,X),
    write('Properti '), write(X), write(' berhasil dibeli.'), nl,
    beliBangunan(Player,X,0),
    isExit(0), gantiPlayer, printNowPlayer.

beliBangunan(Player,X,4) :-
    !,write('Bangunan sudah terupgrade sampai Landmark!'),nl.

beliBangunan(Player,X,Val):- 
    write('Apakah kamu ingin mengupgrade bangunan? [y/n] '),
    read(Inp),
    beliBangunanInp(Player,X,Val,Inp).

beliBangunanInp(Player,X,Val,n):- !.

beliBangunanInp(Player,X,Val,y) :-
    Val2 is Val + 1,
    upgradeBuilding(Player,X), beliBangunan(Player,X, Val2).

akuisisi(Player,Property,n) :- !.
akuisisi(Player,Property,y) :-
    player(Player,Username,Location,Money,PropertiesValue,Asset,Properties,Buildings,Cards),
    lawan(Player, Lawan),
    player(Lawan, Username2,Location2,Money2,PropertiesValue2,Asset2,Properties2,Buildings2,Cards2),
    infoLoc(Property,A,B,C,Lawan,E,Cost,Level,H),
    Money < Cost, !,
    write('Maaf!, uang anda tidak cukup!'),nl.

akuisisi(Player,Property,y) :-
    player(Player,Username,Location,Money,PropertiesValue,Asset,Properties,Buildings,Cards),
    lawan(Player, Lawan),
    player(Lawan, Username2,Location2,Money2,PropertiesValue2,Asset2,Properties2,Buildings2,Cards2),
    infoLoc(Property,A,B,C,Lawan,E,Cost,Level,H),
    Money >= Cost,
    subtractMoney(Player,Cost),
    addMoney(Lawan,Cost),
    retractall(infoLoc(Property,_,_,_,_,_,_,_,_)),
    assertz(infoLoc(Property,A,B,C,Player,E,Cost,Level,H)),
    getIndex(Property,Properties2,Idx),
    removeElement(Properties2,Property,PropertiesUpdated),
    removeElementByIdx(Buildings2,Idx,BuildingsUpdated),
    CostAwal is Cost/2,
    PropertiesValue2Updated is PropertiesValue2 - CostAwal,
    Asset2Updated is Asset2 - CostAwal,
    retractall(player(Lawan, _,_,_,_,_,_,_,_)),
    assertz(player(Lawan, Username2,Location2,Money,PropertiesValue2Updated,Asset2Updated,PropertiesUpdated,BuildingsUpdated,Cards2)),
    PropertiesValueUpdated is PropertiesValue + CostAwal,
    AssetUpdated is Asset + CostAwal,
    retractall(player(Player,_,_,_,_,_,_,_,_)),
    assertz(player(Player,Username,Location,Money,PropertiesValueUpdated,AssetUpdated,[Property|Properties],[Level|Buildings],Cards)).

/* [<SYSTEM> INCLUDE INTERNAL] */
:- include('internal/incl.pl').
