class Base_de_datos
    def initialize(ruta)
        @ruta=ruta
        @tipos={"1" => "Frutas y Verduras" ,"2" => "Carniceria","3" => "Mariscos","4" => "Fiambreria","5" => "Bebidas","6" => "Limpieza" ,"7" => "Bazar","8" => "Electrodomesticos","9" => "Videojuegos"}
    end
    attr_accessor :tipos

    def main
        tip=entrada
        begin
            arch=File.new(@ruta,tip)
            nombre=ingresar_nombre
            distribuidora=ingresar_distribuidora
            precio=ingresar_precio
            tipo,categoria=ingresar_tipo
            renglon= nombre + (",") + distribuidora + (",") + precio + (",") + tipo + (",") + categoria
            arch.puts(renglon)
            $cont=$cont+1
            tip="a"
            arch.close
            stop=salida
        end until(stop==true)
        lectura #si desea leer la base de datos ingresada.
    end

    def entrada
        puts"\n\n---------BASE DE DATOS PARA COMERCIO---------\n\n"
        begin
            puts"Ingrese si va a llenar la base de datos de 0 o si quiere agregar nuevos atributos...\n-Marcando:\n1)Llenar la base de datos de 0 (CUIDADO CON ESTA OPCION)\n2)Agregar nuevo atributo a la base de datos\n"
            print"-Marque 1 o 2: "
            opcion=gets.chomp.to_i
            system('cls')
            if(opcion==0 or opcion>2)
                puts"-Debe ingresar una opcion que no sea 0 ni que sea mayor al rango de (1..2)\n\n"
                enc=false
            else
                enc=true
            end
        end until(enc==true)

        if(opcion==1)
            opcion="w"
            $cont=0
        else
            $cont=1
            opcion="a"
        end
        return opcion 
    end

    def ingresar_nombre
        begin
            print"Ingrese el nombre de producto: "
            nombre=gets.chomp.to_s
            if(nombre.length-1<1)
                puts"-Debe verificar que la cadena de caracteres sea con más de 1 caracter minimo"
                enc=false
            else
                enc=true
            end
            if($cont>0)    
                arch=File.new(@ruta,"r") ; i=0 ; aux="" ; array_de_nombres=Array.new
                begin
                    renglon=(arch.gets.chomp).to_s
                    begin
                        aux=aux+renglon[i]
                        i=i+1
                    end until(renglon[i]==",")
                    array_de_nombres.push(aux)
                    aux="" ; i=0
                end until(arch.eof()==true)
                arch.close 
                i=0
                begin
                    if(array_de_nombres[i]==nombre)
                        puts"-Debe ingresar un nombre que no haya sido ingresado previamente en la base de datos."
                        enc=false
                    else
                        enc=true
                    end
                    i=i+1
                end until(i==array_de_nombres.length or enc==false)
            end
        end until(enc==true)
        return nombre
    end

    def ingresar_distribuidora
        print"Ingrese el nombre de la distribuidora del producto: "
        distribuidora=gets.chomp.to_s
        if(distribuidora.length-1<1)
            puts"-Debe verificar que la cadena de caracteres sea con más de 1 caracter minimo"
            enc=false
        else
            enc=true
        end
        return distribuidora
    end

    def ingresar_precio
        begin
            print"Ingrese el precio del producto: $ "
            precio=gets.chomp.to_f
            if(precio==0)
                puts"-Debe ingresar un precio válido mayor a 0."
                enc=false
            else
                enc=true
            end
        end until(enc==true)
        precio=precio.to_s
        return precio
    end

    def ingresar_tipo
        array1=Array.new ; array2=Array.new
        begin
            puts"Eliga uno de los tipos a continuación para su producto (ELIGA BIEN LAS CLAVES):"
            @tipos.each do |clave,valor|
                puts"#{valor} ==> #{clave}"
                array1.push(clave)
                array2.push(valor)
            end
            print"\nEliga un tipo para su producto marcando solo el valor(el numero): "
            tipo=gets.chomp.to_i
            if(tipo==0 or tipo>9)
                puts"Debe ingresar un número válido dentro del rango (1..9)"
                enc=false
            else
                enc=true
            end
        end until(enc==true)
        for i in 0..array1.size-1
            if(tipo==array1[i].to_i)
                categoria=array2[i]
            end
        end
        puts categoria
        categoria=categoria.to_s
        tipo=tipo.to_s
        system('cls')
        return tipo,categoria
    end

    def salida
        begin
            print"Desea seguir ingresando datos a la Base de datos? (Pulse Y/N): "
            cierre=gets.chomp
            if((cierre!="Y") and (cierre!="y") and (cierre!="N") and (cierre!="n"))
                puts"-Debe escribir Y (De afirmativo) o N (Negativo)"
                enc=false
            else
                enc=true
            end
        end until(enc==true)
        system('cls')
        if(cierre=="n") or (cierre=="N")
            puts"----Se ha cerrado el ingreso a la base de datos.\n"
            return true
        else
            (cierre=="Y") or (cierre=="y")
            puts"----Se seguiran ingresando datos a la base de datos.\n"
            return false
        end
        return cierre
    end

    def lectura
        begin
            print"Desea leer la base de datos? (Pulse Y/N): "
            cierre=gets.chomp
            if((cierre!="Y") and (cierre!="y") and (cierre!="N") and (cierre!="n"))
                puts"-Debe escribir Y (De afirmativo) o N (Negativo)"
                enc=false
            else
                enc=true
            end
        end until(enc==true)
        system('cls')

        if(cierre=="y") or (cierre=="Y")
            puts"--Se leera la base de datos:"
            arch=File.new(@ruta,"r") 
            renglones=Array.new ; aux=""
            arch.each do |linea|
               aux=linea.chomp.split(",")
               renglones.push(aux)
               aux=""
            end
            arch.close 
            puts"------------------------------------------------------"
            for i in 0..renglones.size-1
                puts"Producto: #{renglones[i][0]}\nDistribuidora: #{renglones[i][1]}\nPrecio: $#{renglones[i][2]}\nTipo: #{renglones[i][3]}\nCategoria: #{renglones[i][4]}"
                puts"------------------------------------------------------"
            end
            gets
            system('cls')
        end 
    end
end

#main
system('cls')
$cont=0
ruta=("D:/BACKUP/JUAN BACKUP/PROGRAMACION/Lenguajes de Programación/Ruby Class/FACTURACION PROGRAMA BY Juancho23/BASE DE DATOS.DAT")
bd=Base_de_datos.new(ruta)
#bd.tipos() agregar otro tipo de categoria
bd.lectura #para leer la base de datos rapido(prueba de errores)
bd.main
puts"\nFín del programa."
puts"-Aclaraciones: Para modificar un atributo debe ir al archivo de texto."
#bd.tipos() ingresar mas tipos de clase a la base de datos.

anticierre= gets.chomp