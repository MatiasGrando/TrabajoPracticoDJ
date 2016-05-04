Program TP1_Concierto;

{Concierto con 25 dj's como max y 35 temas cada uno como max. 200 temas con sus duraciones mm:ss
en una lista oficial.
Hasta 25 nombres de DJ's y sus temas elegidos (no repetidos) a travez de un menu.
Los datos ingresados deben:
a)ser validados
Hasta ahora estan hechas las listas de Temas y de Djs, los datos se validan cuando se van ingresando. Hay algunos lugares
donde los operadores tiran una warning pero yo creo que funcionan bien y es problema de pascal que lo tira nomas como advertencia
nombres alfanumericos-que passa si en el putno 2b tienen la misma duracion?}



Const
	Parar = '0'; {esta frase frena la carga de canciones}
        MaxTemasOficiales = 3;
	MaxDuracion = 600;
	MaxDj = 2;
	MaxTemasPorDj = 35;
	CaracteresTitulo = 30;
	CaracteresNombre = 20;

Type
	tTitulo = string[CaracteresTitulo];
	tNombre = string[CaracteresNombre];
	tIndiceTemasOficiales = 1..MaxTemasOficiales;
	tvTemasOficiales = array [tIndiceTemasOficiales] of tTitulo;
	tBaseDuracion = 1..MaxDuracion;
	tvDuracion = array [tIndiceTemasOficiales] of tBaseDuracion;
	tIndiceDj = 1..MaxDj;
	tvDj = array [tIndiceDj] of tNombre;
    tIndiceTemasPorDj = 1..MaxTemasPorDj;
    tBaseCantTemasPorDj = 0..MaxTemasPorDj;
	tmTemasAsignados = array [tIndiceDj, tIndiceTemasPorDj] of tTitulo;
	tvCantTemasPorDj = array [tIndiceTemasPorDj] of tBaseCantTemasPorDj;
	tCantDjs=0..MaxDj;
	tvAcumTiempo= array [1..maxdj] of word;
	tvCont=array[1..maxtemasoficiales] of word;
	tVecOrdPorSeg= array[tIndiceTemasPorDj] of tBaseDuracion;
	tvecOrdParaleloTemasPorSeg= array[tIndiceTemasPorDj] of tIndiceDj;

Var
	vTemasOficiales: tvTemasOficiales;
	vDuracion: tvDuracion;
	vDj: tvDj;						{ Vector Paralelo a la matriz de Djs indica nombre del Dj (string)}
	mTemasAsignados: tmTemasAsignados;
	vCantTemasPorDj: tvCantTemasPorDj; { Vector Paralelo a la matriz de temas Djs indica Maximo Logico (numerico)}
	Titulo: tTitulo;
        DuracionEnSeg: tBaseDuracion;
        CantDjs:tCantDjs; {funciona como ml (cuantos djs hay?) (numerico)}
        vAcumTiempo:tvacumtiempo;
	vCont:tvCont;
	OpcionMenu:Byte;
	CargarTemas, CargarDjs:boolean;




{---------------------Procedimiento Dj Toca Mas Tiempo------------------}



procedure PasarAFormatoValido(maxaux:word);
{aca paso el formato segundos a formato hh:mm:ss}

var
        staux:string[8];
        st0:string[1];
        st1, st2, st3:string[2];
        mins, seg, horas: word;

begin
        staux:='';
        st0:='0';
        horas:=maxaux div 3600;
        mins:=(maxaux mod 3600) div 60;
        seg:=maxaux-((horas*3600)+(mins*60));
        str(horas,st1);
        str(mins,st2);
        str(seg,st3);
        staux:=concat(st1,':',st2,':',st3);
        if horas<10 then
                insert(st0,staux,1);
        if mins<10 then
                insert(st0,staux,4);
        if seg<10 then
                insert(st0,staux,7);
        writeln(staux);

end;


procedure EscribirDjMaxToca(vAcumTiempo:tvAcumTiempo;max:word;vDj:tvDj);

{aca lo que hace es escribir el o los djs que mas tocan junto con el tiempo, pero ese tiempo lo tengo que pasar a formato hh:mm:ss,
por eso puse la funcion esa pasaraformatovalido}

var
i:byte;
maxaux:word;

