/* consult('C:/Users/ASUS/OneDrive - Institut Teknologi Bandung/Documents/GitHub/tugas-besar-logika-komputasional-2022-dynamic-jamtidur-1/dadu.pl') */

:- dynamic(dice1/1).
:- dynamic(dice2/1).
:- dynamic(sameDiceNum/1).
:- dynamic(sumDice/1).

dice1(0).
dice2(0).
sameDiceNum(0).
sumDice(0).

resetSameDiceNum :- retractall(sameDiceNum(_)), assertz(sameDiceNum(0)).

/* prosedur throwDice */
mthrowDice :-
    random(1,7,X),
    random(1,7,Y),
    retractall(dice1(_)),
    retractall(dice2(_)),
    asserta(dice1(X)),
    asserta(dice2(Y)),
    write('Dice 1: '), write(X), nl,
    write('Dice 2: '), write(Y), nl.


/* Mekanisme lempar dadu */
/*
throwDice :-
    mthrowDice, dice1(Dadu1), dice2(Dadu2), throwDiceCMD(Dadu1, Dadu2).
throwDiceCMD(Dadu1, Dadu2) :-
    Dadu1 == Dadu2, !,
    Total1 is Dadu1+Dadu2, commandThrow(Dadu1, Dadu2), nl,
    read(Inp),
    throwDice2(Total1, Inp).
throwDiceCMD(Dadu1, Dadu2) :-
    \+(Dadu1 == Dadu2),
    Dadu is Dadu1+Dadu2, commandThrow(Dadu1,Dadu2).
    
throwDice2(Init, throwDice) :-
    mthrowDice, dice1(Dadu1), dice2(Dadu2), throwDice2CMD(Dadu1, Dadu2, Init).
throwDice2CMD(Dadu1, Dadu2, Init) :-
    Dadu1 == Dadu2, !,
    Total2 is Dadu1+Dadu2+Init, commandThrow(Dadu1, Dadu2),
    read(Inp),
    throwDice3(Total2, Inp).
throwDiceCMD(Dadu1, Dadu2, Init) :-
    \+(Dadu1 == Dadu2),
    Dadu is Dadu1+Dadu2+Init, commandThrow(Dadu1,Dadu2).

throwDice3(Init) :-
    mthrowDice, dice1(Dadu1), dice2(Dadu2), throwDice3CMD(Dadu1, Dadu2, Init).
throwDice3CMD(Dadu1, Dadu2, Init) :-
    Dadu1 == Dadu2, !,
    write('Pemain ke penjara!!!').
throwDice3CMD(Dadu1, Dadu2, Init) :-
    \+(Dadu1 == Dadu2),
    Dadu is Dadu1+Dadu2+Init, commandThrow(Dadu1,Dadu2).*/

throwDice :- 
    mthrowDice, dice1(X), dice2(Y),
    commandThrow(X,Y).

commandThrow(X,X) :-
    sameDiceNum(2),
    write('Jail'), nl,
    retractall(sameDiceNum(_)), assertz(sameDiceNum(0)),
    retractall(sumDice(_)), assertz(sumDice(0)),
    nowPlayer(Player), goToJail(Player),
    gantiPlayer, printNowPlayer.

commandThrow(X,X) :-
    sumDice(S),
    Total is X+X+S,
    write('Double!'), nl,
    write('Anda maju sebanyak '), write(Total), write(' langkah.'),nl,
    sameDiceNum(N), N1 is N+1, retractall(sameDiceNum(N)), assertz(sameDiceNum(N1)),
    retractall(sumDice(_)), assertz(sumDice(Total)),
    printNowPlayer, !.

commandThrow(X,Y) :-
    \+ X == Y,
    sumDice(N),
    Total is X+Y+N,
    nowPlayer(Player), move(Player, Total),
    write('Anda maju sebanyak '), write(Total), write(' langkah.'),nl,
    currentLoc(Player, Loc), coor(Loc, LocOut), 
    retractall(sameDiceNum(_)), assertz(sameDiceNum(0)),
    retractall(sumDice(_)), assertz(sumDice(0)),
    aksi(Player, LocOut).