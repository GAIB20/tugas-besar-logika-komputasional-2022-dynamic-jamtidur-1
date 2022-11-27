tax(X,Y) :-
    Y is X div 10,
    write('Amount of tax the player must pay = '),
    write(Y). 