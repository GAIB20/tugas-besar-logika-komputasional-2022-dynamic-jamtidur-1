tax(Player,Y) :-
    player(Player,_,_,Money,_,_,_,_,_),
    Y is Money*0.1,
    write('Amount of tax the player must pay : '),
    write(Y).