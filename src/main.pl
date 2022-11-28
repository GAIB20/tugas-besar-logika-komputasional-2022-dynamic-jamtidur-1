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
    write('Player W menang! Omedetou!').

bankrupt(w) :-
    retractall(player(w,_,_,_,_,_,_,_,_)),
    assertz(player(w,'W',go,20000,0,0,[],[],[])),
    write('Player V menang! Omedetou!').

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

sellFin(X,n) :- write('Bangunan tidak jadi dijual.').
/* bentar pusing, belum selesai */


/* PROGRAM UTAMA */
/* Pemain akan mengetik command start */
start :-
    retractall(isExit(1)), asserta(isExit(0)), retractall(nowPlayer(_)), asserta(nowPlayer(v)),
    write('Welcome to isekai!1!1'), nl,
    write('Ketik map untuk melihat map.'), nl,
    write('Ketik help untuk melihat command tambahan.'), nl,
    write('Ketik checkPlayerDetail(<nama player>) untuk melihat detail pemain.'), nl,
    printNowPlayer.

help :-
    write('Command tambahan yang dapat digunakan: '), nl,
    write('1. map                      : untuk melihat map'), nl,
    write('2. ingfo(<nama player)      : untuk melihat pemain'), nl,
    write('3. checkPropertyDetail(X)   : melihat detail properti').

/* Mekanisme lempar dadu */
throwDice :-
    mthrowDice,
    dice1(Dadu1), dice2(Dadu2), Dadu is Dadu1+Dadu2,
    nowPlayer(Player), move(Player, Dadu),
    currentLoc(Player, Loc), coor(Loc, LocOut), aksi(Player, LocOut).

/*Cek harga sewa*/
hargaSewa(Prop,0,Sewa) :- sewa(Prop,Sewa,_,_,_,_).
hargaSewa(Prop,1,Sewa) :- sewa(Prop,_,Sewa,_,_,_).
hargaSewa(Prop,2,Sewa) :- sewa(Prop,_,_,Sewa,_,_).
hargaSewa(Prop,3,Sewa) :- sewa(Prop,_,_,_,Sewa,_).
hargaSewa(Prop,4,Sewa) :- sewa(Prop,_,_,_,_,Sewa).

/* Mekanisme aksi di lokasi */
/* (fp) Parkir gratis */
aksi(Player, Loc) :-
    Loc == pl, !,
    write('Parkir gratis!'), nl,
    gantiPlayer, printNowPlayer.

/* (jl) Penjara */
aksi(Player, Loc) :-
    Loc == jl, !,
    goToJail(Player),
    gantiPlayer, printNowPlayer.

/* (wt) World Tour */
aksi(Player, Loc) :-
    Loc == wt, !,
    write('Kamu berkesempatan untuk melakukan world tour! Pilih destinasi: '),
    read(Inp),
    (worldTour(Player, Inp),
    gantiPlayer, printNowPlayer; 
    \+ worldTour(Player, Inp), aksi(Player, Loc)).

/* (cc) Chance Card */
aksi(Player, Loc) :-
    Loc == cc, !,
    pickChanceCard,
    gantiPlayer, printNowPlayer.

/* (tx) Tax */
aksi(Player, Loc) :-
    Loc == tx, !,
    write('Kena pajak!'),
    tax(Player, Y),
    subtractMoney(Player,Y).

/* sisanya */
aksi(Player,X):-
    isProperties(X),
    \+isNotIn(X),
    belongsTo(T,X),
    player(U,T,_,_,_,_,_,_,_),
    U == Player,!,
    write('Properti ini sudah kamu miliki.'),nl,
    beliBangunan(Player,X,0), gantiPlayer, printNowPlayer.

/*Kondisi ketika properti sudah dimiliki orang lain*/
aksi(Player,X):-
    isProperties(X),
    \+isNotIn(X),
    belongsTo(T,X),
    player(U,T,_,_,_,_,_,_,_),
    U \= Player,!,
    infoLoc(X,_,_, _,_, Rent,_,_,_),
    write('Properti ini sudah dimiliki '), write(U), write(' ! Anda harus membayar sewa sebesar '), write(Rent),nl,
    subtractMoney(Player,Rent),
    gantiPlayer, printNowPlayer,!.

/*Kondisi ketika properti belum dimiliki orang lain*/
/*Kondisi ketika tidak ingin membeli*/
aksi(Player,X):-
    isProperties(X),
    isNotIn(X),
    write('Apakah anda ingin membeli properti ini? [y/n]'),
    read(Inp),
    Inp == n,!, gantiPlayer, printNowPlayer.

/*Kondisi ketika ingin membeli*/
aksi(Player,X):-
    isProperties(X),
    isNotIn(X),
    write('Apakah anda ingin membeli properti ini? [y/n]'),
    read(Inp),
    Inp == y,!, 
    buyProperties(Player,X),
    write('Properti '), write('X'), write(' berhasil dibeli.'), 
    beliBangunan(Player,X,0), gantiPlayer, printNowPlayer.

beliBangunan(Player,X,Val):- 
    Val2 is Val + 1,
    Val <4,
    write('Apakah Anda ingin mengupgrade bangunan? [y/n]'),
    read(Inp),
    Inp == n,!.

beliBangunan(Player,X,Val):- 
    Val2 is Val + 1,
    Val <4,
    write('Apakah Anda ingin mengupgrade bangunan? [y/n]'),
    read(Inp),
    Inp == y,
    !, upgradeBuilding(Player,X), beliBangunan(Player,X, Val2).

beliBangunan(Player,X,Val):- 
    Val2 is Val + 1,
    Val == 4,!,write('Bangunan sudah terupgrade sampai Landmark!'),nl,nl.