begin
        maxaux:=max;
        for i:=1 to maxdj do
                if vAcumTiempo[i]=max then
                        begin
                                write(vdj[i],': ');
                                PasarAFormatoValido(maxaux);
                        end;
end;



procedure DjMaxToca(vAcumTiempo:tvAcumTiempo;vDj:tvDj);

{aca busco cual es el dj que mas toca, comparo en el vector vacumtiempo cual es el mayor y ahi saco la posicion del dj que mas toca,
puede ser mas de uno}

var
        i:byte;
        max:word;
        cont:byte;

begin
        cont:=0;
        max:=0;
        for i:=1 to maxdj do
                if vAcumTiempo[i]>max then
                        max:=vAcumTiempo[i]; {busco duracion maxima en seg}
        for i:=1 to maxdj do
                if vAcumTiempo[i]=max then {contador para ver si es 1 o + djs}
                        cont:=cont+1;
        if cont=1 then
                begin
                writeln('El Dj que mas tiempo toca es:');
                EscribirDjMaxToca(vAcumTiempo,max,vDj);
                end;
        if cont<>1 then begin
                writeln('Los Dj que mas tocan son:');
                EscribirDjMaxToca(vacumtiempo,max,vdj);
                end;
end;


procedure BuscoMaximo (var mTemasAsignados:tmTemasAsignados;var vAcumTiempo:tvAcumTiempo; vDj:tvDj; vDuracion:tvDuracion; vTemasOficiales:tvTemasOficiales);

{La matriz mTemasAsignados no se va a modificar pero se pasa por referencia porque es muy pesado, entonces ocupa mucha memoria}
{en este procedure la idea es sumar en un vector vduracion la duracion total por cada dj, la duracion queda en segundos, mas adelante la convierto a hh:mm:ss}

var
i,j,z:byte;
tacum,num:word;

begin

      for i:=1 to maxdj do
      begin
        j:=1;
        tacum:=0;
        repeat
        for z:=1 to maxtemasoficiales do
                if mTemasAsignados[i,j]=vTemasOficiales[z] then
                        tacum:=tacum+vDuracion[z];
        j:=j+1
        until (mTemasAsignados[i,j]=parar) or (j=maxtemaspordj);
      {aca busco el tema de la matriz en el vector de los 200 temas y con el
      vector paralelo vduracion voy sumando las duraciones y lo asigno al
      vector vacumtiempo donde cada espacio es la duracion total del dj}
        vAcumTiempo[i]:=tacum
        end;
        djmaxtoca(vAcumTiempo,vDj);
end;

{----------------Procedimientos Mas Repetido--------------------------}


Procedure EscribirTemaMaxRepetido(vTemasOficiales:tvTemasOficiales;vCont:tvCont;vDuracion:tvDuracion;maxrep:word);

var
i:byte;

begin
for i:=1 to maxtemasoficiales do
        if vCont[i]=maxrep then
        begin
         write(vTemasOficiales[i],' ');
         PasarAFormatoValido(vDuracion[i]); {Reutilizo codigo usado para ver el dj que mas tiempo toca}
         end;
end;


Procedure BuscarMaxRepetido(vCont:tvCont;maxrep:word;vDuracion:tvDuracion;vTemasOficiales:tvTemasOficiales);

var
        cont,i:byte;

begin
cont:=0;
for i:=1 to maxtemasoficiales do
        if vCont[i]=maxrep then
                cont:=cont+1;
        if cont>1 then
begin
        writeln('Los temas mas repetidos son:');
        EscribirTemaMaxRepetido(vTemasOficiales,vCont,vDuracion,maxrep);
end;
if cont=1 then
begin
        writeln('El tema mas repetido es:');
        EscribirTemaMaxRepetido(vTemasOficiales,vCont,vDuracion,maxrep);
end;
end;


Procedure TemasMaxRepetidos(mTemasAsignados:tmTemasAsignados;vTemasOficiales:tvTemasOficiales;var vCont:tvCont;vDuracion:tvDuracion);

var
        y,x,i:byte;
        maxrep,cont:word;
