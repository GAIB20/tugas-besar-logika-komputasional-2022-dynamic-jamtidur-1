/*Kondisi jika pemain punya kartu bebas dari penjara*/
/*rules ini akan ditambahkan ke rules-rules yang membuat pemain masuk ke dalam penjara*/
:- dynamic(penjara/2).
:- dynamic(attempt/2).

penjara(v,0).
penjara(w,0).

goToJail(X):-
    penjara(X,1),!,
    write('Pemain '), write(X), write(' sudah berada dalam penjara.'), !.

goToJail(X):-
    penjara(X,0),
    player(X,Username,Location,Money,PropertiesValue,Asset,Properties,Buildings,Card),
    hasCard(X,card_angel),!,write('Pemain tidak masuk penjara karena memiliki angel card'),
    removeElement(Card,card_angel,NewCard),
    retractall(player(X,_,_,_,_,_,_,_,_)),
    assertz(player(X,Username,Location,Money,PropertiesValue,Asset,Properties,Buildings,NewCard)), !.

/*Kondisi jika pemain tidak punya kartu bebas dari penjara*/
/*rules ini akan ditambahkan ke rules-rules yang membuat pemain masuk ke dalam penjara*/
goToJail(X) :- 
    penjara(X,0),
    player(X,Username,Location,Money,PropertiesValue,Asset,Properties,Buildings,Card),
    retractall(player(X,_,_,_,_,_,_,_,_)),
    coor(Jail, jl), Location2 is Jail, write('Pemain '), write(X), write(' masuk ke dalam penjara'),
    assertz(player(X,Username,Location2,Money,PropertiesValue,Asset,Properties,Buildings,Card)),
    retractall(penjara(X,0)),
    assertz(penjara(X,1)).

/*Kondisi pemain berada dalam penjara*/
isJail(X) :-
    penjara(X,1),
    write('Pemain '), write(X), write(' berada dalam penjara.'),
    write('Apakah Anda ingin membayar denda? [y/n]').
    read(Inp),
    Inp == y,
    !, write('Selamat! Anda dibebaskan dari penjara!'), nl,
    retractall(penjara(X,1)),
    assertz(penjara(X,0)),
    throwDice.

isJail(X) :-
    penjara(X,1),
    write('Pemain '), write(X), write(' berada dalam penjara.'),
    write('Apakah Anda ingin membayar denda? [y/n]').
    read(Inp),
    Inp == n,
    .throwDice, isFree,
    write('Anda mendapat double sebanyak 3 kali! Anda bebas dari penjara!'), nl,
    retractall(penjara(X,1)),
    assertz(penjara(X,0)),
    throwDice.

isJail(X) :-
    penjara(X,1),
    write('Pemain '), write(X), write(' berada dalam penjara.'),
    write('Apakah Anda ingin membayar denda? [y/n]').
    read(Inp),
    Inp == n,
    mthrowDice, \+isFree,
    write('Maaf, Anda harus berada lebih lama di penjara!').


/*Kondisi ketika pemain berhasil keluar dari penjara*/
/*Langkah memuat berapa kali pemain harus maju dari kotak penjara*/
/*rules ini akan ditambahkan ke rules-rules yang membuat pemain keluar dari penjara*/

free(X,Langkah) :-
    isJail(X),
    player(X,Username,Location,Money,PropertiesValue,Asset,Properties,Buildings,Card),
    retractall(player(X,_,_,_,_,_,_,_,_)),
    Location2 is Location + Langkah,
    assertz(player(X,Username,Location2,Money,PropertiesValue,Asset,Properties,Buildings,Card)).
