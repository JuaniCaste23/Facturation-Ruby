class Datos
   def initialize()
      @nombre=ingresar_nombre
      @apellido=ingresar_apellido
      @dni=ingresar_dni
      @fecha,@hora=fecha_de_compra
   end

   private
   def ingresar_nombre
      puts">>----------------------------BIENVENIDO AL COMERCIO TIP!----------------------------<<\n\n"
      puts"-Por favor ingrese sus Datos.\n\n"
      begin
         print"Ingrese su Nombre: "
         nombre=gets.chomp.to_s
         if(nombre.length<4)
            puts"-El nombre debe tener mas de 3 caracteres para que sea válido."
            enc=false
         else
            enc=true
         end
      end until(enc==true)
      return nombre
   end

   def ingresar_apellido
      begin
         print"Ingrese su Apelido: "
         apellido=gets.chomp.to_s
         if(apellido.length<4)
            puts"-El apellido debe tener mas de 3 caracteres para que sea válido."
            enc=false
         else
            enc=true
         end
      end until(enc==true)
      return apellido
   end

   def ingresar_dni
      begin
         print"Ingrese su DNI (Solo numeros): "
         dni=gets.chomp.to_i
         dni=dni.to_s
         if(dni.length!=8)
            puts"-El DNI debe tener un ancho de solo 8 Numeros."
            enc=false
         else
            enc=true
         end
      end until(enc==true)
      return dni
   end

   def fecha_de_compra
      t=Time.now
      time=t.to_s
      aanow=time[0..3].to_i ; mmnow=time[5..6].to_i ; ddnow=time[8..9].to_i
      horas=time[11..12] ; minutos=time[14..15] ; segundos=time[17..18]
      fecha="#{ddnow}/#{mmnow}/#{aanow}"
      hora="#{horas}:#{minutos}:#{segundos}"
      return fecha,hora
   end
end

class Stock
   def initialize(tipo,bd)
      @stock=File.new(bd,"r")
      @tipo=tipo
      @renglones=Array.new
      @merc=Hash.new
   end
   
   def base_de_datos
      #lectura_bd
      control=leer_bd
      chequeo=control_bd
   end

   private
   def leer_bd
      aux="" 
      begin
         renglon=(@stock.gets.chomp).to_s
         #puts renglon
         aux=renglon.chomp.split(",")
         @renglones.push(aux)
         aux=""
     end until(@stock.eof()==true)
     @stock.close
   end

   def control_bd
      i=0 ; cont=1
      begin
         if(@tipo==@renglones[i][3].to_i)
            @merc[cont]=@renglones[i]
            cont=cont+1
         end
         i=i+1
      end until(i==@renglones.size)
   end      

   def lectura_bd #verificar datos de la base de datos (esta separadas con delimitadores (,) def opcional)
      @stock.each do |linea|     
         puts linea
      end
      @stock.close
   end
end

class Facturacion < Stock
   def initialize(tipo,bd)
      super(tipo,bd)
      @tipo=tipo
      @merc2=Hash.new
      @venta=Hash.new
      @array_productos=Array.new
   end

   def main
     system('cls')
     base_de_datos #ejecuta las operaciones para cargar la base de datos en la clase heredada stock
     realizar_venta #realiza la venta
     system('cls')
     puts"\nLo que lleva de mercaderia es:"
     calcular #calcula el total del stock solicitado.
   end

   def imprimir
      puts "------------------------------------------------"
      puts"Stock Disponible:"
      @merc.each do |clave,valor|
         @merc2[clave]=valor[2]
         @array_productos.push(valor[0])
         puts"-CÓDIGO: #{clave}\n-PRODUCTO: #{valor[0]}\n-DISTRIBUIDORA: #{valor[1]}\n-PRECIO: $#{valor[2]}\n-TIPO: #{valor[3]}\n-CATEGORIA: #{valor[4]}"
      end
      puts "------------------------------------------------"
   end

   def realizar_venta
      begin
         begin
            imprimir #imprime el stock solicitado.
            print"\n¿Que producto desea llevar? (PONGA EL CÓDIGO UNICAMENTE): "
            mm=gets.chomp.to_i
            if(@tipo<5)
               if (@merc.has_key?(mm)) #has_key sirve para declarar true o false.
                  print"¿Que cantidad lleva (en Kg)?: "
                  cant=gets.chomp.to_f
                  if(@venta.has_key?(mm))
                     @venta[mm]=@venta[mm]+cant
                     enc=true
                  else
                     @venta[mm]=cant
                     enc=true
                  end 
               else
                  enc=false
               end         
            else
               if (@merc.has_key?(mm)) #has_key sirve para declarar true o false.
                  print"¿Que cantidad lleva (en Unidades)?: "
                  cant=gets.chomp.to_i
                  if(@venta.has_key?(mm))
                     @venta[mm]=@venta[mm]+cant
                     enc=true
                  else
                     @venta[mm]=cant
                     enc=true
                  end 
               else
                  enc=false
               end  
            end
            if(enc==false)
               system('cls')
               puts"-Debe ingresar un Código VÁLIDO!!"
            end
         end until(enc==true)
         begin
            print"\nDesea seguir comprando algo del Stock actual? (Pulse Y/N): "
            cierre=gets.chomp
            if((cierre!="Y") and (cierre!="y") and (cierre!="N") and (cierre!="n"))
               system('cls')
               puts"-Debe escribir Y (De afirmativo) o N (Negativo)"
               enc=false
            else
               enc=true
            end
         end until(enc==true)
         case
         when((cierre=="Y") or (cierre=="y"))
            system('cls')
            puts"\n-Seguira comprando del stock actual."
            enc=false
         when((cierre=="N") or (cierre=="n"))
            enc=true
         end     
      end until(enc==true)
   end

   def calcular
      total=0 ; i=0
      puts"------------------------------------------------"
      if(@tipo<5) #producto=clave ; cantidad=valor
         @venta.each do|producto,cantidad| #productos fijados en kilos
            puts"#{cantidad} kg de #{@array_productos[i]}: $#{(cantidad.to_f * @merc2[producto].to_f).round(2)}" 
            total = total + (cantidad.to_f * @merc2[producto].to_f)
            i=i+1
         end
      else
         @venta.each do|producto,cantidad| #prodcutos fijados en unidades
            puts"#{cantidad} unidades de #{@array_productos[i]}: $#{(cantidad.to_f * @merc2[producto].to_f).round(2)}" 
            total = total + (cantidad.to_f * @merc2[producto].to_f)
            i=i+1
         end
      end
      $suma = $suma + total
      puts"------------------------------------------------"
      puts"-El total de la compra es: $#{total.round(2)}" #round me marca () decimales que quiero.
   end
