/*Kondisi jika pemain punya kartu bebas dari penjara*/
/*rules ini akan ditambahkan ke rules-rules yang membuat pemain masuk ke dalam penjara*/
:- dynamic(penjara/2).
:- dynamic(attempt/2).

penjara(v,0).
penjara(w,0).

goToJail(X):-
    penjara(X,1),!,
    write('Pemain '), write(X), write(' sudah berada dalam penjara.'), nl, !.

goToJail(X):-
    penjara(X,0),
    player(X,Username,Location,Money,PropertiesValue,Asset,Properties,Buildings,Card),
    hasCard(X,card_angel),!,write('Pemain tidak masuk penjara karena memiliki angel card!'), nl,
    removeElement(Card,card_angel,NewCard),
    retractall(player(X,_,_,_,_,_,_,_,_)),
    assertz(player(X,Username,Location,Money,PropertiesValue,Asset,Properties,Buildings,NewCard)), !.

/*Kondisi jika pemain tidak punya kartu bebas dari penjara*/
/*rules ini akan ditambahkan ke rules-rules yang membuat pemain masuk ke dalam penjara*/
goToJail(X) :- 
    penjara(X,0),
    player(X,Username,Location,Money,PropertiesValue,Asset,Properties,Buildings,Card),
    retractall(player(X,_,_,_,_,_,_,_,_)),
    coor(Jail, jl), Location2 is Jail, write('Pemain '), write(X), write(' masuk ke dalam penjara!'), nl,
    assertz(player(X,Username,Location2,Money,PropertiesValue,Asset,Properties,Buildings,Card)),
    retractall(penjara(X,0)),
    assertz(penjara(X,1)),
    assertz(attempt(X,0)).

/*Kondisi pemain berada dalam penjara*/
isJail(X) :-
    penjara(X,1),
    write('Pemain '), write(X), write(' berada dalam penjara.'), nl,
    write('Apakah Anda ingin membayar denda? [y/n]'),
    read(Inp),
    (
        Inp == y, !, actJailOnYes(X);
        Inp == n, !, attemptFree(X), actJailOnNo(X)
    ).

actJailOnYes(X) :-
    write('Selamat! Anda dibebaskan dari penjara!'), nl,
    retractall(attempt(X,_)),
    retractall(penjara(X,1)),
    assertz(penjara(X,0)),
    throwDice.

actJailOnNo(X) :-
    getsFree(X),
    write('Anda berhasil melarikan diri dari penjara!'), nl,
    retractall(attempt(X,_)),
    retractall(penjara(X,1)),
    assertz(penjara(X,0)),
    throwDice.
actJailOnNo(X) :-
    \+getsFree(X),
    write('Maaf, Anda harus berada lebih lama di penjara!'), nl,
    isExit(0), gantiPlayer, printNowPlayer.

attemptFree(X) :-
    attempt(X,N), N1 is N+1,
    write('Percobaan ke-'), write(N1), nl,
    mthrowDice,
    retractall(attempt(X,_)),
    assertz(attempt(X,N1)).

getsFree(X) :-
    attempt(X,N), N >= 3, !.
getsFree(_) :-
    dice1(A), dice2(B),
    A == B, !.

/*Kondisi ketika pemain berhasil keluar dari penjara*/
/*Langkah memuat berapa kali pemain harus maju dari kotak penjara*/
/*rules ini akan ditambahkan ke rules-rules yang membuat pemain keluar dari penjara*/

/*free(X,Langkah) :-
    isJail(X),
    player(X,Username,Location,Money,PropertiesValue,Asset,Properties,Buildings,Card),
    retractall(player(X,_,_,_,_,_,_,_,_)),
    Location2 is Location + Langkah,
    assertz(player(X,Username,Location2,Money,PropertiesValue,Asset,Properties,Buildings,Card)).
*/