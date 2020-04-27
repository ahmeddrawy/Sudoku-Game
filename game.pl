
%% todo grid(G),nth0(0,G,X),nth0(0,X,Y). to  get y = element at (0,0)

numbers([1,2,3,4,5,6,7,8,9]).
% 0 is empty spot in the Grid
grid([
		[0,2,6,0,0,0,8,1,5],
		[3,1,5,7,2,8,9,4,6],
		[4,0,0,0,5,0,0,0,7],
		[0,5,0,1,0,7,0,9,0],
		[0,0,3,9,0,5,1,0,0], 
		[0,4,0,3,0,2,0,5,0],
		[1,0,0,0,3,0,0,0,2],
		[5,0,0,2,0,4,0,0,9],
		[0,3,8,0,0,0,4,6,0]
	]).
printPair([X,Y]):-
	write(X) , write(' ') , write(Y) , put(10).
%% play(empty , currentState,FinalState)
play([] , CurrentState,CurrentState):-
	printGrid(CurrentState),!.
play(Empty , CurrentState , FinalState):-
	for2(X,Empty),
	numbers(Num ),
	for(Y ,Num) ,
	editGridCell(X,Y,CurrentState,NewState),
	safeState(NewState),
	getAllEmpty(NewState , NewEmpty),
	%% printGrid(NewState).
	play(NewEmpty,NewState,FinalState).
	
	%% updateState(X ,CurrentState , NewState),
	%% updateEmpty(X , Empty , NewEmpty),
	%% play(NewEmpty , NewState ,FinalState).


%--------------done---------------------

getEmpty(CurrentState,Pair):-
	between(0,8,A),between(0,8,B),
	getPointAt(A,B,Value , CurrentState),
	Value is 0,
	append([A],[B] ,Pair).
getAllEmpty(CurrentState , List):-
	findall(Element,getEmpty(CurrentState,Element),List).


getSquareCoordinate(X,Y,R):-
	X is (R//3)*3 ,
	Y is (R mod 3)*3.

getSquareElement(R,CurrentState,Element):-
	getSquareCoordinate(X,Y,R),			% we get coordinate for square R 
	between(0,2,A),between(0,2,B),	% we get all coordinates using X+(0,1,2) and Y 
	NwX is X + A ,NwY is Y + B ,
	getPointAt(NwX,NwY,Element,CurrentState). % we get the point to append in the list
%% we get the square with index R in a List 
getSquareList(R,CurrentState,List):-
	findall(Element,getSquareElement(R,CurrentState,Element),List).

%% safeState(CurrentState):-
safeList(L):-
	safeList(L,[]).
safeList([] , _):-!.
safeList([H|T] ,Current ):-
	H>0 ->
		not(member(H,Current)),
		append(Current ,[H] ,NewCurrent),
		safeList(T,NewCurrent);
		safeList(T,Current).
%% we have 9 rows and 9 columns and 9 squares we check all of them 
safeState(CurrentState):-
	safeState(0,CurrentState).
safeState(9,_ ):-!.
safeState(Cnt,CurrentState):-
	getRow(Cnt,CurrentState , Row),
	getColumn(Cnt,CurrentState,Col),
	getSquareList(Cnt,CurrentState,Square),
	safeList(Row),
	safeList(Col),
	safeList(Square),
	NewCnt is Cnt +1 ,
	safeState(NewCnt,CurrentState).





getPointAt(R,C,Res,CurrentState):-
	nth0(R,CurrentState,X),nth0(C,X,Res).	%% to  get y = element at (0,0)	

getColumn(C,CurrentState, Col):-
	getColumn(C,0,CurrentState,[], Col),!.

getColumn(_,9,_,CurrentCol, CurrentCol):-!.
getColumn(C,Cnt,CurrentState,CurrentCol, Col):-
	NewCnt is Cnt +1,
	getPointAt(Cnt , C , Res ,CurrentState),
	append(CurrentCol , [Res] , NewCol),
	getColumn(C,NewCnt, CurrentState,NewCol , Col).

getRow(R , CurrentState , Row):-
	nth0(R,CurrentState , Row),!.% when we remove the cut doesn't work propably with the safeList



printRow([]):-
	put(10),!.
printRow([H|T]):-
	write(H) ,write(' '),write(' '),
	printRow(T).
printGrid([]):-!.
printGrid([H|T]):-
	printRow(H) , printGrid(T).


editGridCell([R,C] ,NewValue, CurrentState,NewState):-
	(
		nth0(R ,CurrentState, Row),
		editListElement(C,0,NewValue , Row , [] , NewRow),				%% we first edit the row list
		editListElement(R, 0, NewRow , CurrentState, [] , NewState)	%% we then edit column list
	).


%% editListElement(C, cnt , NewValue , Row):-
editListElement(C,C , NewValue , [_|T],Prev, NewRow):-
	(
		append(Prev , [NewValue] , TmpLst) ,
		append(TmpLst,T , NewRow),
		!
	).

editListElement(C,Cnt , NewValue , [H|T],Prev, NewRow):-
	(	append(Prev , [H], NewPrev) , 
		NewCnt is Cnt+1 , 
		editListElement(C,NewCnt , NewValue, T , NewPrev , NewRow)
	).


print([X,Y|_]):-
	write(X) , write(' ') , write(Y) , put(10).
%% x is 2D coordinate in the grid
%% CurrentState is a 2D grid
%% safe(X , CurrentState):-


for(_,[]):-!,false.
%% i dont know how but the 2 for loop works without base case
for(X,[H|T]):-
	(X is H) ;
	for(X , T).

for2(_ , []):-!,false.
for2(X , [[H,Y|_]|T]):-
	(append([] , [H] , X2 ) , append(X2,[Y] , X)).
	%% for2(X ,T).