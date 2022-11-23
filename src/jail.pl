/*Kondisi jika pemain punya kartu bebas dari penjara*/
/*rules ini akan ditambahkan ke rules-rules yang membuat pemain masuk ke dalam penjara*/
goToJail(X):-
    player(X,_,Location,_,_,_,_,_,_),
    coor(Jail, jl), Location == Jail,
    write('Pemain '), write(X), write(' sudah berada dalam penjara.'), !.

goToJail(X):-
    player(X,Username,Location,Money,PropertiesValue,Asset,Properties,Buildings,Card),
    hasCard(Card,card_angel),!,write('Pemain tidak masuk penjara karena memiliki angel card'),
    removeElement(Card,card_angel,NewCard),
    retractall(player(X,_,_,_,_,_,_,_,_)),
    assertz(player(X,Username,Location,Money,PropertiesValue,Asset,Properties,Buildings,NewCard)), !.

/*Kondisi jika pemain tidak punya kartu bebas dari penjara*/
/*rules ini akan ditambahkan ke rules-rules yang membuat pemain masuk ke dalam penjara*/
goToJail(X) :- 
    player(X,Username,Location,Money,PropertiesValue,Asset,Properties,Buildings,Card),
    retractall(player(X,_,_,_,_,_,_,_,_)),
    coor(Jail, jl), Location2 is Jail, write('Pemain '), write(X), write(' masuk ke dalam penjara'),
    assertz(player(X,Username,Location2,Money,PropertiesValue,Asset,Properties,Buildings,Card)), !.

/*Kondisi pemain berada dalam penjara*/
isJail(X) :-
    player(X,_,Location,_,_,_,_,_,_),
    coor(Jail, jl), Location == Jail,
    write('Pemain '), write(X), write(' berada dalam penjara.').

/*Kondisi ketika pemain berhasil keluar dari penjara*/
/*Langkah memuat berapa kali pemain harus maju dari kotak penjara*/
/*rules ini akan ditambahkan ke rules-rules yang membuat pemain keluar dari penjara*/
free(X,Langkah) :-
    isJail(X),
    player(X,Username,Location,Money,PropertiesValue,Asset,Properties,Buildings,Card),
    retractall(player(X,_,_,_,_,_,_,_,_)),
    Location2 is Location + Langkah,
    assertz(player(X,Username,Location2,Money,PropertiesValue,Asset,Properties,Buildings,Card)).

/*memeriksa apakah pemain mempunyai suatu kartu*/
hasCard(List,Card) :- contains(Card,List).
/*hasCard([A|_],A) :- !.
hasCard([H|T],A) :-
    H \= A, hasCard(T,A).*/