begin
maxrep:=0;
for i:=1 to maxtemasoficiales do
begin
        cont:=0;
        for y:=1 to maxdj do
        begin
                x:=1;
                repeat
                        if mTemasAsignados[y,x]=vTemasOficiales[i] then
                                cont:=cont+1;
                        x:=x+1;
                until (x=maxtemaspordj) or (mTemasAsignados[y,x]=parar);
        end;
        vCont[i]:=cont;
end;
for i:=1 to maxtemasoficiales do
        if (vCont[i]>maxrep) then
                maxrep:=vCont[i];
BuscarMaxRepetido(vCont,maxrep,vDuracion,vTemasOficiales);
end;

{----------------Procedimientos Lista Temas----------------------------}

Procedure AuxTiempoTransformadoA_Seg (AuxTiempo: word;  var Seg: word);

Begin

	Seg:= ((AuxTiempo div 100)* 60) + (AuxTiempo mod 100)
End;



Procedure LeerDuracionTransformadoAtiempo_Valido (var DuracionEnSeg:tBaseDuracion);

Var
Seg: word;
Validez:boolean;
StTiempo: string;
AuxTiempo: word;
Codigo: integer;
Begin
	Validez:=False;
        Sttiempo:='';
	Repeat
	Readln(StTiempo);
	If (Length(StTiempo)=5) Then
		Begin
		If Copy(StTiempo,3,1)=':' Then
			Begin
			Delete(StTiempo,3,1);
                        Val(StTiempo,AuxTiempo,Codigo);
			If Codigo=0 Then
				If(AuxTiempo mod 100) < 60 Then
					Begin
					AuxTiempoTransformadoA_Seg(AuxTiempo,Seg);
					If (Seg)<=MaxDuracion Then
						Validez:=True;
					End;
			End;
		End;
	If not(Validez) Then
		Writeln('Duracion invalida. Ingrese nuevamente:');
	Until Validez=True;

        DuracionEnSeg:=Seg;

End;



Procedure LeerTitulo (var Titulo: tTitulo);

Var
	StAux: string;
Begin
	Repeat
	Readln(StAux);
	If Length(StAux) > CaracteresTitulo Then
		Writeln('Titulo demasiado largo. Ingrese nuevamente:');
	Until Length(StAux)<= CaracteresTitulo;
	Titulo:=StAux;
End;




Procedure CargarListaOficial (var vTemasOficiales: tvTemasOficiales; var vDuracion: tvDuracion);

Var
	i: byte;

Begin
	Writeln ('Ingrese la lista de ',MaxTemasOficiales,' temas oficiales con sus respectivas duraciones. La duracion del tema no puede exceder los 10 minutos, y debera ingresar dicha duracion en el formato mm:ss.');
	For i:=1 to MaxTemasOficiales do
		Begin
		Writeln ('Ingrese titulo.');
		LeerTitulo(Titulo);
		vTemasOficiales[i]:= Titulo;
		Writeln ('Ingrese duracion del tema con el formato mm:ss. No puede superar los 10 minutos');
		LeerDuracionTransformadoAtiempo_Valido(DuracionEnSeg);
		vDuracion[i]:= DuracionEnSeg;
		End;
End;

{----------------Procedimientos Lista Djs----------------------------}

Procedure LeerNombreDJ(var vDj:tvDj; numeroDj:tIndiceDj);
{Lee y valida los nombres de los DJ los carga al vector vDj}
	var
	DjAux: string;
	i:byte;

	begin
	i:=0;
	Readln(DjAux);
	while (Length(DjAux) = 0) or (Length(DjAux) > CaracteresNombre) do
		begin
		Writeln('El nombre debe contener entre 1 y ',CaracteresNombre, ' caracteres, reingrese');
		Readln(DjAux);
		end;
	repeat
		Begin
		i:=i+1;
		repeat
			if vDj[i]=DjAux then
				begin
				Writeln('Ese Dj ya esta dentro de la lista, reingrese');
				Readln(DjAux);
				end
		until not (vDj[i]=DjAux);
		end
	until (i=numeroDj);
	vDj[numeroDj]:=DjAux
	end;

