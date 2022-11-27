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

/* Status permainan */
:- dynamic(isExit/1).
:- dynamic(nowPlayer/1).
isExit(1).
nowPlayer(v).

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

ingfo(X) :-
    player(Player,X,_,_,_,_,_,_,_),
    checkPlayerDetail(Player).

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
    write('Ketik ingfo(<nama player>) untuk melihat detail pemain.'), nl,
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
    gantiPlayer, printNowPlayer.
    
/* Mekanisme aksi di lokasi */
/* (fp) Parkir gratis */
aksi(Player, fp) :-
    write('Parkir gratis!'), nl,
    gantiPlayer, printNowPlayer.