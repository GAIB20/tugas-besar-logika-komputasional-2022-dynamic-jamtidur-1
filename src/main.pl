/* *** Include file *** */
/* [<SYSTEM> INCLUDE INTERNAL] */
:- include('internal/incl.pl').

/* Include util */
:- include('util_list.pl').

/* Include source */
:- include('chance_card.pl').
:- include('dadu.pl').
:- include('jail.pl').
:- include('player.pl').
:- include('property.pl').
:- include('Loc.pl').

/* Status permainan */
:- dynamic(isExit/1).
:- dynamic(nowPlayer/1).
isExit(1).
nowPlayer(v).

start :-
    retractall(isExit(1)), asserta(isExit(0)), retractall(nowPlayer(_)), asserta(nowPlayer(v)),
    write('Misalnya ini pesan pembuka xixixixi'), nl,
    write('Sekarang adalah giliran pemain '),
    nowPlayer(X), player(X,Nama,_,_,_,_,_,_,_),
    write(Nama), write('.'), nl,
    write('Ketik map untuk melihat map.'), nl,
    write('Ketik ingfo(<nama player>) untuk melihat detail pemain.'),
    /* Inisialisasi random */
    random(0,120,_).

ingfo(X) :-
    player(Player,X,_,_,_,_,_,_,_),
    checkPlayerDetail(Player), !.

/* map sudah diimplementasikan di file ... */
/* throwDice, dice1, dice2 sudah diimplementasikan di file ... */

/* bankrupt */
bankrupt(v) :-
    retractall(player(v,_,_,_,_,_,_,_,_)),
    assertz(player(v,'V',go,20000,0,0,[],[],[])).

bankrupt(w) :-
    retractall(player(w,_,_,_,_,_,_,_,_)),
    assertz(player(w,'W',go,20000,0,0,[],[],[])).

/* sellBuilding untuk membeli bangunan yang dimiliki */
sellBuilding(X) :- harga(_,X,_,H1,H2,H3,H4,_), Harga is 0.8*(H1+H2+H3+H4), nowPlayer(Player), addMoney(Player,Harga).

/* bentar ya belum selesai hehehe */