function EstaDentroLista(Tema:string; Lista:tvTemasOficiales):boolean;
{Esta funcion verifica si el tema ingresado esta dentro de la lista de temas oficiales y devuelve un booleano}
	var
	i:byte;

	begin
	i:=0;
	repeat
		i:= i+1
	until (Tema = Lista[i]) or (i = MaxTemasOficiales);
	if (Tema = Lista[i]) then
		EstaDentroLista:=True
	else
		begin
		Writeln('Ese tema no esta dentro de la lista, ingrese otro tema');
		EstaDentroLista:=False;
		end;
	end;

Procedure IniVector(vector:tvCantTemasPorDj);
{Inicializa el vector vCantTemasPorDj en 0}
	var
	i:tIndiceTemasPorDj;

	begin
	for i:=1 to MaxTemasPorDj do
	vCantTemasPorDj[i] := 0
	end;

function EstaRepetidoTema(Tema:string; mTemas:tmTemasAsignados; numeroDj:tIndiceDj; mlTemas:tBaseCantTemasPorDj):boolean;
{Esta funcion verifica si el tema ingresado ya fue ingresado anteriormente y devuelve un booleano}
	var
	i:byte;
	encontro:boolean;

	Begin
	encontro:= false;
	i:=1;
	if (mlTemas > 0) then
		begin
		while (i<= mlTemas) and not encontro do
			begin
			if (Tema = mTemas[numeroDj,i]) then
				encontro:= true;
			i:=i+1;
			end;
		if encontro then
			begin
			Writeln('Este tema esta ya fue seleccionado');
			EstaRepetidoTema:= True;
			end
		else
			EstaRepetidoTema:= False;
		end
	else
		EstaRepetidoTema:=False;
	end;

Procedure IngresarTemasDj(var mTemas:tmTemasAsignados;var vCantTemasPorDj:tvCantTemasPorDj; ListaTemas:tvTemasOficiales; numeroDj:tIndiceDj);
{Este procedimiento recibe los temas que tocara cada Dj, los verifica por medio de las funciones EstaDentroLista y EstaRepetido
y los guarda dentro de la matriz mTemasAsignados ademas modifica el vector vCantTemasPorDj que funciona como ML}
	var
	i: tIndiceTemasOficiales;
	AuxTema:string;
	j:byte;

	begin
	Writeln('Estas son las canciones disponibles'); {Esta parte no es necesaria, pero me parecio bueno ponerla}
	for i:=1 to MaxTemasOficiales do
		begin
		if (i < MaxTemasOficiales) then {Muestra todas las canciones}
		Write(ListaTemas[i], ', ')
		else
		Write(ListaTemas[i])
		end;
	Writeln();
	IniVector(vCantTemasPorDj);
	j:=0;
	Writeln('Acontinuacion ingrese hasta 35 canciones de la lista, puede ingresar ',Parar,' para ingresar menos');
	repeat {ingresa temas hasta que llega a 25 o el usuraio ingrese la frase especificada en Const}
		begin
		j:=j+1;
		repeat
			begin
			Writeln('Ingrese el tema numero ', j);
			LeerTitulo(AuxTema); {Reuso Leer titulo para validar el tema auxiliar}
			end
		until (AuxTema = Parar) or (EstaDentroLista(AuxTema, ListaTemas)) and not (EstaRepetidoTema(AuxTema,mTemas,numeroDj,vCantTemasPorDj[numeroDj]));
		mTemas[numeroDj,j]:=AuxTema;
		vCantTemasPorDj[numeroDj]:=vCantTemasPorDj[numeroDj]+1;
		end
	until (j=MaxTemasPorDj) or (AuxTema = Parar);
	if (j = MaxTemasPorDj) then
		Writeln('Ha alcanzado el limite de canciones')
	end;


Procedure CargarInfoDJs(var vDj:tvDj;var vCantTemasPorDj:tvCantTemasPorDj; var mTemasAsignados:tmTemasAsignados; vTemasOficiales:tvTemasOficiales;CantDjs:tCantDjs);
{Recibe la cantidad de Djs que tocaran y llama a los procedimientos LeerNombreDJ y IngresarTemasDj}
var
i:tIndiceDj;
mlDj:byte;

