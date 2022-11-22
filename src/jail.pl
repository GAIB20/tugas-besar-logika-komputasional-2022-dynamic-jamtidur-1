/*Kondisi jika pemain punya kartu bebas dari penjara*/
/*rules ini akan ditambahkan ke rules-rules yang membuat pemain masuk ke dalam penjara*/
goToJail(X):-
    player(X,Username,Location,Money,PropertiesValue,Asset,Properties,Buildings,Card),
    hasCard(Card,angelcard),!,write('Pemain tidak masuk penjara karena memiliki angel card'),
    removeElement(Card,angelcard,_),
    retractall(player(X,Username,Location,Money,PropertiesValue,Asset,Properties,Buildings,Card)),
    assertz(player(X,Username,Location,Money,PropertiesValue,Asset,Properties,Buildings,Card)).

/*Kondisi jika pemain tidak punya kartu bebas dari penjara*/
/*rules ini akan ditambahkan ke rules-rules yang membuat pemain masuk ke dalam penjara*/
goToJail(X) :- 
    retractall(player(X,Username,_,Money,PropertiesValue,Asset,Properties,Buildings,Card)),
    Location2 is jail, write('Pemain '), write(X), write(' masuk ke dalam penjara'),
    assertz(player(X,Username,Location2,Money,PropertiesValue,Asset,Properties,Buildings,Card)).

/*Kondisi pemain berada dalam penjara*/
isJail(X) :-
    player(X,_,Location,_,_,_,_,_,_),
    Location == jail,
    write('pemain '), write(X), write(' berada dalam penjara.').

/*Kondisi ketika pemain berhasil keluar dari penjara*/
/*Langkah memuat berapa kali pemain harus maju dari kotak penjara*/
/*rules ini akan ditambahkan ke rules-rules yang membuat pemain keluar dari penjara*/
free(X,Langkah) :-
    isJail(X),
    retractall(player(X,Username,Location,Money,PropertiesValue,Asset,Properties,Buildings,Card)),
    Location2 is Location + Langkah,
    assertz(player(X,Username,Location2,Money,PropertiesValue,Asset,Properties,Buildings,Card)).

/*menghapus elemen dari list*/
removeElement([A|T],A,T) :- !.
removeElement([H|T],A,[H|L]):-
    H \= A,
    removeElement(T,A,L).

/*memeriksa apakah pemain mempunyai suatu kartu*/
hasCard([A|_],A) :- !.
hasCard([H|T],A) :-
    H \= A, hasCard(T,A).

