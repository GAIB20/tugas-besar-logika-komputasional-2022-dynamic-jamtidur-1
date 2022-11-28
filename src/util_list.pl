/* Container untuk semua rule pembantu untuk list */
/* Mencetak list ke layar */
printList([],_).
printList([A|B],P) :-
    write(P),write('. '),
    P1 is P +1,
    write(A),nl,
    printList(B,P1).

/* true jika elemen ada dalam list */
contains(_,[]) :- !, fail.
contains(A,[A|_]) :- !.
contains(A,[H|T]) :- contains(A,T).

/* mengembalikan banyak elemen dalam list */
lengthList([],0):- !.
lengthList([_|T],C):-
    lengthList(T,C1),
    C is C1+1.

/* mengembalikan indeks dari suatu elemen dalam list, -1 jika tidak ada */
getIndex(_,[],-1) :- !.
getIndex(A,[A|_],1) :- !.
getIndex(A,[_|T],Idx1) :-
    getIndex(A,T,Idx), Idx1 is Idx + 1.

/* mengembalikan nilai pada indeks tertentu dalam list */
getValue([H|_],1,H) :- !.
getValue([_|T],Idx,Value) :-
    Idx1 is Idx-1,
    getValue(T,Idx1,Value).

/* menyimpan nilai di indeks tertentu dalam list */
setValue(A,[_|T],1,[A|T]):-!.
setValue(A,[H|T],Idx,[H|L1]):-
    Idx1 is Idx - 1,
    setValue(A,T,Idx1,L1).

/* menambahkan elemen baru ke akhir list */
appendElement(A, [], [A]):- !.
appendElement(A, [H|T], [H|T1]):- appendElement(A, T, T1).

/* menghapus elemen dari list */
removeElement([A|T],A,T) :- !.
removeElement([H|T],A,[H|L]):-
    H \= A,
    removeElement(T,A,L).