begin
	CantDjs:=0;
	Writeln('Ingrese la cantidad de DJs hasta un maximo de ',MaxDj);
	repeat
	begin
	Readln(mlDj);
	if (mlDj > MaxDj) Then
		Writeln('Ese numero no esta comprendido dentro del limite de ',MaxDj, 'reingrese la cantidad');
	end;
	until (mlDj <= MaxDj) and (mlDj > 0);
	CantDjs:=mlDj;
	for i:= 1 to mlDj do
		begin
		Writeln('A continuacion, ingrese el nombre del Dj Nro ',i,' (max ',CaracteresNombre,' caracteres)');
		LeerNombreDJ(vDj, i);
		IngresarTemasDj(mTemasAsignados,vCantTemasPorDj,vTemasOficiales,i);
		end;
end;
{-----------------------------------------------------------------------PUNTO 2-------------------------------------------------------------------------------}
Procedure mostrarListasA1(vDj:tvDj);
	var i:byte;
	begin
	for i:=1 to MaxDj do
		Writeln(vDj[i]);

	end;
Procedure mostrarListasA2(vDj:tvDj);
	var i,j:byte;
		aux:tNombre;
	begin
	 for i:=1 to (MaxDj-1) do
	 	for j:=1 to (MaxDj-1) do
	 		if vDj[j]>vDj[j+1] then
	 		begin
	 			aux:=vDj[j];
	 			vDj[j]:=vDj[j+1];
	 			vDj[j+1]:= aux ;
	 		end;


	 for i:=1 to (MaxDj) do
	 	writeln(vDj[i]);
	end;



Procedure MostrarListasA (vDj:tvDj);
	var auxdecision:byte;

begin
	repeat
	 writeln('Ver listado de Djs') ;
	 writeln('1- En el orden en que fueron ingresados');
	 writeln('2- En el orden en que fueron ingresados  o alfabeticamente en formaascendente');
	 readln(auxdecision);
	 if (auxdecision=1) then mostrarListasA1(vDj);
	 if (auxdecision= 2) then MostrarListasA2(vDj);
	 if (auxdecision<>1) and (auxdecision<>2) Then
		Writeln('VALOR NO VALIDO');
	until (auxdecision=1) or (auxdecision=2);

end;
{---------------------------------------------------------------------------}
Procedure mostrarListasB1(vTemasOficiales: tvTemasOficiales);{temas acendente y duracion desendente}
var i,j:byte;
	aux:tTitulo;
begin
	for i:=1 to (MaxTemasOficiales-1) do
		for j:=1 to (MaxTemasOficiales-1) do
			if vTemasOficiales[j]>vTemasOficiales[j+1] then
	 		begin
	 			aux:=vTemasOficiales[j];
	 			vTemasOficiales[j]:=vTemasOficiales[j+1];
	 			vTemasOficiales[j+1]:= aux ;
	 		end;
	 for i:=1 to (MaxTemasOficiales) do
	 	writeln(vTemasOficiales[i]);

end;



Procedure mostrarListasB2(vTemasOficiales: tvTemasOficiales;vDuracion: tvDuracion);
var
	i,j:byte;
	auxTitulo:tTitulo;
        auxDuracion:tBaseDuracion;

begin
	for i:=1 to (MaxTemasOficiales-1) do
		for j:=1 to (MaxTemasOficiales-1) do
			if( vDuracion[j] < vDuracion[j+1]) Then
				begin
				auxDuracion := vDuracion[j];
				vDuracion[j] := vDuracion[j+1];
				vDuracion[j+1]:= auxDuracion;
				auxTitulo := vTemasOficiales[j];
				vTemasOficiales[j]:= vTemasOficiales[j+1];
				vTemasOficiales[j+1] := auxTitulo
				end;
	for i:=1 to MaxTemasOficiales do
        begin
                Write(  vTemasOficiales[i],'  ---> ');
                PasaraFormatoValido(vDuracion[i]);
        end;
end;



Procedure MostrarListasB(vTemasOficiales: tvTemasOficiales;vDuracion: tvDuracion);
var auxdecision:byte;

begin
	repeat
	writeln('Ver listado de temas') ;
	writeln('1- Ordenado alfabeticamente en forma ascendente');
	writeln('2- Ordenado por duracion en forma descendente');
	readln(auxdecision);
	if (auxdecision=1) then mostrarListasB1(vTemasOficiales);
	if (auxdecision=2) then	mostrarListasB2(vTemasOficiales,vDuracion);
	if (auxdecision<>1) and (auxdecision<>2) Then
		Writeln('VALOR NO VALIDO');
	until (auxdecision=1) or (auxdecision=2);


