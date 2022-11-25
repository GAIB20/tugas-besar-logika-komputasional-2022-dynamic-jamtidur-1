/* EXTERNAL: Melakukan world tour */
worldTour(_, Dest):-
    \+ isLoc(Dest),
    write(Dest), write(' bukan tujuan yang valid!'), nl, !.

worldTour(Player, Dest):-
    player(Player, _, Location, _, _, _, _, _, _),
    infoLoc(Dest, _, Name, _, _, _, _, _,_),
    findDistance(Location, Dest, X),
    move(Player, X),
    write('Selamat datang ke '), write(Name), ('!'), nl, !.
