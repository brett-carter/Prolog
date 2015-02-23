%Brett Carter
%CS355 - assignment #4.
%brett.carter@wsu.edu.

/*
eval-var: A is the var. H will be the first in the list, X is the output.
 outputs the truth value attributed to the given var
*/

%case that we find the variable. return the truth value paired with it
eval-var(A,[[A,C]|_],C).

%case that we do not have the var in the head, so recurse with the tail.
eval-var(A,[_|T],X):-
    eval-var(A,T,X).

/*
eval-clause: will return if the given clause is satisfied (true) or not (false).
*/

%case that the state is empty. return false.
eval-clause(_,[],false).

%case that the head is just a single variable. eval the variable, if true return, else recurse.

eval-clause(A,[H|T],X):-
    eval-var(H,A,Z),
    (Z =@= true ->
     X = Z;
     eval-clause(A,T,X)
    ).

%case the head is a "not" case. evaluate the variable, if true (now false), recurse with the tail. else its false (now true) and return.

eval-clause(A,[[_,T]|Y],X):-
     eval-var(T,A,Z),
     (Z =@= true ->
      eval-clause(A,Y,X);
      X = true
      ).

/*
get-vars: returns the list of all variables in a clause.
*/

%flatten the list, removes duplicate vars., then removes all "not" from the list.

get-vars(A,X):-
    flatten(A,Z),
    list_to_set(Z,Y),
    delete(Y,not,X).

/*
get-all-vars: returns the list of all variable (no duplicates) from a list of clauses.
*/

%flatten the list of clauses, remove duplicates, and remove "not".

get-all-vars(A,X):-
    flatten(A,Z),
    list_to_set(Z,Y),
    delete(Y,not,X).

/*
unsat-clauses: evaluates all the clauses and returns those that are false.
*/

%case the list of clauses is empty.

unsat-clauses([],_,[]).

%case the list is not empty. evaluate the head of the clause list. if false append, then recurse.

unsat-clauses([H|T],X,Z):- 
    eval-clause(X,H,P), 
    F= false, 
    (F == P -> 
     unsat-clauses(T,X,Rest), 
     append([H],Rest,Z); 
     unsat-clauses(T,X,Z)
     ).

/*
flip-var: changes the truth value of the given variable and returns the changed truth values.
*/

%case that we matched the variable with the list, and its true.flip the value and return the list.

flip-var(H,[[H,T]|Z],[[H,U]|Z]):-
    Y = true,
    T == Y,
    U = false.

%case that we matched the variable with the list, and its false. flip the value and return the list.

flip-var(H,[[H,T]|Z],[[H,U]|Z]):-
    Y = true,
    T \== Y,
    U = true.

%case that the variable didnt match the head, recurse with tail.

flip-var(A,[H|T],[H|Z]):-
    flip-var(A,T,Z).
