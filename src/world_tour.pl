/* EXTERNAL: Melakukan world tour */
worldTour(_, Dest):-
    \+ isLoc(Dest),
    write(Dest), write(' bukan tujuan yang valid!'), nl, !, fail.

worldTour(Player, Dest):-
    player(Player, _, Coor, _, _, _, _, _, _),
    coor(Coor, Location),
    infoLoc(Dest, _, Name, _, _, _, _, _,_),
    findDistance(Location, Dest, X),
    move(Player, X),
    write('Selamat datang ke '), write(Name), write('!'), nl, !.