end;
{----------------------------------------------------------------------------}
function PosicionDj (vDj:tvDj;AuxNombre:tNombre;CantDjs:tCantDjs) : tIndiceDj;
 var
 i:tIndiceDj;
 begin
 i:=1;
 while (i < CantDjs ) and (vDj[i] <> AuxNombre ) do

 	begin
	 	i:= i+1 ;
	 	posiciondj:= i ;
	 end;

 end;


 Procedure mostrarListasC2(vDj: tvDj ;mTemasAsignados: tmTemasAsignados;CantDjs:tCantDjs);
	var     auxnombre:tnombre;
		i,j:byte;

	begin
	writeln('Ingrese nombre del Dj');
	readln(AuxNombre);
        i:=0;
        repeat
        i:=i+1;
        until (AuxNombre=vDj[i]);
        writeln('Los temas que toca ',vDj[i],' son:');
        j:=1;
        while (mTemasAsignados[i,j]<>'0') and (j<=MaxTemasPorDj) do
        begin
                writeln(mTemasAsignados[i,j]);
                j:=j+1;
        end;
	end;

{---------------------------------------------------------------------------}
function PosicionTema(mTemasAsignados: tmTemasAsignados; vTemasOficiales: tvTemasOficiales; auxdjposicion:tIndiceDj; i:tIndiceTemasPorDj):tIndiceTemasOficiales;
	var
	j:byte;

	begin
		j:=1  ;
		while (j < MaxTemasOficiales) and (mTemasAsignados[auxdjposicion,i] <>  vTemasOficiales[j] ) do
				j:= j+1;
		PosicionTema:= j ;
	end;
Procedure OrdenarListasC1(var VecOrdPorSeg:tVecOrdPorSeg ;var vecOrdParaleloTemasPorSeg:tvecOrdParaleloTemasPorSeg);
	var i,j:byte;
		aux:tBaseDuracion;
		auxParalelo:tIndiceDj;
	begin
		for i:=1 to (MaxTemasPorDj-1) do
			for  j:=1 to (MaxTemasPorDj-1) do
				if VecOrdPorSeg[j] > VecOrdPorSeg[j+1] Then
					begin
						aux:= VecOrdPorSeg[j];
						auxParalelo:= vecOrdParaleloTemasPorSeg[j];
						VecOrdPorSeg[j]:= VecOrdPorSeg[j+1];
						vecOrdParaleloTemasPorSeg[j]:= vecOrdParaleloTemasPorSeg[j+1];
						VecOrdPorSeg[j+1]:= aux;
						vecOrdParaleloTemasPorSeg[j+1]:= auxParalelo;
					end;
	end;


Procedure MostrarListasC1(vDj:tvDj; mTemasAsignados:tmTemasAsignados; CantDjs:tCantDjs; vTemasOficiales: tvTemasOficiales; vDuracion:tvDuracion);
	var             auxnombre:tnombre;
			i:tIndiceTemasPorDj;
			j:tIndiceTemasPorDj;
			auxdjposicion:tIndiceDj;
			VecOrdPorSeg: array[tIndiceTemasPorDj] of tBaseDuracion;
			vecOrdParaleloTemasPorSeg: array[tIndiceTemasPorDj] of tIndiceDj;
			auxPosicionTema:tIndiceTemasOficiales;

	Begin


		writeln('Ingrese nombre del Dj');
		readln(AuxNombre);
		auxdjposicion:= posiciondj(vDj,AuxNombre,CantDjs);
		j:=1;
		for i:=1 to MaxTemasPorDj do
			begin
				vecOrdParaleloTemasPorSeg[i]:= j;
				j:= (j+1) ;
			end;
		for i:=1 to MaxTemasPorDj do
			begin
			auxPosicionTema:=PosicionTema(mTemasAsignados,vTemasOficiales,auxdjposicion,i);
			VecOrdPorSeg[i]:= vDuracion[auxPosicionTema];
			end;

		OrdenarListasC1(VecOrdPorSeg,vecOrdParaleloTemasPorSeg);

		for i:= 1 to MaxTemasPorDj do
			begin
				writeln(mTemasAsignados[auxdjposicion,vecOrdParaleloTemasPorSeg[i]]);
				writeln( ('   ---->    '),(VecOrdPorSeg[i] div 60), (':'), (VecOrdPorSeg[i] mod 60) );
			end;
	End;




