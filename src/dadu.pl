/* consult('C:/Users/ASUS/OneDrive - Institut Teknologi Bandung/Documents/GitHub/tugas-besar-logika-komputasional-2022-dynamic-jamtidur-1/dadu.pl') */

:- dynamic(dice1/1).
:- dynamic(dice2/1).
:- dynamic(sameDice/1).
:- dynamic(sameDiceNum/1).

dice1(0).
dice2(0).
sameDiceNum(0).

/* prosedur throwDice */
throwDice :-
    random(1,7,X),
    random(1,7,Y),
    retractall(dice1(_)),
    retractall(dice2(_)),
    asserta(dice1(X)),
    asserta(dice2(Y)),
    write('Dice 1: '), write(X), nl,
    write('Dice 2: '), write(Y), nl,
    write('Anda maju sebanyak '), Z is X+Y, write(Z), write(' langkah.'), nl,
    (X == Y, write('Double!')).

sameDice :- dice1(A), dice2(B), A == B, sameDiceNum(X), Y is X+1, retractall(sameDiceNum(_)), asserta(sameDiceNum(Y)).