end

class Comercio < Datos
   def initialize(tipos,base_de_datos)
      super() #se cargan los datos del usuario  a traves de la clase heredada datos.
      @bd=base_de_datos
      @tipo=tipos
      @@id=id
      @listado=Hash.new
   end         

   def bienvenida
      system('cls')
      puts">>----------------------------BIENVENIDO AL COMERCIO TIP!----------------------------<<"
      begin
         puts"\nPor favor, eliga uno de los siguientes stocks:"
         @tipo.each do |clave,valor|
            puts"TIPO: #{clave} -#{valor}"
         end
         print"\n-Eliga un tipo de stock (marque solo el número): "
         codigo=gets.chomp.to_i
         if(codigo==0 or codigo>9)
            system('cls')
            puts"-Debe marcar un tipo que no sea 0 ni que supere el rango (1..9)"
            enc=false
         else
            enc=true
         end
      end until(enc==true)
      return codigo
   end

   def main 
      i=1
      begin
         codigo=bienvenida #se pide al usuario ingresar el codigo
         mercado=Facturacion.new(codigo,@bd)     
         mercado.main #se ejecuta la clase facturacion
         @listado[i]=mercado #guarda en un hash cada objeto creado de facturacion con su respectivo stock cargado
         i=i+1
         control=salida #se le pide al usuario si desea seguir comprando con otros stocks o salir del programa
      end until(control==true)
      calcular_total #ticket de compra con el total de todos los stocks.
   end

   def salida
      begin
         print"\n\nDesea seguir comprando en el comercio? (Pulse Y/N): "
         cierre=gets.chomp
         if((cierre!="Y") and (cierre!="y") and (cierre!="N") and (cierre!="n"))
             system('cls')
             puts"-Debe escribir Y (De afirmativo) o N (Negativo)"
             enc=false
         else
             enc=true
         end
     end until(enc==true)
      case
      when((cierre=="y") or (cierre=="Y"))
         system('cls')
         puts"-Seguira Comprando en el comercio."
         return false
      when((cierre=="n") or (cierre=="N"))
         system('cls')
         puts"-A Continuacion se le mostrara el total de la compra:\n\n"
         return true
      end
   end
   
   def calcular_total
      $suma=0
      puts"---------------------------------------------------------------------------------------------------------------------------------\n\n"
      puts"|--> TICKET DEL TOTAL DE LA COMPRA --> #{@@id} <--\n"
      puts"\nDatos de la persona que compro:\n-Nombre y Apellido: #{@nombre} #{@apellido}\n-DNI: #{@dni}\n-Fecha de la compra: #{@fecha}\n-Hora de la compra: #{@hora}\n\n"
      @listado.each do |clave,valor|
         puts"Operación Número --> #{clave}."
         puts"----------------------------------------------------------------------------------------------------------------"
         valor.calcular
         puts"----------------------------------------------------------------------------------------------------------------\n\n"
      end
      puts"|--> SUMA TOTAL A PAGAR: $#{$suma}\n\n"
      puts"---------------------------------------------------------------------------------------------------------------------------------"
      puts"\n\nGRACIAS POR COMPRAR EN EL COMERCIO TIP, HASTA PRONTO!"
   end

   protected
   def id
      letras = "TICKET__"
      for i in 0..3
        letras = letras.to_s + (rand(65..90).chr).to_s
      end
      @@id = letras.to_s + (rand(0..9999)).to_s
   end
end

#main
system('cls')#borra todos los datos de la consola.
tipos={"1" => "Frutas y Verduras" ,"2" => "Carniceria","3" => "Mariscos","4" => "Fiambreria","5" => "Bebidas","6" => "Limpieza" ,"7" => "Bazar","8" => "Electrodomesticos","9" => "Videojuegos"} 
base_de_datos="D:/BACKUP/JUAN BACKUP/PROGRAMACION/Lenguajes de Programación/Ruby Class/FACTURACION PROGRAMA BY Juancho23/BASE DE DATOS.DAT" #Agregar mas tipos: {"" => ""}
$suma=0
comercio=Comercio.new(tipos,base_de_datos)
comercio.main

anticierre=gets.chomp