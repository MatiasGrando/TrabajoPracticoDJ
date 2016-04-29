Program	SubprogramaTpCargarDatos;

{Concierto con 25 dj's como max y 35 temas cada uno como max. 200 temas con sus duraciones mm:ss
en una lista oficial.
Hasta 25 nombres de DJ's y sus temas elegidos (no repetidos) a travez de un menu.
Los datos ingresados deben:
a)ser validados

Hasta ahora estan hechas las listas de Temas y de Djs, los datos se validan cuando se van ingresando. Hay algunos lugares
donde los operadores tiran una warning pero yo creo que funcionan bien y es problema de pascal que lo tira nomas como advertencia}

Uses Crt;

Const
	Parar = '0'; {esta frase frena la carga de canciones}
	MaxTemasOficiales = 2;
	MaxDuracion = 600;
	MaxDj = 25;
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
	tvCantTemasPorDj= array [tIndiceTemasPorDj] of tBaseCantTemasPorDj;
	tCantDjs=0..MaxDj;
Var
	vTemasOficiales: tvTemasOficiales;
	vDuracion: tvDuracion;
	vDj: tvDj;						{ Vector Paralelo a la matriz de Djs indica nombre del Dj (string)}
	mTemasAsignados: tmTemasAsignados;
	vCantTemasPorDj: tvCantTemasPorDj; { Vector Paralelo a la matriz de temas Djs indica Maximo Logico (numerico)}
	Titulo: tTitulo;
    DuracionEnSeg: tBaseDuracion;
    CantDjs:tCantDjs; {funciona como ml (cuantos djs hay?) (numerico)}









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
	Writeln ('Ingrese la lista de 200 temas oficiales con sus respectivas duraciones. La duracion del tema no puede exceder los 10 minutos, y debera ingresar dicha duracion en el formato mm:ss.');
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
	var 
	i:tIndiceTemasPorDj;
	
	begin
	for i:=1 to MaxTemasPorDj do
	vCantTemasPorDj[i] := 0
	end;

function EstaRepetidoTema(Tema:string; mTemas:tmTemasAsignados; numeroDj:tIndiceDj; mlTemas:tBaseCantTemasPorDj):boolean;
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
	var
	i: tIndiceTemasOficiales;
	AuxTema:string;
	j:byte;

	begin
	Writeln('Estas son las canciones disponibles'); {Esta parte se podria sacar, pero me parecio bueno ponerlo}
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
	Writeln('Acontinuacion ingrese hasta 25 canciones de la lista, puede ingresar ',Parar,' para ingresar menos');
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




{---------PROGRAMA PRINCIPAL---------}

Begin 
	clrscr; 
	CargarListaOficial(vtemasOficiales,vDuracion);
	CargarInfoDJs(vDj,vCantTemasPorDj,mTemasAsignados,vTemasOficiales,CantDjs);

	{Esta hecho lo de cargar las listas de temas y de Djs}

End.