Procedure MostrarListasC(vDj: tvDj;mTemasAsignados: tmTemasAsignados;CantDjs:tCantDjs;vTemasOficiales: tvTemasOficiales; vDuracion: tvDuracion);
var auxdecision:byte;

begin
	repeat
	writeln('Ver listado de temas de un Dj') ;
	writeln('1- Listado de temas de un Dj temas que tocara ordenados por duracion de cada tema en forma ascendente');
	writeln('2- Listado de temas de un Dj temas que tocara ordenados segun el orden que fueron ingresados');
	readln(auxdecision);
	if (auxdecision=1) then mostrarListasC1 (vDj, mTemasAsignados, CantDjs, vTemasOficiales, vDuracion);
	if (auxdecision=2) then MostrarListasC2 (vDj,mTemasAsignados,CantDjs);

	if (auxdecision<>1) and (auxdecision<>2) Then

		Writeln('VALOR NO VALIDO');
	until (auxdecision=1) or (auxdecision=2);



end;

Procedure MostrarListas (vDj: tvDj; vTemasOficiales: tvTemasOficiales;vDuracion: tvDuracion;mTemasAsignados: tmTemasAsignados;CantDjs:tCantDjs);
var
auxdecision:byte;
begin
	repeat
	writeln('Ingrese 1- si quiere el listado de Dj: en el orden en que fueron ingresados o alfabeticamente en forma ascendente');
	writeln('Ingrese 2- si quiere el listado de Temas: alfabeticamente en forma ascendente o por duracion del tema en forma descendente');
	writeln('Ingrese 3- si quiere la lista de temas de un Dj determinado: se pide ingresar un DJ y mostrar los temas que tocara ordenados por duracion de cada tema en forma ascendente o segun el orden que fueron ingresados.');
	readln(auxdecision);
	if (auxdecision = 1) then MostrarListasA(vDj) ;

	if (auxdecision= 2) then MostrarListasB(vTemasOficiales,vDuracion) ;

	if (auxdecision=3) then MostrarListasC(vDj,mTemasAsignados,CantDjs,vTemasOficiales, vDuracion) ;

	if (auxdecision<>1) and (auxdecision<>2) and (auxdecision<>3) Then
	Writeln('VALOR NO VALIDO.') ;
	until (auxdecision=1) or (auxdecision=2) or (auxdecision=3);




end;


{---------PROGRAMA PRINCIPAL---------}

Begin
CargarDjs:= false;
CargarTemas:= false;
repeat
	begin
	Writeln('Acontinuacion Ingrese "1" para cargar la lista oficial de temas o "2" para cargar la lista oficial de Djs');
	readln(OpcionMenu);
	case OpcionMenu of
		1:begin
		CargarListaOficial(vtemasOficiales,vDuracion);
		CargarTemas:= true;
		end;
		2:begin
		CargarInfoDJs(vDj,vCantTemasPorDj,mTemasAsignados,vTemasOficiales,CantDjs);
		CargarDjs:= true;
		end;
	else Writeln ('Opcion Invalida, intente nuevamente')
	end
	end

        until (CargarDjs = true) and (CargarTemas = true);
repeat
	Begin
	Writeln('Ahora, Ingrese "1" para mostrar las listas cargadas, "2" para mostrar que Djs tocaran mas tiempo, "3" para mostrar los temas que se tocaran mas veces o "0" para terminar');
	Readln(OpcionMenu);
	case OpcionMenu of
		0:writeln();
		1:MostrarListas(vDj,vTemasOficiales,vDuracion,mtemasasignados,cantdjs);
		2:BuscoMaximo (mTemasAsignados, vAcumTiempo, vDj,vDuracion,vTemasOficiales);
		3:TemasMaxRepetidos(mTemasAsignados,vTemasOficiales,vCont,vDuracion);
    else Writeln('Opcion Invalida, intente nuevamente')
    end
    end
until (OpcionMenu = 0);
readln();


End.

